
-- =====================================================
-- PROJECT: Brazilian E-Commerce Business Intelligence
-- FILE: 05_data_cleaning.sql
-- PURPOSE: Prepare clean analytical datasets
-- APPROACH: Preserve raw source tables
-- =====================================================

USE ecommerce_analytics;


-- =====================================================
-- 1. CREATE CLEAN ORDERS VIEW
-- Remove records without an order ID
-- =====================================================

CREATE OR REPLACE VIEW vw_clean_orders AS
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM olist_orders_dataset
WHERE order_id IS NOT NULL;


-- =====================================================
-- 2. CREATE CLEAN ORDER ITEMS VIEW
-- Remove records without essential identifiers
-- =====================================================

CREATE OR REPLACE VIEW vw_clean_order_items AS
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
FROM olist_order_items_dataset
WHERE order_id IS NOT NULL
  AND order_item_id IS NOT NULL
  AND product_id IS NOT NULL
  AND seller_id IS NOT NULL;


-- =====================================================
-- 3. CREATE CLEAN PRODUCTS VIEW
-- Remove records without product IDs
-- =====================================================

CREATE OR REPLACE VIEW vw_clean_products AS
SELECT
    product_id,
    product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM olist_products_dataset
WHERE product_id IS NOT NULL;


-- =====================================================
-- 4. CREATE CLEAN CUSTOMERS VIEW
-- Remove records without customer IDs
-- =====================================================

CREATE OR REPLACE VIEW vw_clean_customers AS
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM olist_customers_dataset
WHERE customer_id IS NOT NULL;


-- =====================================================
-- END OF INITIAL CLEANING VIEWS
-- =====================================================





USE ecommerce_analytics;

-- 1. Compare raw and view record counts

SELECT
    'Customers' AS dataset,
    (SELECT COUNT(*) FROM olist_customers_dataset) AS raw_records,
    (SELECT COUNT(*) FROM vw_clean_customers) AS view_records

UNION ALL

SELECT
    'Orders',
    (SELECT COUNT(*) FROM olist_orders_dataset),
    (SELECT COUNT(*) FROM vw_clean_orders)

UNION ALL

SELECT
    'Order Items',
    (SELECT COUNT(*) FROM olist_order_items_dataset),
    (SELECT COUNT(*) FROM vw_clean_order_items)

UNION ALL

SELECT
    'Products',
    (SELECT COUNT(*) FROM olist_products_dataset),
    (SELECT COUNT(*) FROM vw_clean_products);