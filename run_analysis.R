library(dplyr)
library(tidyr)
library(reshape2)

#read in the column names for both the training and test data sets
allcols <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)[,2]

#read in the activity labels for both the training and test data sets
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE, col.names=c("Id", "Activity Name"))

#test data sets

#read in data
testData          <- read.table("./UCI HAR Dataset/test/X_test.txt",col.names = allcols, header=FALSE)

#read in the activities
testActivity      <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)

#read in the subjects
testSubject       <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)

#now only use mean and std measures.
relTestData       <- select(testData, matches("\\.mean\\.|\\.std\\.", ignore.case=FALSE))

#add activity and subject data into our data sets
relTestData$Activity <- testActivity[,1]
relTestData$Subject  <- testSubject[,1]

#training data sets

#read in data
trainingData          <- read.table("./UCI HAR Dataset/train/X_train.txt",col.names = allcols, header=FALSE)

#read in activities
trainingActivity      <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)

#read in subjects
trainingSubject       <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)

#now only use mean and std measures
relTrainingData       <- select(trainingData, matches("\\.mean\\.|\\.std\\." , ignore.case=FALSE))

#add activity and subject data into our data sets
relTrainingData$Activity <- trainingActivity[,1]
relTrainingData$Subject  <- trainingSubject[,1]

#join both datasets into one.
mergedData <- rbind(relTrainingData,relTestData)

#break down the columns by Activity and Subject.
res <- gather(mergedData, variable, mean, -cbind(Activity, Subject))

#separate the grouped columns into three new columns
groupedRes <- separate(res, variable, c("ObservationType", "ObservationStat", "Vector"))

#now get the average per observation
avgSet <- dcast(groupedRes, Activity + Subject + ObservationType + ObservationStat + Vector ~ "Average", value.var="mean", mean)

#one more step is to replace the activity number with the actitity name.
renamedData <- merge(activities, avgSet, by.x = "Id", by.y = "Activity")
#drop the activity id column
renamedData <- select(renamedData, Activity.Name : Average)
#write the file
write.table(renamedData, file="tidy_data.txt", row.name=FALSE)
