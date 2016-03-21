# coursera-datascience-gcd-project

This is the final project for Coursera's Getting and Cleaning Data course.

Included is the original data source, the solution.txt file created by running the R script, and the R script, run_analysis.R (even though we're not running any analysis, we're just tidying data so it's ready for analysis; but that's neither here nor there).

run_analysis.R fetches data from data files in the UCI_HAR_Dataset subdirectory (so make sure this subdirectory is in the same directory as run_analysis.R when you run it). It then combines the test data and training data sets, where it filters out all non-mean and non-standard-deviation data. Finally, it creates a new data set from this tidied data set by calculating the mean of every column, grouped by subject and activity type. It is this new data set that is written to a new file, solution.txt, in the final line of run_analysis.R.
