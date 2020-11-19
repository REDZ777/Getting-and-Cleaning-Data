# Loading packages
library(dplyr)

# downloading data
# file_name
filename <- "Coursera_DS3_Final.zip"  

if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# unzip check

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
 
#load feature and activity data

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("both", "activity"))

#1: merging both data sets(training, test)

# test
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/x_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "both")

#training
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/x_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "both")
 
#merging
x_merge <- rbind(x_train, x_test)
y_merge <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
merged_data <- cbind(Subject, y_merge, x_merge)



#2: Extracts only the measurements on the mean and standard deviation for each measurement
tidy_data <- merged_data %>% select(subject, both, contains("mean"), contains("std"))


#3: Uses descriptive activity names to name the activities in the data set
tidy_data$both <- activities[tidy_data$both, 2]

#4: Appropriately labels the data set with descriptive variable names.
names(tidy_data)[2] = "activity"
names(tidy_data)<-gsub("-mean()", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-std()", "STD", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-freq()", "Frequency", names(tidy_data), ignore.case = TRUE)


#5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidy_data_set <- tidy_data %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
write.table(tidy_data_set, "tidy_data_set.txt", row.name=FALSE) 

