-- ==========================================
-- PROJECT: E-Commerce Business Intelligence
-- FILE: 03_data_import.sql
-- PURPOSE: Document CSV data import commands
-- ==========================================

USE ecommerce_analytics;

-- Customer CSV import
-- Execute this in MySQL Command Line Client
-- after enabling LOCAL INFILE.
-- Replace the file path with your own local path.

LOAD DATA LOCAL INFILE
'C:/YOUR_USERNAME/Downloads/olist_customers_dataset.csv'
INTO TABLE olist_customers_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;