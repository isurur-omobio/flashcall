-- deployment/docker/infrastructure/postgres/init-scripts/02-schemas.sql
\c voice_fw_db;

-- Create schemas
CREATE SCHEMA IF NOT EXISTS public;
CREATE SCHEMA IF NOT EXISTS raw_data;
CREATE SCHEMA IF NOT EXISTS processed_data;
CREATE SCHEMA IF NOT EXISTS ml_models;
CREATE SCHEMA IF NOT EXISTS etl_jobs;
CREATE SCHEMA IF NOT EXISTS analytics;
CREATE SCHEMA IF NOT EXISTS audit_logs;

-- Grant schema permissions
GRANT ALL ON SCHEMA public TO admin;
GRANT ALL ON SCHEMA raw_data TO admin;
GRANT ALL ON SCHEMA processed_data TO admin;
GRANT ALL ON SCHEMA ml_models TO admin;
GRANT ALL ON SCHEMA etl_jobs TO admin;
GRANT ALL ON SCHEMA analytics TO admin;
GRANT ALL ON SCHEMA audit_logs TO admin;
