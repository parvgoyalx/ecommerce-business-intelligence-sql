
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




-- CUSTOMER DUPLICATE CHECK
-- Result: No duplicate customer_id values found.
-- Status: Passed

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM vw_clean_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- ORDER ITEMS DUPLICATE CHECK
-- Result: No duplicate order_item_id and order_id values found.
-- Status: Passed

SELECT
    order_id, order_item_id,
    Count(*) AS duplicate_items
FROM vw_clean_order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;


-- ORDER DUPLICATE CHECK
-- Result: No duplicate order_id values found.
-- Status: Passed

SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM vw_clean_orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- PRODUCT DUPLICATE CHECK
-- Result: No duplicate product_id values found.
-- Status: Passed

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM vw_clean_products
GROUP BY product_id
HAVING COUNT(*) > 1;


-- =====================================================
-- DUPLICATE CHECK RESULTS
-- =====================================================

-- Customers: No duplicate customer_id values found.
-- Orders: No duplicate order_id values found.
-- Order Items: No duplicate composite keys found.
-- Products: No duplicate product_id values found.




-- =====================================================
-- CUSTOMER DATASET: MISSING VALUE CHECK
-- =====================================================

SELECT
    COUNT(*) - COUNT(customer_id) AS missing_customer_id,

    COUNT(*) - COUNT(customer_unique_id) AS missing_customer_unique_id,

    COUNT(*) - COUNT(customer_zip_code_prefix) AS missing_zip_code,

    COUNT(*) - COUNT(customer_city) AS missing_customer_city,

    COUNT(*) - COUNT(customer_state) AS missing_customer_state

FROM vw_clean_customers;




-- =====================================================
-- ORDERS DATASET: MISSING VALUE CHECK
-- =====================================================

SELECT
    COUNT(*) - COUNT(order_id) AS missing_order_id,

    COUNT(*) - COUNT(customer_id) AS missing_customer_id,

    COUNT(*) - COUNT(order_status) AS missing_order_status,

    COUNT(*) - COUNT(order_purchase_timestamp) AS missing_purchase_timestamp,

    COUNT(*) - COUNT(order_approved_at) AS missing_approved_at,

    COUNT(*) - COUNT(order_delivered_carrier_date) AS missing_carrier_date,

    COUNT(*) - COUNT(order_delivered_customer_date) AS missing_delivery_date,

    COUNT(*) - COUNT(order_estimated_delivery_date) AS missing_estimated_delivery_date

FROM vw_clean_orders;


-- =====================================================
-- ORDERS DATASET: MISSING VALUE ANALYSIS BY ORDER STATUS
-- =====================================================

-- PURPOSE:
-- Investigate whether missing timestamps are associated
-- with particular order statuses.
--
-- BUSINESS OBJECTIVE:
-- Determine whether missing approval, carrier handover,
-- and customer delivery timestamps are expected based
-- on the order lifecycle or require further investigation.
--
-- METHODOLOGY:
-- 1. Group orders by order_status.
-- 2. Count total orders for each status.
-- 3. Use CASE WHEN to count missing timestamps.
-- 4. Compare missing timestamps across order statuses.
--
-- NOTE:
-- Missing timestamps are not automatically considered
-- data errors. Their meaning depends on the order status.
--
-- =====================================================


