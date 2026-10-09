-- Query 1: RFM Customer Segmentation
WITH customer_stats AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        DATEDIFF(day, MAX(o.order_date), '2026-10-01') AS recency_days,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.quantity * oi.unit_price) AS monetary_value
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT 
    customer_id,
    customer_name,
    recency_days,
    frequency,
    monetary_value,
    CASE 
        WHEN frequency >= 5 AND monetary_value >= 1000 THEN 'VIP / High Value'
        WHEN recency_days > 180 THEN 'At Risk / Churned'
        WHEN frequency BETWEEN 2 AND 4 THEN 'Regular'
        ELSE 'New / Low Engagement'
    END AS customer_segment
FROM customer_stats;
