# Dashboard usage guide
# Dashboard Guide

## Access Dashboard
```
http://localhost:8501
```

## Main Pages

### Overview
- System health status
- Real-time fraud detection count
- API performance metrics
- ETL pipeline status

### Real-time Monitoring
- Live fraud alerts
- Incoming CDR processing
- Prediction confidence scores
- System resource usage

### Fraud Analytics
- Detection trends over time
- Fraud types breakdown
- Operator-wise statistics
- Geographic fraud distribution
- False positive/negative rates

### Model Management
- Train new models
- Deploy trained models
- Compare model performance
- Feature importance visualization
- Model accuracy tracking

### Admin Panel
- User management
- API key management
- System configuration
- Performance tuning
- Data quality reports

## Key Features

### Interactive Charts
```python
# Real-time fraud detection chart
# Operator performance comparison
# Time-series trend analysis
# Geographic heat maps
```

### Real-time Updates
- Auto-refresh every 30 seconds
- Live alerts and notifications
- Real-time metrics display
- Dynamic chart updates

### Data Export
- Export analytics reports
- Download model performance data
- Generate compliance reports
- Export fraud detection logs

## Navigation
```
Sidebar Menu:
├── 🏠 Overview
├── 📊 Real-time Monitoring  
├── 📈 Fraud Analytics
├── 🤖 Model Management
└── ⚙️ Admin Panel
```

## Configuration
```yaml
# configs/dashboard/streamlit.yaml
dashboard:
  title: "Vice FW ML Dashboard"
  theme: "dark"
  auto_refresh: 30
  max_data_points: 1000
```