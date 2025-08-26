# Voice FW ML - Expansion Guide
## Essential Growth Strategy

---

## **🚀 Quick Commands**

### **Add New Fraud Module**
```bash
python scripts/expansion/add-module.py --name robocall --algorithm lightgbm
python scripts/ml/train-models.py --module robocall
make deploy-module MODULE=robocall
```

### **Add New Operator**
```bash
python scripts/expansion/add-operator.py --name operator_d --format csv
# Edit: configs/etl/operators/operator_d.yaml
make test-operator OPERATOR=operator_d
```

### **Scale System**
```bash
docker-compose up --scale api=5 --scale spark-worker=8
./scripts/performance/optimize-database.sh --production
```

---

## **📈 Growth Phases**

### **Phase 1: Single Module (Current)**
- Flash Call Detection
- Basic ETL Pipeline
- Single Operator Support

### **Phase 2: Multi-Module (Next)**
- Add Robocall Detection
- Add CLI Spoofing Detection
- Multi-Operator Support

### **Phase 3: Enterprise Scale**
- 10+ Fraud Types
- Real-time Streaming
- Advanced AI Models (GNN, LSTM)

---

## **🧩 Adding Fraud Detection Module**

### **1. Generate Module**
```bash
python scripts/expansion/add-module.py \
  --name robocall \
  --algorithm lightgbm \
  --features "voice_patterns,call_frequency,timing_analysis"
```

### **2. Implement Detection**
```python
# app/ml/models/robocall.py
class RobocallDetector(BaseFraudDetector):
    def __init__(self):
        super().__init__("robocall", "lightgbm")
    
    def extract_features(self, cdr_data):
        return {
            'call_frequency_1h': self.calculate_frequency(cdr_data, '1h'),
            'voice_pattern_score': self.analyze_voice_patterns(cdr_data),
            'timing_regularity': self.calculate_timing_patterns(cdr_data)
        }
    
    def predict(self, features):
        probability = self.model.predict_proba([list(features.values())])[0][1]
        return {
            'fraud_probability': probability,
            'fraud_type': 'robocall' if probability > 0.7 else 'legitimate'
        }
```

### **3. Configure Model**
```yaml
# configs/ml/models/robocall.yaml
robocall:
  enabled: true
  algorithm: "lightgbm"
  features:
    - call_frequency_1h
    - voice_pattern_score
    - timing_regularity
  hyperparameters:
    n_estimators: 100
    learning_rate: 0.1
    max_depth: 8
  thresholds:
    fraud_probability: 0.7
```

---

## **🌐 Adding Telecom Operator**

### **1. Generate Configuration**
```bash
python scripts/expansion/add-operator.py \
  --name operator_d \
  --country LK \
  --format csv,xml
```

### **2. Configure Mappings**
```yaml
# configs/etl/operators/operator_d.yaml
operator:
  name: "operator_d"
  country: "LK"
  
field_mappings:
  caller_number:
    source_field: "source_msisdn"
    transformation: "normalize_lk_number"
    
  called_number:
    source_field: "destination_msisdn"
    transformation: "normalize_lk_number"
    
  call_start_time:
    source_field: "call_timestamp"
    transformation: "parse_datetime"
    format: "%Y-%m-%d %H:%M:%S"
    
  call_duration:
    source_field: "duration_seconds"
    transformation: "convert_to_int"
```

---

## **☁️ Cloud Deployment**

### **AWS Deployment**
```bash
./scripts/cloud/deploy-aws.sh --environment production --region us-east-1
# Creates: ECS Fargate, RDS PostgreSQL, ElastiCache, S3, ALB
```

### **Azure Deployment**
```bash
./scripts/cloud/deploy-azure.sh --environment production --region eastus
# Creates: Container Instances, PostgreSQL, Redis Cache, Blob Storage
```

### **Google Cloud Deployment**
```bash
./scripts/cloud/deploy-gcp.sh --environment production --region us-central1
# Creates: GKE, Cloud SQL, Memorystore, Cloud Storage
```

---

## **📊 Performance Scaling**

### **Horizontal Scaling**
```yaml
# Scale services
api_scaling:
  min_replicas: 2
  max_replicas: 10
  target_cpu: 70%

spark_scaling:
  min_workers: 2
  max_workers: 20

database_scaling:
  read_replicas: 3
  connection_pool_size: 50
```

### **Database Optimization**
```sql
-- Performance indexes for new modules
CREATE INDEX CONCURRENTLY idx_robocall_patterns 
ON cdr_data_fast (caller_frequency_1h, timing_regularity)
WHERE fraud_type = 'robocall';

-- Partitioning for large datasets
CREATE TABLE cdr_data_y2024m06 PARTITION OF cdr_data_fast
FOR VALUES FROM ('2024-06-01') TO ('2024-07-01');
```

---

## **🔧 Environment Configuration**

### **Production Settings**
```yaml
# configs/environments/production.yaml
database:
  pool_size: 50
  max_overflow: 100

cache:
  redis_max_connections: 100
  memory_cache_size: 10000

api:
  workers: 8
  max_requests: 10000

ml:
  batch_size: 1000
  model_cache_size: 20
  gpu_enabled: true
```

### **Feature Flags**
```yaml
# configs/features.yaml
features:
  robocall_detection:
    enabled: false
    rollout_percentage: 0
    
  gpu_acceleration:
    enabled: true
    fallback_to_cpu: true
```

---

## **🚨 Critical Alerts**

```yaml
# configs/monitoring/alerts.yaml
alerts:
  api_latency_high:
    condition: "p95_latency > 200ms"
    action: "scale_api_instances"
    
  fraud_detection_rate_drop:
    condition: "detection_rate < 80% of baseline"
    action: "notify_ml_team"
    
  etl_pipeline_failure:
    condition: "pipeline_status = failed"
    action: "notify_ops_team"
```

---

## **🔄 Deployment Process**

### **Zero-Downtime Deployment**
```bash
# Blue-green deployment
./scripts/deployment/blue-green-deploy.sh \
  --module robocall \
  --version 1.0.0

# Canary deployment
./scripts/deployment/canary-deploy.sh \
  --module robocall \
  --traffic-percentage 10
```

---

## **📋 Expansion Checklist**

### **Before Adding Module:**
- [ ] Define fraud detection requirements
- [ ] Choose appropriate ML algorithm
- [ ] Estimate resource requirements

### **Module Development:**
- [ ] Generate module structure
- [ ] Implement detection logic
- [ ] Configure model parameters
- [ ] Add API endpoints
- [ ] Write tests

### **Deployment:**
- [ ] Test in development
- [ ] Deploy to staging
- [ ] Performance testing
- [ ] Production deployment
- [ ] Monitor performance

---

## **🎯 Performance Targets**

```yaml
targets:
  api_response_time: "< 100ms p95"
  ml_inference_time: "< 50ms"
  etl_throughput: "> 50k records/min"
  system_uptime: "> 99.5%"
  fraud_detection_accuracy: "> 90%"
```