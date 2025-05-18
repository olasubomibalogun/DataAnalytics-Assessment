SELECT 
    *, 
    ROUND((total_transactions / NULLIF(tenure_months, 0)) * 12 * 0.001, 2) AS estimated_clv
FROM (
    SELECT 
        c.id AS customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS name,   
        TIMESTAMPDIFF(MONTH, c.date_joined, CURDATE()) AS tenure_months, 
        COUNT(t.id) AS total_transactions
    FROM 
        adashi_staging.users_customuser c
    LEFT JOIN adashi_staging.savings_savingsaccount t 
        ON t.owner_id = c.id
    GROUP BY 
        c.id, c.first_name, c.last_name, c.date_joined
) AS y
ORDER BY 
    estimated_clv DESC;
