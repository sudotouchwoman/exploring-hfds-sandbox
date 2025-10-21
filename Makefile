COMPOSE := docker compose
COMPOSE_EXEC := $(COMPOSE) exec nodemanager bash -c

.PHONY: build
build:
	$(COMPOSE) build

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
