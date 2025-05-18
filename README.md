# DataAnalytics-Assessment
# Question 1: High-Value Customers with Multiple Products
**Steps:**
1. Identified customers with funded (amount > 0) savings and investment plans using users_customuser, savings_savingsaccount, and plans_plan.
2. Used LEFT JOIN to match customers with both plan types via owner_id, avoiding overcounting from prior join issues with the use of subqueries.
3. Summed amount from both tables in subqueries to calculate total deposits.
4. Sorted by total deposits DESC

# Question 2: Transaction Frequency Analysis
**Steps:**
1. Counted all transactions in savings_savingsaccount per customer per month using YEAR(transaction_date) and MONTH(transaction_date).
2. Fixed overcounting from joins by pre-aggregating in a subquery before joining with users_customuser.
3. Categorized averages (≥10, 3-9, ≤2 transactions/month) as High, Medium, Low Frequency with CASE.
4. Grouped by category for Frequency_category, Customer_count, Avg_transactions_per_month

# Question 3: Account Inactivity Alert
**Steps:**
1. Flagged savings accounts with no amount > 0 transactions since May 18, 2024, using created_at in savings_savingsaccount.
2. For plans_plan, used created on date column to get last transaction till date.
3. Used UNION ALL to combine savings and investment accounts, avoiding join complexity.
4. Output plan_id, owner_id, type, last_transaction_date, inactivity_days.

# Question 4: Customer Lifetime Value (CLV) Estimation
**Steps:**
1. Calculated tenure using TIMESTAMPDIFF on date_joined from users_customuser, setting minimum of 1 month.
2. Counted all transactions and averaged profit by the stipulated profit percentage (amount * 0.001) in savings_savingsaccount via subquery.
3. Applied CLV formula: (total_transactions / tenure) * 12 * avg_profit_per_transaction as given in the instructions, using LEFT JOIN for all customers.
4. Sorted by estimated_clv in DESCENDING order.

## Challenges Faced
- The only challenge I faced was the overcounting problem when I was trying to solve the first question, and I was getting million-rows 
 as savings_count, while the entire data row count is not up to a million.
  I resolved this through the use of using subqueries to nest the two tables
  I was getting the savings count and investment count from. This aided my quick resolution in the remaining three questions, as I didn't
  make such mistake again.
