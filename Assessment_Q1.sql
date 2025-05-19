
SELECT 
    u.id AS owner_id, -- Customer ID from users table
    u.name, -- Customer name
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.plan_id END) AS savings_count, -- Count distinct savings plans
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.plan_id END) AS investment_count, -- Count distinct investment plans
    CONCAT('₦', FORMAT(SUM(s.confirmed_amount) / 100.0, 2)) AS total_deposits -- Sum of confirmed amounts in Naira with ₦ symbol
FROM 
    users_customuser u -- Users table with customer info
    INNER JOIN savings_savingsaccount s ON u.id = s.owner_id -- Join with savings accounts to get transactions
    INNER JOIN plans_plan p ON s.plan_id = p.id -- Join with plans to identify savings/investment types
WHERE 
    s.confirmed_amount > 0 -- Only include funded plans (non-zero deposits)
GROUP BY 
    u.id, u.name -- Group by customer to aggregate their plans
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.plan_id END) >= 1 -- Ensure at least one savings plan
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.plan_id END) >= 1 -- Ensure at least one investment plan
ORDER BY 
    total_deposits DESC; -- Sort by total deposits in descending order