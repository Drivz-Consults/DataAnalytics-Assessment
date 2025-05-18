-- Question 4: Customer Lifetime Value (CLV) Estimation --
-- use coalesce to leave out null values in columns for aggregation. --
SELECT 
    u.id AS customer_id,
    u.name,
    GREATEST(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 1) AS tenure_months,
    COALESCE(trans.total_transactions, 0) AS total_transactions,
    COALESCE(
        (COALESCE(trans.total_transactions, 0) / GREATEST(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 1)) * 12 * COALESCE(trans.avg_profit_per_transaction, 0),
        0
    ) AS estimated_clv
FROM users_customuser AS u
--  use a subquerry to calculate the profit percentage per customer transaction, then give it an alias that will be called in the select function --
LEFT JOIN (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,
        AVG(amount * 0.001) AS avg_profit_per_transaction
    FROM adashi_staging.savings_savingsaccount
    GROUP BY owner_id
) AS trans
    ON u.id = trans.owner_id
-- order by customer life value in descending order to have high profiters at the top
ORDER BY estimated_clv DESC;