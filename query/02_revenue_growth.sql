-- Query 2: Running Revenue Total & Month-over-Month Growth Rate
WITH monthly_revenue AS (
    SELECT 
        DATETRUNC('month', o.order_date) AS sales_month,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY DATETRUNC('month', o.order_date)
)
SELECT 
    sales_month,
    total_revenue,
    SUM(total_revenue) OVER (ORDER BY sales_month) AS running_total_revenue,
    LAG(total_revenue) OVER (ORDER BY sales_month) AS prev_month_revenue,
    ROUND(
        ((total_revenue - LAG(total_revenue) OVER (ORDER BY sales_month)) 
        / NULLIF(LAG(total_revenue) OVER (ORDER BY sales_month), 0)) * 100, 2
    ) AS mom_growth_percentage
FROM monthly_revenue;
