# Makefile for GridFlow

.PHONY: help setup up down logs clean test

help: ## Show this help message
	@echo "GridFlow - Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

setup: ## Run setup script to initialize all services
	./setup.sh

up: ## Start all services
	docker-compose up -d

down: ## Stop all services
	docker-compose down

logs: ## View logs from all services
	docker-compose logs -f

restart: ## Restart all services
	docker-compose restart

clean: ## Stop all services and remove volumes
	docker-compose down -v

build: ## Build all Docker images
	docker-compose build

ps: ## Show status of all services
	docker-compose ps

# Individual service commands
api: ## Start only API Gateway
	cd api-gateway && uvicorn main:app --reload --port 8000

ai: ## Start only AI Service
	cd ai-service && uvicorn main:app --reload --port 8001

web: ## Start only Client Web
	cd client-web && npm run dev

# Testing
test-api: ## Run API Gateway tests
	cd api-gateway && pytest

test-ai: ## Run AI Service tests
	cd ai-service && pytest

test-web: ## Run Client Web tests
	cd client-web && npm test

# Database
db-shell: ## Open PostgreSQL shell
	docker-compose exec postgres psql -U postgres

redis-shell: ## Open Redis shell
	docker-compose exec redis redis-cli
