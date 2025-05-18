SELECT 
    *, 
    DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
FROM (
    SELECT 
        p.id, 
        p.owner_id,
        CASE 
            WHEN is_a_fund = 1 THEN 'Investment' 
            WHEN is_regular_savings = 1 THEN 'Savings' 
        END AS type, 
        MAX(transaction_date) AS last_transaction_date
    FROM 
        adashi_staging.plans_plan p
    LEFT JOIN 
        adashi_staging.savings_savingsaccount a 
        ON a.plan_id = p.id
    WHERE 
        p.is_deleted = 0
    GROUP BY 
        p.id, p.owner_id
) AS x
WHERE 
    type IS NOT NULL 
    AND DATEDIFF(CURDATE(), last_transaction_date) > 365;
