until hdfs dfs -ls / >/dev/null 2>&1; do echo Waiting for HDFS...; sleep 1; done

echo "Creating hive directories..."
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chown -R hive:hive /user/hive/

echo "Creating tmp directories..."
hdfs dfs -mkdir -p /tmp/hive /tmp/dwh
hdfs dfs -mkdir -p /tmp/hadoop-yarn/logs /tmp/hadoop-yarn/local /tmp/hadoop-yarn/staging
hdfs dfs -chmod -R 1777 /tmp

echo "HDFS init done."
