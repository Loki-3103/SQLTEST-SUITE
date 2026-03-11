-- ============================================================
-- SQL Test Cases (30+)
-- Author: Logesh T
-- Description: CRUD, JOINs, constraints, and data integrity checks
-- ============================================================


-- ============================================================
-- SECTION 1: CRUD OPERATIONS
-- ============================================================

-- TC-01: INSERT valid customer
INSERT INTO customers (full_name, email, phone, city)
VALUES ('Test User', 'testuser@example.com', '9000000001', 'Delhi');

-- TC-02: SELECT all customers
SELECT * FROM customers;

-- TC-03: SELECT customer by ID
SELECT * FROM customers WHERE customer_id = 1;

-- TC-04: UPDATE customer city
UPDATE customers SET city = 'Pune' WHERE email = 'testuser@example.com';
SELECT city FROM customers WHERE email = 'testuser@example.com';
-- Expected: Pune

-- TC-05: DELETE test customer
DELETE FROM customers WHERE email = 'testuser@example.com';
SELECT COUNT(*) FROM customers WHERE email = 'testuser@example.com';
-- Expected: 0

-- TC-06: INSERT valid product
INSERT INTO products (product_name, category_id, price, stock)
VALUES ('Test Product', 1, 999.00, 10);

-- TC-07: UPDATE product price
UPDATE products SET price = 899.00 WHERE product_name = 'Test Product';
SELECT price FROM products WHERE product_name = 'Test Product';
-- Expected: 899.00

-- TC-08: DELETE test product
DELETE FROM products WHERE product_name = 'Test Product';


-- ============================================================
-- SECTION 2: CONSTRAINT VALIDATION
-- ============================================================

-- TC-09: UNIQUE constraint – duplicate email should fail
-- Expected: Error (Duplicate entry)
INSERT INTO customers (full_name, email, phone, city)
VALUES ('Duplicate', 'logesht3103@gmail.com', '0000000000', 'Test');

-- TC-10: NOT NULL constraint – missing required full_name should fail
-- Expected: Error (Column cannot be null)
INSERT INTO customers (email, phone, city)
VALUES ('noname@example.com', '1234567890', 'City');

-- TC-11: CHECK constraint – negative price should fail
-- Expected: Error (Check constraint violated)
INSERT INTO products (product_name, category_id, price, stock)
VALUES ('Bad Product', 1, -50.00, 10);

-- TC-12: CHECK constraint – negative stock should fail
-- Expected: Error
INSERT INTO products (product_name, category_id, price, stock)
VALUES ('Bad Stock', 1, 100.00, -5);

-- TC-13: CHECK constraint – zero quantity in order_items should fail
-- Expected: Error
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (1, 1, 0, 100.00);

-- TC-14: FOREIGN KEY constraint – invalid category_id should fail
-- Expected: Error
INSERT INTO products (product_name, category_id, price, stock)
VALUES ('Ghost Category', 999, 100.00, 5);

-- TC-15: FOREIGN KEY constraint – invalid customer_id in orders should fail
-- Expected: Error
INSERT INTO orders (customer_id, status) VALUES (9999, 'pending');

-- TC-16: ENUM constraint – invalid order status should fail
-- Expected: Error
INSERT INTO orders (customer_id, status) VALUES (1, 'unknown_status');


-- ============================================================
-- SECTION 3: MULTI-TABLE JOINs
-- ============================================================

-- TC-17: INNER JOIN – customers with their orders
SELECT c.full_name, c.city, o.order_id, o.status
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

-- TC-18: LEFT JOIN – customers with or without orders
SELECT c.full_name, o.order_id, o.status
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- TC-19: JOIN across 3 tables – order details with product names
SELECT o.order_id, c.full_name, p.product_name, oi.quantity, oi.unit_price
FROM orders o
JOIN customers c   ON o.customer_id  = c.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
JOIN products p    ON oi.product_id  = p.product_id;

-- TC-20: JOIN with category name
SELECT p.product_name, cat.category_name, p.price
FROM products p
JOIN categories cat ON p.category_id = cat.category_id
ORDER BY cat.category_name, p.price DESC;

-- TC-21: Aggregate JOIN – total revenue per customer
SELECT c.full_name,
       COUNT(DISTINCT o.order_id) AS total_orders,
       SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o      ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id   = oi.order_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC;


-- ============================================================
-- SECTION 4: DATA INTEGRITY CHECKS
-- ============================================================

-- TC-22: Verify no order_items reference non-existent orders
SELECT oi.*
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;
-- Expected: 0 rows

-- TC-23: Verify no order_items reference non-existent products
SELECT oi.*
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;
-- Expected: 0 rows

-- TC-24: Verify no orders reference non-existent customers
SELECT o.*
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
-- Expected: 0 rows

-- TC-25: Verify no products reference non-existent categories
SELECT p.*
FROM products p
LEFT JOIN categories cat ON p.category_id = cat.category_id
WHERE cat.category_id IS NULL;
-- Expected: 0 rows

-- TC-26: Check for customers with duplicate emails (data quality)
SELECT email, COUNT(*) AS count
FROM customers
GROUP BY email
HAVING count > 1;
-- Expected: 0 rows

-- TC-27: Verify all unit_prices in order_items are > 0
SELECT * FROM order_items WHERE unit_price <= 0;
-- Expected: 0 rows

-- TC-28: Verify all quantities in order_items are > 0
SELECT * FROM order_items WHERE quantity <= 0;
-- Expected: 0 rows

-- TC-29: Verify product prices are non-negative
SELECT * FROM products WHERE price < 0;
-- Expected: 0 rows

-- TC-30: Check total item count per order is correct
SELECT o.order_id,
       COUNT(oi.item_id)       AS line_items,
       SUM(oi.quantity)        AS total_units,
       SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id
ORDER BY o.order_id;


-- ============================================================
-- SECTION 5: ADVANCED QUERIES
-- ============================================================

-- TC-31: Subquery – customers who placed more than 1 order
SELECT full_name, email
FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
);

-- TC-32: Products never ordered
SELECT p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- TC-33: Top-selling product by quantity
SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC
LIMIT 1;
