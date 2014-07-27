#######################################################################################################################################  
# 	Install and load Necessary Libraries
####################################################################################################################################### 
install.packages("plyr")
install.packages("reshape")

library(plyr)
library(reshape)

#######################################################################################################################################  
# 	Load all data
####################################################################################################################################### 

features 		<- read.table(file="UCI HAR Dataset/features.txt")										# List of all features
train 			<- read.table(file="UCI HAR Dataset/train/X_train.txt", col.names=features[,2])			# Training set
test  			<- read.table(file="UCI HAR Dataset/test/X_test.txt"  , col.names=features[,2])			# Test set
trainLabels 	<- read.table(file="UCI HAR Dataset/train/y_train.txt", col.names=c("Activity"))		# Training labels
testLabels 		<- read.table(file="UCI HAR Dataset/test/y_test.txt",  col.names=c("Activity"))			# Test labels
trainSubjects	<- read.table(file="UCI HAR Dataset/train/subject_train.txt", col.names=c("Subject"))	# Test Subjects
testSubjects	<- read.table(file="UCI HAR Dataset/test/subject_test.txt", col.names=c("Subject"))		# Train Subjects
activityLabels 	<- read.table(file="UCI HAR Dataset/activity_labels.txt")								# Links the class labels with their activity name

print("Succesfully read in data as follows:")
cat("Training set : \t\t", 	dim(train)[1], 			"x", dim(train)[2], 		"\n", sep="")
cat("Test set : \t\t", 		dim(test)[1], 			"x", dim(test)[2], 			"\n", sep="")
cat("Test labels : \t\t", 	dim(testLabels)[1], 	"x", dim(testLabels)[2], 	"\n", sep="")
cat("Train labels : \t\t", 	dim(trainLabels)[1], 	"x", dim(trainLabels)[2],	"\n", sep="")
cat("Test Subjects : \t\t", dim(testSubjects)[1], 	"x", dim(testSubjects)[2], 	"\n", sep="")
cat("Train Subjects : \t", 	dim(trainSubjects)[1], 	"x", dim(trainSubjects)[2],	"\n", sep="")
cat("Features : \t\t", 		dim(features)[1], 		"x", dim(features)[2], 		"\n", sep="")
cat("Activity Labels : \t", dim(activityLabels)[1], "x", dim(activityLabels)[2],"\n", sep="")


#######################################################################################################################################  
# 	Merge the training and the test sets to create one data set
####################################################################################################################################### 

data <- rbind(train, test)
print(dim(data))

# Clean up Column Names
names(data) <- gsub("(\\.)+", " ", names(data))		# Replace full stops with spaces
names(data) <- gsub("( )$", "", names(data))		# Remove trailing spaces

#######################################################################################################################################  
# Extract only the measurements on the mean and standard deviation for each measurement
#######################################################################################################################################  

cols <- grep("(mean\\(\\))|(std\\(\\))", features[,2]) 	# Build a vector of columns which include mean() or stdDev()
data <- data[,cols] 									# Subset the data based on this

#######################################################################################################################################  
# Use descriptive activity names to name the activities in the data set 
#######################################################################################################################################  

# Merge the training and the test labels
labels <- rbind(trainLabels, testLabels)

# Merge the training and the test subjects
subjects <- rbind(trainSubjects, testSubjects)			

# For each activity, look for all occurences of the int in labels and replace with the descriptive name
for (i in 1:nrow(activityLabels))
{
	labels <- as.data.frame(sapply(labels, gsub,pattern=activityLabels[i,1],replacement=activityLabels[i,2]))
}

# Add activity Column to data
data <- cbind(data,subjects)

# Add subject Column to data
data <- cbind(data,labels)

#######################################################################################################################################  
# Appropriately label the data set with descriptive variable names
#######################################################################################################################################  


# This was accomplished in the initial read using col.names


#######################################################################################################################################
# Create a second, independent tidy data set with the average of each variable for each activity and each subject
#######################################################################################################################################

# Melt Data
dataMelt <- melt(data, id.vars = c("Activity","Subject"), measure.vars = names(data[,1:66]), variable.name = "Feature" )

# Reshape
data2 <- ddply(dataMelt, .(Activity, Subject, variable), summarise, Mean=mean(value))

#######################################################################################################################################
# Output the resulting data
#######################################################################################################################################

write.table(data, "tidyData.txt", row.names = F)
write.table(data2, "meanData.txt", row.names = F)

