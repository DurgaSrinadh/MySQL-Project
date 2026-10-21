USE sales_analysis;

CREATE INDEX idx_orders_order_date ON orders(order_date);
CREATE INDEX idx_orders_status_date ON orders(status, order_date);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_customers_city ON customers(city);
CREATE INDEX idx_order_items_product ON order_items(product_id);

SHOW INDEX FROM orders;
SHOW INDEX FROM products;
SHOW INDEX FROM customers;
SHOW INDEX FROM order_items;

EXPLAIN SELECT * FROM orders WHERE order_date = '2025-10-02';
