USE sales_analysis;

DROP PROCEDURE IF EXISTS sp_sales_by_date;
DROP PROCEDURE IF EXISTS sp_top_products;
DROP PROCEDURE IF EXISTS sp_revenue_by_category;

DELIMITER //

CREATE PROCEDURE sp_sales_by_date(IN p_start_date DATE, IN p_end_date DATE)
BEGIN
    IF p_start_date IS NULL OR p_end_date IS NULL OR p_start_date > p_end_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid date range';
    END IF;

    SELECT o.order_id, c.customer_name, o.order_date,
           SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
      AND o.order_date >= p_start_date
      AND o.order_date < DATE_ADD(p_end_date, INTERVAL 1 DAY)
    GROUP BY o.order_id, c.customer_name, o.order_date
    ORDER BY o.order_date;
END //

CREATE PROCEDURE sp_top_products(IN p_limit INT)
BEGIN
    IF p_limit IS NULL OR p_limit < 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Limit must be at least 1';
    END IF;

    SELECT p.product_name, p.category, SUM(oi.quantity) AS units_sold,
           SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status = 'Completed'
    GROUP BY p.product_id, p.product_name, p.category
    ORDER BY total_revenue DESC
    LIMIT p_limit;
END //

CREATE PROCEDURE sp_revenue_by_category()
BEGIN
    SELECT p.category, SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status = 'Completed'
    GROUP BY p.category ORDER BY total_revenue DESC;
END //

DELIMITER ;

CALL sp_sales_by_date('2025-10-01', '2025-10-31');
CALL sp_top_products(3);
CALL sp_revenue_by_category();
SHOW PROCEDURE STATUS WHERE Db = 'sales_analysis';
