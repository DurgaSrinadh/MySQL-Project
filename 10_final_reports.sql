USE sales_analysis;

-- 1. Overall sales summary
SELECT COUNT(DISTINCT o.order_id) AS completed_orders,
       SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * oi.unit_price) AS total_revenue,
       ROUND(SUM(oi.quantity * oi.unit_price) / COUNT(DISTINCT o.order_id), 2)
           AS average_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed';

-- 2. Best customer by completed spending
SELECT c.customer_name, c.city, SUM(oi.quantity * oi.unit_price) AS total_spending
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY total_spending DESC LIMIT 1;

-- 3. Low-stock products
SELECT product_name, category, stock FROM products
WHERE stock < 15 ORDER BY stock ASC;

-- 4. Cancelled order values
SELECT o.order_id, c.customer_name, o.order_date,
       SUM(oi.quantity * oi.unit_price) AS order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Cancelled'
GROUP BY o.order_id, c.customer_name, o.order_date
ORDER BY o.order_date;

-- 5. Monthly revenue
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
       COUNT(DISTINCT o.order_id) AS completed_orders,
       SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;

-- 6. Stock audit history
SELECT sa.audit_id, p.product_name, sa.old_stock, sa.new_stock,
       sa.change_reason, sa.changed_at
FROM stock_audit sa JOIN products p ON sa.product_id = p.product_id
ORDER BY sa.changed_at DESC;
