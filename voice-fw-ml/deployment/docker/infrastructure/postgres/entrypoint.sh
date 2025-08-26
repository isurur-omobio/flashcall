#!/bin/bash
set -e

# Function to wait for postgres to be ready
wait_for_postgres() {
    until pg_isready -h localhost -p 5432 -U "$POSTGRES_USER"; do
        echo "Waiting for PostgreSQL to be ready..."
        sleep 2
    done
}

# Initialize database if needed
if [ ! -d "$PGDATA" ] || [ -z "$(ls -A "$PGDATA" 2>/dev/null)" ]; then
    echo "Initializing PostgreSQL database..."
    
    # Initialize database with custom settings
    initdb \
        --username="$POSTGRES_USER" \
        --pwfile=<(echo "$POSTGRES_PASSWORD") \
        --encoding=UTF8 \
        --locale=C \
        --data-checksums
    
    echo "Database initialized successfully"
fi

# Start PostgreSQL in background for setup
postgres \
    -c config_file=/etc/postgresql/postgresql.conf \
    -c hba_file=/etc/postgresql/pg_hba.conf &

PG_PID=$!

# Wait for PostgreSQL to start
wait_for_postgres

# Run initialization scripts
if [ -d /docker-entrypoint-initdb.d ]; then
    echo "Running initialization scripts..."
    for f in /docker-entrypoint-initdb.d/*; do
        case "$f" in
            *.sh)
                echo "Running $f"
                bash "$f"
                ;;
            *.sql)
                echo "Running $f"
                psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f "$f"
                ;;
            *.sql.gz)
                echo "Running $f"
                gunzip -c "$f" | psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"
                ;;
            *)
                echo "Ignoring $f"
                ;;
        esac
    done
fi

# Stop background PostgreSQL
kill $PG_PID
wait $PG_PID

echo "PostgreSQL setup completed"

# Start PostgreSQL in foreground
exec postgres \
    -c config_file=/etc/postgresql/postgresql.conf \
    -c hba_file=/etc/postgresql/pg_hba.conf