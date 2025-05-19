-- CTE to compute per-customer transaction statistics
WITH CustomerTransactionStats AS (
    SELECT 
        u.id AS customer_id, -- Customer ID
        COUNT(*) AS total_transactions, -- Total number of transactions (inflows or outflows)
        TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) + 1 AS active_months, -- Active months between first and last transaction
        COUNT(*) / (TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) + 1) AS avg_transactions_per_month -- Average transactions per month
    FROM 
        users_customuser u -- Users table
        INNER JOIN savings_savingsaccount s ON u.id = s.owner_id -- Join with savings accounts for transactions
    WHERE 
        s.confirmed_amount > 0  -- Include only inflow or outflow transactions
    GROUP BY 
        u.id -- Group by customer
)
-- Categorize customers by transaction frequency
SELECT 
    CASE 
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency' -- 10 or more transactions per month
        WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency' -- 3 to 9 transactions per month
        ELSE 'Low Frequency' -- 2 or fewer transactions per month
    END AS frequency_category, -- Frequency category label
    COUNT(*) AS customer_count, -- Number of customers in each category
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month -- Average transactions per month for the category
FROM 
    CustomerTransactionStats -- Use CTE results
GROUP BY 
    CASE 
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END -- Group by frequency category
ORDER BY 
    avg_transactions_per_month DESC; -- Sort by average transactions per month