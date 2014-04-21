# It is assumed that the data is in the ./UCI HAR Dataset/directory
# The new dataset is saved on "./fulldataset_mean_std.txt"

# Load feature data
fname <- "UCI HAR Dataset/test/X_test.txt" 
features <- read.table("./UCI HAR Dataset/features.txt")
feature_indices <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
feature_names <- features[feature_indices,2]

# Load needed features
readfile <- function (fname, dfcolnames, indices) {
    con <- file(fname, "r")
    data <- readLines(con)
    close(con)
    trim <- function (x) gsub("^\\s+|\\s+$", "", x)
    dedupspaces <- function (x) gsub(" +", " ", x)
    formatline <- function(l) sapply(strsplit(dedupspaces(trim(l)), " "), as.numeric)
    r <-lapply(data, function(l) formatline(l)[indices])
    r
}

testdata <- readfile("./UCI HAR Dataset/test/X_test.txt", feature_names, feature_indices)
traindata <- readfile("./UCI HAR Dataset/train/X_train.txt", feature_names, feature_indices)

# Merge train and test datasets
df <- data.frame(matrix(unlist(c(testdata, traindata)), ncol=length(feature_indices)))
names(df) <- feature_names

# Load activity data and actity labels
testactivity <- read.table("./UCI HAR Dataset/test/y_test.txt")
trainactivity <- read.table("./UCI HAR Dataset/train/y_train.txt")
allactivityvals <- matrix(unlist(c(testactivity, trainactivity)), ncol=1)

# Translate activities to labels
activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
allactivitylabels <- sapply(allactivityvals, function(a) activitylabels[activitylabels$V1 == a, 2])
df["Activity"] <- allactivitylabels

# Save results
write.table(df, "./fulldataset_mean_std.txt")


