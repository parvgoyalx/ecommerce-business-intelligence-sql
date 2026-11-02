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



-- =====================================================
-- 5. ORDER REVIEWS DATASET
-- SOURCE: dataset/olist_order_reviews_dataset.csv
-- STATUS: Imported successfully
-- EXPECTED ROW COUNT: 99,224
-- =====================================================

LOAD DATA LOCAL INFILE
'C:/ecommerce-business-intelligence-sql/dataset/olist_order_reviews_dataset.csv'
INTO TABLE olist_order_reviews_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    review_id,
    order_id,
    review_score,
    @review_comment_title,
    @review_comment_message,
    @review_creation_date,
    @review_answer_timestamp
)
SET
    review_comment_title = NULLIF(@review_comment_title, ''),
    review_comment_message = NULLIF(@review_comment_message, ''),
    review_creation_date = NULLIF(@review_creation_date, ''),
    review_answer_timestamp = NULLIF(@review_answer_timestamp, '');




-- =====================================================
-- 6. PRODUCTS DATASET
-- SOURCE: dataset/olist_products_dataset.csv
-- STATUS: Imported successfully
-- EXPECTED ROW COUNT: 32,951
-- =====================================================

LOAD DATA LOCAL INFILE
'C:/ecommerce-business-intelligence-sql/dataset/olist_products_dataset.csv'
INTO TABLE olist_products_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    product_id,
    @product_category_name,
    @product_name_lenght,
    @product_description_lenght,
    @product_photos_qty,
    @product_weight_g,
    @product_length_cm,
    @product_height_cm,
    @product_width_cm
)
SET
    product_category_name = NULLIF(@product_category_name, ''),
    product_name_lenght = NULLIF(@product_name_lenght, ''),
    product_description_lenght = NULLIF(@product_description_lenght, ''),
    product_photos_qty = NULLIF(@product_photos_qty, ''),
    product_weight_g = NULLIF(@product_weight_g, ''),
    product_length_cm = NULLIF(@product_length_cm, ''),
    product_height_cm = NULLIF(@product_height_cm, ''),
    product_width_cm = NULLIF(@product_width_cm, '');




-- =====================================================
-- 7. SELLERS DATASET
-- SOURCE: dataset/olist_sellers_dataset.csv
-- STATUS: Imported successfully
-- EXPECTED ROW COUNT: 3,095
-- =====================================================

LOAD DATA LOCAL INFILE
'C:/ecommerce-business-intelligence-sql/dataset/olist_sellers_dataset.csv'
INTO TABLE olist_sellers_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
);




-- =====================================================
-- 8. GEOLOCATION DATASET
-- SOURCE: dataset/olist_geolocation_dataset.csv
-- STATUS: Imported successfully
-- EXPECTED ROW COUNT: 1,000,163
-- NOTE: No primary key; duplicate postal prefixes exist.
-- =====================================================

LOAD DATA LOCAL INFILE
'C:/ecommerce-business-intelligence-sql/dataset/olist_geolocation_dataset.csv'
INTO TABLE olist_geolocation_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
);
