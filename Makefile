COMPOSE := docker compose
COMPOSE_EXEC := $(COMPOSE) exec nodemanager bash -c
COMPOSE_EXEC_HIVE := $(COMPOSE) exec standalone-hive bash -c

.PHONY: build
build:
	$(COMPOSE) build

.PHONY: volumes
volumes:
	mkdir -p ./data/hdfs-namenode
	mkdir -p ./data/hdfs-datanode
	mkdir -p ./data/hive-metastore
	$(COMPOSE) run --rm namenode hdfs namenode -format -nonInteractive

.PHONY: clean
clean:
	rm -rf ./data

.PHONY: up
up:
	$(COMPOSE) up -d

.PHONY: down
down:
	$(COMPOSE) down -v

.PHONY: basic-dfs-ops-example
basic-dfs-ops-example:
	cd ./examples/basic-dfs-ops && make test

.PHONY: wordcount-example
wordcount-example:
	$(COMPOSE_EXEC) "cd /opt/examples/wordcount && sh ./scripts/submit.sh"

.PHONY: needle-in-haystack-example
needle-in-haystack-example:
	$(COMPOSE_EXEC) "cd /opt/examples/needle-in-haystack && sh ./scripts/submit.sh"

.PHONY: hive-query
hive-query:
	$(COMPOSE_EXEC_HIVE) "beeline -u 'jdbc:hive2://standalone-hive:10000/'"

.PHONY: hive-build-marts
hive-build-marts:
	$(COMPOSE_EXEC_HIVE) "cd /opt/examples/hive-marts && sh ./scripts/init-schema.sh"
	$(COMPOSE_EXEC_HIVE) "cd /opt/examples/hive-marts && sh ./scripts/build-marts.sh"
