#!/bin/bash

# Determine the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Read PostgreSQL parameters from .env file
source "$SCRIPT_DIR/../../.env"

# Set the PGPASSWORD for non-interactive authentication
export PGPASSWORD="$POSTGRESQL_PASSWORD"

# Drop all tables in the schema and then drop the schema
psql -h "$POSTGRESQL_HOST" -U "$POSTGRESQL_USER" -d "$POSTGRESQL_DATABASE" <<EOF
BEGIN;

-- Drop all tables in the schema
DO \$\$
DECLARE
    row RECORD;
BEGIN
    FOR row IN SELECT tablename FROM pg_tables WHERE schemaname = '$POSTGRESQL_SCHEMA'
    LOOP
        EXECUTE 'DROP TABLE IF EXISTS "' || '$POSTGRESQL_SCHEMA' || '"."' || row.tablename || '" CASCADE';
    END LOOP;
END
\$\$;

-- Drop the schema
DROP SCHEMA IF EXISTS "$POSTGRESQL_SCHEMA" CASCADE;

COMMIT;
EOF

# Check if the psql command was successful
if [ $? -eq 0 ]; then
  echo "Schema $POSTGRESQL_SCHEMA was dropped successfully."
else
  echo "Error dropping schema $POSTGRESQL_SCHEMA."
fi

# Unset PGPASSWORD to clear it from the environment
unset PGPASSWORD
