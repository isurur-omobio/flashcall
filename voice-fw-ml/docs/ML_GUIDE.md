# ML development guide
# ML Development Guide

## Train Models
```bash
# Train flash call model
python scripts/ml/train-models.py --module flash_call

# Evaluate performance
python scripts/ml/evaluate-models.py --module flash_call

# Deploy model
python scripts/ml/deploy-models.py --module flash_call
```

## Add New Model
```bash
# Generate model structure
python scripts/expansion/add-module.py --name robocall --algorithm lightgbm

# Implement detection logic
# Edit: app/ml/models/robocall.py

# Configure model
# Edit: configs/ml/models/robocall.yaml
```

## Model Configuration
```yaml
# configs/ml/models/flash_call.yaml
flash_call:
  enabled: true
  algorithm: "xgboost"
  features:
    - hour_of_day
    - call_duration
    - caller_frequency_1h
  hyperparameters:
    n_estimators: 100
    learning_rate: 0.1
  thresholds:
    fraud_probability: 0.7
```

## Feature Engineering
```python
# Add new features in app/ml/features/extractors.py
def extract_temporal_features(cdr_data):
    return {
        'hour_of_day': cdr_data['call_start_time'].hour,
        'day_of_week': cdr_data['call_start_time'].weekday(),
        'is_weekend': cdr_data['call_start_time'].weekday() >= 5
    }
```

## Model Performance
```bash
# Check model accuracy
python scripts/ml/model-stats.py --module flash_call

# Compare models
python scripts/ml/compare-models.py
```