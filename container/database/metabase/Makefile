.PHONY: info
info:
	docker -v

METABASE_CONTAINER = "metabase"
.PHONY: create
create:
	docker run --name $(METABASE_CONTAINER) \
		-p 12345:3000 \
		-d metabase/metabase:latest

.PHONY: delete
delete:
	docker rm $(REDIS_CONTAINER)

.PHONY: start
start:
	docker start $(METABASE_CONTAINER)

.PHONY: stop
stop:
	docker stop $(METABASE_CONTAINER)
