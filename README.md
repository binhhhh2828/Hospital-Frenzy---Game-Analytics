# Hospital Frenzy – Game Analytics Project

## Project Overview
This is a personal data analysis project focusing on player behavior in the mobile game *Hospital Frenzy*.
The project aims to understand player retention, churn, and revenue contribution across different player segments.
It was done mainly as a learning project to practice game analytics and exploratory data analysis.

---

## Business Questions
- How does player retention change over time (D1, D7, D10)?
- At which stage do players churn the most?
- How is revenue distributed among different player segments?
- Are there differences in behavior across regions?

---

## Dataset
- The dataset contains player activity and transaction records.
- Main fields include:
  - Player ID
  - Event date
  - Player level
  - Country
  - Revenue
- The data used in this repository is anonymized and simplified for analysis purposes.

---

## Analysis Approach
1. Data cleaning and preprocessing
2. Player lifecycle analysis
3. Retention and churn calculation (D1, D10)
4. Revenue contribution by player segments
5. Regional comparison

---

## Key Metrics
- **DAU (Daily Active Users)**: Approximately 13,000 users
- **Retention**:
  - D1 retention around 15%
  - D10 retention around 2–3%
- **Revenue Concentration**:
  - Top 1% of players contributed about 75% of total revenue

---

## Key Insights
- Severe early churn occurred at Level 1, indicating onboarding issues.
- Retention dropped significantly after the first day, suggesting low early engagement.
- Revenue was highly dependent on a very small group of VIP players.
- Japan showed higher retention compared to other regions, while the USA was the main revenue driver.

---

## Recommendations
- Improve onboarding experience at early levels to reduce first-day churn.
- Focus on retention strategies for high-value players (VIP segment).
- Optimize in-app purchase (IAP) offers and event cadence to support monetization.

---

## Tools Used
- Python
- SQL
- Excel

---

## Project Structure
├── hospital_frenzy_analysis.ipynb
├── Phân tích Game Hospital Frenzy (15_7 -10_8).pdf
├── README.md

---

## Limitations
- The dataset is limited and does not represent a full production environment.
- The analysis focuses on exploratory insights rather than predictive modeling.

---

## Author
**Lai Thuy Binh**  
IT Student | Data Analyst Intern Candidate
