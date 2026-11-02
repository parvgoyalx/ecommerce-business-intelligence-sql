CREATE DATABASE ecommerce_analytics;

USE ecommerce_analytics;

SELECT DATABASE();

CREATE TABLE project_info (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_name VARCHAR(150) NOT NULL,
    database_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO project_info (project_name, database_name)
VALUES (
    'E-Commerce Business Intelligence',
    'ecommerce_analytics'
);

SELECT * FROM project_info;