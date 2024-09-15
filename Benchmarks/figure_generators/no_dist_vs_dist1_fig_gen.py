import pandas as pd
import matplotlib.pyplot as plt

# Function to convert time string to seconds
def time_to_seconds(time_str):
    h, m, s = map(float, time_str.split(':'))
    return h * 3600 + m * 60 + s

# Load the two CSV files
file1 = pd.read_csv('../query_results_merged/no_dist_bench_10092024.csv')
file2 = pd.read_csv('../query_results_merged/dist_3_workers_cooked.csv')

# Queries to include in the comparison
queries = ['query002', 'query004', 'query005', 'query011', 'query033', 'query051', 'query066', 'query072', 'query075', 'query082', 'query083', 'query097']

# Filter file1 and file2 to only include the relevant queries
file1_filtered = file1[file1['query'].isin(queries)].copy()
file2_filtered = file2[file2['query'].isin(queries)].copy()

# Convert time strings to seconds for relevant columns in file1
for col in ['postgresql_run1', 'cassandra_run1', 'redis_run1', 'postgresql_run2', 'cassandra_run2', 'redis_run2']:
    file1_filtered.loc[:, col] = file1_filtered[col].apply(lambda x: time_to_seconds(x) if pd.notna(x) and x != '00:00:00.000' else 0)

# Convert time strings to seconds for relevant columns in file2
for col in ['run1', 'run2']:
    file2_filtered.loc[:, col] = file2_filtered[col].apply(lambda x: time_to_seconds(x) if pd.notna(x) and x != '00:00:00.000' else 0)

# Function to calculate average times for run1, run2, and combined
def calculate_avg(df, run1_col, run2_col):
    avg_run1 = df[run1_col].mean()
    avg_run2 = df[run2_col].mean()
    avg_combined = (avg_run1 + avg_run2) / 2
    return avg_run1, avg_run2, avg_combined

# Calculate average times for PostgreSQL and Cassandra (from file1)
postgres_avg_times = calculate_avg(file1_filtered, 'postgresql_run1', 'postgresql_run2')
cassandra_avg_times = calculate_avg(file1_filtered, 'cassandra_run1', 'cassandra_run2')

# Calculate average times for the Distribution Strategy (from file2)
dist_strategy_avg_times = calculate_avg(file2_filtered, 'run1', 'run2')

# Combine all averages into a single list for plotting
all_avg_times = [
    postgres_avg_times[0], cassandra_avg_times[0], dist_strategy_avg_times[0],  # Run 1
    postgres_avg_times[1], cassandra_avg_times[1], dist_strategy_avg_times[1],  # Run 2
    postgres_avg_times[2], cassandra_avg_times[2], dist_strategy_avg_times[2]   # Combined Avg
]

# Function to plot the comparison
def plot_comparison(avg_times, title, filename):
    fig, ax = plt.subplots(figsize=(10, 7), facecolor='white')

    # Labels for x-axis
    x_labels = ['PostgreSQL', 'Cassandra', 'Fact Table ER Based Strategy']

    # Set x-axis locations
    num_x = len(x_labels)
    bar_width = 0.2
    x = range(num_x)

    # Create offset positions for each run
    x_pos_run1 = [i - bar_width for i in x]
    x_pos_run2 = [i for i in x]
    x_pos_combined = [i + bar_width for i in x]

    # Plot bars
    ax.bar(x_pos_run1, avg_times[:num_x], width=bar_width, color='#1f77b4', label='Run 1')  # Run 1 values
    ax.bar(x_pos_run2, avg_times[num_x:num_x * 2], width=bar_width, color='#ff7f0e', label='Run 2')  # Run 2 values
    ax.bar(x_pos_combined, avg_times[num_x * 2:num_x * 3], width=bar_width, color='#2ca02c', label='Combined Avg')  # Combined Avg values

    # Set labels and title
    ax.set_ylabel('Time (seconds)', fontsize=14)
    ax.set_title(title, fontsize=16)
    ax.set_xticks([i for i in x])
    ax.set_xticklabels(x_labels, fontsize=12)

    # Display values above bars
    for i in range(num_x):
        # Display values for Run 1
        ax.text(x_pos_run1[i], avg_times[i] + 0.1, f'{avg_times[i]:.2f}', ha='center', va='bottom', fontsize=10)
        # Display values for Run 2
        ax.text(x_pos_run2[i], avg_times[i + num_x] + 0.1, f'{avg_times[i + num_x]:.2f}', ha='center', va='bottom', fontsize=10)
        # Display values for Combined Avg
        ax.text(x_pos_combined[i], avg_times[i + num_x * 2] + 0.1, f'{avg_times[i + num_x * 2]:.2f}', ha='center', va='bottom', fontsize=10)

    # Add a legend
    ax.legend(loc='upper right')

    # Save the figure
    plt.tight_layout()
    plt.savefig(f'figures/{filename}', dpi=300)
    plt.close()

# Plot comparison and save as PNG
plot_comparison(all_avg_times, 'PostgreSQL vs Cassandra vs Fact Table ER Based Strategy', 'no_dist_vs_dist1.png')

print("Comparison figure saved as 'no_dist_vs_dist1.png'.")
