USE sales_analysis;

-- Run only once on a fresh database.
INSERT INTO customers (customer_name, email, city) VALUES
('Arun Kumar', 'arun@example.com', 'Hyderabad'),
('Priya Sharma', 'priya@example.com', 'Mumbai'),
('Rahul Verma', 'rahul@example.com', 'Delhi'),
('Sneha Reddy', 'sneha@example.com', 'Hyderabad'),
('Vikram Singh', 'vikram@example.com', 'Chennai'),
('Ananya Das', 'ananya@example.com', 'Kolkata'),
('Kiran Rao', 'kiran@example.com', 'Bengaluru'),
('Meera Nair', 'meera@example.com', 'Chennai');

INSERT INTO products (product_name, category, price, stock) VALUES
('Laptop', 'Electronics', 55000.00, 10),
('Smartphone', 'Electronics', 25000.00, 20),
('Headphones', 'Accessories', 2000.00, 50),
('Keyboard', 'Accessories', 1500.00, 30),
('Office Chair', 'Furniture', 8000.00, 12),
('Desk', 'Furniture', 12000.00, 8),
('Monitor', 'Electronics', 15000.00, 15),
('Mouse', 'Accessories', 800.00, 60);

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2025-10-02', 'Completed'),
(2, '2025-10-05', 'Completed'),
(3, '2025-10-08', 'Pending'),
(1, '2025-10-12', 'Completed'),
(4, '2025-10-15', 'Cancelled'),
(5, '2025-11-01', 'Completed'),
(6, '2025-11-05', 'Completed'),
(2, '2025-11-10', 'Completed'),
(7, '2025-11-15', 'Pending'),
(8, '2025-12-01', 'Completed'),
(3, '2025-12-10', 'Completed'),
(4, '2025-12-15', 'Completed');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 55000.00),
(1, 3, 2, 2000.00),
(2, 2, 1, 25000.00),
(2, 8, 2, 800.00),
(3, 7, 1, 15000.00),
(4, 4, 2, 1500.00),
(4, 3, 1, 2000.00),
(5, 5, 1, 8000.00),
(6, 6, 1, 12000.00),
(6, 8, 2, 800.00),
(7, 2, 2, 25000.00),
(7, 3, 1, 2000.00),
(8, 1, 1, 55000.00),
(8, 7, 1, 15000.00),
(9, 5, 1, 8000.00),
(10, 8, 3, 800.00),
(10, 4, 1, 1500.00),
(11, 2, 1, 25000.00),
(11, 3, 2, 2000.00),
(12, 6, 1, 12000.00);
