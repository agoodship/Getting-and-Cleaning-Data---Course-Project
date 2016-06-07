## Set working directory to location with the files ##
setwd("C:/Users/algo/Desktop/Coursera/Course Project/UCI HAR Dataset")
library(dplyr)
## Read in datasets from Train and Test##
features <- read.table('./features.txt', header = FALSE)
activityLabels <- read.table('./activity_labels.txt', header = FALSE)
trainSubjects <- read.table('./train/subject_train.txt', header = FALSE)
trainObservations <- read.table('./train/X_train.txt', header = FALSE)
trainActivities <- read.table('./train/Y_train.txt', header = FALSE)

testSubjects <- read.table('./test/subject_test.txt', header = FALSE)
testObservations <- read.table('./test/X_test.txt', header = FALSE)
testActivities <- read.table('./test/Y_test.txt', header = FALSE)

##Assign names to columns##
colnames(activityLabels) = c("activityID", "activityType")
colnames(trainSubjects) = "subjectID"
colnames(trainActivities) = "activityID"
colnames(trainObservations) = features[,2]

colnames(testSubjects) = "subjectID"
colnames(testActivities) = "activityID"
colnames(testObservations) = features[,2]

##Merge into complete train and test datasets and then combine into one complete dataset##
completeTrain <- cbind(trainSubjects, trainActivities, trainObservations)
completeTest <- cbind(testSubjects, testActivities, testObservations)
completeData <- rbind(completeTrain, completeTest)

##Create logical vector of features containing ID, mean and standard deviation##
columnsNeeded <- grepl(".*ID.*|.*-mean.*|.*-std.*", colnames(completeData))
condensedData <- completeData[, columnsNeeded]

##Add in descriptive activity names by merging activity labels on activity ID##
finalData <- merge(condensedData, activityLabels, by='activityID', all.x = TRUE)
finalData <- arrange(finalData, subjectID, activityID)

##Clean up column names##
columnNames <- colnames(finalData)
for (i in 1:length(columnNames)) 
{
  columnNames[i] = gsub("\\()","",columnNames[i])
  columnNames[i] = gsub("-std$","StdDev",columnNames[i])
  columnNames[i] = gsub("-mean","Mean",columnNames[i])
  columnNames[i] = gsub("^(t)","time",columnNames[i])
  columnNames[i] = gsub("^(f)","freq",columnNames[i])
  columnNames[i] = gsub("([Gg]ravity)","Gravity",columnNames[i])
  columnNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",columnNames[i])
  columnNames[i] = gsub("[Gg]yro","Gyro",columnNames[i])
  columnNames[i] = gsub("AccMag","AccMagnitude",columnNames[i])
  columnNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",columnNames[i])
  columnNames[i] = gsub("JerkMag","JerkMagnitude",columnNames[i])
  columnNames[i] = gsub("GyroMag","GyroMagnitude",columnNames[i])
};

colnames(finalData) = columnNames

##create tidy data subset with only the means of each variable and subject##
meandataset <- aggregate(finalData[,names(finalData)!=c("activityID","subjectID", "activityType")],
                         by=list(acitivityID=finalData$activityID, subjectID = finalData$subjectID),
                         mean, na.rm=TRUE)

##Export the dataset with the means by subject ID and acitivy##
write.table(meandataset, "./courseprojectdataset.txt", row.names = TRUE, sep = ",")
