# 1. merge training and test data sets

# 2. extract only the mean and std.dev. for each measurement

# 3. use descriptive activity names to describe the activities in the data set

# 4. appropriately label the data set with descriptive variable names

# 5. from data set in 4, create a second, independent tidy data set w/the avg. of each
#    var for each activity and each subject

library(dplyr)

## getset some vars
subjectTest <- read.table("UCI_HAR_Dataset/test/subject_test.txt")
xTest <- read.table("UCI_HAR_Dataset/test/X_test.txt")
yTest <- read.table("UCI_HAR_Dataset/test/Y_test.txt")

subjectTrain <- read.table("UCI_HAR_Dataset/train/subject_train.txt")
xTrain <- read.table("UCI_HAR_Dataset/train/X_train.txt")
yTrain <- read.table("UCI_HAR_Dataset/train/y_train.txt")

features <- read.table("UCI_HAR_Dataset/features.txt")

## rename y's column to "activitytype"
names(yTest)[1] <- "activitytype"
names(yTrain)[1] <- "activitytype"

## rename subject's column to "subject"
names(subjectTest)[1] <- "subject"
names(subjectTrain)[1] <- "subject"

## remove "V" from x column names, for easier lookup
names(xTest) <- gsub("V", "", names(xTest))
names(xTrain) <- gsub("V", "", names(xTrain))

## merge x and y's together
testdata <- merge(xTest, yTest, by=0)
testdata <- testdata[, -which(as.character(names(testdata)) == "Row.names")]
testdata <- merge(testdata, subjectTest, by=0)
trainingdata <- merge(xTrain, yTrain, by=0)
trainingdata <- trainingdata[, -which(as.character(names(trainingdata)) == "Row.names")]
trainingdata <- merge(trainingdata, subjectTrain, by=0)

## kill non-mean-or-std columns in testdata and trainingdata
## ## by checking against features data frame
for(i in 1:nrow(features)) {
  if(!grepl("mean|std", features$V2[i], ignore.case=TRUE)) {
    names(testdata)[i+1] <- "DELETECOL"
    names(trainingdata)[i+1] <- "DELETECOL"
  } else {
    names(testdata)[i+1] <- as.character(features$V2[i])
    names(trainingdata)[i+1] <- as.character(features$V2[i])
  }
}

## remove unnecessary columns
testdata <- testdata[, -which(as.character(names(testdata)) == "DELETECOL")]
trainingdata <- trainingdata[, -which(as.character(names(trainingdata)) == "DELETECOL")]

## id which dataset each row came from before binding
testdata$datasource <- "testing"
trainingdata$datasource <- "training"

## and in the darkness, bind them
fulldata <- rbind(trainingdata, testdata)

## tidy up the column names
names(fulldata) <- gsub("\\.|-|\\(|\\)|,", "_", names(fulldata))
names(fulldata) <- tolower(names(fulldata))
names(fulldata) <- gsub("^t", "time", names(fulldata))
names(fulldata) <- gsub("^f", "frequency", names(fulldata))

## replace those integer activitytype identifiers with actual descriptive characters
fulldata$activitytype <- gsub("1", "WALKING", as.character(fulldata$activitytype))
fulldata$activitytype <- gsub("2", "WALKING_UPSTAIRS", as.character(fulldata$activitytype))
fulldata$activitytype <- gsub("3", "WALKING_DOWNSTAIRS", as.character(fulldata$activitytype))
fulldata$activitytype <- gsub("4", "SITTING", as.character(fulldata$activitytype))
fulldata$activitytype <- gsub("5", "STANDING", as.character(fulldata$activitytype))
fulldata$activitytype <- gsub("6", "LAYING", as.character(fulldata$activitytype))


## now for that second, independent, tidy data set of averages
## ## avg each variable for each activity and each subject
grouped <- group_by(fulldata, subject, activitytype)
grouped <- select(grouped, -row_names, -datasource)

finalset <- grouped %>% summarize_each(funs(mean))

## write solution to a local txt file
write.table(finalset, file = "solution.txt", row.names = FALSE)

