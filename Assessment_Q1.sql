SELECT 
    c.id AS owner_id,
    CONCAT(c.first_name, ' ', c.last_name) AS name,

    -- Count of funded savings plans
    COUNT(DISTINCT CASE 
        WHEN s.is_regular_savings = 1 AND s.amount > 0 THEN s.id 
    END) AS savings_count,

    -- Count of funded investment plans
    COUNT(DISTINCT CASE 
        WHEN s.is_a_fund = 1 AND s.amount > 0 THEN s.id 
    END) AS investment_count,

    -- Total deposits from savings accounts, formatted to 2 decimal places
    FORMAT(COALESCE(t.total_deposits, 0), 2) AS total_deposits

FROM 
    adashi_staging.users_customuser c

-- Join with plans to evaluate each user's plan types and funding
LEFT JOIN 
    adashi_staging.plans_plan s 
    ON s.owner_id = c.id

-- Subquery to compute total confirmed deposits per customer
LEFT JOIN (
    SELECT 
        owner_id, 
        SUM(confirmed_amount) AS total_deposits
    FROM 
        adashi_staging.savings_savingsaccount
    GROUP BY 
        owner_id
) t ON t.owner_id = c.id

-- Grouping by unique user and their deposit total
GROUP BY 
    c.id, c.first_name, c.last_name, t.total_deposits

-- Filter: Only include users who have at least one funded savings AND one funded investment plan
HAVING 
    savings_count > 0 AND 
    investment_count > 0

-- Sort by highest deposit total
ORDER BY 
    total_deposits DESC;