SELECT
    order_status,

    COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN order_approved_at IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_approval_date,

    SUM(
        CASE
            WHEN order_delivered_carrier_date IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_carrier_date,

    SUM(
        CASE
            WHEN order_delivered_customer_date IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_delivery_date

FROM vw_clean_orders

GROUP BY order_status

ORDER BY order_status;



-- =====================================================
-- ORDERS DATASET: INVESTIGATION OF INCONSISTENT RECORDS
-- =====================================================

-- PURPOSE:
-- Investigate orders whose status may be inconsistent
-- with their associated lifecycle timestamps.
--
-- INVESTIGATION 1:
-- Delivered orders with missing approval, carrier
-- handover, or customer delivery timestamps.
--
-- INVESTIGATION 2:
-- Cancelled orders with an existing customer delivery
-- timestamp.
--
-- OBJECTIVE:
-- Identify potentially inconsistent records before
-- deciding whether any cleaning action is necessary.
--
-- IMPORTANT:
-- These records will be investigated, not automatically
-- deleted or modified.
--
-- =====================================================



SELECT
    order_id,
    customer_id,
    order_status,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM vw_clean_orders
WHERE order_status = 'delivered'
  AND (
      order_approved_at IS NULL
      OR order_delivered_carrier_date IS NULL
      OR order_delivered_customer_date IS NULL
  );




SELECT
    order_id,
    customer_id,
    order_status,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM vw_clean_orders
WHERE order_status = 'canceled'
  AND order_delivered_customer_date IS NOT NULL;




-- =====================================================
-- ORDERS DATASET: CANCELLED ORDERS WITH DELIVERY DATES
-- =====================================================

-- PURPOSE:
-- Investigate cancelled orders that contain customer
-- delivery timestamps.
--
-- OBJECTIVE:
-- Examine the complete order timeline to determine
-- whether these records show a possible inconsistency
-- between the recorded order status and delivery events.
--
-- METHODOLOGY:
-- Compare purchase, approval, carrier handover,
-- actual delivery, and estimated delivery timestamps.
--
-- NOTE:
-- No records will be modified or deleted.
-- Findings will be documented after investigation.
--
-- =====================================================



SELECT
    order_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM vw_clean_orders
WHERE order_status = 'canceled'
  AND order_delivered_customer_date IS NOT NULL
ORDER BY order_purchase_timestamp;




-- =====================================================
-- ORDERS DATASET: INVESTIGATION OF CANCELLED ORDERS
-- =====================================================

-- PURPOSE:
-- Investigate whether cancelled orders with completed
-- delivery timestamps have associated transaction records.

-- METHODOLOGY:
-- Check the existence of order items, payment records,
-- and customer reviews for the six identified orders.

-- OBJECTIVE:
-- Gather additional evidence about these orders before
-- deciding whether their status represents an anomaly.

-- No records will be modified or deleted.
-- =====================================================



SELECT
    o.order_id,
    o.order_status,

    COALESCE(oi.item_count, 0) AS total_order_items,

    COALESCE(p.payment_count, 0) AS total_payment_records,

    COALESCE(r.review_count, 0) AS total_review_records

FROM vw_clean_orders o

LEFT JOIN (
    SELECT
        order_id,
        COUNT(*) AS item_count
    FROM olist_order_items_dataset
    GROUP BY order_id
) oi
    ON o.order_id = oi.order_id

LEFT JOIN (
    SELECT
        order_id,
        COUNT(*) AS payment_count
    FROM olist_order_payments_dataset
    GROUP BY order_id
) p
    ON o.order_id = p.order_id

LEFT JOIN (
    SELECT
        order_id,
        COUNT(*) AS review_count
    FROM olist_order_reviews_dataset
    GROUP BY order_id
) r
    ON o.order_id = r.order_id

WHERE o.order_status = 'canceled'
  AND o.order_delivered_customer_date IS NOT NULL

ORDER BY o.order_purchase_timestamp;




-- =====================================================
-- INVESTIGATION: PAYMENT AND REVIEW DETAILS
-- FOR CANCELLED ORDERS WITH DELIVERY TIMESTAMPS
-- =====================================================

-- PURPOSE:
-- Examine payment values and customer review scores
-- for the six previously identified cancelled orders.

-- OBJECTIVE:
-- Determine whether the associated payment and review
-- records provide additional evidence about these orders.

-- METHODOLOGY:
-- Aggregate payment and review information separately
-- before joining it to the orders.
--
-- IMPORTANT:
-- A payment record does not automatically establish
-- successful payment capture or settlement.
-- No source records will be modified or deleted.

-- =====================================================




SELECT
    o.order_id,
    o.order_status,

    oi.total_items,
    oi.total_item_value,

    p.payment_records,
    p.total_payment_value,
    p.payment_types,

    r.review_records,
    r.average_review_score

FROM vw_clean_orders o

LEFT JOIN (
    SELECT
        order_id,
        COUNT(*) AS total_items,
        SUM(price) AS total_item_value
    FROM olist_order_items_dataset
    GROUP BY order_id
) oi
    ON o.order_id = oi.order_id

LEFT JOIN (
    SELECT
        order_id,
        COUNT(*) AS payment_records,
        SUM(payment_value) AS total_payment_value,
        GROUP_CONCAT(DISTINCT payment_type) AS payment_types
    FROM olist_order_payments_dataset
    GROUP BY order_id
) p
    ON o.order_id = p.order_id

LEFT JOIN (
    SELECT
        order_id,
        COUNT(*) AS review_records,
        AVG(review_score) AS average_review_score
    FROM olist_order_reviews_dataset
    GROUP BY order_id
) r
    ON o.order_id = r.order_id

WHERE o.order_status = 'canceled'
  AND o.order_delivered_customer_date IS NOT NULL

ORDER BY o.order_purchase_timestamp;



-- =====================================================
-- INVESTIGATION: ORDER VALUE AND PAYMENT RECONCILIATION
-- =====================================================

-- PURPOSE:
-- Compare merchandise value, freight charges, and
-- recorded payment values for cancelled orders with
-- customer delivery timestamps.

-- OBJECTIVE:
-- Determine whether the recorded payment amount is
-- consistent with item prices and freight charges.

-- METHODOLOGY:
-- Aggregate item prices and freight separately
-- for each order, then compare with payment totals.

-- NOTE:
-- Differences will be investigated, not automatically
-- classified as errors.
-- =====================================================



SELECT
    o.order_id,

    oi.total_item_value,
    oi.total_freight_value,

    p.total_payment_value,

    ROUND(
        oi.total_item_value + oi.total_freight_value,
        2
    ) AS expected_order_value,

    ROUND(
        p.total_payment_value
        - (oi.total_item_value + oi.total_freight_value),
        2
    ) AS payment_difference

FROM vw_clean_orders o

LEFT JOIN (
    SELECT
        order_id,
        SUM(price) AS total_item_value,
        SUM(freight_value) AS total_freight_value
    FROM olist_order_items_dataset
    GROUP BY order_id
) oi
    ON o.order_id = oi.order_id

LEFT JOIN (
    SELECT
        order_id,
        SUM(payment_value) AS total_payment_value
    FROM olist_order_payments_dataset
    GROUP BY order_id
) p
    ON o.order_id = p.order_id

WHERE o.order_status = 'canceled'
  AND o.order_delivered_customer_date IS NOT NULL

ORDER BY o.order_purchase_timestamp;



-- =====================================================
-- INVESTIGATION FINDINGS: CANCELLED ORDERS WITH
-- COMPLETED DELIVERY TIMESTAMPS
-- =====================================================

-- FINDINGS:
-- 1. Six cancelled orders have customer delivery dates.
-- 2. All six have approval and carrier handover dates.
-- 3. All six have associated order-item records.
-- 4. All six have payment records and review records.
-- 5. All six payment totals reconcile with the sum of
--    item prices and freight charges.
--
-- PAYMENT RECONCILIATION:
-- No payment-value differences were found.
--
-- DATA QUALITY ASSESSMENT:
-- These records show a potential inconsistency between
-- order_status and the recorded fulfilment timeline.
--
-- DECISION:
-- Preserve the original records.
-- Do not automatically change order statuses.
-- Flag these records for further investigation.
--
-- LIMITATION:
-- Payment records do not establish whether funds were
-- ultimately settled, retained, or refunded.
--
-- =====================================================





-- =====================================================
-- ORDER ITEMS DATASET: MISSING VALUE CHECK
-- =====================================================

-- PURPOSE:
-- Identify missing values in the order-items dataset.

-- BUSINESS OBJECTIVE:
-- Ensure that important order, product, seller,
-- shipping and financial information is available
-- for accurate sales and operational analysis.

-- METHODOLOGY:
-- COUNT(*) counts all records.
-- COUNT(column_name) counts non-NULL values.
-- Their difference gives the number of NULL values.

-- COLUMNS INVESTIGATED:
-- order_id
-- order_item_id
-- product_id
-- seller_id
-- shipping_limit_date
-- price
-- freight_value

-- NOTE:
-- Missing values will be investigated before deciding
-- whether any cleaning action is necessary.

-- =====================================================

SELECT
    COUNT(*) - COUNT(order_id) AS missing_order_id,

    COUNT(*) - COUNT(order_item_id) AS missing_order_item_id,

    COUNT(*) - COUNT(product_id) AS missing_product_id,

    COUNT(*) - COUNT(seller_id) AS missing_seller_id,

    COUNT(*) - COUNT(shipping_limit_date) AS missing_shipping_limit_date,

    COUNT(*) - COUNT(price) AS missing_price,

    COUNT(*) - COUNT(freight_value) AS missing_freight_value

FROM vw_clean_order_items;



-- =====================================================
-- ORDER ITEMS DATASET: EMPTY STRING CHECK
-- =====================================================

-- PURPOSE:
-- Identify empty or whitespace-only values in
-- important text identifier columns.

-- METHODOLOGY:
-- TRIM() removes leading and trailing spaces.
-- If the resulting value is empty, the field is
-- considered blank.
--
-- CASE WHEN counts records meeting each condition.

-- COLUMNS INVESTIGATED:
-- order_id, product_id, seller_id

-- NOTE:
-- NULL values were checked separately.
-- No records will be modified or deleted.

-- =====================================================



SELECT
    SUM(
        CASE
            WHEN TRIM(order_id) = '' THEN 1
            ELSE 0
        END
    ) AS blank_order_id,

    SUM(
        CASE
            WHEN TRIM(product_id) = '' THEN 1
            ELSE 0
        END
    ) AS blank_product_id,

    SUM(
        CASE
            WHEN TRIM(seller_id) = '' THEN 1
            ELSE 0
        END
    ) AS blank_seller_id

FROM vw_clean_order_items;




-- =====================================================
-- ORDER ITEMS DATASET: NUMERICAL VALUE VALIDATION
-- =====================================================

-- PURPOSE:
-- Identify invalid or unusual numerical values in
-- price and freight_value.

-- OBJECTIVE:
-- Ensure that merchandise prices and freight charges
-- are suitable for financial and sales analysis.

-- VALIDATION RULES:
-- 1. Identify negative prices.
-- 2. Identify negative freight charges.
-- 3. Identify zero prices.
-- 4. Identify zero freight charges.

-- NOTE:
-- Zero values are investigated separately because
-- they are not automatically invalid.
-- No records will be modified or deleted.

-- =====================================================



SELECT
    COUNT(*) AS total_records,

    SUM(CASE
        WHEN price < 0 THEN 1
        ELSE 0
    END) AS negative_prices,

    SUM(CASE
        WHEN freight_value < 0 THEN 1
        ELSE 0
    END) AS negative_freight_values,

    SUM(CASE
        WHEN price = 0 THEN 1
        ELSE 0
    END) AS zero_prices,

    SUM(CASE
        WHEN freight_value = 0 THEN 1
        ELSE 0
    END) AS zero_freight_values

FROM vw_clean_order_items;




-- =====================================================
-- FINDING: ZERO FREIGHT VALUES
-- =====================================================

-- RESULT:
-- 383 order-item records have freight_value = 0.
-- No negative prices, negative freight values,
-- or zero prices were identified.

-- ASSESSMENT:
-- Zero freight charges are not automatically invalid.
-- They may represent free shipping or other legitimate
-- order-level shipping arrangements.

-- NEXT ACTION:
-- Inspect the affected records before deciding whether
-- they represent valid business cases or data anomalies.

-- No records will be modified or deleted.

-- =====================================================



SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    price,
    freight_value,
    shipping_limit_date
FROM vw_clean_order_items
WHERE freight_value = 0
ORDER BY order_id, order_item_id;




-- =====================================================
-- ORDER ITEMS: ZERO FREIGHT DISTRIBUTION BY SELLER
-- =====================================================

-- PURPOSE:
-- Investigate how zero freight values are distributed
-- across sellers.

-- OBJECTIVE:
-- Determine whether zero freight values are concentrated
-- among a small number of sellers or distributed across
-- multiple sellers.

-- METHODOLOGY:
-- Group zero-freight order items by seller.
-- Count affected items and distinct orders.
-- Calculate the merchandise value of those items.

-- NOTE:
-- Zero freight is not automatically classified as an
-- error. This analysis is for investigation only.

-- =====================================================



SELECT
    seller_id,
    COUNT(*) AS zero_freight_items,
    COUNT(DISTINCT order_id) AS affected_orders,
    SUM(price) AS total_item_value

FROM vw_clean_order_items

WHERE freight_value = 0

GROUP BY seller_id

ORDER BY zero_freight_items DESC;
