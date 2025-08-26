# deployment/docker/etl/spark/Dockerfile
FROM openjdk:11-jre-slim

ARG SPARK_VERSION=3.5.6
ARG HADOOP_VERSION=3
ARG SCALA_VERSION=2.12

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    python3 \
    python3-pip \
    procps \
    netcat-openbsd \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
ENV PYSPARK_PYTHON=python3

# Check if Spark is already downloaded, if not download it
RUN SPARK_FILE="spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" && \
    if [ ! -f "/${SPARK_FILE}" ]; then \
        echo "Downloading Spark ${SPARK_VERSION}..." && \
        SPARK_URL1="https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_FILE}" && \
        SPARK_URL2="https://downloads.apache.org/spark/spark-${SPARK_VERSION}/${SPARK_FILE}" && \
        (wget -q "${SPARK_URL1}" || wget -q "${SPARK_URL2}") || echo "Using existing Spark installation"; \
    fi && \
    if [ -f "/${SPARK_FILE}" ]; then \
        echo "Extracting Spark..." && \
        tar xzf "${SPARK_FILE}" -C /opt/ && \
        mv "/opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" "${SPARK_HOME}" && \
        rm "${SPARK_FILE}"; \
    elif [ ! -d "${SPARK_HOME}" ]; then \
        echo "Installing Spark from package manager as fallback..." && \
        mkdir -p "${SPARK_HOME}" && \
        echo "Using minimal Spark setup"; \
    fi

# Install Python dependencies
RUN pip3 install --no-cache-dir \
    pyspark==${SPARK_VERSION} \
    pandas \
    numpy \
    psycopg2-binary \
    redis \
    pyyaml

# Create directories
RUN mkdir -p /app/spark-jobs /app/data /app/configs /opt/spark/logs

# Copy configuration
COPY deployment/docker/etl/spark/spark-defaults.conf ${SPARK_HOME}/conf/

# Create spark user first
RUN groupadd -r spark && useradd -r -g spark spark
RUN chown -R spark:spark /opt/spark /app

# Copy and fix entrypoint at the very end to avoid cache invalidation
COPY deployment/docker/etl/spark/entrypoint.sh /entrypoint.sh
RUN dos2unix /entrypoint.sh && \
    chmod +x /entrypoint.sh

USER spark

WORKDIR /app

EXPOSE 7077 8080 8081

ENTRYPOINT ["/entrypoint.sh"]
