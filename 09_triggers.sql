USE sales_analysis;

DROP TRIGGER IF EXISTS trg_check_stock_before_insert;
DROP TRIGGER IF EXISTS trg_reduce_stock_after_insert;
DROP TRIGGER IF EXISTS trg_check_stock_before_update;
DROP TRIGGER IF EXISTS trg_adjust_stock_after_update;
DROP TRIGGER IF EXISTS trg_restore_stock_after_delete;

DELIMITER //

CREATE TRIGGER trg_check_stock_before_insert
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE available_stock INT DEFAULT NULL;
    SELECT stock INTO available_stock FROM products WHERE product_id = NEW.product_id;

    IF available_stock IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product not found';
    ELSEIF NEW.quantity <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantity must be positive';
    ELSEIF available_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient product stock';
    END IF;
END //

CREATE TRIGGER trg_reduce_stock_after_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE previous_stock INT;
    SELECT stock INTO previous_stock FROM products WHERE product_id = NEW.product_id;
    UPDATE products SET stock = stock - NEW.quantity WHERE product_id = NEW.product_id;
    INSERT INTO stock_audit (product_id, old_stock, new_stock, change_reason)
    VALUES (NEW.product_id, previous_stock, previous_stock - NEW.quantity,
            CONCAT('Order item inserted: ', NEW.order_id));
END //

CREATE TRIGGER trg_check_stock_before_update
BEFORE UPDATE ON order_items
FOR EACH ROW
BEGIN
    DECLARE available_stock INT DEFAULT NULL;

    IF NEW.quantity <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantity must be positive';
    END IF;

    IF OLD.product_id = NEW.product_id THEN
        SELECT stock + OLD.quantity INTO available_stock
        FROM products WHERE product_id = NEW.product_id;
    ELSE
        SELECT stock INTO available_stock
        FROM products WHERE product_id = NEW.product_id;
    END IF;

    IF available_stock IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product not found';
    ELSEIF available_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock for update';
    END IF;
END //

CREATE TRIGGER trg_adjust_stock_after_update
AFTER UPDATE ON order_items
FOR EACH ROW
BEGIN
    DECLARE old_product_stock INT;
    DECLARE new_product_stock INT;

    IF OLD.product_id = NEW.product_id THEN
        IF OLD.quantity <> NEW.quantity THEN
            SELECT stock INTO old_product_stock FROM products WHERE product_id = NEW.product_id;
            UPDATE products SET stock = stock + OLD.quantity - NEW.quantity
            WHERE product_id = NEW.product_id;
            INSERT INTO stock_audit (product_id, old_stock, new_stock, change_reason)
            VALUES (NEW.product_id, old_product_stock,
                    old_product_stock + OLD.quantity - NEW.quantity,
                    'Order item quantity updated');
        END IF;
    ELSE
        SELECT stock INTO old_product_stock FROM products WHERE product_id = OLD.product_id;
        UPDATE products SET stock = stock + OLD.quantity WHERE product_id = OLD.product_id;
        INSERT INTO stock_audit (product_id, old_stock, new_stock, change_reason)
        VALUES (OLD.product_id, old_product_stock, old_product_stock + OLD.quantity,
                'Old product returned after item update');

        SELECT stock INTO new_product_stock FROM products WHERE product_id = NEW.product_id;
        UPDATE products SET stock = stock - NEW.quantity WHERE product_id = NEW.product_id;
        INSERT INTO stock_audit (product_id, old_stock, new_stock, change_reason)
        VALUES (NEW.product_id, new_product_stock, new_product_stock - NEW.quantity,
                'New product deducted after item update');
    END IF;
END //

CREATE TRIGGER trg_restore_stock_after_delete
AFTER DELETE ON order_items
FOR EACH ROW
BEGIN
    DECLARE previous_stock INT;
    SELECT stock INTO previous_stock FROM products WHERE product_id = OLD.product_id;
    UPDATE products SET stock = stock + OLD.quantity WHERE product_id = OLD.product_id;
    INSERT INTO stock_audit (product_id, old_stock, new_stock, change_reason)
    VALUES (OLD.product_id, previous_stock, previous_stock + OLD.quantity,
            CONCAT('Order item deleted: ', OLD.order_id));
END //

DELIMITER ;

SHOW TRIGGERS FROM sales_analysis;

-- Optional test: run these statements individually after creating triggers.
-- INSERT INTO orders (customer_id, order_date, status) VALUES (1, '2025-12-20', 'Pending');
-- SET @test_order_id = LAST_INSERT_ID();
-- INSERT INTO order_items (order_id, product_id, quantity, unit_price)
-- VALUES (@test_order_id, 8, 1, 800.00);
-- SELECT product_name, stock FROM products WHERE product_id = 8;
-- UPDATE order_items SET quantity = 2 WHERE order_id = @test_order_id AND product_id = 8;
-- SELECT product_name, stock FROM products WHERE product_id = 8;
-- DELETE FROM order_items WHERE order_id = @test_order_id AND product_id = 8;
-- SELECT product_name, stock FROM products WHERE product_id = 8;
-- SELECT * FROM stock_audit ORDER BY audit_id;
