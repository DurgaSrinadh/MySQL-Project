USE sales_analysis;

CREATE OR REPLACE VIEW v_completed_sales AS
SELECT o.order_id, c.customer_name, c.city, o.order_date,
       SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY o.order_id, c.customer_name, c.city, o.order_date;

CREATE OR REPLACE VIEW v_product_revenue AS
SELECT p.product_id, p.product_name, p.category,
       SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.product_id, p.product_name, p.category;

CREATE OR REPLACE VIEW v_category_revenue AS
SELECT p.category, SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.category;

SELECT * FROM v_completed_sales ORDER BY order_date;
SELECT * FROM v_product_revenue ORDER BY total_revenue DESC;
SELECT * FROM v_category_revenue ORDER BY total_revenue DESC;
SHOW FULL TABLES WHERE Table_type = 'VIEW';
