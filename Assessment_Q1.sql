-- Checking the content of each table involved in the solution --
SELECT COUNT(*) FROM savings_savingsaccount;
SELECT COUNT(*) FROM plans_plan;
SELECT COUNT(*) FROM users_customuser;
-- Question 1: High-Value Customers with Multiple Products --
SELECT 
    s.owner_id,
    u.name,
    s.savings_count,
    COALESCE(p.investment_count, 0) AS investment_count,
    s.total_deposits
-- make a subquerry of savings table that counts the saving per owner_id (customer), and sum of amount (total savings), and use it as the grom table --
FROM (
    SELECT 
        owner_id,
        COUNT(CASE WHEN amount > 0 THEN 1 END) AS savings_count,
        SUM(amount) AS total_deposits
    FROM adashi_staging.savings_savingsaccount
    GROUP BY owner_id
) AS s
-- join the users_customeuser table to get the name of each customer from it. --
LEFT JOIN users_customuser AS u
    ON s.owner_id = u.id
-- join the plans table through a subquerry to get the investments count ---
LEFT JOIN (
    SELECT 
        owner_id,
        COUNT(CASE WHEN amount > 0 THEN 1 END) AS investment_count
    FROM plans_plan
    GROUP BY owner_id
) AS p
    ON s.owner_id = p.owner_id
ORDER BY s.total_deposits DESC
LIMIT 5;
-- These subquerries are used to avoid overcounting of the savings and investments counts across the joined tables. --
