-- =====================================================
-- FILE: 04_data_validation.sql
-- PURPOSE: Validate imported datasets
-- =====================================================

USE ecommerce_analytics;


-- =====================================================
-- 1. CUSTOMERS DATASET
-- STATUS: Imported - validation to be recorded
-- =====================================================

SELECT
    COUNT(*) AS total_customer_records
FROM olist_customers_dataset;


-- Check for missing customer IDs
SELECT
    COUNT(*) AS missing_customer_ids
FROM olist_customers_dataset
WHERE customer_id IS NULL;


-- Check for duplicate customer IDs
SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM olist_customers_dataset
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- =====================================================
-- 2. ORDERS DATASET
-- STATUS: Imported successfully
-- =====================================================

-- Total number of orders
SELECT
    COUNT(*) AS total_orders
FROM olist_orders_dataset;

-- Check for duplicate order IDs
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM olist_orders_dataset
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Check for missing order IDs
SELECT
    COUNT(*) AS missing_order_ids
FROM olist_orders_dataset
WHERE order_id IS NULL;

-- Check for missing customer IDs
SELECT
    COUNT(*) AS missing_customer_ids
FROM olist_orders_dataset
WHERE customer_id IS NULL;

-- Check order status distribution
SELECT
    order_status,
    COUNT(*) AS order_count
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY order_count DESC;