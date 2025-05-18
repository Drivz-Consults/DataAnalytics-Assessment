-- Question 3: Account Inactivity Alert --
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
/* create a select querry to get the last transaction date from the plans_plan table. 
create another select querry that also gets the last transaction date from the savings table,
join both querries using the UNION ALL function, then nest both as a subquerry in FROM, then give it an alias */
FROM (
    SELECT 
        id AS plan_id,
        owner_id,
        'Savings' AS type,
        MAX(transaction_date) AS last_transaction_date
    FROM adashi_staging.savings_savingsaccount
    WHERE amount > 0
    GROUP BY id, owner_id
    HAVING MAX(transaction_date) < DATE_SUB(CURDATE(), INTERVAL 365 DAY)
    
    UNION ALL
    
    SELECT 
        id AS plan_id,
        owner_id,
        'Investment' AS type,
        MAX(created_on) AS last_transaction_date
    FROM plans_plan
    WHERE amount > 0
    GROUP BY id, owner_id
    HAVING MAX(created_on) < DATE_SUB(CURDATE(), INTERVAL 365 DAY)
) AS inactive_accounts
ORDER BY inactivity_days DESC;