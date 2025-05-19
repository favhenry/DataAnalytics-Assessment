-- CTE to compute customer tenure, transactions, and profit
WITH CustomerStats AS (
    SELECT 
        u.id AS customer_id, -- Customer ID
        u.name, -- Customer name
        TIMESTAMPDIFF(MONTH, u.date_joined, '2025-05-19') AS tenure_months, -- Months since signup
        COUNT(*) AS total_transactions, -- Total number of transactions
        SUM(COALESCE(s.confirmed_amount, 0) ) / 100.0 * 0.001 AS total_profit -- Total profit (0.1% of transaction value in base currency)
    FROM 
        users_customuser u -- Users table with signup date
        INNER JOIN savings_savingsaccount s ON u.id = s.owner_id -- Join with savings accounts for transactions
    WHERE 
        s.confirmed_amount > 0  -- Include only inflow or outflow transactions
    GROUP BY 
        u.id, u.name, u.date_joined -- Group by customer and signup date
)
-- Calculate CLV for each customer
SELECT 
    customer_id, -- Customer ID
    name, -- Customer name
    tenure_months, -- Account tenure in months
    total_transactions, -- Total number of transactions
    CONCAT('₦', FORMAT(
        (total_transactions / NULLIF(tenure_months, 0)) * 12 * (total_profit / NULLIF(total_transactions, 0)),
        2
    )) AS estimated_clv -- CLV: annualized transactions * average profit per transaction, formatted in Naira
FROM 
    CustomerStats -- Use CTE results
WHERE 
    tenure_months > 0 -- Exclude customers with zero tenure to avoid division by zero
ORDER BY 
    (total_transactions / NULLIF(tenure_months, 0)) * 12 * (total_profit / NULLIF(total_transactions, 0)) DESC; -- Sort by raw CLV value