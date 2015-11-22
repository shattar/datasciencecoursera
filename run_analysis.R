# dplyr required
library(dplyr)

# Get the data if it is not already here.
# This project assumes that the data is already in the working directory
#dataZip <- "./Dataset.zip"
#dataZipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#if (!file.exists(dataZip)) {
#    download.file(dataZipUrl, destfile = dataZip, mode = "wb")
#    unzip(dataZip, overwrite = TRUE, junkpaths = TRUE, exdir = ".")
#}

# Read the features file to determine the feature column names
features <- read.table("./features.txt",
                       col.names = c("FeatureColumn", "FeatureName"),
                       stringsAsFactors = FALSE)

# Make sure that the features are ordered by the column index
features <- features[features$FeatureColumn, ]

# Create a new column that tells whether or not the feature is of interest
# A feature is of interest if it is a mean() or std()
features$IsMeanOrStd <- 
    grepl("mean\\(\\)", features$FeatureName) | 
    grepl("std\\(\\)", features$FeatureName)

# Create a new column that represents the class to use for reading in the file
# A "NULL" class means that the feature will not be read
features$FeatureClass <- rep("NULL", length(features$FeatureName))
features[features$IsMeanOrStd, "FeatureClass"] <- NA

# Read the activity labels
activity_labels <- read.table("./activity_labels.txt",
                              col.names = c("Levels", "Labels"))


# Read the test data feature file, but only the columns needed and with the
# desired names
test_data_x <- read.table("./X_test.txt",
                          col.names = features$FeatureName,
                          check.names = FALSE,  # Keep the original names
                          colClasses = features$FeatureClass)

# Read the test data activity classification
test_data_y <- read.table("./y_test.txt",
                          col.names = c("Activity"),
                          colClasses = c("integer"))


# Read the test subjects file
test_subjects <- read.table("./subject_test.txt",
                            col.names = c("Subject"),
                            colClasses = c("integer"))

# Put all of the test data into a find data frame
test_data <- cbind(test_data_x, test_data_y, test_subjects)

# Add a column that indicates this is test data
#test_data$Test <- logical(nrow(test_data))
#test_data$Test[] <- TRUE

# Read the train data file, but only the columns needed and with the
# desired names
train_data_x <- read.table("./X_train.txt",
                           col.names = features$FeatureName,
                           check.names = FALSE,  # Keep the original names
                           colClasses = features$FeatureClass)

# Read the train data activity classification
train_data_y <- read.table("./y_train.txt",
                           col.names = c("Activity"),
                           colClasses = c("integer"))


# Read the train subjects file
train_subjects <- read.table("./subject_train.txt",
                             col.names = c("Subject"),
                             colClasses = c("integer"))

# Put all of the train data into a find data frame
train_data <- cbind(train_data_x, train_data_y, train_subjects)

# Add a column that indicates this is not test data
#train_data$Test <- logical(nrow(train_data))

# Put the test and train data frames together
data <- rbind(test_data, train_data)


# Convert the activity integer to a factor with the proper activity label
data <- mutate(data,
               Activity = factor(Activity,
                                 activity_labels$Levels,
                                 activity_labels$Labels))

# Convert the subject integer to a factor
data <- mutate(data,
               Subject = factor(Subject))

# Split the data by Activity and Subject and summarize the remaining
# columns by taking their mean
summaryData <- summarize_each(group_by(data, Activity, Subject), funs(mean))

# Write the results to a file
write.table(summaryData, file = "./tidy_data.txt", row.names = FALSE)