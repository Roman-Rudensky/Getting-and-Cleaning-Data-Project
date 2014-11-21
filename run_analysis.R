#This script does the following.
#Loads data from the directory "UCI HAR Dataset" into R 
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Check dir. This section checks that "UCI HAR Dataset" is current working directory. Otherwise script is stopped 
if(!(grep("UCI HAR Dataset$",getwd())==1)) stop("Make sure 'UCI HAR Dataset' is set as Your working directory")
  
## load all data into R

# activity labels
activity_labels <- read.table("./activity_labels.txt")

# column names
col_names <- read.table("./features.txt")
##test Data
#X_test
X_test <- read.table("./test/X_test.txt")
# y_test
y_test <- read.table("./test/y_test.txt")
# subject_test
subject_test <- read.table("./test/subject_test.txt")

##Train data
# X_train
X_train <- read.table("./train/X_train.txt")

# y_train 
y_train <- read.table("./train/y_train.txt")

#subject_train
subject_train <- read.table("./train/subject_train.txt")

##Merges the training and the test sets
#Merge test dataset
#add activity id and subject id to X_test
X_test<-cbind(X_test,y_test,subject_test)
#add activity id and subject id to X_train
X_train<-cbind(X_train,y_train,subject_train)

#Label the data set with descriptive variable names
names <- c(as.character(col_names[,"V2"]),"activity_id","subject")
names(X_test) <- names
names(X_train)<-names
#Merge Test and Train
X_all<-rbind(X_test,X_train)
#Free memory
rm(X_test)
rm(X_train)

# Extract measurements on the mean and standard deviation
cols2extr<-grep("mean|std|activity_id|subject",names)
X_all<- X_all[,cols2extr]

#Uses descriptive activity names to name the activities
X_all[,82] <- activity_labels[X_all[,80],2]
names(X_all)[82]<-"Activity_Label"

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Melt X_all
X_allMelt <- melt(X_all,id=names(X_all)[80:82],measure.vars=names(X_all)[1:79])

#Make 2nd tidy data set
Tidy_data_set2<-dcast(X_allMelt, Activity_Label+subject ~ variable, mean)

write.table(Tidy_data_set2, file = "./tidy_data.txt",row.name=FALSE)
