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



-- =====================================================
-- 5. ORDER REVIEWS DATASET
-- STATUS: Imported and validated
-- =====================================================

-- Total review records
SELECT COUNT(*) AS total_reviews
FROM olist_order_reviews_dataset;

-- Review score distribution
SELECT
    review_score,
    COUNT(*) AS review_count
FROM olist_order_reviews_dataset
GROUP BY review_score
ORDER BY review_score;

-- Average review score
SELECT
    ROUND(AVG(review_score), 2) AS average_review_score
FROM olist_order_reviews_dataset;

-- Check duplicate review IDs
SELECT
    review_id,
    COUNT(*) AS duplicate_count
FROM olist_order_reviews_dataset
GROUP BY review_id
HAVING COUNT(*) > 1;

-- Check invalid review scores
SELECT COUNT(*) AS invalid_review_scores
FROM olist_order_reviews_dataset
WHERE review_score NOT BETWEEN 1 AND 5;




-- =====================================================
-- 6. PRODUCTS DATASET'
-- STATUS: Imported and validated
-- =====================================================

-- Total products
SELECT COUNT(*) AS total_products
FROM olist_products_dataset;

-- Check duplicate product IDs
SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM olist_products_dataset
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Products by category
SELECT
    product_category_name,
    COUNT(*) AS product_count
FROM olist_products_dataset
GROUP BY product_category_name
ORDER BY product_count DESC
LIMIT 15;

-- Check missing product IDs
SELECT COUNT(*) AS missing_product_ids
FROM olist_products_dataset
WHERE product_id IS NULL;

-- Check missing product dimensions
SELECT
    SUM(product_weight_g IS NULL) AS missing_weight,
    SUM(product_length_cm IS NULL) AS missing_length,
    SUM(product_height_cm IS NULL) AS missing_height,
    SUM(product_width_cm IS NULL) AS missing_width
FROM olist_products_dataset;
