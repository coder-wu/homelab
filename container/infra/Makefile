DATA_DIR := $(HOME)/Code/data
.PHONY: info
info:
	docker -v

ALIST_CONTAINER = "alist"
.PHONY: create-alist
create-alist:
	docker run --name $(ALIST_CONTAINER) \
		-v $(DATA_DIR)/infra/alist:/opt/alist/data \
		-p 5244:5244 \
		-d xhofe/alist:latest

.PHONY: delete-alist
delete-alist:
	docker rm $(ALIST_CONTAINER)

.PHONY: start-alist
start-alist:
	docker start $(ALIST_CONTAINER)

.PHONY: stop-alist
stop-alist:
	docker stop $(ALIST_CONTAINER)
