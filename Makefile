DOCKER-COMPOSE_CMD=sudo docker-compose
DOCKER_CMD=sudo docker

.PHONY: build-dev
build-dev: 
	$(DOCKER-COMPOSE_CMD) -f docker-compose-dev.yml build

.PHONY: up-dev
up-dev: 
	$(DOCKER-COMPOSE_CMD) -f docker-compose-dev.yml up -d --force-recreate --remove-orphans 

.PHONY: down-dev
down-dev: 
	$(DOCKER-COMPOSE_CMD) -f docker-compose-dev.yml down

.PHONY: ps-dev
ps-dev: 
	$(DOCKER-COMPOSE_CMD) -f docker-compose-dev.yml ps
