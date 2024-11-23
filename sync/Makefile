_DOCKER_IS_RUNNING=0

.PHONY: info
info:
	docker -v

.PHONY: start-docker-mac
start-docker-mac: 
ifeq ($(_DOCKER_IS_RUNNING), 0)
	open -a Docker
	sleep 10
else
	$(info Docker is running already.)
endif

.PHONY: stop-docker-mac
stop-docker-mac:
# if docker is NOT running at the very beginning, then quit docker
ifeq ($(_DOCKER_IS_RUNNING), 0)
	pkill -SIGHUP -f /Applications/Docker.app 'docker serve' 
	sleep 5
	kill -9 `pgrep "com.docker.backend"`
else
	$(info Docker is running at the very beginning, will not quit it.)
endif

.PHONY: start-alist
start-alist:
	cd ../container/infra/; make start-alist; sleep 10

.PHONY: stop-alist
stop-alist:
	cd ../container/infra/; make stop-alist; sleep 10

DOCKER_IS_RUNNING=$(shell docker stats --no-stream > /dev/null 2>&1 && echo 1 || echo 0)
.PHONY: backup
backup:
	make start-docker-mac _DOCKER_IS_RUNNING=$(DOCKER_IS_RUNNING)
	make start-alist
	./sync.sh
	make stop-alist
	make stop-docker-mac _DOCKER_IS_RUNNING=$(DOCKER_IS_RUNNING)