-- Query 4: Cohort Retention Analysis
WITH first_purchase AS (
    SELECT 
        customer_id,
        MIN(DATETRUNC('month', order_date)) AS cohort_month
    FROM orders
    GROUP BY customer_id
),
user_activities AS (
    SELECT 
        o.customer_id,
        fp.cohort_month,
        DATEDIFF('month', fp.cohort_month, DATETRUNC('month', o.order_date)) AS month_number
    FROM orders o
    JOIN first_purchase fp ON o.customer_id = fp.customer_id
    WHERE o.order_status = 'Completed'
)
SELECT 
    cohort_month,
    month_number,
    COUNT(DISTINCT customer_id) AS active_users
FROM user_activities
GROUP BY cohort_month, month_number
ORDER BY cohort_month, month_number;
