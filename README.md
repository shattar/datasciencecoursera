# Summary of...
## Human Activity Recognition Using Smartphones
The run_analysis.R script expects the data files to be located in the working directory when the script is run.
The data files can be obtained at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Each observation of the original data includes a 128 sample time series of IMU data.
Statistics are calculated about the measured time series data, such as mean and std.
A series of other calculated time series variables are also summarized with these statistics.

Averages of these statistics, means and stds, are grouped by activity and subject, where the activity represents what the subject was doing.

If the run_analysis.R script completes successfully, a file called "tidy_data.txt" will be in the working directory.

The following list describes the columns:
- Activity: what activity the subject was doing
- Subject: the unique subject identifier
- Columns names of the form [domain][variable]-[aggregation]-[component]
 - [domain] - 't' for time samples or 'f' for fft
 - [variable] - the name of the measured or calculated variable
 - [aggregation] - the aggregation method used to aggregate over the observation, mean() or std()
 - [component] - the component of the 3d vector, X, Y, or Z
