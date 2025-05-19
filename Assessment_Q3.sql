-- Select plans with no recent inflow transactions
SELECT 
    s.plan_id, -- Plan ID from savings account
    p.owner_id, -- Owner ID from plans table
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings' -- Label as Savings if regular savings plan
        WHEN p.is_a_fund = 1 THEN 'Investment' -- Label as Investment if fund
    END AS type, -- Plan type
    MAX(s.transaction_date) AS last_transaction_date, -- Most recent inflow transaction date
    DATEDIFF('2025-05-19', MAX(s.transaction_date)) AS inactivity_days -- Days since last inflow
FROM 
    plans_plan p -- Plans table with plan type info
    INNER JOIN savings_savingsaccount s ON p.id = s.plan_id -- Join with savings accounts for transactions
WHERE 
    s.confirmed_amount > 0 -- Only consider inflow transactions
GROUP BY 
    s.plan_id, p.owner_id, p.is_regular_savings, p.is_a_fund -- Group by plan and owner to get latest transaction per plan
HAVING 
    DATEDIFF('2025-05-19', MAX(s.transaction_date) ) > 365 -- Filter for plans with no inflows for over 365 days
ORDER BY 
    inactivity_days DESC; -- Sort by inactivity duration