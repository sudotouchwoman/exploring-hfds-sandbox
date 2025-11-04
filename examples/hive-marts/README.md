# Working with tabular data in Hive

This example focuses on ingesting data into `hive` and building data marts from it.
The dataset used is `Brazilian E-Commerce Public Dataset` and can be found [on kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).
The dataset has information of 100k orders from 2016 to 2018 made at multiple marketplaces in Brazil.
Its features allows viewing an order from multiple dimensions: from order status, price, payment and freight performance to customer location, product attributes and finally reviews written by customers.

Note that `hiveql` over `mapreduce` takes forever to run (`10.5m` on my machine)!

Data can be downloaded like this:

```shell
mkdir -p ./tmp
curl -L -o ./tmp/brazilian-ecommerce.zip https://www.kaggle.com/api/v1/datasets/download/olistbr/brazilian-ecommerce
cd ./tmp && unzip ./brazilian-ecommerce.zip
```

Then, hive schema and marts can be created using the root `Makefile`:

```shell
make hive-build-marts
```

Will import `csv` files to `hdfs`, create external and staging tables and generate
marts for them using scripts in `./sql` dir.

To enter `hiveql` console: `make hive-query`.

Mart description is located in the comments for `./sql/04-build-marts.sql`.
These are essentially some basic aggregates over the original normalized data.

Wiring `hive` container with the existing `hadoop` setup was a nightmare but it sort of works now, albeit with several limitations: e.g. local `mapred` jobs are broken for some reason (`/tmp/hive/hive.log` contains minimal traceback), so `SET hive.auto.convert.join=false;` is used to avoid them.
Also, I did not manage to integrate `hive` with `tez` or `spark`, so it uses `mr` as backend, which is rather slow. To my knowledge, running `hive` in a separate standalone container makes things easier, yet I was willing to integrate it to the existing setup without breaking things in the process.

As a result, most of configuration was moved from `.hdfs.env` into dedicated `xml` configs,
since `hive` container does not support `env` substitution like `hadoop` does!
