-- deployment/docker/infrastructure/postgres/init-scripts/04-indexes.sql
\c voice_fw_db;

-- Indexes for raw_data.cdr_data
CREATE INDEX idx_cdr_call_start_time ON raw_data.cdr_data(call_start_time);
CREATE INDEX idx_cdr_caller_number ON raw_data.cdr_data(caller_number);
CREATE INDEX idx_cdr_called_number ON raw_data.cdr_data(called_number);
CREATE INDEX idx_cdr_operator_id ON raw_data.cdr_data(operator_id);
CREATE INDEX idx_cdr_duration ON raw_data.cdr_data(call_duration);
CREATE INDEX idx_cdr_created_at ON raw_data.cdr_data(created_at);

-- Indexes for processed_data.cdr_processed
CREATE INDEX idx_processed_call_start_time ON processed_data.cdr_processed(call_start_time);
CREATE INDEX idx_processed_caller_hash ON processed_data.cdr_processed(caller_number_hash);
CREATE INDEX idx_processed_flash_call ON processed_data.cdr_processed(is_flash_call);
CREATE INDEX idx_processed_operator ON processed_data.cdr_processed(operator_id);
CREATE INDEX idx_processed_hour_day ON processed_data.cdr_processed(hour_of_day, day_of_week);

-- Composite indexes for feature engineering
CREATE INDEX idx_processed_caller_time ON processed_data.cdr_processed(caller_number_hash, call_start_time);
CREATE INDEX idx_processed_pattern ON processed_data.cdr_processed(caller_prefix, is_flash_call, hour_of_day);

-- Indexes for feature_store
CREATE INDEX idx_features_cdr_id ON processed_data.feature_store(cdr_id);
CREATE INDEX idx_features_caller_freq ON processed_data.feature_store(caller_freq_1h, caller_freq_24h);
CREATE INDEX idx_features_flash_ratio ON processed_data.feature_store(flash_call_ratio_1h, flash_call_ratio_24h);

-- Indexes for ml_models.predictions
CREATE INDEX idx_predictions_cdr_id ON ml_models.predictions(cdr_id);
CREATE INDEX idx_predictions_model_id ON ml_models.predictions(model_id);
CREATE INDEX idx_predictions_fraud_prob ON ml_models.predictions(fraud_probability DESC);
CREATE INDEX idx_predictions_created_at ON ml_models.predictions(created_at);

-- Indexes for model registry
CREATE INDEX idx_model_registry_name_version ON ml_models.model_registry(model_name, model_version);
CREATE INDEX idx_model_registry_active ON ml_models.model_registry(is_active) WHERE is_active = true;

-- Indexes for ETL job tracking
CREATE INDEX idx_job_runs_name ON etl_jobs.job_runs(job_name);
CREATE INDEX idx_job_runs_status ON etl_jobs.job_runs(status);
CREATE INDEX idx_job_runs_start_time ON etl_jobs.job_runs(start_time);

-- Indexes for audit logs
CREATE INDEX idx_audit_logs_service ON audit_logs.system_logs(service_name);
CREATE INDEX idx_audit_logs_level ON audit_logs.system_logs(log_level);
CREATE INDEX idx_audit_logs_timestamp ON audit_logs.system_logs(timestamp);
