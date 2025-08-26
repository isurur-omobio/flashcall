# Voice FW ML - Quick Setup Makefile

.PHONY: setup build up down logs clean test

# Quick setup for development
setup:
	@echo "🚀 Setting up Voice FW ML..."
	cp .env.example .env
	mkdir -p data/{raw,processed,models,logs,cache}
	mkdir -p data/logs/{api,ml,etl,dashboard,airflow}
	mkdir -p deployment/docker/{etl,infrastructure,api,ml,dashboard}
	mkdir -p deployment/docker/etl/{spark,airflow}
	mkdir -p deployment/docker/infrastructure/{postgres,redis,nginx}
	mkdir -p deployment/docker/infrastructure/postgres/init-scripts
	@echo "✅ Basic setup complete!"

# Build all containers
build:
    @echo "🔨 Building containers..."
    docker-compose build --no-cache

# Start core services (Postgres, Spark, Airflow, Redis)
up:
	@echo "🚀 Starting core services..."
	docker-compose up -d
	@echo "✅ Services started!"
	@echo "📊 Airflow UI: http://localhost:8081 (admin/admin123)"
	@echo "⚡ Spark UI: http://localhost:8080"
	@echo "🐘 PostgreSQL: localhost:5432"
	@echo "📦 Redis: localhost:6379"

# Stop all services
down:
	@echo "🛑 Stopping services..."
	docker-compose down

# View logs
logs:
	docker-compose logs -f

# View specific service logs
logs-postgres:
	docker-compose logs -f postgres

logs-spark:
	docker-compose logs -f spark-master spark-worker

logs-airflow:
	docker-compose logs -f airflow-webserver airflow-scheduler

# Clean up
clean:
	@echo "🧹 Cleaning up..."
	docker-compose down -v
	docker system prune -f
	docker volume prune -f

# Reset everything
reset: clean
	@echo "🔄 Resetting environment..."
	rm -rf data/logs/*
	docker-compose up -d --build

# Check service health
health:
	@echo "🏥 Checking service health..."
	docker-compose ps
	@echo "\n📊 Service URLs:"
	@echo "Airflow: http://localhost:8081"
	@echo "Spark: http://localhost:8080"
	@echo "PostgreSQL: localhost:5432"

# Test Spark connection
test-spark:
	@echo "🧪 Testing Spark connection..."
	docker-compose exec spark-master python /app/spark-jobs/test_connection.py

# Run sample Spark job
run-sample-job:
	@echo "🚀 Running sample Spark job..."
	docker-compose exec spark-master python /app/spark-jobs/sample_job.py

# Check Spark cluster status
spark-status:
	@echo "⚡ Checking Spark cluster status..."
	@echo "Master UI: http://localhost:8080"
	docker-compose exec spark-master /opt/spark/bin/spark-shell --master spark://spark-master:7077 --version

# Database operations
db-init:
	@echo "🗄️ Initializing database..."
	docker-compose exec postgres psql -U admin -d voice_fw_db -c "SELECT version();"

# Show resource usage
stats:
	docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"