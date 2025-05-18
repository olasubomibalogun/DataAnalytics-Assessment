SELECT 
    c.id AS owner_id,
    CONCAT(c.first_name, ' ', c.last_name) AS name,
    
    COUNT(DISTINCT CASE 
        WHEN s.is_regular_savings = 1 AND s.amount > 0 THEN s.id 
    END) AS savings_count,

    COUNT(DISTINCT CASE 
        WHEN s.is_a_fund = 1 AND s.amount > 0 THEN s.id 
    END) AS investment_count,

    format(COALESCE(t.total_deposits, 0),2) AS total_deposits

FROM 
    adashi_staging.users_customuser c

LEFT JOIN 
    adashi_staging.plans_plan s ON s.owner_id = c.id

LEFT JOIN (
    SELECT 
        owner_id, 
        SUM(confirmed_amount) AS total_deposits
    FROM 
        adashi_staging.savings_savingsaccount
    GROUP BY 
        owner_id
) t ON t.owner_id = c.id

GROUP BY 
    c.id, c.first_name, c.last_name, t.total_deposits

HAVING 
    savings_count > 0 AND 
    investment_count > 0

ORDER BY 
    total_deposits DESC;
