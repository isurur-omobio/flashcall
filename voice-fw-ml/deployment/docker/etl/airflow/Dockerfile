# deployment/docker/etl/airflow/Dockerfile
FROM apache/airflow:2.10.0-python3.11

USER root

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

USER airflow

# Install Python dependencies
COPY deployment/docker/etl/airflow/requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

# Copy entrypoint script only (use env vars for config)
COPY deployment/docker/etl/airflow/entrypoint.sh /entrypoint.sh

USER root
RUN chmod +x /entrypoint.sh && \
    (dos2unix /entrypoint.sh 2>/dev/null || sed -i 's/\r$//' /entrypoint.sh)
USER airflow

# Set working directory
WORKDIR /opt/airflow

ENTRYPOINT ["/entrypoint.sh"]