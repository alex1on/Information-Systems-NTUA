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
one_worker_data = pd.read_csv('../query_results_merged/dist2_1_worker_bench_14092024.csv').dropna(subset=['run1', 'run2'], how='all')
two_workers_data = pd.read_csv('../query_results_merged/dist2_2_workers_bench_14092024.csv').dropna(subset=['run1', 'run2'], how='all')
three_workers_data = pd.read_csv('../query_results_merged/dist2_3_workers_bench_14092024.csv').dropna(subset=['run1', 'run2'], how='all')

queries = ['query002', 'query004', 'query005', 'query011', 'query033', 'query051', 'query066', 'query072', 'query075', 'query082', 'query083', 'query097']

# Convert time strings to seconds for all relevant columns
for col in ['run1', 'run2']:
    one_worker_data[col] = one_worker_data[col].apply(lambda x: time_to_seconds(x) if x != '00:00:00.000' else 0)
    two_workers_data[col] = two_workers_data[col].apply(lambda x: time_to_seconds(x) if x != '00:00:00.000' else 0)
    three_workers_data[col] = three_workers_data[col].apply(lambda x: time_to_seconds(x) if x != '00:00:00.000' else 0)

# Function to calculate averages for 1st run, 2nd run, and both combined
def calculate_avg(df, queries):
    filtered_df = df[df['query'].isin(queries)]
    
    # Average times
    avg_run1 = filtered_df['run1'].mean()
    avg_run2 = filtered_df['run2'].mean()
    avg_combined = (avg_run1 + avg_run2) / 2
        
    return (avg_run1, avg_run2, avg_combined)

# Calculate average times for all configurations
avg_times_one_worker = calculate_avg(one_worker_data, queries)
avg_times_two_workers = calculate_avg(two_workers_data, queries)
avg_times_three_workers = calculate_avg(three_workers_data, queries)

print(f"One Worker: {avg_times_one_worker}")
print(f"Two Workers: {avg_times_two_workers}")
print(f"Three Workers: {avg_times_three_workers}")

# Combine all averages into a single list for plotting
all_avg_times = [avg_times_one_worker, avg_times_two_workers, avg_times_three_workers]

# Function to plot and save the bar plot with value labels
def plot_combined_bar_with_labels(avg_times, title, filename):
    # Set figure size for better clarity
    fig, ax = plt.subplots(figsize=(10, 7))

    # Labels for x-axis (Number of Workers)
    x_labels = ['1 Worker', '2 Workers', '3 Workers']

    # Set x-axis locations
    num_workers = len(x_labels)
    bar_width = 0.2
    x = range(num_workers)

    # Plot bars with distinct colors for each run (Run 1, Run 2, Combined Avg)
    ax.bar([i - bar_width for i in x], [avg_times[i][0] for i in range(num_workers)], width=bar_width, color='#1f77b4', label='Run 1')  # Run 1 values
    ax.bar([i for i in x], [avg_times[i][1] for i in range(num_workers)], width=bar_width, color='#ff7f0e', label='Run 2')  # Run 2 values
    ax.bar([i + bar_width for i in x], [avg_times[i][2] for i in range(num_workers)], width=bar_width, color='#2ca02c', label='Combined Avg')  # Combined Avg values

    # Set labels and title
    ax.set_ylabel('Time (seconds)', fontsize=14)
    ax.set_title(title, fontsize=16)
    ax.set_xticks([i for i in x])
    ax.set_xticklabels(x_labels, fontsize=12)

    # Display values above bars
    for i in range(num_workers):
        # Display values for Run 1
        ax.text(i - bar_width, avg_times[i][0] + 0.1, f'{avg_times[i][0]:.2f}', ha='center', va='bottom', fontsize=10)
        # Display values for Run 2
        ax.text(i, avg_times[i][1] + 0.1, f'{avg_times[i][1]:.2f}', ha='center', va='bottom', fontsize=10)
        # Display values for Combined Avg
        ax.text(i + bar_width, avg_times[i][2] + 0.1, f'{avg_times[i][2]:.2f}', ha='center', va='bottom', fontsize=10)

    # Add a legend
    ax.legend(loc='upper right', fontsize=12)

    # Save the figure
    plt.tight_layout()
    plt.savefig(f'figures/{filename}', dpi=300)
    plt.close()

# Generate a single plot for all configurations
plot_combined_bar_with_labels(all_avg_times, 'Distributed Queries Over Different Number of Workers', 'dist_queries_over_workers.png')

print("Combined figure saved to the 'figures/' directory.")
