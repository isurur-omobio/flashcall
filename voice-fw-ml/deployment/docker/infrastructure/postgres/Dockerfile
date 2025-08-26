FROM postgres:15.4-alpine

# Install additional packages
RUN apk add --no-cache \
    curl \
    postgresql-contrib \
    netcat-openbsd

# Copy initialization scripts with proper permissions
COPY --chown=postgres:postgres deployment/docker/infrastructure/postgres/init-scripts/ /docker-entrypoint-initdb.d/

# Copy configuration files with proper permissions
COPY --chown=postgres:postgres deployment/docker/infrastructure/postgres/postgresql.conf /etc/postgresql/postgresql.conf
COPY --chown=postgres:postgres deployment/docker/infrastructure/postgres/pg_hba.conf /etc/postgresql/pg_hba.conf

# Create directories for logs
RUN mkdir -p /var/log/postgresql && \
    chown -R postgres:postgres /var/log/postgresql

# Ensure all scripts are executable
RUN chmod +x /docker-entrypoint-initdb.d/*.sql || true
RUN chmod +x /docker-entrypoint-initdb.d/*.sh || true
# In your Dockerfile for postgres image
COPY deployment/docker/infrastructure/postgres/healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/healthcheck.sh


EXPOSE 5432

# Use standard PostgreSQL entrypoint