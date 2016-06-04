# Getting-and-Cleaning-Data---Course-Project

The code in the run_analysis.R script is intended to do the following:

1)      Read in datasets Train and Test from the UCI HAR database along with the features and activity lists
2)      Merge the features, subject and activity ID data from both the train and test datasets individually and then combine into one complete dataset
3)      Identify the desired features / columns by Creating a logical vector of features containing ID, mean and standard deviation and subset the data on these columns
4)      Add in descriptive activity names by merging the dataset with the activity list based on activity ID
5)      create a condensed dataset that contains the means of the data grouped by subject ID and activity ID
6)      Export the condensed dataset
