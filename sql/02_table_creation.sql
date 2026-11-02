-- ==========================================
-- PROJECT: E-Commerce Business Intelligence
-- FILE: 02_table_creation.sql
-- PURPOSE: Create project database tables
-- ==========================================

USE ecommerce_analytics;

-- Customers table

CREATE TABLE IF NOT EXISTS olist_customers_dataset (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);