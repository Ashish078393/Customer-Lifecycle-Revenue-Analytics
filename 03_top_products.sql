-- Query 3: Product Ranking & Top 3 Products per Category
WITH product_sales AS (
    SELECT 
        cat.category_name,
        p.product_name,
        SUM(oi.quantity * oi.unit_price) AS total_product_revenue,
        DENSE_RANK() OVER (
            PARTITION BY cat.category_name 
            ORDER BY SUM(oi.quantity * oi.unit_price) DESC
        ) AS rank_in_category
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN categories cat ON p.category_id = cat.category_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY cat.category_name, p.product_name
)
SELECT 
    category_name,
    product_name,
    total_product_revenue,
    rank_in_category
FROM product_sales
WHERE rank_in_category <= 3;
