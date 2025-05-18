-- Final result: All active savings or investment plans with no transactions in the last 365 days
SELECT 
    *, 
    -- Calculate number of days since last transaction
    DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
FROM (
    -- Subquery to get the last transaction date for each active plan
    SELECT 
        p.id AS plan_id, 
        p.owner_id,

        -- Determine plan type: 'Investment' or 'Savings'
        CASE 
            WHEN is_a_fund = 1 THEN 'Investment' 
            WHEN is_regular_savings = 1 THEN 'Savings' 
        END AS type,

        -- Get the most recent transaction date for each plan
        MAX(transaction_date) AS last_transaction_date
    FROM 
        adashi_staging.plans_plan p

    -- Join with transactions table using plan ID
    LEFT JOIN 
        adashi_staging.savings_savingsaccount a 
        ON a.plan_id = p.id

    -- Only consider non-deleted plans
    WHERE 
        p.is_deleted = 0

    -- Group by unique plan and owner
    GROUP BY 
        p.id, 
        p.owner_id
) AS x

-- Filter only savings/investment plans and check if last transaction was over a year ago
WHERE 
    type IS NOT NULL 
    AND DATEDIFF(CURDATE(), last_transaction_date) > 365;
