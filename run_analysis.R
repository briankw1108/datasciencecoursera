#setup working directory to desktop.
setwd("C://Users/u213493/Desktop")

#create a folder on desktop if the folder is not existed.
if (!file.exists("Data Science")) {dir.create("Data Science")}

#file source address
fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#download the file from the file source.
setwd("C://Users/u213493/Desktop/Data Science")
if (!file.exists("Samsung Data.zip")) {download.file(fileUrl, destfile = "C://Users/u213493/Desktop/Data Science/Samsung Data.zip")}

#unzip the .zip data.
if (!file.exists("UCI HAR Dataset")) {unzip("Samsung Data.zip")}

#setup new working directory to new unzipped folder.
setwd("C://Users/u213493/Desktop/Data Science/UCI HAR Dataset")

#read the features file
features = read.table("features.txt")

#merge train data set.
train.x = read.table("train/X_train.txt")
colnames(train.x) = features[,2]
train.subject = read.table("train/subject_train.txt", col.names = "Subject")
train.y = read.table("train/y_train.txt", col.names = "Activity")
new.train.data = cbind(train.subject, train.y, train.x)

#merge test data set.
test.x = read.table("test/X_test.txt")
colnames(test.x) = features[,2]
test.subject = read.table("test/subject_test.txt", col.names = "Subject")
test.y = read.table("test/y_test.txt", col.names = "Activity")
new.test.data = cbind(test.subject, test.y, test.x)

#merge train and test data set
new.data = rbind(new.train.data, new.test.data)

#get the indices from all measurements that contain mean and std
indices = c( 1, 2, sort(c(grep("-mean()", features[,2]), grep("-std()", features[,2]))) + 2)

#extract the measurements that contain mean and std
new.data2 = new.data[,indices]

#label activities
new.data2[new.data2$Activity == 1,][,2] = "WALKING"
new.data2[new.data2$Activity == 2,][,2] = "WALKING_UPSTAIRS"
new.data2[new.data2$Activity == 3,][,2] = "WALKING_DOWNSTAIRS"
new.data2[new.data2$Activity == 4,][,2] = "SITTING"
new.data2[new.data2$Activity == 5,][,2] = "STANDING"
new.data2[new.data2$Activity == 6,][,2] = "LAYING"

#reshape the data set by melting the data
library(reshape2)
meltdata = melt(new.data2, id = c("Subject", "Activity"))

#calculate means for all variables for each subject and activity by using dcast function
finaldata = dcast(meltdata, Subject + Activity ~ variable, mean)

#create a text file with this dataset
write.table(finaldata, file = "Analysis Result.txt", row.names = FALSE)




