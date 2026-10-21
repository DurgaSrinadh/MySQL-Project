USE sales_analysis;

-- Orders with customer names
SELECT o.order_id, c.customer_name, o.order_date, o.status
FROM orders o JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date;

-- Products in each order
SELECT o.order_id, c.customer_name, p.product_name, oi.quantity, oi.unit_price,
       oi.quantity * oi.unit_price AS line_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id;

-- Total value of each order
SELECT o.order_id, o.status, SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.status ORDER BY order_total DESC;

-- Completed sales revenue
SELECT SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed';

-- Revenue by product
SELECT p.product_name, SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY p.product_id, p.product_name ORDER BY revenue DESC;

-- Revenue by category
SELECT p.category, SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY p.category ORDER BY revenue DESC;

-- Monthly revenue
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
       SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m') ORDER BY sales_month;

-- Top five products
SELECT p.product_name, SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY p.product_id, p.product_name ORDER BY revenue DESC LIMIT 5;

-- Customer spending
SELECT c.customer_name, SUM(oi.quantity * oi.unit_price) AS total_spending
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.customer_name ORDER BY total_spending DESC;

-- Customers who never ordered
SELECT c.customer_id, c.customer_name
FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Orders worth more than 20,000
SELECT o.order_id, SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id
HAVING SUM(oi.quantity * oi.unit_price) > 20000;

-- Average completed order value
SELECT ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT o.order_id, SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY o.order_id
) AS completed_orders;

-- Order counts by status
SELECT status, COUNT(*) AS total_orders FROM orders GROUP BY status;

-- Products never ordered
SELECT p.product_id, p.product_name
FROM products p LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;

-- Completed revenue by city
SELECT c.city, SUM(oi.quantity * oi.unit_price) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.city ORDER BY revenue DESC;
