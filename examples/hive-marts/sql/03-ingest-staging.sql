-- STAGING: typed, clean, parquet
USE staging;

DROP TABLE IF EXISTS orders_stg;
CREATE TABLE orders_stg STORED AS PARQUET AS
SELECT
  order_id,
  customer_id,
  order_status,
  CAST(order_purchase_timestamp AS TIMESTAMP)      AS order_purchase_timestamp,
  CAST(order_approved_at AS TIMESTAMP)             AS order_approved_at,
  CAST(order_delivered_carrier_date AS TIMESTAMP)  AS order_delivered_carrier_date,
  CAST(order_delivered_customer_date AS TIMESTAMP) AS order_delivered_customer_date,
  CAST(order_estimated_delivery_date AS TIMESTAMP) AS order_estimated_delivery_date
FROM raw_csv.orders_raw
WHERE order_id IS NOT NULL;

DROP TABLE IF EXISTS customers_stg;
CREATE TABLE customers_stg STORED AS PARQUET AS
SELECT
  customer_id,
  customer_unique_id,
  customer_zip_code_prefix,
  customer_city,
  customer_state
FROM raw_csv.customers_raw
WHERE customer_id IS NOT NULL;

DROP TABLE IF EXISTS order_items_stg;
CREATE TABLE order_items_stg STORED AS PARQUET AS
SELECT
  order_id,
  CAST(order_item_id AS INT)            AS order_item_id,
  product_id,
  seller_id,
  CAST(shipping_limit_date AS TIMESTAMP)AS shipping_limit_date,
  CAST(price AS DECIMAL(12,2))          AS price,
  CAST(freight_value AS DECIMAL(12,2))  AS freight_value
FROM raw_csv.order_items_raw
WHERE order_id IS NOT NULL AND product_id IS NOT NULL AND seller_id IS NOT NULL;

DROP TABLE IF EXISTS order_payments_stg;
CREATE TABLE order_payments_stg STORED AS PARQUET AS
SELECT
  order_id,
  CAST(payment_sequential AS INT)       AS payment_sequential,
  payment_type,
  CAST(payment_installments AS INT)     AS payment_installments,
  CAST(payment_value AS DECIMAL(12,2))  AS payment_value
FROM raw_csv.order_payments_raw
WHERE order_id IS NOT NULL;

DROP TABLE IF EXISTS products_stg;
CREATE TABLE products_stg STORED AS PARQUET AS
SELECT
  product_id,
  product_category_name,
  CAST(product_name_length AS INT)          AS product_name_length,
  CAST(product_description_length AS INT)   AS product_description_length,
  CAST(product_photos_qty AS INT)           AS product_photos_qty,
  CAST(product_weight_g AS INT)             AS product_weight_g,
  CAST(product_length_cm AS INT)            AS product_length_cm,
  CAST(product_height_cm AS INT)            AS product_height_cm,
  CAST(product_width_cm AS INT)             AS product_width_cm
FROM raw_csv.products_raw
WHERE product_id IS NOT NULL;

DROP TABLE IF EXISTS sellers_stg;
CREATE TABLE sellers_stg STORED AS PARQUET AS
SELECT
  seller_id,
  seller_zip_code_prefix,
  seller_city,
  seller_state
FROM raw_csv.sellers_raw
WHERE seller_id IS NOT NULL;

DROP TABLE IF EXISTS geolocation_stg;
CREATE TABLE geolocation_stg STORED AS PARQUET AS
SELECT
  geolocation_zip_code_prefix,
  CAST(geolocation_lat AS DOUBLE)  AS geolocation_lat,
  CAST(geolocation_lng AS DOUBLE)  AS geolocation_lng,
  geolocation_city,
  geolocation_state
FROM raw_csv.geolocation_raw;

DROP TABLE IF EXISTS order_reviews_stg;
CREATE TABLE order_reviews_stg STORED AS PARQUET AS
SELECT
  review_id,
  order_id,
  CAST(review_score AS INT)           AS review_score,
  review_comment_title,
  review_comment_message,
  CAST(review_creation_date AS TIMESTAMP)          AS review_creation_date,
  CAST(review_answer_timestamp AS TIMESTAMP)       AS review_answer_timestamp
FROM raw_csv.order_reviews_raw;

DROP TABLE IF EXISTS product_category_translation_stg;
CREATE TABLE product_category_translation_stg STORED AS PARQUET AS
SELECT
  product_category_name,
  product_category_name_english
FROM raw_csv.product_category_translation_raw;
