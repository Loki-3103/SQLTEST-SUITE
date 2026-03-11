-- ============================================================
-- Seed Data for SQL Database Testing Suite
-- Author: Logesh T
-- ============================================================

-- Categories
INSERT INTO categories (category_name) VALUES
('Electronics'),
('Books'),
('Clothing'),
('Home & Kitchen'),
('Sports');

-- Customers
INSERT INTO customers (full_name, email, phone, city) VALUES
('Logesh T',       'logesht3103@gmail.com',   '8098305335', 'Bengaluru'),
('Arun Kumar',     'arun.kumar@example.com',  '9876543210', 'Chennai'),
('Priya S',        'priya.s@example.com',     '9123456780', 'Coimbatore'),
('Ravi Shankar',   'ravi.sh@example.com',     '9988776655', 'Hyderabad'),
('Meena Devi',     'meena.d@example.com',     NULL,         'Mumbai');

-- Products
INSERT INTO products (product_name, category_id, price, stock) VALUES
('Wireless Headphones',   1, 1299.00, 50),
('Python Programming',    2,  499.00, 30),
('Running Shoes',         5,  799.00, 20),
('Stainless Steel Mug',   4,  249.00, 100),
('Cotton T-Shirt',        3,  199.00, 75),
('USB-C Hub',             1,  599.00, 40),
('Data Structures Book',  2,  350.00, 25);

-- Orders
INSERT INTO orders (customer_id, status) VALUES
(1, 'delivered'),
(2, 'shipped'),
(3, 'confirmed'),
(4, 'pending'),
(1, 'delivered');

-- Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1299.00),
(1, 4, 2,  249.00),
(2, 3, 1,  799.00),
(3, 2, 2,  499.00),
(4, 5, 3,  199.00),
(5, 6, 1,  599.00),
(5, 7, 1,  350.00);
