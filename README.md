# DataAnalytics-Assessment
This repository contains SQL solutions to a four-question data analytics assessment focused on customer behavior, transaction frequency, account activity, and customer lifetime value (CLV). Each solution is provided as a standalone SQL script, along with detailed explanations of the approach and any challenges encountered.

---

## 📁 Repository Structure
DataAnalytics-Assessment/
│
├── Assessment_Q1.sql # High-Value Customers with Multiple Products
├── Assessment_Q2.sql # Transaction Frequency Analysis
├── Assessment_Q3.sql # Account Inactivity Alert
├── Assessment_Q4.sql # Customer Lifetime Value (CLV) Estimation
└── README.md # This documentation file


---

## ✅ Per-Question Explanations

### **Q1. High-Value Customers with Multiple Products**

**Scenario**: Identify customers who have both a funded savings and investment plan.

**Approach**:
- Used `INNER JOIN` between `users_customuser`, `plans_plan`, and `savings_savingsaccount`.
- Applied filters for:
  - `is_regular_savings = 1` and `confirmed_amount > 0` for savings plans.
  - `is_a_fund = 1` and `confirmed_amount > 0` for investment plans.
- Aggregated count of each plan type per customer and calculated total deposits.
- Grouped by customer ID and name, then sorted by total deposit amount.

**Challenge**:
- Ensuring that duplicate transactions or plans were not double-counted. This was resolved using proper `GROUP BY` and `COUNT(DISTINCT plan_id)` as needed.

---

### **Q2. Transaction Frequency Analysis**

**Scenario**: Segment customers by how often they transact.

**Approach**:
- Calculated `total_transactions` per customer from `savings_savingsaccount` using inflow and outflow events.
- Calculated account `active_months` using the difference between the earliest and latest transaction dates.
- Computed `avg_transactions_per_month` = total transactions / active months.
- Categorized customers into "High", "Medium", or "Low" frequency.
- Used a Common Table Expression (CTE) to cleanly compute intermediate statistics.

**Challenge**:
- Correctly accounting for the active time range. Used `TIMESTAMPDIFF(MONTH, MIN(...), MAX(...)) + 1` to ensure both end months are counted.

---

### **Q3. Account Inactivity Alert**

**Scenario**: Flag plans that haven't had inflows in over 365 days.

**Approach**:
- Focused on `confirmed_amount > 0` transactions only.
- Used `MAX(transaction_date)` to determine the last inflow date per plan.
- Computed inactivity duration using `DATEDIFF(CURRENT_DATE, last_transaction_date)`.
- Categorized plan types as 'Savings' or 'Investment' using `is_regular_savings` and `is_a_fund`.

**Challenge**:
- In MySQL, `DATEDIFF` accepts only two arguments. Initial use of SQL Server syntax (`DATEDIFF(DAY, ...)`) caused errors, which was corrected.

---

### **Q4. Customer Lifetime Value (CLV) Estimation**

**Scenario**: Estimate CLV using a simplified profit model.

**Approach**:
- Calculated `tenure_months` since user signup from `date_joined`.
- Counted total transactions (inflows and outflows).
- Assumed `profit_per_transaction` = 0.1% of transaction value (converted from Kobo).
- Formula: `CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction`.
- Sorted output by CLV descending.

**Challenge**:
- Ensuring unit consistency for monetary values (Kobo to Naira).
- Handling customers with tenure = 0 to avoid division by zero (used conditional logic or filtered such cases).

---

## ⚠️ Important Notes

- All solutions are original and authored by the candidate.
- No database dumps or non-SQL files are included.


---

## 🛠️ Tech Stack

- **Database**: MySQL
- **Language**: SQL (ANSI-compliant syntax adapted for MySQL)

---

## 📬 Contact

For further questions about this assessment or the SQL scripts, please contact the project author directly.

