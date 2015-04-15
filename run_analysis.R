setwd("F:/coursra/Getting and Cleaning Data/project/P1")

#read the data
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
cname <- read.table("./UCI HAR Dataset/features.txt")

#Merges the training and the test sets to create one data set
x_merge <- rbind(x_train, x_test )
y_merge <- rbind(y_train, y_test )
subject <- rbind(subject_train, subject_test)[,1]
        
#Extracts only the measurements on the mean and standard deviation for each measurement
subset <- grep("mean\\(|std\\(",cname$V2)
x_merge <- x_merge[,subset]

#Uses descriptive activity names to name the activities in the data set
activity <- merge(y_merge,activity_labels,by.x="V1",by.y="V1")[,2]

#Appropriately labels the data set with descriptive variable names
colnames(x_merge) <- cname[subset,2]

#creates a second, independent tidy data set with the average of each variable for each activity and each subject
all_merge <- cbind(x_merge, activity, subject)
meltdata <- melt(all_merge,id.vars=c("activity","subject"),measure.vars=cname[subset,2])
dataset2 <- dcast(meltdata,activity+subject~variable,mean)

#save dataset2
write.table(dataset2, file = "dataset2.txt", row.names = FALSE)
