# MyGetting-and-Cleaning-DataProject

This is the repository for my course project in the Getting and Cleaning Data course.  It contains the following files:
  
1.  run_analysis.R  -- A R file that contains code with comments that does the following with the 
   Human Activity Recognition Using Smartphones Dataset:

      -- Merges the training and the test sets to create one data set.
      
      -- Extracts only the measurements on the mean and standard deviation for each measurement. 
      -- Uses descriptive activity names to name the activities in the data set
      
      -- Appropriately labels the data set with descriptive variable names. 
      
      -- Creates a second, independent tidy data set with the average of each variable for each
         activity and each subject.

In summary, the file does the following steps (with various lines of code and comments under each step):

STEP 1: Read in the test and training data and labels

STEP 2: Add column and row names to the test/training data and combine the data
        to create a working dataset

STEP 3: Indentify the measurements that correspond to the mean and standard deviation, 
		    and extract them from working dataset to create a new working dataset

STEP 4: Add the "labels" to the dataset and read in the activity_labels, and start using the dplyr library to add the
        "labels" variables.

STEP 5: Add a variable that contains the activity names to the working dataset and remove labels from the working     
        dataset.

STEP 6: Read in the test/train subject variable and add it to the working dataset 

STEP 7: Clean up the column names

STEP 8: group data by activity name, then subject

STEP 9: Define the final dataset that computes the average of each variable for each activity and each subject

2.  Codebook       -- The codebook for the dataset
 



