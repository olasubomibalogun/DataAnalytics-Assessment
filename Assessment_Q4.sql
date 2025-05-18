-- Final result: Customer-wise CLV based on transaction volume and tenure
SELECT 
    *, 
    -- Estimated CLV = (transactions/month) * 12 * profit rate (0.1% or 0.001)
    ROUND((total_transactions / NULLIF(tenure_months, 0)) * 12 * 0.001, 2) AS estimated_clv
FROM (
    -- Subquery: calculate account tenure and total transactions per customer
    SELECT 
        c.id AS customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS name,   

        -- Calculate account tenure in months
        TIMESTAMPDIFF(MONTH, c.date_joined, CURDATE()) AS tenure_months, 

        -- Count total transactions by customer
        COUNT(t.id) AS total_transactions
    FROM 
        adashi_staging.users_customuser c

    -- Join transactions made by each customer
    LEFT JOIN adashi_staging.savings_savingsaccount t 
        ON t.owner_id = c.id

    -- Group by customer to aggregate results
    GROUP BY 
        c.id, 
        c.first_name, 
        c.last_name, 
        c.date_joined
) AS y

-- Sort customers by CLV in descending order
ORDER BY 
    estimated_clv DESC;
