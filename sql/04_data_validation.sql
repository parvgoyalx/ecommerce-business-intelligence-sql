-- ============================================
-- PROJECT: E-Commerce Business Intelligence
-- FILE: 04_data_validation.sql
-- PURPOSE: Verify imported customer data
-- ============================================

USE ecommerce_analytics;

-- 1. Total customer records

SELECT
    COUNT(*) AS total_customers
FROM olist_customers_dataset;


-- 2. Display first 10 customers

SELECT *
FROM olist_customers_dataset
LIMIT 10;


-- 3. Check duplicate customer IDs

SELECT
    customer_id,
    COUNT(*) AS occurrence_count
FROM olist_customers_dataset
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- 4. Check missing customer IDs

SELECT
    COUNT(*) AS missing_customer_ids
FROM olist_customers_dataset
WHERE customer_id IS NULL;


-- 5. Check missing customer locations

SELECT
    COUNT(*) AS missing_customer_cities
FROM olist_customers_dataset
WHERE customer_city IS NULL;