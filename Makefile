#!make

export $(shell sed 's/=.*//' .env)

COMPOSE_FILE := docker-compose.yml

RUN = sudo docker-compose -p minio -f $(COMPOSE_FILE) run --rm
START = sudo docker-compose -p minio -f $(COMPOSE_FILE) up -d
STOP = sudo docker-compose -p minio -f $(COMPOSE_FILE) stop
DOWN = sudo docker-compose -p minio -f $(COMPOSE_FILE) down
LOGS = sudo docker-compose -p minio -f $(COMPOSE_FILE) logs -f
EXEC = sudo docker-compose -p minio -f $(COMPOSE_FILE) exec
STATUS = sudo docker-compose -p minio -f $(COMPOSE_FILE) ps
BUILD = sudo docker buildx build

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

######### Main #########

up: ## Start all containers
	@$(START)
	@$(STATUS)

start: up ## Start all containers

stop: ## Stop all containers
	@$(STOP)

status: ## Show containers status
	@$(STATUS)

restart: ## Restart all containers
	@$(STOP)
	@$(START)
	@$(STATUS)

clear: ## Clear docker cache
	@docker system prune -af

logs: ## Show logs from all containers
	@$(LOGS)

build: ## Build telegram bot image
	@sudo docker build -t tg-bot:latest .

rebuild: build restart ## Rebuild image and restart container

console: ## Connect to minio container terminal
	@$(EXEC) minio bash