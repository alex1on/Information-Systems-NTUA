import sqlparse, json
from sqlparse.sql import Where, TokenList, Parenthesis, IdentifierList, Identifier
from sqlparse.tokens import Keyword, DML, Name, Punctuation, Whitespace, Newline

def read_config(partition):
    with open('./distribution_structures.json', 'r') as file:
        config = json.load(file)

        lookup_table = {
            "all_tables": config['all_tables'],
            "partition": config['partitions'][partition-1] # should be equal to id, too bored to fix
        }

        return lookup_table

def read_query(file_path):
    with open(file_path, 'r') as file:
        sql_query = file.read()
    return sql_query

def break_from_case(token):
    return token.ttype in (Name, Whitespace, Punctuation, Newline)

def find_table_definitions_and_positions(sql_query):
    parsed = sqlparse.parse(sql_query)[0]

    from_tables = False
    next_table = True
    tables = []
    positions = []

    current_pos = 0
    for token in parsed.flatten():
        # Increment current position based on token length
        current_pos += len(token.value)

        if token.ttype in Keyword and token.value.upper() == 'FROM':
            from_tables = True
            next_table = True
            subq_tables = []
            subq_positions = []
        elif from_tables:
            if break_from_case(token):
                if token.ttype in Name and next_table:
                    next_table = False
                    subq_tables.append(token.value)
                    # Record the position, adjusting for token length
                    subq_positions.append((current_pos - len(token.value), current_pos))
                if token.ttype in Punctuation:
                    next_table = True
            else:
                if subq_tables:
                    tables.append(subq_tables)
                    positions.append(subq_positions)
                from_tables = False

    return tables, positions

def modify_query_with_tables(sql_query, tables, positions, lookup_table):
    # Reversed is needed as altering from start to finish will change the offsets. To avoid having to again change the offsets we 
    # just iterate from the finish to start of the query so the last offsets are handled first.
    for subq_tables, subq_positions in reversed(list(zip(tables, positions))):
        subq_tables_db_locations = []
        for table, (start, end) in zip(subq_tables, subq_positions):
            table_db_locations = []
            if table in lookup_table['all_tables']:
                if table in lookup_table['partition']['pg_tables']:
                    table_db_locations.append('postgresql')
                if table in lookup_table['partition']['cass_tables']:
                    table_db_locations.append('cassandra')
                if table in lookup_table['partition']['redis_tables']:
                    table_db_locations.append('redis')            
            subq_tables_db_locations.append(table_db_locations)

        print(subq_tables_db_locations)
        sql_query = modify_subquery_tables(sql_query, subq_tables_db_locations, subq_tables, subq_positions)
    return sql_query

def modify_subquery_tables(sql_query, subq_tables_loc, subq_tables, subq_positions):
    offset = 0
    db_priority = ['postgresql', 'cassandra', 'redis']
    
    # Helper function to pre-scan subquery locations for priority database
    def determine_priority_database(subq_tables_locs):
        db_counts = {}
        for locs in subq_tables_locs:
            if len(locs) == 1:  # Single-database table
                db = locs[0]
                db_counts[db] = db_counts.get(db, 0) + 1
        # Sort available databases by their priority and count, preferring higher counts and higher priority
        sorted_dbs = sorted(db_counts, key=lambda x: (db_priority.index(x), -db_counts[x]), reverse=True)
        #print(sorted_dbs)
        return sorted_dbs[0] if sorted_dbs else None

    # Helper function to choose the database for each table
    def choose_database(table_locs, priority_db):
        if priority_db in table_locs:
            return priority_db  # Use the priority database if applicable
        elif len(table_locs) == 1:
            return table_locs[0]  # Single-database table
        else:
            # Use round-robin selection based on the predefined order
            for db in db_priority:
                if db in table_locs:
                    return db
            return None  # Case where a table is not one of the default tables

    # Determine priority DB for this subquery. 
    # This db will always be preferred in the subquery if a table is located there (this applies to dublicate tables - tables
    # located in multiple databases)
    priority_db = determine_priority_database(subq_tables_loc)  
    
    for table, locs, (start, end) in zip(subq_tables, subq_tables_loc, subq_positions):
        chosen_db = choose_database(locs, priority_db)  # Choose DB considering the priority
        # Only valid tables are modified
        if chosen_db:
            print(chosen_db, table)
            modified_table = f"{chosen_db}.tpcds.{table}"
            adjusted_start = start + offset
            adjusted_end = end + offset
            sql_query = sql_query[:adjusted_start] + modified_table + sql_query[adjusted_end:]
            offset += len(modified_table) - (end - start)

    return sql_query




lookup_table = read_config(1)
sql_query = read_query("../../queries/query025.sql")
#print(json.dumps(lookup_table, indent=2))
# tables = find_table_definitions(sql_query)
tables, positions = find_table_definitions_and_positions(sql_query)
modified_sql = modify_query_with_tables(sql_query, tables, positions, lookup_table)
print(modified_sql)
#print(tables)