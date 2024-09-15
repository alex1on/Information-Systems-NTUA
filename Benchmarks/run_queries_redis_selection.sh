#!/bin/bash

# Description:
# This script executes only the queries that consist of tables that performed faster on our benchmarks queries # (some simple queries) when located on the redis server. 
# We are expandind our tests to measure the perfomance impact of some more complex queries when some tables are
# on the Redis node.
# The tables that performed better when located on the Redis node are the following:
#   "ship_mode"                   # 4 kb
#   "warehouse"                   # 4 kb
#   "web_site"                    # 12 kb
#   "web_page"                    # 16 kb
#   "income_band"                 # 4 kb
#   "call_center"                 # 8 kb
#   "reason"                      # 4 kb
#   "promotion"                   # 56 kb
#   "store"                       # 24 kb
#   "dbgen_version"               # 4 kb
# 
# We are going to run only the queries that actively use one or more of the above tables. The queries from the
# TPC-DS benchmarking tool that use those tables are the following:
#   ship_mode       —> 62, 99
#   warehouse       —> 39, 40, 62
#   web_site        —> 62
#   web_page        —> 90
#   income_band     —> 84
#   call_center     —> 57, 91, 99
#   reason          —> 9, 85, 93, 
#   promotion       —> 7, 26, 27, 61, 64
#   store           —> 1, 5, 8, 13, 17, 19, 24, 25, 29, 34, 36, 43, 46, 47, 48, 50, 53,, 54, 59, 61, 63, 64, #                      68,73, 79, 88, 89, 96 
#   dbgen_version   -> -
#
# In the total the queries run in this script are the following:
#   Queries: 1, 5, 7, 8, 9, 13, 17, 19, 24, 25, 26, 27, 29, 34, 36, 39, 40, 43, 46, 47, 48, 50, 53, 54, 57, 59, #            61, 62, 63, 64, 68, 73, 79, 84, 85, 88, 89, 90, 91, 93, 96, 99
#
# The output times are to be compared with the previous query run to determine if any gain is seen by migrating # the above (or some) tables to the Redis node.
#

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ../.env

# List of databases
DATABASES=("postgresql" "cassandra")

TEST_TABLES=(
  "ship_mode"                   # 4 kb
  "warehouse"                   # 4 kb
  "web_site"                    # 12 kb
  "web_page"                    # 16 kb
  "income_band"                 # 4 kb
  "call_center"                 # 8 kb
  "reason"                      # 4 kb
  "promotion"                   # 56 kb
  "store"                       # 24 kb
  "dbgen_version"               # 4 kb  
)

# Directory containing SQL queries
QUERY_DIR="../../queries"

REDIS_DIR="../Databases/Redis"

# Queries 5, 40 & 17 are not running
 
Queries=(1 7 8 9 13 19 24 25 26 27 29 34 36 39 43 46 47 48 50 53 54 57 59 61 62 63 64 68 73 79 84 85 88 89 90 91 93 96 99)

# Define Trino command with host and port
TRINO_COMMAND="./../../trino $TRINO_HOST:$TRINO_PORT"

# Create or clear the results directory
RESULTS_DIR="query_results"
#mkdir -p "$RESULTS_DIR"

datetime=$(date +"%Y%m%d_%H%M")

# Create CSV file for results
CSV_FILE="$RESULTS_DIR/tpcds_queries_redis_cache_$datetime.csv"
echo "query,postgresql_run1,cassandra_run1,postgresql_run2,cassandra_run2" > "$CSV_FILE"


format_duration() {
  local seconds=$(($1 / 1000))
  local minutes=$((seconds / 60))
  local hours=$((minutes / 60))
  local remaining_milliseconds=$(($1 % 1000))
  local remaining_seconds=$((seconds % 60))
  local remaining_minutes=$((minutes % 60))

  # Following format: HH:mm:ss.xxx
  printf "%02d:%02d:%02d.%03d" "$hours" "$remaining_minutes" "$remaining_seconds" "$remaining_milliseconds"
}

# Flush redis
python3 $REDIS_DIR/utils/flush_redis.py

for table in "${TEST_TABLES[@]}"; do
    ./${REDIS_DIR}/load_data_redis.sh ${table} --cleanup=false --batch_processing=true
done

for query in "${Queries[@]}"; do
    formatted_query=$(printf "%03d" "$query")

    query_file=$QUERY_DIR/query$formatted_query.sql
    tmp_query_file=$QUERY_DIR/query${formatted_query}_tmp.sql

    # Make a copy of the original SQL file
    cp $query_file $tmp_query_file

    # Loop through each table and replace in the copied SQL file
    for table in "${TEST_TABLES[@]}"; do
        sed -i "s/\b${table}\b/redis.tpcds.${table}/g" $tmp_query_file
    done

    # Extract the SQL query from the file
    QUERY=$(cat "$tmp_query_file")

    # Initialize variables for storing durations
    postgresql_run1_duration=""
    cassandra_run1_duration=""
    postgresql_run2_duration=""
    cassandra_run2_duration=""

    for db in "${DATABASES[@]}"; do

        # Execute the query 2 times for each database
        for i in {1..2}; do

            # Define the full query with schema
            FULL_QUERY="USE $db.tpcds; $QUERY"

            echo "Running $query_file for $db with Redis cache (Run $i)..."
        
            # Execute the query in Trino
            $TRINO_COMMAND --execute "$FULL_QUERY" > /dev/null

            # Calculate the duration in seconds
            duration_query="SELECT date_diff('millisecond', created, \"end\") AS duration FROM system.runtime.queries ORDER BY created DESC OFFSET 1 LIMIT 1;"
            duration=$($TRINO_COMMAND --execute "$duration_query")

            # Extract and format the duration
            duration_striped="${duration:1:-1}"

            formatted_duration=$(format_duration "$duration_striped")

            # Store the duration in the appropriate variable based on the run
            case "$i" in
                1)
                    if [ "$db" == "postgresql" ]; then
                        postgresql_run1_duration="$formatted_duration"
                    elif [ "$db" == "cassandra" ]; then
                        cassandra_run1_duration="$formatted_duration"
                    fi
                    ;;
                2)
                    if [ "$db" == "postgresql" ]; then
                        postgresql_run2_duration="$formatted_duration"
                    elif [ "$db" == "cassandra" ]; then
                        cassandra_run2_duration="$formatted_duration"
                    fi
                    ;;
            esac
        done
    done

    # Save query and durations to results CSV file
    echo "$(basename "$query_file" .sql),$postgresql_run1_duration,$cassandra_run1_duration,$postgresql_run2_duration,$cassandra_run2_duration" >> "$CSV_FILE"

    rm $tmp_query_file
done 