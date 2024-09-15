import os
import re

def convert_to_trino_sql(query):
    """
    Convert SQL query to Trino SQL dialect by replacing date arithmetic with INTERVAL keyword
    and casting date literals to DATE.
    """
    # Enhanced regex pattern to match both addition and subtraction with different date formats
    pattern_arithmetic = r"cast\s*\(\s*'(\d{4}-\d{1,2}-\d{1,2})'\s*as\s*date\s*\)\s*([\+\-])\s*(\d+)\s*days?"
    
    # Regex pattern to match date literals that need casting to DATE,
    # avoiding dates already inside a CAST expression
    pattern_literal = r"(?<!cast\()'(\d{4}-\d{1,2}-\d{1,2})'(?!\s*as\s*date)"

    # Regex pattern to replace 'c_last_review_date_sk' with 'c_last_review_date'
    pattern_replace_column = r"\bc_last_review_date_sk\b"

    # Specific regex pattern to handle date arithmetic without casting to convert to INTERVAL
    pattern_date_arithmetic = r"(\bd_date\b)\s*\+\s*(\d+)\b"

    # Replacement for date arithmetic to use INTERVAL in Trino's syntax
    def replacement_arithmetic(match):
        date_str = match.group(1)
        days = match.group(3)
        return f"CAST('{date_str}' AS DATE) + INTERVAL '{days}' DAY"

    # Replacement for date literals to cast them to DATE
    def replacement_literal(match):
        date_str = match.group(1)
        return f"CAST('{date_str}' AS DATE)"
    
    # Replacement for specific date arithmetic to use INTERVAL
    def replacement_date_arithmetic(match):
        date_column = match.group(1)
        days = match.group(2)
        return f"{date_column} + INTERVAL '{days}' DAY"
    
    # Apply the replacements
    converted_query = re.sub(pattern_arithmetic, replacement_arithmetic, query, flags=re.IGNORECASE)
    converted_query = re.sub(pattern_literal, replacement_literal, converted_query, flags=re.IGNORECASE)
    converted_query = re.sub(pattern_replace_column, 'c_last_review_date', converted_query, flags=re.IGNORECASE)
    converted_query = re.sub(pattern_date_arithmetic, replacement_date_arithmetic, converted_query, flags=re.IGNORECASE)
    
    
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
output_directory = '../../queries/' # Replace with your output directory path

process_sql_files(input_directory, output_directory)
