#!/bin/bash
# upload raw csv to hdfs
set -x

hdfs dfs -mkdir -p /tmp/dwh/olist/orders
hdfs dfs -mkdir -p /tmp/dwh/olist/customers
hdfs dfs -mkdir -p /tmp/dwh/olist/order_items
hdfs dfs -mkdir -p /tmp/dwh/olist/order_payments
hdfs dfs -mkdir -p /tmp/dwh/olist/products
hdfs dfs -mkdir -p /tmp/dwh/olist/sellers
hdfs dfs -mkdir -p /tmp/dwh/olist/geolocation
hdfs dfs -mkdir -p /tmp/dwh/olist/order_reviews
hdfs dfs -mkdir -p /tmp/dwh/olist/product_category_translation

hdfs dfs -put -f ./tmp/olist_orders_dataset.csv /tmp/dwh/olist/orders/
hdfs dfs -put -f ./tmp/olist_customers_dataset.csv /tmp/dwh/olist/customers/
hdfs dfs -put -f ./tmp/olist_order_items_dataset.csv /tmp/dwh/olist/order_items/
hdfs dfs -put -f ./tmp/olist_order_payments_dataset.csv /tmp/dwh/olist/order_payments/
hdfs dfs -put -f ./tmp/olist_products_dataset.csv /tmp/dwh/olist/products/
hdfs dfs -put -f ./tmp/olist_sellers_dataset.csv /tmp/dwh/olist/sellers/
hdfs dfs -put -f ./tmp/olist_geolocation_dataset.csv /tmp/dwh/olist/geolocation/
hdfs dfs -put -f ./tmp/olist_order_reviews_dataset.csv /tmp/dwh/olist/order_reviews/
hdfs dfs -put -f ./tmp/product_category_name_translation.csv /tmp/dwh/olist/product_category_translation/

hdfs dfs -ls -R /tmp/dwh/olist/

# init schema and create external table over csv
beeline -u 'jdbc:hive2://standalone-hive:10000/' -f ./sql/01-init-schema.sql
beeline -u 'jdbc:hive2://standalone-hive:10000/' -f ./sql/02-ingest-raw.sql
beeline -u 'jdbc:hive2://standalone-hive:10000/' -f ./sql/03-ingest-staging.sql
