DATA_DIR := $(HOME)/Code/data
.PHONY: info
info:
	docker -v

MARIADB_CONTAINER = "mariadb"
.PHONY: create
create:
	docker run --name $(MARIADB_CONTAINER) \
		-v $(DATA_DIR)/db/mariadb/data:/var/lib/mysql \
		-e MARIADB_ROOT_PASSWORD=root@ \
		-p 3306:3306 \
		-d mariadb:latest

.PHONY: delete
delete:
	docker rm $(MARIADB_CONTAINER)

.PHONY: start
start:
	docker start $(MARIADB_CONTAINER)

.PHONY: stop
stop:
	docker stop $(MARIADB_CONTAINER)
