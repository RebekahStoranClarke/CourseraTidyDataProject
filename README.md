
# Coursera Tidy Data Course Project

* The Samsung data should be in a directory as such: UCI HAR Dataset/...
* Why does my data have 11,880 Rows instead of 181?
	* Because I have produced narrow instead of wide data, which according to the following course discussion is acceptable
	  https://class.coursera.org/getdata-005/forum/thread?thread_id=199
	* EAch row represents a unique combination of Subject, Activity and Feature (30 Subjects x 6 Activities x 66 Features = 11,880 Rows)

## STEPS TAKEN

* Install Necessary Packages - plyr, reshape
*  Load all data using read.table
	* When loading the train & test data sets set col.names equal to the data from features.txt, this ensures columns use descriptive variable names
* Merge the training and the test sets using row bind
# Clean up data column names to make them more readable
	* Replace full stops with spaces
	* Remove trailing spaces
* Extract only the measurements on the mean and standard deviation for each measurement
	* Use regular expressions to find any column names containing either "mean()" or "std()", build a vector of matching column indexes
	* Subset the data based on this vector
* Merge the training and test label data using row bind
* Merge the training and test subject data using row bind
* Replace the label data with descriptive activity names
	* For each activity:
		* Use sapply to replace the activity number with the activity description in the label data
* Add both the activity and subject columns to the main data using column bind
* Create a second, independent tidy data set with the average of each variable for each activity and each subject
	* Using melt(): Melt the data to get a column indicating the variable type
	* Using ddply: Reshape this data to get a mean for all unique combinations of Activity, Subject and Variable 
* Output resulting data to files


## TIDY DATA

* Each variable is in a separate column 
* Each observation is in one row
* The column names have been cleaned up to be plain English and descriptive
* All variables are meaningful, the full descriptive activity names are included instead of activity numbers
