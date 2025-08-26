# Issue resolution guide
# Troubleshooting Guide

## Common Issues

### Services Not Starting
```bash
# Check Docker status
docker-compose ps

# View service logs
docker-compose logs api
docker-compose logs postgres
docker-compose logs spark-master

# Restart services
docker-compose restart
```

### Database Connection Error
```bash
# Check PostgreSQL status
docker-compose logs postgres

# Test connection
docker-compose exec postgres psql -U admin -d vice_fw

# Reset database
make reset-database
```

### Slow API Performance
```bash
# Check system resources
docker stats

# Monitor API metrics
curl http://localhost:8000/metrics

# Optimize database
./scripts/performance/optimize-database.sh
```

### ML Model Issues
```bash
# Check model loading
python scripts/ml/test-model.py --module flash_call

# Retrain model
python scripts/ml/train-models.py --module flash_call

# Clear model cache
rm -rf data/cache/models/*
```

### ETL Pipeline Failures
```bash
# Check Airflow logs
docker-compose logs airflow-webserver

# View DAG status
curl http://localhost:8080/api/v1/dags

# Restart pipeline
python app/etl/airflow/dags/cdr_pipeline.py
```

## Performance Issues

### High Memory Usage
```bash
# Check memory usage
docker stats

# Optimize Spark memory
# Edit: configs/performance/spark.yaml

# Restart with more memory
docker-compose up --scale spark-worker=4
```

### Disk Space Issues
```bash
# Check disk usage
df -h

# Clean old logs
./scripts/operations/cleanup.sh

# Archive old data
./scripts/operations/archive-data.sh
```

## Debug Commands
```bash
# System health
make health-check

# Performance benchmark
make benchmark

# View all logs
make logs

# Reset everything
make clean && make ultra-setup
```