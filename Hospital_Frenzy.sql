<<<<<<< HEAD
/*
Project: Game Analytics - Hospital Frenzy
Author: Lại Thụy Bình
Description:
- Cleaning raw data from multiple sources.
- Handling NULL values in advertising_id using vendor_id fallback.
- Standardizing Country and Platform names.
-- */


-- xử lý dữ liệu và union 2 bảng tutorial và level_end
with raw_user_engagement as(
  select event_date
    , t.user_pseudo_id
    , case when t.advertising_id = "" then cast (t.vendor_id as string)
else t.advertising_id end as advertising_id
    , t.app_version
    , upper(t.platform) as platform
    , case when t.country in ('None', 'N/A', '') or t.country is null then 'Unknown'
        else t.country
    end as country
    , t.online_time
    , t.max_level

    , null as engagement_time_msec
    , t.ga_session_id
    , t.ga_session_number
    , 'tutorial' as event_name
  from jda-k1.mobile_games.tutorial t
  where t.advertising_id <> "0000-0000"
  and t.advertising_id <> "00000000-0000-0000-0000-000000000000"

  union all 

  select l.event_date
    , l.user_pseudo_id
    , case when l.advertising_id = "" then cast (l.vendor_id as string)
else l.advertising_id end as advertising_id 
    , l.app_version
    , upper(l.platform) as platform
    , case when l.country in ('None', 'N/A', '') or l.country is null then 'Unknown'
        else l.country
    end as country
    , l.online_time
    , l.max_level

    , null as engagement_time_msec
    , l.ga_session_id
    , l.ga_session_number
    , 'Level_End' as event_name
  from jda-k1.mobile_games.level_end l
  where l.advertising_id <> "0000-0000"
  and l.advertising_id <> "00000000-0000-0000-0000-000000000000"
)

-- giữ lại bản ghi đầu tiên và cuối cùng của mỗi phiên (session) trong ngày
-- tạo cột giả iaa, iap để chuẩn bị union
, user_engagement as( 
  select * except(row_asc, row_desc)
    , cast(null as string) as product_id_iap
    , cast(0 as float64) as rev_iap
    , cast(0 as float64) as rev_iaa
    , cast(null as string) placement
    , cast(null as string) as_source
    , cast(null as string) ad_format
  from 
    (select * 
      , row_number() over(partition by advertising_id, event_date, cast(ga_session_number as int) order by event_date asc) as row_asc
      , row_number() over(partition by advertising_id, event_date, cast (ga_session_number as int) order by event_date desc) as row_desc
    from raw_user_engagement)
  where row_asc = 1 
  or row_desc = 1
)

-- xử lý bảng iap
, iap as (
  select event_date
  , p.user_pseudo_id
  , case when p.advertising_id = "" then cast (p.vendor_id as string) else p.advertising_id end as advertising_id
  , p.app_version
  , upper(p.platform) as platform
  , case when p.country in ('None', 'N/A', '') or p.country is null then 'Unknown'
        else p.country
    end as country
  , p.online_time
  , p.max_level
  -- , p.max_res
  -- , p.player_id
  , null as engagement_time_msec
  , p.ga_session_id
  , p.ga_session_number
  , 'in_app_purchase' as event_name
  , p.product_id as product_id_iap
  , cast(p.event_value_in_usd as float64) as rev_iap
  , cast(0 as float64) as rev_iaa
  , cast(null as string) placement
  , cast(null as string) ad_source
  , cast(null as string) ad_format
  from jda-k1.mobile_games.in_app_purchase p
  where p.advertising_id <> "0000-0000"
  and p.advertising_id <> "00000000-0000-0000-0000-000000000000"
)

-- xử lý bảng iaa
, iaa as (
  select
    a.event_date
  , a.user_pseudo_id
  , case when a.advertising_id = "" then cast (a.vendor_id as string) else a.advertising_id end as advertising_id
  , a.app_version
  , upper(a.platform) as platform
  , case when a.country in ('None', 'N/A', '') or a.country is null then 'Unknown'
        else a.country
  end as country
  , a.online_time
  , a.max_level
  -- , a.max_res
  -- , a.player_id
  , null as engagement_time_msec
  , a.ga_session_id
  , a.ga_session_number
  , "ad_impression" as event_name
  , cast(null as STRING) as product_id_iap
  , cast(0 as float64) as rev_iap
  , a.revenue as rev_iaa
  , a.placement 
  , a.ad_source 
  , a.ad_format
   
  from jda-k1.mobile_games.ad_impression a
  -- where a._table_suffix >= "20250715"
  where a.advertising_id <> "0000-0000"
  and a.advertising_id <> "00000000-0000-0000-0000-000000000000"
)

-- union 3 bảng về chung 1 bảng
, result as (
  select 'Engage' as table_name
  , *
  from user_engagement
  union all
  select 'IAP' as table_name
  , *
  from iap
  union all
  select 'IAA' as table_name
  , *
  from iaa
)

-- tìm ngày cài đặt thực tế của người dùng
, clean_install_date as
(select advertising_id, min(date(event_date)) as min_event_timestamp
from result 
group by 1)

-- kết hợp ngày cài đặt vào bảng dữ liệu cuối cùng
, final_result as
(select a.*
  , b.min_event_timestamp  as install_date
from result a
left join clean_install_date b on a.advertising_id = b.advertising_id
order by advertising_id, install_date asc)


select * from final_result
where app_version = "3.1.1"
and event_date <= "2025-08-10"
and event_date >= "2025-07-15"














