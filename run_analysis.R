#filePath 
setwd('D:/Johns Hopkins University/Getting and cleaning Data/project')

#create data.table data
traindata <- read.table('UCI HAR Dataset/train/X_train.txt')
testdata <- read.table('UCI HAR Dataset/test/X_test.txt')

#read activity variables
trainActivityData <- read.table('UCI HAR Dataset/train/y_train.txt')
testActivityData <- read.table('UCI HAR Dataset/test/y_test.txt')

#read subject variables
trainSubject <- read.table('UCI HAR Dataset/train/subject_train.txt') 
testSubject <- read.table('UCI HAR Dataset/test/subject_test.txt') 

#read activity labels
names_activity <- read.table('UCI HAR Dataset/activity_labels.txt')

#1.Merges the training and the test sets to create one data set.

#merge by rows
data <- rbind(traindata, testdata)
activity <- rbind(trainActivityData, testActivityData)
subject <- rbind(trainSubject, testSubject)

#set names variables
names(subject) <- c('subject')
names(activity) <- c('activity')
features <- read.table('UCI HAR Dataset/features.txt') 
name_feat <- features$V2
names(data) <- name_feat

#merge Data to create one data set
data1 <- cbind(data, activity)
data_set <- cbind(data1, subject)

#2.Extracts only the measurements on the mean and standard deviation for each measurement.
#subset names
subnames <- features$V2[grep('mean\\(\\)|std\\(\\)', features$V2)]
#subset measurements
allnames <- c(as.character(subnames), 'activity', 'subject')
data_set2 <- subset(data_set, select = allnames)

#3.Uses descriptive activity names to name the activities in the data set
data_set$activity <- as.character(data_set$activity)
data_set$activity <- gsub('1', names_activity$V2[1], data_set$activity)
data_set$activity <- gsub('2', names_activity$V2[2], data_set$activity)
data_set$activity <- gsub('3', names_activity$V2[3], data_set$activity)
data_set$activity <- gsub('4', names_activity$V2[4], data_set$activity)
data_set$activity <- gsub('5', names_activity$V2[5], data_set$activity)
data_set$activity <- gsub('6', names_activity$V2[6], data_set$activity)

#4.Appropriately labels the data set with descriptive variable names.
names(data_set) <- gsub('^t', 'time', names(data_set))
names(data_set) <- gsub('^f', 'frequency', names(data_set))
names(data_set) <- gsub('Acc', 'Accelerometer', names(data_set))
names(data_set) <- gsub('Gyro', 'Gyroscope', names(data_set))
names(data_set) <- gsub('BodyBody', 'Body', names(data_set))
names(data_set) <- gsub('Mag', 'Magnitude', names(data_set))

#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)
Datatidy <-aggregate(. ~subject + activity, data_set, mean)
Datatidy <- Datatidy[order(Datatidy$subject,Datatidy$activity),]
write.table(Datatidy, file = "tidydata.txt",row.name=FALSE)



#Bibliografy: https://rpubs.com/Jb_2823/55939



