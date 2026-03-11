# SQL Database Testing Suite

A comprehensive MySQL test suite covering CRUD operations, multi-table JOINs, constraint validation, and data integrity checks across a normalized relational schema.

## Schema Overview

```
categories ──< products ──< order_items >── orders ──< customers
```

| Table          | Description                          |
|----------------|--------------------------------------|
| `customers`    | Registered users with contact info   |
| `categories`   | Product categories                   |
| `products`     | Items with price, stock, FK to category |
| `orders`       | Customer orders with status enum     |
| `order_items`  | Line items linking orders & products |

## Files

| File             | Purpose                              |
|------------------|--------------------------------------|
| `schema.sql`     | Table definitions with constraints   |
| `seed_data.sql`  | Sample data for testing              |
| `test_cases.sql` | 33 test cases across 5 sections      |

## Test Case Coverage

| Section                    | Test Cases |
|----------------------------|------------|
| CRUD Operations            | TC-01 – TC-08 |
| Constraint Validation      | TC-09 – TC-16 |
| Multi-Table JOINs          | TC-17 – TC-21 |
| Data Integrity Checks      | TC-22 – TC-30 |
| Advanced Queries           | TC-31 – TC-33 |

## Setup & Run

```bash
# Start MySQL and create database
mysql -u root -p
CREATE DATABASE sql_test_suite;
USE sql_test_suite;

# Load schema and seed data
SOURCE schema.sql;
SOURCE seed_data.sql;

# Run test cases
SOURCE test_cases.sql;
```

## Constraints Tested
- `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`
- `NOT NULL`, `CHECK` (price ≥ 0, stock ≥ 0, quantity > 0)
- `ENUM` for order status
- Referential integrity across all tables

## Author
**Logesh T** – [GitHub](https://github.com/Loki-3103) | [LinkedIn](https://linkedin.com/in/logesh-t-/)
