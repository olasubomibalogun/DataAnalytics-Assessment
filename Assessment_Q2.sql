-- Final output: frequency category, customer count in that category,
-- and the average number of transactions per month for that category
SELECT 
    frequency_category, 
    COUNT(owner_id) AS customer_count, 
    FORMAT(AVG(avg_transactions_per_month), 1) AS average_transactions_per_month
FROM (
    
    -- Step 2: Assign a frequency category based on average transactions per month
    SELECT 
        *,
        CASE 
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            WHEN avg_transactions_per_month <= 2 THEN 'Low Frequency'
        END AS frequency_category
    FROM (
        
        -- Step 1: Calculate total transactions and active months for each customer
        SELECT 
            t.owner_id,
            COUNT(*) AS total_transactions,
            COUNT(DISTINCT DATE_FORMAT(t.transaction_date, '%Y-%m')) AS active_months,

            -- Calculate average number of transactions per active month
            ROUND(
                COUNT(*) / NULLIF(COUNT(DISTINCT DATE_FORMAT(t.transaction_date, '%Y-%m')), 0),
                0
            ) AS avg_transactions_per_month
        FROM 
            adashi_staging.savings_savingsaccount t
        GROUP BY 
            t.owner_id
    ) AS x

) AS y

-- Step 3: Group by frequency category
GROUP BY 
    frequency_category;
