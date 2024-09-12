import pandas as pd
import matplotlib.pyplot as plt
import os

# Function to convert time string to seconds
def time_to_seconds(time_str):
    h, m, s = map(float, time_str.split(':'))
    return h * 3600 + m * 60 + s

# Ensure the 'figures' directory exists
os.makedirs('figures', exist_ok=True)

# Load CSV data
data = pd.read_csv('../query_results_merged/queries_first_bench_10092024.csv')

# Queries for each group
group1_queries = ['query002', 'query004', 'query005', 'query011', 'query014', 'query023', 'query033', 'query051', 'query066', 'query072', 'query075', 'query082', 'query083', 'query097']
group2_queries = ['query006', 'query013', 'query018', 'query027', 'query030', 'query039', 'query040', 'query050', 'query084', 'query085', 'query088', 'query090', 'query091', 'query099']
group3_queries = ['query030', 'query062', 'query090']

# Convert time strings to seconds for all relevant columns
for col in ['postgresql_run1', 'cassandra_run1', 'redis_run1', 'postgresql_run2', 'cassandra_run2', 'redis_run2']:
    data[col] = data[col].apply(lambda x: time_to_seconds(x) if x != '00:00:00.000' else 0)

# Function to calculate averages for 1st run, 2nd run, and both combined
def calculate_avg(df, queries, include_redis=False):
    filtered_df = df[df['query'].isin(queries)]
    
    # Average for PostgreSQL
    postgres_avg_run1 = filtered_df['postgresql_run1'].mean()
    postgres_avg_run2 = filtered_df['postgresql_run2'].mean()
    postgres_avg_combined = (postgres_avg_run1 + postgres_avg_run2) / 2
        
    # Average for Cassandra
    cassandra_avg_run1 = filtered_df['cassandra_run1'].mean()
    cassandra_avg_run2 = filtered_df['cassandra_run2'].mean()
    cassandra_avg_combined = (cassandra_avg_run1 + cassandra_avg_run2) / 2
    
    if include_redis:
        # Average for Redis
        redis_avg_run1 = filtered_df['redis_run1'].mean()
        redis_avg_run2 = filtered_df['redis_run2'].mean()
        redis_avg_combined = (redis_avg_run1 + redis_avg_run2) / 2
            
        return (postgres_avg_run1, cassandra_avg_run1, redis_avg_run1,
                postgres_avg_run2, cassandra_avg_run2, redis_avg_run2,
                postgres_avg_combined, cassandra_avg_combined, redis_avg_combined)
    
    return (postgres_avg_run1, cassandra_avg_run1, postgres_avg_run2,
            cassandra_avg_run2, postgres_avg_combined, cassandra_avg_combined)
    

# Function to plot and save the bar plot with value labels
def plot_bar_with_labels(avg_times, labels, title, filename, include_redis=False):
    # Set colors for bars
    colors = ['cyan', 'magenta', 'green']
    
    # Create a wider figure to avoid overlap when Redis is included
    fig, ax = plt.subplots(figsize=(10, 6)) if include_redis else plt.subplots(figsize=(8, 6))
    
    # Labels for x-axis (PostgreSQL, Cassandra, Redis if included)
    x_labels = ['PostgreSQL', 'Cassandra']
    if include_redis:
        x_labels.append('Redis')
    
    # Set x-axis locations
    num_dbs = len(x_labels)
    bar_width = 0.2
    x = range(num_dbs)
    
    # Create offset positions for each run
    x_pos_run1 = [i - bar_width for i in x]
    x_pos_run2 = [i for i in x]
    x_pos_combined = [i + bar_width for i in x]

    # Plot bars
    ax.bar(x_pos_run1, avg_times[:num_dbs], width=bar_width, color=colors[0], label='Run 1')  # Run 1 values
    ax.bar(x_pos_run2, avg_times[num_dbs:num_dbs * 2], width=bar_width, color=colors[1], label='Run 2')  # Run 2 values
    ax.bar(x_pos_combined, avg_times[num_dbs * 2:num_dbs * 3], width=bar_width, color=colors[2], label='Combined Avg')  # Combined Avg values

    # Set labels and title
    ax.set_ylabel('Time (seconds)')
    ax.set_title(title)
    ax.set_xticks([i for i in x])
    ax.set_xticklabels(x_labels)

    # Reduce the font size for the values to avoid overlap
    font_size = 10 if include_redis else 12
    
    # Display values above bars (adjust positions)
    for i in range(num_dbs):
        # Display values for Run 1
        ax.text(x_pos_run1[i], avg_times[i] + 0.1, f'{avg_times[i]:.2f}', ha='center', va='bottom', fontsize=font_size)
        # Display values for Run 2
        ax.text(x_pos_run2[i], avg_times[i + num_dbs] + 0.1, f'{avg_times[i + num_dbs]:.2f}', ha='center', va='bottom', fontsize=font_size)
        # Display values for Combined Avg
        ax.text(x_pos_combined[i], avg_times[i + num_dbs * 2] + 0.1, f'{avg_times[i + num_dbs * 2]:.2f}', ha='center', va='bottom', fontsize=font_size)

    # Add a legend
    ax.legend()

    # Save the figure
    plt.tight_layout()
    plt.savefig(f'figures/{filename}')
    plt.close()


# Generate plot for Group 1 (PostgreSQL vs Cassandra)
avg_times_group1 = calculate_avg(data, group1_queries)
plot_bar_with_labels(avg_times_group1, ['PostgreSQL', 'Cassandra'], 'Group 1 Queries', 'group1.png')

# Generate plot for Group 2 (PostgreSQL vs Cassandra)
avg_times_group2 = calculate_avg(data, group2_queries)
plot_bar_with_labels(avg_times_group2, ['PostgreSQL', 'Cassandra'], 'Group 2 Queries', 'group2.png')

# Generate plot for Group 3 (PostgreSQL vs Cassandra vs Redis)
avg_times_group3 = calculate_avg(data, group3_queries, include_redis=True)
plot_bar_with_labels(avg_times_group3, ['PostgreSQL', 'Cassandra', 'Redis'], 'Group 3 Queries', 'group3.png', include_redis=True)

print("Figures saved to the 'figures/' directory.")
