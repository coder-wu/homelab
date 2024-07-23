DATA_DIR := $(HOME)/Code/data
.PHONY: info
info:
	docker -v

.PHONY: start-env
start-env:
	make start-mariadb
	make start-pg
	make start-redis

.PHONY: stop-env
stop-env:
	make stop-mariadb
	make stop-pg
	make stop-redis

MARIADB_CONTAINER = "mariadb"
.PHONY: create-mariadb
create-mariadb:
	docker run --name $(MARIADB_CONTAINER) \
		-v $(DATA_DIR)/db/mariadb/data:/var/lib/mysql \
		-e MARIADB_ROOT_PASSWORD=root@ \
		-p 3306:3306 \
		-d mariadb:latest

.PHONY: start-mariadb
start-mariadb:
	docker start $(MARIADB_CONTAINER)

.PHONY: stop-mariadb
stop-mariadb:
	docker stop $(MARIADB_CONTAINER)


PG_CONTAINER = "postgres"
.PHONY: create-pg
create-pg:
	docker run --name $(PG_CONTAINER) \
		-v $(DATA_DIR)/db/pg/data:/var/lib/postgresql/data \
		-e POSTGRES_USER=postgres \
		-e POSTGRES_PASSWORD=postgres@ \
		-p 5432:5432 \
		-d postgres:15.7

.PHONY: delete-pg
delete-pg:
	docker rm $(PG_CONTAINER)

.PHONY: start-pg
start-pg:
	docker start $(PG_CONTAINER)

.PHONY: stop-pg
stop-pg:
	docker stop $(PG_CONTAINER)

REDIS_CONTAINER = "redis"
.PHONY: create-redis
create-redis:
	docker run --name $(REDIS_CONTAINER) \
		-v $(DATA_DIR)/db/redis/data:/data \
		-p 6379:6379 \
		-d redis:latest

.PHONY: delete-redis
delete-redis:
	docker rm $(REDIS_CONTAINER)

.PHONY: start-redis
start-redis:
	docker start $(REDIS_CONTAINER)

.PHONY: stop-redis
stop-redis:
	docker stop $(REDIS_CONTAINER)
