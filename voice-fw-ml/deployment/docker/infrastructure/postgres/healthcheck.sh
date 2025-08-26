#!/bin/sh
set -eu

# Defaults help if POSTGRES_USER isn’t set
USER="${POSTGRES_USER:-postgres}"
PORT="${POSTGRES_PORT:-5432}"

exec pg_isready -h localhost -p "$PORT" -U "$USER" -d postgres
