#### We will test the retrival speed (SELECT statements on the tables). 
#### Each table will follow the same process.
# 1. Load the data to Redis
# 2. Perform the following queries. SELECT *, SELECT count(*), SELECT a random record of that table.
# 3. We will test only the tables that are less than 512MB (as we tested the store_returns table and was considerably slower on Redis than PostgreSQL and Cassandra). 
# 4. Test if loading more data on the Redis Server impacts negatively the performance. (We will add a dummy table of half a GB to see if there is a change in performance).
#    We will test only the tables that we chose from the start (i.e less than 512MB).

## TODO: Maybe add a join query ? 
## TODO: Automate the random record - Maybe add a 10 step check and consider the average time of retrieval ? 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ../.env

# Create or clear the results directory
RESULTS_DIR="query_results"

datetime=$(date +"%Y%m%d_%H%M")

CSV_FILE="$RESULTS_DIR/query_execution_results_$datetime.csv"
echo "query,postgresql_run1,cassandra_run1,redis_run1,postgresql_run2,cassandra_run2,redis_run2" > "$CSV_FILE"

# Define Trino command with host and port
TRINO_COMMAND="./../../trino $TRINO_HOST:$TRINO_PORT"

# List of databases
DATABASES=("postgresql" "cassandra" "redis")

TEST_TABLES=(
  "dbgen_version"               # 4 kb
  "date_dim"                    # 9.8 mb
  "ship_mode"                   # 4 kb
  "warehouse"                   # 4 kb
  "web_site"                    # 12 kb
  "web_page"                    # 16 kb
  "income_band"                 # 4 kb
  "call_center"                 # 8 kb
  "reason"                      # 4 kb
  "item"                        # 23 mb
  "promotion"                   # 56 kb 
  "customer_address"            # 22 mb
  "customer_demographics"       # 76 mb
  "household_demographics"      # 144 kb
  "store"                       # 24 kb
  "time_dim"                    # 4.8 kb
  #"inventory"                  # 1,6 gb
  "catalog_page"                # 1.6 mb
  "customer"                    # 52 mb
  #"web_sales"                  # 1.2 gb
  "web_returns"                 # 78 mb
  #"store_sales"                # 3 gb
  "store_returns"               # 256 mb
  #"catalog_sales"              # 2.3 gb
  "catalog_returns"             # 168 mb    
)

BASE_QUERIES=(
    "SELECT * FROM"
    "SELECT count(*) FROM"
    "SELECT * FROM"
)

for table in "${TEST_TABLES[@]}"; do
  #for query in "${QUERIES[@]}"; do
  pk=$(python3 redis_performance.py $table | tee /dev/tty | sed -n '2p')
  # echo $pk

  for ((i=0; i<${#BASE_QUERIES[@]}; i++)); do
    # Initialize variables for storing durations
    postgresql_run1_duration=""
    cassandra_run1_duration=""
    redis_run1_duration=""
    postgresql_run2_duration=""
    cassandra_run2_duration=""
    redis_run2_duration=""

    BASE_QUERY="${BASE_QUERIES[$i]}"
    # Call the python script only for the "SELECT * FROM ... WHERE ... " query

    QUERY="$BASE_QUERY $table"

    if [ $i -eq 2 ]; then
        QUERY="$BASE_QUERY $table WHERE $pk"
        # array=$(echo "$pk" | tail -n1 | tr -d '[], ')
        # echo "Array from Python script: $array"
    fi

    RESULTS_FILE=$RESULTS_DIR/${table}_query_v${i}.txt
    #echo $QUERY
    echo "" > $RESULTS_FILE
    echo "Table: $table" >> $RESULTS_FILE
    echo "Query: $QUERY" >> $RESULTS_FILE
    echo "" >> $RESULTS_FILE

    FULL_QUERY=""
    
    for run in {1..2}; do 
      echo "### RUN $run ###"
      echo "### RUN $run ###" >> $RESULTS_FILE
      for db in "${DATABASES[@]}"; do
        FULL_QUERY="USE $db.tpcds; $QUERY"
        echo "Running '$FULL_QUERY' for $db..."

        # Execute the query in trino
        $TRINO_COMMAND --execute "$FULL_QUERY" > /dev/null

        # Calculate the duration in seconds
        duration_query="SELECT date_diff('millisecond', created, \"end\") AS duration FROM system.runtime.queries ORDER BY created DESC OFFSET 1 LIMIT 1;"
        duration=$($TRINO_COMMAND --execute "$duration_query")

        # Extract and format the duration
        duration_striped="${duration:1:-1}"
        seconds=$((duration_striped / 1000))
        minutes=$((seconds / 60))
        hours=$((minutes / 60))
        remaining_milliseconds=$((duration_striped % 1000))
        remaining_seconds=$((seconds % 60))
        remaining_minutes=$((minutes % 60))

        # Save to output file with the following format: HH:mm:ss.xxx
        formatted_duration=$(printf "%02d:%02d:%02d.%03d" "$hours" "$remaining_minutes" "$remaining_seconds" "$remaining_milliseconds")

        echo "Database: $db" >> $RESULTS_FILE
        echo "Duration: $formatted_duration" >> $RESULTS_FILE
        echo "----------------------------" >> $RESULTS_FILE

        # Store the duration in the appropriate variable based on the run
        case "$run" in
            1)
                if [ "$db" == "postgresql" ]; then
                    postgresql_run1_duration="$formatted_duration"
                elif [ "$db" == "cassandra" ]; then
                    cassandra_run1_duration="$formatted_duration"
                elif [ "$db" == "redis" ]; then
                    redis_run1_duration="$formatted_duration"
                fi
                ;;
            2)
                if [ "$db" == "postgresql" ]; then
                    postgresql_run2_duration="$formatted_duration"
                elif [ "$db" == "cassandra" ]; then
                    cassandra_run2_duration="$formatted_duration"
                elif [ "$db" == "redis" ]; then
                    redis_run2_duration="$formatted_duration"                
                fi
                ;;
        esac
      done
    done
    # Save query and durations to results CSV file
    echo "${table}_v$i,$postgresql_run1_duration,$cassandra_run1_duration,$redis_run1_duration,$postgresql_run2_duration,$cassandra_run2_duration,$redis_run2_duration" >> "$CSV_FILE"
  done
 
  python3 ../Redis/utils/flush_redis.py
done

