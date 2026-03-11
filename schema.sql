-- ============================================================
-- SQL Database Testing Suite
-- Author: Logesh T
-- Description: Normalized schema for database QA test suite
-- ============================================================

-- Drop tables if re-running
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS categories;

-- -----------------------------------------------
-- Table: categories
-- -----------------------------------------------
CREATE TABLE categories (
    category_id   INT          PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- -----------------------------------------------
-- Table: customers
-- -----------------------------------------------
CREATE TABLE customers (
    customer_id   INT          PRIMARY KEY AUTO_INCREMENT,
    full_name     VARCHAR(150) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    phone         VARCHAR(15),
    city          VARCHAR(100),
    created_at    DATETIME     DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%')
);

-- -----------------------------------------------
-- Table: products
-- -----------------------------------------------
CREATE TABLE products (
    product_id    INT            PRIMARY KEY AUTO_INCREMENT,
    product_name  VARCHAR(150)   NOT NULL,
    category_id   INT            NOT NULL,
    price         DECIMAL(10, 2) NOT NULL,
    stock         INT            NOT NULL DEFAULT 0,
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES categories(category_id),
    CONSTRAINT chk_price  CHECK (price  >= 0),
    CONSTRAINT chk_stock  CHECK (stock  >= 0)
);

-- -----------------------------------------------
-- Table: orders
-- -----------------------------------------------
CREATE TABLE orders (
    order_id      INT      PRIMARY KEY AUTO_INCREMENT,
    customer_id   INT      NOT NULL,
    order_date    DATETIME DEFAULT CURRENT_TIMESTAMP,
    status        ENUM('pending', 'confirmed', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- -----------------------------------------------
-- Table: order_items
-- -----------------------------------------------
CREATE TABLE order_items (
    item_id       INT            PRIMARY KEY AUTO_INCREMENT,
    order_id      INT            NOT NULL,
    product_id    INT            NOT NULL,
    quantity      INT            NOT NULL,
    unit_price    DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_item_order   FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    CONSTRAINT fk_item_product FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT chk_quantity    CHECK (quantity   > 0),
    CONSTRAINT chk_unit_price  CHECK (unit_price >= 0)
);
