LOG_DIR := /tmp/one-api/logs
.PHONY: info
info:
	docker -v

ONE_API_CONTAINER = "one-api"
.PHONY: create
create:
	docker run --name $(ONE_API_CONTAINER) \
		-e TZ=Asia/Shanghai \
		-v $(LOG_DIR):/data \
		-p 3000:3000 \
		-d justsong/one-api

.PHONY: delete
delete: stop
	docker rm $(ONE_API_CONTAINER)

.PHONY: start
start:
	docker start $(ONE_API_CONTAINER)

.PHONY: stop
stop:
	docker stop $(ONE_API_CONTAINER)
