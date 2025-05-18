-- Question 2: Transaction Frequency Analysis --
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    AVG(avg_transactions_per_month) AS avg_transactions_per_month
    
/* make a nested subquerry that gets the count of transaction per month based on each owner_id, then 
use case statement to classify the transaction count into HIgh, Medium, Low Frequencies. Then order these frequencies accordingly
as High, Medium, and Low Frequencies. */
FROM (
    SELECT 
        u.id,
        CASE 
            WHEN COALESCE(AVG(trans.transaction_count), 0) >= 10 THEN 'High Frequency'
            WHEN COALESCE(AVG(trans.transaction_count), 0) >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        COALESCE(AVG(trans.transaction_count), 0) AS avg_transactions_per_month
    FROM users_customuser AS u
    LEFT JOIN (
        SELECT 
            owner_id,
            YEAR(transaction_date) AS trans_year,
            MONTH(transaction_date) AS trans_month,
            COUNT(*) AS transaction_count
        FROM adashi_staging.savings_savingsaccount
        GROUP BY owner_id, YEAR(transaction_date), MONTH(transaction_date)
    ) AS trans
        ON u.id = trans.owner_id
    GROUP BY u.id
) AS customer_freq
GROUP BY frequency_category
ORDER BY 
    CASE frequency_category 
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        WHEN 'Low Frequency' THEN 3
    END;