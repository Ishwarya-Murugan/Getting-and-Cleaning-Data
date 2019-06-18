library(dplyr)

# *************************** GET THE DATA *********************************************

setwd("C:\\Users\\Ishwa\\Desktop\\DataScience\\R\\Getting and Cleaning Data")
path <- getwd()

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

f <- "getdata_projectfiles_UCI HAR Dataset.zip"
if (!file.exists(path)) {dir.create(path)}
download.file(url, file.path(path, f))

setwd("C:\\Users\\Ishwa\\Desktop\\DataScience\\R\\Getting and Cleaning Data\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset") 
path <- getwd()

unzip(f,exdir=path)

# ******************* LOAD THE REQUIRED INPUR FILES *****************************

actv_labl <- read.table("activity_labels.txt", col.names = c("class", "name"))
str(actv_labl)

feature <- read.table("features.txt", col.names= c("idx", "name"))
str(feature)

# Extracts only the measurements on the mean and standard deviation for each measurement.
# Assumption: as the requirement didn't explain which mean values included variable for mean() as well as meanFreq()

cols_with_mean_std <- grep("mean|std",feature$name,ignore.case = TRUE, value = TRUE)
cols_with_mean_std <- grep ("^(?!angle).*", cols_with_mean_std,ignore.case = TRUE, value = TRUE, perl=TRUE)
cols_with_mean_std

# ******************** PROCESS/TIDY THE TEST DATASET ************************


subject_test <- read.table("test\\subject_test.txt", col.names= c("subject_id"))
head(subject_test)


x_test <- read.table("test\\X_test.txt")

# Appropriately labels the data set with descriptive variable names in x_test dataset
names(x_test)<- feature$name
str(x_test)
head(x_test)


y_test <- read.table("test\\y_test.txt", col.names= c("y_label"))

# Apply descriptive activity names to name the activities in y_test dataset labels
y_test$y_label<- sapply(y_test$y_label, function(label){ actv_labl$name[actv_labl$class==label]})
str(y_test)


x_test_mean_std <- x_test[,cols_with_mean_std]
str(x_test_mean_std)

# Merge the subject id and the activity label to the test dataset

test_data <- cbind(subject_test$subject_id,y_test$y_label,x_test_mean_std)
colnames(test_data)[1] <- "subject_id"
colnames(test_data)[2] <- "activity"
str(test_data)


# ******************** PROCESS/TIDY THE TRAINING DATASET ************************

subject_train <- read.table("train\\subject_train.txt", col.names= c("subject_id"))
str(subject_train)

x_train <- read.table("train\\X_train.txt")

# Appropriately labels the data set with descriptive variable names in x_train dataset
names(x_train)<- feature$name
str(x_train)
head(x_train)


y_train <- read.table("train\\y_train.txt", col.names= c("y_label"))

# Apply descriptive activity names to name the activities in y_train dataset labels
y_train$y_label<- sapply(y_train$y_label, function(label){ actv_labl$name[actv_labl$class==label]})
str(y_train)


x_train_mean_std <- x_train[,cols_with_mean_std]
str(x_train_mean_std)

# Merge the subject id and the activity label to the training dataset

train_data <- cbind(subject_train$subject_id,y_train$y_label,x_train_mean_std)
colnames(train_data)[1] <- "subject_id"
colnames(train_data)[2] <- "activity"
str(train_data)

# ***************** MERGE THE TRAINING AND TEST DATASET & CREATE THE FINAL TIDY DATASET *********************

# Merges the training and the test sets to create one data set per step #4
tidy_data <- rbind(train_data, test_data)
str(tidy_data)


# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data_avg<- tidy_data %>% group_by(activity, subject_id) %>%summarise_all( "mean") 
View(tidy_data_avg)
str(tidy_data_avg)

# Write the final tidy dataset to the output file
write.table(tidy_data_avg, file = "tidy_data_average.txt", row.name=FALSE)
