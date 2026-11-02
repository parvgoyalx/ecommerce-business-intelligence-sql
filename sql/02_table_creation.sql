
-- =====================================================
-- PROJECT: Brazilian E-Commerce Business Intelligence
-- FILE: 02_table_creation.sql
-- PURPOSE: Create tables for all 9 Olist datasets
-- DATABASE: ecommerce_analytics
-- =====================================================

USE ecommerce_analytics;


-- =====================================================
-- 1. CUSTOMERS DATASET
-- STATUS: Previously created
-- =====================================================

CREATE TABLE IF NOT EXISTS olist_customers_dataset (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);


-- =====================================================
-- 2. ORDERS DATASET
-- =====================================================

CREATE TABLE IF NOT EXISTS olist_orders_dataset (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(30),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);


-- =====================================================
-- 3. ORDER ITEMS DATASET
-- Composite primary key: order_id + order_item_id
-- =====================================================

CREATE TABLE IF NOT EXISTS olist_order_items_dataset (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(12,2),
    freight_value DECIMAL(12,2),
    PRIMARY KEY (order_id, order_item_id)
);


-- =====================================================
-- 4. ORDER PAYMENTS DATASET
-- Composite primary key: order_id + payment_sequential
-- =====================================================

CREATE TABLE IF NOT EXISTS olist_order_payments_dataset (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(12,2),
    PRIMARY KEY (order_id, payment_sequential)
);


-- =====================================================
-- 5. ORDER REVIEWS DATASET
-- =====================================================

CREATE TABLE IF NOT EXISTS olist_order_reviews_dataset (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);


-- =====================================================
-- 6. PRODUCTS DATASET
-- =====================================================

CREATE TABLE IF NOT EXISTS olist_products_dataset (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);


-- =====================================================
-- 7. SELLERS DATASET
-- =====================================================

CREATE TABLE IF NOT EXISTS olist_sellers_dataset (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);


-- =====================================================
-- 8. GEOLOCATION DATASET
-- No primary key: repeated postal prefixes and coordinates
-- can occur in the source data.
-- =====================================================

CREATE TABLE IF NOT EXISTS olist_geolocation_dataset (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat DECIMAL(10,7),
    geolocation_lng DECIMAL(10,7),
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
);


-- =====================================================
-- 9. PRODUCT CATEGORY TRANSLATION DATASET
-- =====================================================

CREATE TABLE IF NOT EXISTS product_category_name_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);


-- =====================================================
-- END OF TABLE CREATION SCRIPT
-- =====================================================