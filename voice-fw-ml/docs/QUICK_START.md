# Quick Start Guide

## Setup (30 seconds)
```bash
git clone <repo-url>
cd vice-fw-ml
make ultra-setup
```

## Access Points
- **API**: http://localhost:8000/docs
- **Dashboard**: http://localhost:8501
- **Airflow**: http://localhost:8080 (admin/admin)

## Test Fraud Detection
```bash
curl -X POST http://localhost:8000/api/v1/fraud/predict \
  -H "Content-Type: application/json" \
  -d '{
    "caller_number": "0771234567",
    "called_number": "0777654321", 
    "call_duration": 3
  }'
```

## Common Commands
```bash
make dev          # Start development
make test         # Run tests
make prod         # Production deployment
make health-check # Check system status
```

## Troubleshooting
```bash
docker-compose ps              # Check services
docker-compose logs api        # View API logs
make reset-database           # Reset database
```