#!/bin/bash
set -e

wait_for_db() {
    local host=$1
    local port=$2
    echo "Waiting for database at $host:$port..."
    while ! nc -z "$host" "$port"; do
        echo "Waiting for database..."
        sleep 2
    done
    echo "Database is ready!"
}

wait_for_redis() {
    local host=$1
    local port=$2
    echo "Waiting for Redis at $host:$port..."
    while ! nc -z "$host" "$port"; do
        echo "Waiting for Redis..."
        sleep 2
    done
    echo "Redis is ready!"
}

if [[ "${1}" == "airflow" && "${2}" == "db" && "${3}" == "upgrade" ]] || [[ "${_AIRFLOW_DB_UPGRADE}" == "true" ]]; then
    echo "Initializing Airflow database..."
    wait_for_db "airflow-postgres" "5432"
    
    airflow db init
    airflow db upgrade
    
    if [[ "${_AIRFLOW_WWW_USER_CREATE}" == "true" ]]; then
        echo "Creating Airflow admin user..."
        airflow users create \
            --username "${_AIRFLOW_WWW_USER_USERNAME:-admin}" \
            --firstname "Admin" \
            --lastname "User" \
            --role "Admin" \
            --email "admin@example.com" \
            --password "${_AIRFLOW_WWW_USER_PASSWORD:-admin}"
    fi
fi

case "$1" in
    webserver)
        echo "Starting Airflow Webserver..."
        wait_for_db "airflow-postgres" "5432"
        exec airflow webserver
        ;;
    scheduler)
        echo "Starting Airflow Scheduler..."
        wait_for_db "airflow-postgres" "5432"
        wait_for_redis "redis" "6379"
        exec airflow scheduler
        ;;
    worker)
        echo "Starting Airflow Worker..."
        wait_for_db "airflow-postgres" "5432"
        wait_for_redis "redis" "6379"
        exec airflow celery worker
        ;;
    *)
        exec "$@"
        ;;
esac