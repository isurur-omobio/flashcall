-- deployment/docker/infrastructure/postgres/init-scripts/05-functions.sql
\c voice_fw_db;

-- Function to update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger for raw_data.cdr_data
CREATE TRIGGER update_cdr_data_updated_at 
    BEFORE UPDATE ON raw_data.cdr_data 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to calculate feature aggregations
CREATE OR REPLACE FUNCTION calculate_caller_features(
    p_caller_hash VARCHAR(64),
    p_call_time TIMESTAMP
)
RETURNS TABLE(
    freq_1h INTEGER,
    freq_24h INTEGER,
    unique_called_1h INTEGER,
    unique_called_24h INTEGER,
    avg_duration_1h DECIMAL,
    avg_duration_24h DECIMAL,
    flash_ratio_1h DECIMAL,
    flash_ratio_24h DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        -- 1 hour frequencies
        COUNT(*)::INTEGER as freq_1h,
        (SELECT COUNT(*) FROM processed_data.cdr_processed 
         WHERE caller_number_hash = p_caller_hash 
         AND call_start_time BETWEEN p_call_time - INTERVAL '24 hours' AND p_call_time)::INTEGER as freq_24h,
        
        -- Unique called numbers
        COUNT(DISTINCT called_number_hash)::INTEGER as unique_called_1h,
        (SELECT COUNT(DISTINCT called_number_hash) FROM processed_data.cdr_processed 
         WHERE caller_number_hash = p_caller_hash 
         AND call_start_time BETWEEN p_call_time - INTERVAL '24 hours' AND p_call_time)::INTEGER as unique_called_24h,
        
        -- Average durations
        COALESCE(AVG(call_duration), 0)::DECIMAL as avg_duration_1h,
        (SELECT COALESCE(AVG(call_duration), 0) FROM processed_data.cdr_processed 
         WHERE caller_number_hash = p_caller_hash 
         AND call_start_time BETWEEN p_call_time - INTERVAL '24 hours' AND p_call_time)::DECIMAL as avg_duration_24h,
        
        -- Flash call ratios
        COALESCE(AVG(CASE WHEN is_flash_call THEN 1.0 ELSE 0.0 END), 0)::DECIMAL as flash_ratio_1h,
        (SELECT COALESCE(AVG(CASE WHEN is_flash_call THEN 1.0 ELSE 0.0 END), 0) 
         FROM processed_data.cdr_processed 
         WHERE caller_number_hash = p_caller_hash 
         AND call_start_time BETWEEN p_call_time - INTERVAL '24 hours' AND p_call_time)::DECIMAL as flash_ratio_24h
         
    FROM processed_data.cdr_processed
    WHERE caller_number_hash = p_caller_hash 
    AND call_start_time BETWEEN p_call_time - INTERVAL '1 hour' AND p_call_time;
END;
$$ LANGUAGE plpgsql;

-- Grant all permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA raw_data TO admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA processed_data TO admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA ml_models TO admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA etl_jobs TO admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA analytics TO admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA audit_logs TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA raw_data TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA processed_data TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA ml_models TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA etl_jobs TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA analytics TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA audit_logs TO admin;