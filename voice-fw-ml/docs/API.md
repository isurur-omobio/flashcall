# API Documentation

## Base URL
```
http://localhost:8000/api/v1
```

## Authentication
```bash
# Get token
curl -X POST /auth/login \
  -d '{"username": "admin", "password": "password"}'

# Use token
curl -H "Authorization: Bearer <token>" /fraud/predict
```

## Fraud Detection Endpoints

### Single Prediction
```bash
POST /fraud/predict
{
  "caller_number": "0771234567",
  "called_number": "0777654321",
  "call_duration": 3,
  "call_start_time": "2024-01-15T10:30:00"
}
```

### Batch Prediction
```bash
POST /fraud/predict/batch
[
  {"caller_number": "0771234567", "called_number": "0777654321", "call_duration": 3},
  {"caller_number": "0751234567", "called_number": "0117654321", "call_duration": 2}
]
```

## Response Format
```json
{
  "cdr_id": "uuid",
  "fraud_probability": 0.85,
  "fraud_type": "flash_call",
  "risk_score": 0.9,
  "processing_time_ms": 45
}
```

## Health Endpoints
```bash
GET /health              # Basic health
GET /health/detailed     # Component status
GET /metrics            # Performance metrics
```

## Error Codes
- **400**: Bad Request
- **401**: Unauthorized
- **429**: Rate Limited
- **500**: Internal Error