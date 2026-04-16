#!/bin/bash
set -e

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
  echo "Creating multiple databases: $POSTGRES_MULTIPLE_DATABASES"
  IFS=',' read -ra DB_LIST <<< "$POSTGRES_MULTIPLE_DATABASES"
  for DB in "${DB_LIST[@]}"; do
    DB_TRIMMED=$(echo "$DB" | xargs)
    if [ -n "$DB_TRIMMED" ]; then
      psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
        CREATE DATABASE "$DB_TRIMMED";
EOSQL
    fi
  done
  echo "Multiple databases created"
fi
