-- deployment/docker/infrastructure/postgres/init-scripts/01-databases.sql
-- Create main databases (only if they don't exist)
SELECT 'CREATE DATABASE voice_fw_db OWNER admin'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'voice_fw_db')\gexec

SELECT 'CREATE DATABASE voice_fw_test OWNER admin'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'voice_fw_test')\gexec

SELECT 'CREATE DATABASE voice_fw_analytics OWNER admin'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'voice_fw_analytics')\gexec

-- Switch to main database
\c voice_fw_db;

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS btree_gin;
