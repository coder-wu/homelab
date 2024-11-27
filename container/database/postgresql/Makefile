DATA_DIR := $(HOME)/Code/data
.PHONY: info
info:
	docker -v

PG_CONTAINER = "postgres"
.PHONY: create
create:
	docker run --name $(PG_CONTAINER) \
		-v $(DATA_DIR)/db/pg/data:/var/lib/postgresql/data \
		-e POSTGRES_USER=postgres \
		-e POSTGRES_PASSWORD=postgres@ \
		-p 5432:5432 \
		-d postgres:15.7

.PHONY: delete
delete: stop
	docker rm $(PG_CONTAINER)

.PHONY: start
start:
	docker start $(PG_CONTAINER)

.PHONY: stop
stop:
	docker stop $(PG_CONTAINER)
