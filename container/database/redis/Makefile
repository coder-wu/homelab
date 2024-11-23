DATA_DIR := $(HOME)/Code/data
.PHONY: info
info:
	docker -v

REDIS_CONTAINER = "redis"
.PHONY: create
create:
	docker run --name $(REDIS_CONTAINER) \
		-v $(DATA_DIR)/db/redis/data:/data \
		-p 6379:6379 \
		-d redis:latest

.PHONY: delete
delete:
	docker rm $(REDIS_CONTAINER)

.PHONY: start
start:
	docker start $(REDIS_CONTAINER)

.PHONY: stop
stop:
	docker stop $(REDIS_CONTAINER)
