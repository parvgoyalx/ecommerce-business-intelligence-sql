-- =====================================================
-- FILE: 03_data_import.sql
-- PURPOSE: Load CSV files into MySQL tables
-- NOTE: Run imports after creating the corresponding tables.
-- =====================================================

USE ecommerce_analytics;


-- =====================================================
-- 1. CUSTOMERS DATASET
-- STATUS: Imported
-- =====================================================

LOAD DATA LOCAL INFILE
'C:/ecommerce-business-intelligence-sql/dataset/olist_customers_dataset.csv'
INTO TABLE olist_customers_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- =====================================================
-- 2. ORDERS DATASET
-- SOURCE: dataset/olist_orders_dataset.csv
-- STATUS: Imported successfully
-- =====================================================

LOAD DATA LOCAL INFILE
'C:/ecommerce-business-intelligence-sql/dataset/olist_orders_dataset.csv'
INTO TABLE olist_orders_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    order_id,
    customer_id,
    order_status,
    @order_purchase_timestamp,
    @order_approved_at,
    @order_delivered_carrier_date,
    @order_delivered_customer_date,
    @order_estimated_delivery_date
)
SET
    order_purchase_timestamp = NULLIF(@order_purchase_timestamp, ''),
    order_approved_at = NULLIF(@order_approved_at, ''),
    order_delivered_carrier_date = NULLIF(@order_delivered_carrier_date, ''),
    order_delivered_customer_date = NULLIF(@order_delivered_customer_date, ''),
    order_estimated_delivery_date = NULLIF(@order_estimated_delivery_date, '');



-- =====================================================
-- 3. ORDER ITEMS DATASET
-- SOURCE: dataset/olist_order_items_dataset.csv
-- STATUS: Imported successfully
-- EXPECTED ROW COUNT: 112,650
-- =====================================================

LOAD DATA LOCAL INFILE
'C:/ecommerce-business-intelligence-sql/dataset/olist_order_items_dataset.csv'
INTO TABLE olist_order_items_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    order_id,
    order_item_id,
    product_id,
    seller_id,
    @shipping_limit_date,
    price,
    freight_value
)
SET
    shipping_limit_date = NULLIF(@shipping_limit_date, '');



-- =====================================================
-- 4. ORDER PAYMENTS DATASET
-- SOURCE: dataset/olist_order_payments_dataset.csv
-- STATUS: Imported successfully
-- EXPECTED ROW COUNT: 103,886
-- =====================================================

LOAD DATA LOCAL INFILE
'C:/ecommerce-business-intelligence-sql/dataset/olist_order_payments_dataset.csv'
INTO TABLE olist_order_payments_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
);
