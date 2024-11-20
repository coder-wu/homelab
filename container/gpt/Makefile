LOG_DIR := /tmp/one-api/logs
.PHONY: info
info:
	docker -v

ONE_API_CONTAINER = "one-api"
.PHONY: create-one-api
create-one-api:
	docker run --name $(ONE_API_CONTAINER) \
		--restart always \
		-e TZ=Asia/Shanghai \
		-v $(LOG_DIR):/data \
		-p 3000:3000 \
		-d justsong/one-api

.PHONY: delete-one-api
delete-one-api:
	docker rm $(ONE_API_CONTAINER)

.PHONY: start-one-api
start-one-api:
	docker start $(ONE_API_CONTAINER)

.PHONY: stop-one-api
stop-one-api:
	docker stop $(ONE_API_CONTAINER)
