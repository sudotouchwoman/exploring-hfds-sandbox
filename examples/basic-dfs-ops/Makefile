COMPOSE := docker compose
COMPOSE_EXEC := $(COMPOSE) exec nodemanager hdfs dfs
EXAMPLE_DIR := /user/hadoop/basic-dfs-ops

.PHONY: test
test:
	$(COMPOSE_EXEC) -mkdir -p $(EXAMPLE_DIR)/
	$(COMPOSE_EXEC) -mkdir -p $(EXAMPLE_DIR)/createme
	$(COMPOSE_EXEC) -mkdir -p $(EXAMPLE_DIR)/deleteme
	$(COMPOSE_EXEC) -rm -r -f $(EXAMPLE_DIR)/deleteme
	$(COMPOSE_EXEC) -copyFromLocal /opt/examples/basic-dfs-ops/Makefile $(EXAMPLE_DIR)/
	$(COMPOSE_EXEC) -ls $(EXAMPLE_DIR)/
	$(COMPOSE_EXEC) -cat $(EXAMPLE_DIR)/Makefile

.PHONY: clean
clean:
	$(COMPOSE_EXEC) -rm -r -f $(EXAMPLE_DIR)/
