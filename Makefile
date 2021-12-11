DOCKER-COMPOSE_CMD=sudo docker-compose
DOCKER_CMD=sudo docker
APP_NAME=ugleiton/glpi
VERSION=9.2.3

.PHONY: build-dev
build-dev: 
	$(DOCKER-COMPOSE_CMD) build

.PHONY: up-dev
up-dev: 
	$(DOCKER-COMPOSE_CMD) up -d

.PHONY: down-dev
down-dev: 
	$(DOCKER-COMPOSE_CMD) down

.PHONY: ps-dev
ps-dev: 
	$(DOCKER-COMPOSE_CMD ps

.PHONY: publish
publish: 
	docker build -t $(APP_NAME):latest .
	docker push $(APP_NAME):latest
	docker tag $(APP_NAME):latest $(APP_NAME):$(VERSION)
	docker push $(APP_NAME):$(VERSION)
