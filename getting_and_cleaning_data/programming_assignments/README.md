# Writting assignments

---
title: "Getting and cleaning data - Course project"
author: "Raphael Carvalho"
date: "23/03/2020"
output: pdf_document
---


The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. The deliverables for the project are: 

1) A tidy data set;
2) A link to a Github repository with your script for performing the analysis;
3) A code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.


To make the dataset tidy, I must: 

- Merge the training and the test sets to create one data set.
- Extract only the measurements on the mean and standard deviation for each measurement.
- Use descriptive activity names to name the activities in the data set
- Appropriately label the data set with descriptive variable names.
- From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.


## Project folder contents 

The project folder contains the following files: 

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.



## Data cleaning process


To start working with the dataset, I've downloaded and unziped the project content, as shown below: 


```
zipname <- "course_project_data.zip"
if (!file.exists(zipname)) {
  fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  download.file(fileUrl, zipname, method = 'curl')
}

project_folder <- "UCI HAR Dataset"

if (!file.exists(project_folder)) {
  unzip(zipname)
}
```

After the folder is downloaded, I'll read every dataset: 


```
#Reading the training tables

xtrain <- read.table(file.path(pathdata, "train", "X_train.txt"), header = FALSE)
ytrain <- read.table(file.path(pathdata, "train", "y_train.txt"), header = FALSE)
subject_train <- read.table(file.path(pathdata, "train", "subject_train.txt"), header = FALSE)

#Reading the testing tables

xtest <- read.table(file.path(pathdata, "test", "X_test.txt"), header = FALSE)
ytest <- read.table(file.path(pathdata, "test", "y_test.txt"), header = FALSE)
subject_test <- read.table(file.path(pathdata, "test", "subject_test.txt"), header = FALSE)

#Read the features data

features <- read.table(file.path(pathdata, "features.txt"), header = FALSE)

#Read activity labels data

activityLabels <- read.table(file.path(pathdata, "activity_labels.txt"), header = FALSE)
```

With the datasets loaded, I'll label them:

```
#Labeling the datasets

colnames(xtrain) <- features[, 2]
colnames(ytrain) <- "activity_id"
colnames(subject_train) <- "subject_id"

colnames(xtest) = features[, 2]
colnames(ytest) = "activity_id"
colnames(subject_test) = "subject_id"

colnames(activityLabels) <- c('activity_id','activity_type')
```

Now that the labeling process is done, it's time to merge the train and test datasets: 

```
#Merging the train and test datasets
train_dataset <- cbind(xtrain, ytrain, subject_train)
test_dataset <- cbind(xtest, ytest, subject_test)

dataset <- rbind(train_dataset, test_dataset)
names <- colnames(dataset)
```

Now we have to search and filter the dataset to include only columns that are labeled as "mean" or "std": 

```
mean_std_col_index <- c(grep("mean..", names), grep("std..", names))
mean_std_col_names <- c(names[mean_std_col_index], "subject_id", "activity_id")
dataset <- dataset[, mean_std_col_names]
```

Applying more transformations... 

```
#Labeling the activity_id
dataset <- merge(dataset, activityLabels, by = "activity_id" , all.x = TRUE)

#Removing the parenthesis
colnames(dataset) <- gsub("[()]", "", colnames(dataset))

#Transforming activity and subject to factors - 30 subject_id * 6 activity_id = 180 rows.
mean_dataset <- aggregate(. ~subject_id + activity_id, dataset, mean)
mean_dataset <- mean_dataset[order(mean_dataset$subject_id, mean_dataset$activity_id),]
```
And, at last, saving the tidy dataset into a file: 

```
#Saving the dataset to a file
write.table(mean_dataset, "cleaned_mean_dataset.txt", row.name=FALSE)
```


