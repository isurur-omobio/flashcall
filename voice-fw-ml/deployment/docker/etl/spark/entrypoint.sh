#!/bin/bash
set -e

wait_for_service() {
    local host=$1
    local port=$2
    local service_name=$3
    
    echo "Waiting for $service_name to be ready at $host:$port..."
    while ! nc -z "$host" "$port"; do
        echo "Waiting for $service_name..."
        sleep 2
    done
    echo "$service_name is ready!"
}

start_master() {
    echo "Starting Spark Master..."
    export SPARK_MASTER_HOST=${SPARK_MASTER_HOST:-spark-master}
    export SPARK_MASTER_PORT=${SPARK_MASTER_PORT:-7077}
    export SPARK_MASTER_WEBUI_PORT=${SPARK_MASTER_WEBUI_PORT:-8080}
    
    exec "${SPARK_HOME}/bin/spark-class" org.apache.spark.deploy.master.Master \
        --host "${SPARK_MASTER_HOST}" \
        --port "${SPARK_MASTER_PORT}" \
        --webui-port "${SPARK_MASTER_WEBUI_PORT}"
}

start_worker() {
    echo "Starting Spark Worker..."
    
    MASTER_HOST=${SPARK_MASTER_HOST:-spark-master}
    MASTER_PORT=${SPARK_MASTER_PORT:-7077}
    wait_for_service "$MASTER_HOST" "$MASTER_PORT" "Spark Master"
    
    export SPARK_WORKER_CORES=${SPARK_WORKER_CORES:-2}
    export SPARK_WORKER_MEMORY=${SPARK_WORKER_MEMORY:-2g}
    export SPARK_WORKER_WEBUI_PORT=${SPARK_WORKER_WEBUI_PORT:-8081}
    
    MASTER_URL=${SPARK_MASTER_URL:-spark://spark-master:7077}
    
    exec "${SPARK_HOME}/bin/spark-class" org.apache.spark.deploy.worker.Worker \
        "${MASTER_URL}" \
        --cores "${SPARK_WORKER_CORES}" \
        --memory "${SPARK_WORKER_MEMORY}" \
        --webui-port "${SPARK_WORKER_WEBUI_PORT}"
}

case "${SPARK_MODE}" in
    "master")
        start_master
        ;;
    "worker")
        start_worker
        ;;
    *)
        echo "Unknown SPARK_MODE: ${SPARK_MODE}"
        echo "Valid modes: master, worker"
        exit 1
        ;;
esac