=======
/*
Project: Game Analytics - Hospital Frenzy
Author: Lại Thụy Bình
Description:
- Cleaning raw data from multiple sources.
- Handling NULL values in advertising_id using vendor_id fallback.
- Standardizing Country and Platform names.
-- */


-- xử lý dữ liệu và union 2 bảng tutorial và level_end
with raw_user_engagement as(
  select event_date
    , t.user_pseudo_id
    , case when t.advertising_id = "" then cast (t.vendor_id as string)
else t.advertising_id end as advertising_id
    , t.app_version
    , upper(t.platform) as platform
    , case when t.country in ('None', 'N/A', '') or t.country is null then 'Unknown'
        else t.country
    end as country
    , t.online_time
    , t.max_level

    , null as engagement_time_msec
    , t.ga_session_id
    , t.ga_session_number
    , 'tutorial' as event_name
  from jda-k1.mobile_games.tutorial t
  where t.advertising_id <> "0000-0000"
  and t.advertising_id <> "00000000-0000-0000-0000-000000000000"

  union all 

  select l.event_date
    , l.user_pseudo_id
    , case when l.advertising_id = "" then cast (l.vendor_id as string)
else l.advertising_id end as advertising_id 
    , l.app_version
    , upper(l.platform) as platform
    , case when l.country in ('None', 'N/A', '') or l.country is null then 'Unknown'
        else l.country
    end as country
    , l.online_time
    , l.max_level

    , null as engagement_time_msec
    , l.ga_session_id
    , l.ga_session_number
    , 'Level_End' as event_name
  from jda-k1.mobile_games.level_end l
  where l.advertising_id <> "0000-0000"
  and l.advertising_id <> "00000000-0000-0000-0000-000000000000"
)

-- giữ lại bản ghi đầu tiên và cuối cùng của mỗi phiên (session) trong ngày
-- tạo cột giả iaa, iap để chuẩn bị union
, user_engagement as( 
  select * except(row_asc, row_desc)
    , cast(null as string) as product_id_iap
    , cast(0 as float64) as rev_iap
    , cast(0 as float64) as rev_iaa
    , cast(null as string) placement
    , cast(null as string) as_source
    , cast(null as string) ad_format
  from 
    (select * 
      , row_number() over(partition by advertising_id, event_date, cast(ga_session_number as int) order by event_date asc) as row_asc
      , row_number() over(partition by advertising_id, event_date, cast (ga_session_number as int) order by event_date desc) as row_desc
    from raw_user_engagement)
  where row_asc = 1 
  or row_desc = 1
)

-- xử lý bảng iap
, iap as (
  select event_date
  , p.user_pseudo_id
  , case when p.advertising_id = "" then cast (p.vendor_id as string) else p.advertising_id end as advertising_id
  , p.app_version
  , upper(p.platform) as platform
  , case when p.country in ('None', 'N/A', '') or p.country is null then 'Unknown'
        else p.country
    end as country
  , p.online_time
  , p.max_level
  -- , p.max_res
  -- , p.player_id
  , null as engagement_time_msec
  , p.ga_session_id
  , p.ga_session_number
  , 'in_app_purchase' as event_name
  , p.product_id as product_id_iap
  , cast(p.event_value_in_usd as float64) as rev_iap
  , cast(0 as float64) as rev_iaa
  , cast(null as string) placement
  , cast(null as string) ad_source
  , cast(null as string) ad_format
  from jda-k1.mobile_games.in_app_purchase p
  where p.advertising_id <> "0000-0000"
  and p.advertising_id <> "00000000-0000-0000-0000-000000000000"
)

-- xử lý bảng iaa
, iaa as (
  select
    a.event_date
  , a.user_pseudo_id
  , case when a.advertising_id = "" then cast (a.vendor_id as string) else a.advertising_id end as advertising_id
  , a.app_version
  , upper(a.platform) as platform
  , case when a.country in ('None', 'N/A', '') or a.country is null then 'Unknown'
        else a.country
  end as country
  , a.online_time
  , a.max_level
  -- , a.max_res
  -- , a.player_id
  , null as engagement_time_msec
  , a.ga_session_id
  , a.ga_session_number
  , "ad_impression" as event_name
  , cast(null as STRING) as product_id_iap
  , cast(0 as float64) as rev_iap
  , a.revenue as rev_iaa
  , a.placement 
  , a.ad_source 
  , a.ad_format
   
  from jda-k1.mobile_games.ad_impression a
  -- where a._table_suffix >= "20250715"
  where a.advertising_id <> "0000-0000"
  and a.advertising_id <> "00000000-0000-0000-0000-000000000000"
)

-- union 3 bảng về chung 1 bảng
, result as (
  select 'Engage' as table_name
  , *
  from user_engagement
  union all
  select 'IAP' as table_name
  , *
  from iap
  union all
  select 'IAA' as table_name
  , *
  from iaa
)

-- tìm ngày cài đặt thực tế của người dùng
, clean_install_date as
(select advertising_id, min(date(event_date)) as min_event_timestamp
from result 
group by 1)

-- kết hợp ngày cài đặt vào bảng dữ liệu cuối cùng
, final_result as
(select a.*
  , b.min_event_timestamp  as install_date
from result a
left join clean_install_date b on a.advertising_id = b.advertising_id
order by advertising_id, install_date asc)


select * from final_result
where app_version = "3.1.1"
and event_date <= "2025-08-10"
and event_date >= "2025-07-15"














>>>>>>> 845321cad6474f173526378c00f2e17d9592366f
