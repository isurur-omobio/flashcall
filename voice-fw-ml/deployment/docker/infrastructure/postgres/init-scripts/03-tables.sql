-- deployment/docker/infrastructure/postgres/init-scripts/03-tables.sql
\c voice_fw_db;

-- Raw CDR data table
CREATE TABLE raw_data.cdr_data (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    raw_record_id VARCHAR(50) UNIQUE NOT NULL,
    caller_number VARCHAR(20) NOT NULL,
    called_number VARCHAR(20) NOT NULL,
    call_start_time TIMESTAMP NOT NULL,
    call_end_time TIMESTAMP,
    call_duration INTEGER NOT NULL,
    operator_id SMALLINT NOT NULL,
    call_type VARCHAR(10) DEFAULT 'voice',
    termination_cause VARCHAR(20),
    raw_data JSONB,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Processed CDR data table
CREATE TABLE processed_data.cdr_processed (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    raw_cdr_id UUID REFERENCES raw_data.cdr_data(id),
    caller_number_hash VARCHAR(64) NOT NULL,
    called_number_hash VARCHAR(64) NOT NULL,
    call_start_time TIMESTAMP NOT NULL,
    call_duration INTEGER NOT NULL,
    operator_id SMALLINT NOT NULL,
    hour_of_day SMALLINT NOT NULL,
    day_of_week SMALLINT NOT NULL,
    is_weekend BOOLEAN NOT NULL,
    is_flash_call BOOLEAN GENERATED ALWAYS AS (call_duration <= 5) STORED,
    caller_prefix VARCHAR(6) NOT NULL,
    called_prefix VARCHAR(6) NOT NULL,
    processed_at TIMESTAMP DEFAULT NOW()
);

-- Feature store table
CREATE TABLE processed_data.feature_store (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    cdr_id UUID REFERENCES processed_data.cdr_processed(id),
    caller_freq_1h SMALLINT DEFAULT 0,
    caller_freq_24h SMALLINT DEFAULT 0,
    called_freq_1h SMALLINT DEFAULT 0,
    unique_called_1h SMALLINT DEFAULT 0,
    unique_called_24h SMALLINT DEFAULT 0,
    avg_duration_1h DECIMAL(8,2) DEFAULT 0,
    avg_duration_24h DECIMAL(8,2) DEFAULT 0,
    flash_call_ratio_1h DECIMAL(5,4) DEFAULT 0,
    flash_call_ratio_24h DECIMAL(5,4) DEFAULT 0,
    pattern_score DECIMAL(6,5) DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ML model registry
CREATE TABLE ml_models.model_registry (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    model_name VARCHAR(50) NOT NULL,
    model_version VARCHAR(20) NOT NULL,
    model_type VARCHAR(30) NOT NULL,
    model_path TEXT NOT NULL,
    model_config JSONB,
    accuracy_score DECIMAL(6,5),
    precision_score DECIMAL(6,5),
    recall_score DECIMAL(6,5),
    f1_score DECIMAL(6,5),
    is_active BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(model_name, model_version)
);

-- ML predictions table
CREATE TABLE ml_models.predictions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    cdr_id UUID REFERENCES processed_data.cdr_processed(id),
    model_id UUID REFERENCES ml_models.model_registry(id),
    fraud_probability DECIMAL(6,5) NOT NULL,
    risk_score DECIMAL(6,5) NOT NULL,
    prediction_class SMALLINT NOT NULL CHECK (prediction_class IN (0, 1)),
    confidence_score DECIMAL(6,5) NOT NULL,
    processing_time_ms SMALLINT NOT NULL,
    prediction_metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ETL job tracking
CREATE TABLE etl_jobs.job_runs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    job_name VARCHAR(100) NOT NULL,
    job_type VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'running',
    start_time TIMESTAMP DEFAULT NOW(),
    end_time TIMESTAMP,
    records_processed INTEGER DEFAULT 0,
    records_failed INTEGER DEFAULT 0,
    error_message TEXT,
    job_config JSONB,
    spark_application_id VARCHAR(100)
);

-- Audit logs
CREATE TABLE audit_logs.system_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    service_name VARCHAR(50) NOT NULL,
    log_level VARCHAR(10) NOT NULL,
    message TEXT NOT NULL,
    metadata JSONB,
    timestamp TIMESTAMP DEFAULT NOW()
);
