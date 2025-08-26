# Monitoring setup guide
# Monitoring Guide

## Monitoring Stack
- **ELK Stack**: Elasticsearch, Logstash, Kibana
- **Application Logs**: Structured JSON logging
- **Performance Metrics**: API and ML metrics
- **Health Checks**: Service availability

## Access Points
- **Kibana**: http://localhost:5601
- **Metrics**: http://localhost:8000/metrics
- **Health**: http://localhost:8000/health

## Key Metrics
```yaml
API:
  - response_time_p95: < 100ms
  - requests_per_second: > 100
  - error_rate: < 1%

ML:
  - prediction_latency: < 50ms
  - model_accuracy: > 90%
  - cache_hit_rate: > 80%

Database:
  - query_time: < 50ms
  - connection_pool: < 80%
  - transaction_rate: > 100 TPS
```

## Alerts Configuration
```yaml
# configs/monitoring/alerts.yaml
alerts:
  high_api_latency:
    condition: "p95 > 200ms"
    action: "scale_api"
    
  low_accuracy:
    condition: "accuracy < 85%"
    action: "retrain_model"
```

## Log Analysis
```bash
# Search logs in Kibana
# Filter by service, level, timestamp
# Create dashboards for key metrics
```

## Health Monitoring
```bash
# Check all services
curl http://localhost:8000/health/detailed

# Monitor specific component
curl http://localhost:8000/health/database
curl http://localhost:8000/health/ml
```