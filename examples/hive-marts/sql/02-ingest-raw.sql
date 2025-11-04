USE raw_csv;

-- RAW EXTERNAL TABLES (one per CSV). Respect headers and quoting.
DROP TABLE IF EXISTS orders_raw;
CREATE EXTERNAL TABLE orders_raw (
  order_id                         STRING,
  customer_id                      STRING,
  order_status                     STRING,
  order_purchase_timestamp         STRING,
  order_approved_at                STRING,
  order_delivered_carrier_date     STRING,
  order_delivered_customer_date    STRING,
  order_estimated_delivery_date    STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\"",
  "escapeChar" = "\\"
)
STORED AS TEXTFILE
LOCATION '/tmp/dwh/olist/orders'
TBLPROPERTIES ("skip.header.line.count"="1");

DROP TABLE IF EXISTS customers_raw;
CREATE EXTERNAL TABLE customers_raw (
  customer_id              STRING,
  customer_unique_id       STRING,
  customer_zip_code_prefix STRING,
  customer_city            STRING,
  customer_state           STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\"",
  "escapeChar" = "\\"
)
STORED AS TEXTFILE
LOCATION '/tmp/dwh/olist/customers'
TBLPROPERTIES ("skip.header.line.count"="1");

DROP TABLE IF EXISTS order_items_raw;
CREATE EXTERNAL TABLE order_items_raw (
  order_id            STRING,
  order_item_id       STRING,
  product_id          STRING,
  seller_id           STRING,
  shipping_limit_date STRING,
  price               STRING,
  freight_value       STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\"",
  "escapeChar" = "\\"
)
STORED AS TEXTFILE
LOCATION '/tmp/dwh/olist/order_items'
TBLPROPERTIES ("skip.header.line.count"="1");

DROP TABLE IF EXISTS order_payments_raw;
CREATE EXTERNAL TABLE order_payments_raw (
  order_id             STRING,
  payment_sequential   STRING,
  payment_type         STRING,
  payment_installments STRING,
  payment_value        STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\"",
  "escapeChar" = "\\"
)
STORED AS TEXTFILE
LOCATION '/tmp/dwh/olist/order_payments'
TBLPROPERTIES ("skip.header.line.count"="1");

DROP TABLE IF EXISTS products_raw;
CREATE EXTERNAL TABLE products_raw (
  product_id                    STRING,
  product_category_name         STRING,
  product_name_length           STRING,
  product_description_length    STRING,
  product_photos_qty            STRING,
  product_weight_g              STRING,
  product_length_cm             STRING,
  product_height_cm             STRING,
  product_width_cm              STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\"",
  "escapeChar" = "\\"
)
STORED AS TEXTFILE
LOCATION '/tmp/dwh/olist/products'
TBLPROPERTIES ("skip.header.line.count"="1");

DROP TABLE IF EXISTS sellers_raw;
CREATE EXTERNAL TABLE sellers_raw (
  seller_id              STRING,
  seller_zip_code_prefix STRING,
  seller_city            STRING,
  seller_state           STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\"",
  "escapeChar" = "\\"
)
STORED AS TEXTFILE
LOCATION '/tmp/dwh/olist/sellers'
TBLPROPERTIES ("skip.header.line.count"="1");

DROP TABLE IF EXISTS geolocation_raw;
CREATE EXTERNAL TABLE geolocation_raw (
  geolocation_zip_code_prefix STRING,
  geolocation_lat             STRING,
  geolocation_lng             STRING,
  geolocation_city            STRING,
  geolocation_state           STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\"",
  "escapeChar" = "\\"
)
STORED AS TEXTFILE
LOCATION '/tmp/dwh/olist/geolocation'
TBLPROPERTIES ("skip.header.line.count"="1");

DROP TABLE IF EXISTS order_reviews_raw;
CREATE EXTERNAL TABLE order_reviews_raw (
  review_id               STRING,
  order_id                STRING,
  review_score            STRING,
  review_comment_title    STRING,
  review_comment_message  STRING,
  review_creation_date    STRING,
  review_answer_timestamp STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\"",
  "escapeChar" = "\\"
)
STORED AS TEXTFILE
LOCATION '/tmp/dwh/olist/order_reviews'
TBLPROPERTIES ("skip.header.line.count"="1");

DROP TABLE IF EXISTS product_category_translation_raw;
CREATE EXTERNAL TABLE product_category_translation_raw (
  product_category_name         STRING,
  product_category_name_english STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\"",
  "escapeChar" = "\\"
)
STORED AS TEXTFILE
LOCATION '/tmp/dwh/olist/product_category_translation'
TBLPROPERTIES ("skip.header.line.count"="1");
