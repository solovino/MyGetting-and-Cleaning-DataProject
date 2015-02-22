###### STEP 1: Read in the test/training data and labels, as well as the features

### training data
# x
trainx = read.table("train/X_train.txt", header=F) # Read in  the training dataset
dim(trainx )   # dimension of the dataframe

# y 
trainy = read.table("train/Y_train.txt", header=F) # Read in the training labels
dim(trainy )

 
### test data
# x
testx = read.table("test/X_test.txt", header=F) # Read in the test dataset
dim(testx)

# y 
testy = read.table("test/Y_test.txt", header=F) # Read in the test labels
dim(testy)


### features
feats = read.table("features.txt", header=F)  # Read in all features (column names)
#names(feats)

###### STEP 2: Add column and row names to the test/training data and combine the data
######	       to create a working dataset

###  colnames added to dataframe 
colnames(testx) <- feats[,2]

colnames(trainx) <- feats[,2]

###  add rownames
rownames(testx) <-  paste("test",rownames(testx), sep="") 
rownames(trainx ) <-  paste("train",rownames(trainx ), sep="")

alldataA <-rbind(testx, trainx) # merge the dataframes
dim(alldataA )
rownames(alldataA )

###### STEP 3: Indentify the measurements that correspond to the mean and standard deviation, 
######		and extract them from working dataset to create a new working dataset.  

### Note: It was not clear if we should select those variables with mean in an earlier part of the name as well. 
### To be safe, those were included since its easier to remove variables than add variables after the
### dataset is obtained.

### look for cases where "mean" appears 
mean.index <- grep("mean", colnames(alldataA))

### look for cases where "std" appears 
sd.index <- grep("std", colnames(alldataA)) 
 
### set up a dataframe with only the mean and std measurements
mean.std.measA <- alldataA[, c(mean.index, sd.index)]
names(mean.std.measA )

###### STEP 4: Add the "labels" to the dataset and read in the activity_labels, and start using the dplyr 
######	       library to add the "labels" variables.

###  use dplyr to better handle the data
library(dplyr) 
mean.std.measB<- tbl_df(mean.std.measA)

###  combine labels from both datasets...recall it was testx followed by trainx
alllabels <- c(unlist(testy), unlist(trainy))
names(alllabels) <- NULL

###  add labels of activities
mean.std.measC <-mutate(mean.std.measB, labels = alllabels)

### Read in  activity_labels
actlabels = read.table("activity_labels.txt", header=F)   
names(actlabels) <- c("LabelID", "LabelName")

###### STEP 5: Add a variable that contains the activity names to the working dataset and remove labels from the working dataset

###  create an empty list to hold the type of activity name, where
###  each list element corresponds to the type of activity
act.index.list <- NULL

###  loop through the activity names
for(j in 1:6){ 
	# identify label and store the matching results
	act.index.list[[j]] <- which( mean.std.measC$labels == actlabels$"LabelID"[j] )
}

mean.std.measD <- mean.std.measC # create another dataset

###  add an empty slot for the label names
mean.std.measD <-mutate(mean.std.measD , labelnames = rep(NA, length(mean.std.measD$labels)) )

 
###  loop thru each name and store it in "labelnames"
for(j in 1:6){
	mean.std.measD$labelnames[act.index.list[[j]]] <-  as.character(actlabels$LabelName[j])
}

###  check that it matches:
# mean.std.measD[runif(10, 1, 1500), 75:81]

###  remove the labels variable
mean.std.measE <- select( mean.std.measD, -labels)

###  rename labelnames to ActivityNames 
mean.std.measF <- rename(mean.std.measE, ActivityNames= labelnames)

###### STEP 6: Read in the subject variable and add it to the dataset 

###  look at subjects... 
subjecttrain = read.table("train/subject_train.txt", header=F) # Read in the subjects
subjecttest = read.table("test/subject_test.txt", header=F) # Read in the subjects

 
###  combine subjects from both datasets...recall it was testx followed by trainx
allsubjects  <- c(unlist(subjecttest ), unlist(subjecttrain))
names(allsubjects) <- NULL
 

###  add subject to  mean.std.measF
mean.std.measG <-mutate(mean.std.measF, subject = allsubjects )
#names(mean.std.measG)
 

###### STEP 7: Clean up the column names

###  clean up the column names. Credit for this function goes to "Adekoya Adekunle Rotimi" from the discussion form!
clean.up.column.names<-function(v){            
          v=gsub('-','.',v)         
          v=gsub('\\(','',v)
          v=gsub(')','',v)
          v=gsub('BodyBody','Body',v)
          v            
        }

colnames(mean.std.measG) <- clean.up.column.names(colnames(mean.std.measG))

###### STEP 8: Group data by activity name, then subject

### group data by activity name, then subject
databy.act.sub <- group_by(mean.std.measG, ActivityNames, subject )

###### STEP 9: Define the final dataset that computes the average of each variable for each activity and each subject

### compute average of each variable for each activity and each subject.
# define a new mean to handel missing values within summarise
mymean <- function(x){ #to handel missing values
	mean(x, na.rm=TRUE)
}

# final dataset!
mean.std.measH <- summarise_each(databy.act.sub, funs(mymean))

# give the dataset a clearer name
tidy.mean.std <- mean.std.measH


