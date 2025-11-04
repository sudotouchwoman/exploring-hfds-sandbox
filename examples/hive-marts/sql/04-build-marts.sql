-- This script builds marts from staging tables
USE marts;

-- Disable automatic join optimization
-- This is a workaround to avoid issue with local map-reduce engine
-- (it would fail with no apparent reason and no error message so just disable it)
SET hive.auto.convert.join=false;

-- Daily orders and GMV:
-- shows daily order metrics and GMV by payment type
DROP TABLE IF EXISTS orders_daily;
CREATE TABLE orders_daily STORED AS PARQUET AS
WITH payments_per_order AS (
  SELECT
    order_id,
    SUM(payment_value) AS order_payment_value
  FROM staging.order_payments_stg
  GROUP BY order_id
)
SELECT
  CAST(o.order_purchase_timestamp AS DATE)                       AS order_date,
  COUNT(1)                                                       AS orders_total,
  SUM(CASE WHEN o.order_status = 'delivered' THEN 1 ELSE 0 END) AS orders_delivered,
  SUM(CASE WHEN o.order_status = 'canceled'  THEN 1 ELSE 0 END) AS orders_canceled,
  COUNT(DISTINCT o.customer_id)                                  AS customers_distinct,
  SUM(COALESCE(p.order_payment_value, 0))                        AS gmv_total,
  SUM(CASE WHEN o.order_status = 'delivered'
           THEN COALESCE(p.order_payment_value, 0) ELSE 0 END)   AS gmv_delivered
FROM staging.orders_stg o
LEFT JOIN payments_per_order p
  ON o.order_id = p.order_id
GROUP BY CAST(o.order_purchase_timestamp AS DATE);

-- Weekly delivery SLA percentiles
-- shows weekly delivery percentiles by lateness (in days) for completed orders
DROP TABLE IF EXISTS delivery_sla_weekly;
CREATE TABLE delivery_sla_weekly
STORED AS PARQUET AS
WITH delivered AS (
  SELECT
    CAST(order_delivered_customer_date AS DATE) AS delivered_date,
    CAST(order_estimated_delivery_date AS DATE) AS estimated_date
  FROM staging.orders_stg
  WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
),
with_lateness AS (
  SELECT
    delivered_date,
    datediff(delivered_date, estimated_date) AS lateness_days
  FROM delivered
)
SELECT
  year(delivered_date)                  AS year_,
  weekofyear(delivered_date)            AS week_of_year,
  COUNT(*)                              AS delivered_orders,
  percentile_approx(lateness_days, 0.5) AS p50_lateness_days,
  percentile_approx(lateness_days, 0.9) AS p90_lateness_days,
  percentile_approx(lateness_days, 0.99)AS p99_lateness_days
FROM with_lateness
GROUP BY year(delivered_date), weekofyear(delivered_date);

-- Daily income by payment type and item category:
-- shows daily income by payment type and item category
-- best-effort conversion of category names to English using translation table
DROP TABLE IF EXISTS income_daily_by_payment_category;
CREATE TABLE income_daily_by_payment_category
STORED AS PARQUET AS
WITH item_prices AS (
  SELECT
    oi.order_id,
    oi.product_id,
    CAST(oi.price AS DECIMAL(18,6)) AS price
  FROM staging.order_items_stg oi
),
order_totals AS (
  SELECT
    order_id,
    CAST(SUM(price) AS DECIMAL(18,6)) AS order_total_price
  FROM item_prices
  GROUP BY order_id
),
pay_by_type AS (
  SELECT
    order_id,
    payment_type,
    CAST(SUM(payment_value) AS DECIMAL(18,6)) AS payment_value_type
  FROM staging.order_payments_stg
  GROUP BY order_id, payment_type
),
items_with_cat AS (
  SELECT
    ip.order_id,
    ip.product_id,
    ip.price,
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category
  FROM item_prices ip
  LEFT JOIN staging.products_stg p
    ON ip.product_id = p.product_id
  LEFT JOIN staging.product_category_translation_stg t
    ON p.product_category_name = t.product_category_name
),
orders_with_date AS (
  SELECT
    order_id,
    CAST(order_purchase_timestamp AS DATE) AS order_date
  FROM staging.orders_stg
)
SELECT
  owd.order_date,
  p.payment_type,
  iwc.category,
  CAST(SUM(
    CASE
      WHEN ot.order_total_price > 0
      THEN p.payment_value_type * (iwc.price / ot.order_total_price)
      ELSE CAST(0 AS DECIMAL(18,6))
    END
  ) AS DECIMAL(14,2)) AS income_allocated
FROM items_with_cat iwc
JOIN order_totals ot
  ON iwc.order_id = ot.order_id
JOIN pay_by_type p
  ON iwc.order_id = p.order_id
JOIN orders_with_date owd
  ON iwc.order_id = owd.order_id
GROUP BY owd.order_date, p.payment_type, iwc.category;

-- Seller daily stats:
-- shows daily cumulative delivered order metrics by seller
DROP TABLE IF EXISTS seller_daily;
CREATE TABLE seller_daily
STORED AS PARQUET AS
WITH items AS (
  SELECT
    order_id,
    seller_id,
    CAST(price AS DECIMAL(12,2))         AS price,
    CAST(freight_value AS DECIMAL(12,2)) AS freight_value
  FROM staging.order_items_stg
),
orders_with_date AS (
  SELECT order_id, CAST(order_purchase_timestamp AS DATE) AS order_date
  FROM staging.orders_stg
  WHERE order_status = 'delivered'
)
SELECT
  owd.order_date,
  i.seller_id,
  COUNT(DISTINCT i.order_id)                          AS orders,
  COUNT(*)                                            AS items,
  CAST(SUM(i.price) AS DECIMAL(14,2))                 AS revenue,
  CAST(SUM(i.freight_value) AS DECIMAL(14,2))         AS freight_total
FROM items i
JOIN orders_with_date owd
  ON i.order_id = owd.order_id
GROUP BY owd.order_date, i.seller_id;
