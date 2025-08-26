# System Architecture

## High-Level Design
```
FastAPI → PostgreSQL → Spark ETL → Airflow → ML Models
   ↓           ↓           ↓          ↓         ↓
Redis     ELK Stack   Feature    Training   Prediction
Cache     Monitoring   Store     Pipeline    Cache
```

## Core Components
- **FastAPI**: REST API with async processing
- **PostgreSQL**: Multi-layer data storage 
- **Redis**: Caching and session management
- **Spark**: Distributed data processing
- **Airflow**: ETL orchestration
- **Streamlit**: Real-time dashboard

## Data Flow
```
CDR Files → Raw Storage → Mapping → Feature Store → 
ML Training → Model Registry → Prediction API
```

## Database Schema
```sql
raw_cdr_data        # Original CDR files
↓
mapped_cdr_data     # Standardized CDR
↓  
feature_store       # ML features
↓
predictions         # Fraud predictions
```

## Performance Features
- **Multi-tier caching**: Memory + Redis
- **Connection pooling**: 50+ DB connections
- **Vectorized ML**: NumPy optimizations
- **Partitioned tables**: Time-based partitioning