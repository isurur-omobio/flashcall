# ETL pipeline guide
# ETL Pipeline Guide

## Pipeline Overview
```
CDR Files → Spark Ingestion → Raw Storage → 
Mapping → Standardized Storage → Feature Engineering → 
Feature Store → ML Training/Inference
```

## Run ETL Jobs
```bash
# Manual pipeline execution
python app/etl/spark/jobs/ingestion.py --operator operator_a
python app/etl/spark/jobs/mapping.py --date 2024-01-15
python app/etl/spark/jobs/features.py --date 2024-01-15
```

## Airflow DAGs
- **cdr_pipeline.py**: Main ETL pipeline
- **ml_training.py**: Model training pipeline
- **data_quality.py**: Data validation pipeline

## Add New Operator
```bash
# Generate operator config
python scripts/expansion/add-operator.py --name operator_d

# Configure field mappings
# Edit: configs/etl/operators/operator_d.yaml

# Test operator
make test-operator OPERATOR=operator_d
```

## Operator Configuration
```yaml
# configs/etl/operators/operator_a.yaml
operator:
  name: "operator_a"
  format: "csv"
  
field_mappings:
  caller_number:
    source_field: "calling_party"
    transformation: "normalize_phone_number"
  call_start_time:
    source_field: "start_timestamp"
    transformation: "parse_datetime"
```

## Monitor Pipelines
```bash
# Check pipeline status
curl http://localhost:8080/api/v1/dags/cdr_pipeline/dagRuns

# View Spark jobs
curl http://localhost:4040/api/v1/applications
```