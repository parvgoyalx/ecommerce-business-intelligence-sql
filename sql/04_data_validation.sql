-- =====================================================
-- FILE: 04_data_validation.sql
-- PURPOSE: Validate imported datasets
-- =====================================================

USE ecommerce_analytics;


-- =====================================================
-- 1. CUSTOMERS DATASET
-- STATUS: Imported and validated
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
-- STATUS: Imported and validated
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



-- =====================================================
-- 3. ORDER ITEMS DATASET
-- STATUS: Imported and validated
-- =====================================================

-- Total records
SELECT COUNT(*) AS total_order_items
FROM olist_order_items_dataset;

-- Check duplicate composite keys
SELECT
    order_id,
    order_item_id,
    COUNT(*) AS duplicate_count
FROM olist_order_items_dataset
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

-- Check missing order IDs
SELECT COUNT(*) AS missing_order_ids
FROM olist_order_items_dataset
WHERE order_id IS NULL;

-- Check missing product IDs
SELECT COUNT(*) AS missing_product_ids
FROM olist_order_items_dataset
WHERE product_id IS NULL;

-- Merchandise sales and freight totals
SELECT
    ROUND(SUM(price), 2) AS total_merchandise_sales,
    ROUND(SUM(freight_value), 2) AS total_freight_value
FROM olist_order_items_dataset;


-- =====================================================
-- 4. ORDER PAYMENT DATASET
-- STATUS: Imported and validated
-- =====================================================

-- Total payment records
SELECT COUNT(*) AS total_payment_records
FROM olist_order_payments_dataset;

-- Check duplicate composite keys
SELECT
    order_id,
    payment_sequential,
    COUNT(*) AS duplicate_count
FROM olist_order_payments_dataset
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;

-- Payment method distribution
SELECT
    payment_type,
    COUNT(*) AS transaction_count,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY total_payment_value DESC;

-- Check missing order IDs
SELECT COUNT(*) AS missing_order_ids
FROM olist_order_payments_dataset
WHERE order_id IS NULL;