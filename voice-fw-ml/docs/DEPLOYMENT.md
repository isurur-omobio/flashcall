# Deployment guide
# Deployment Guide

## Development
```bash
# Start development environment
make dev

# Access services
# API: http://localhost:8000
# Dashboard: http://localhost:8501
# Airflow: http://localhost:8080
```

## Production
```bash
# Deploy production stack
make prod

# Health check
make health-check

# View logs
make logs SERVICE=api
```

## Cloud Deployment

### AWS
```bash
./scripts/cloud/deploy-aws.sh --environment production --region us-east-1
```

### Azure
```bash
./scripts/cloud/deploy-azure.sh --environment production --region eastus
```

### Google Cloud
```bash
./scripts/cloud/deploy-gcp.sh --environment production --region us-central1
```

## Configuration
```bash
# Environment setup
cp .env.example .env
# Edit database, redis, and API settings

# Update configs
# Edit: configs/environments/production.yaml
```

## Scaling
```bash
# Scale API instances
docker-compose up --scale api=5

# Scale Spark workers
docker-compose up --scale spark-worker=8
```

## Backup & Recovery
```bash
# Backup database
./scripts/operations/backup.sh

# Restore from backup
./scripts/operations/restore.sh --date 2024-01-15
```