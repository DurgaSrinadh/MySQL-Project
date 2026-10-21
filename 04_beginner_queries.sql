USE sales_analysis;

SELECT * FROM customers;

SELECT * FROM products;

SELECT * FROM products WHERE price > 10000;

SELECT * FROM customers WHERE city = 'Hyderabad';

SELECT product_name, price FROM products ORDER BY price DESC;

SELECT DISTINCT city FROM customers;

SELECT product_name, stock FROM products WHERE stock < 15;

SELECT * FROM products WHERE product_name LIKE '%o%';

SELECT COUNT(*) AS total_customers FROM customers;

SELECT COUNT(*) AS total_products FROM products;

SELECT MAX(price) AS highest_price FROM products;

SELECT MIN(price) AS lowest_price FROM products;

SELECT ROUND(AVG(price), 2) AS average_price FROM products;

SELECT SUM(stock) AS total_stock FROM products;

SELECT status, COUNT(*) AS total_orders FROM orders GROUP BY status;

