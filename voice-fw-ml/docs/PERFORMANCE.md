# Performance Guide

## Targets
- **API**: < 50ms response time
- **ML**: < 20ms inference
- **ETL**: 100k+ records/min
- **Throughput**: 50k+ requests/min

## Optimization Commands
```bash
# Database optimization
./scripts/performance/optimize-database.sh

# Cache tuning
./scripts/performance/tune-cache.py

# Load testing
python scripts/performance/load-test.py --users 1000
```

## Scaling
```bash
# Scale API
docker-compose up --scale api=5

# Scale Spark workers  
docker-compose up --scale spark-worker=8
```

## Key Settings
```yaml
# Database
pool_size: 50
max_overflow: 100

# Redis
max_connections: 100
cache_ttl: 300

# ML
batch_size: 1000
model_cache_size: 10
```

## Monitoring
```bash
# Performance metrics
curl http://localhost:8000/metrics

# System health
curl http://localhost:8000/health
```