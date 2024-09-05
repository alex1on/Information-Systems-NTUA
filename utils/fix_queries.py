import os
import re

def convert_to_trino_sql(query):
    """
    Convert SQL query to Trino SQL dialect by replacing date arithmetic with INTERVAL keyword.
    """
    # Replace date addition using '+' with INTERVAL in Trino's syntax
    pattern = r"cast\('(\d{4}-\d{2}-\d{2})' as date\)\s*\+\s*(\d+)\s*days?"
    
    def replacement(match):
        date_str = match.group(1)
        days = match.group(2)
        return f"CAST('{date_str}' AS DATE) + INTERVAL '{days}' DAY"
    
    # Apply the replacement
    converted_query = re.sub(pattern, replacement, query, flags=re.IGNORECASE)
    
    return converted_query

def process_sql_files(input_dir, output_dir):
    """
    Process all SQL files in the input directory, convert them to Trino SQL dialect,
    and save the converted queries to the output directory.
    """
    # Ensure output directory exists
    os.makedirs(output_dir, exist_ok=True)

    # Iterate over all files in the input directory
    for filename in os.listdir(input_dir):
        if filename.endswith(".sql"):
            input_file_path = os.path.join(input_dir, filename)
            output_file_path = os.path.join(output_dir, filename)

            # Read the content of the input SQL file
            with open(input_file_path, 'r') as input_file:
                original_query = input_file.read()

            # Convert the query to Trino SQL dialect
            converted_query = convert_to_trino_sql(original_query)

            # Write the converted query to the output file
            with open(output_file_path, 'w') as output_file:
                output_file.write(converted_query)

            print(f"Processed {filename} and saved converted query to {output_file_path}")

# Example usage
input_directory = '../../queries/'   # Replace with your input directory path
output_directory = '../../queries_updated/' # Replace with your output directory path

process_sql_files(input_directory, output_directory)
