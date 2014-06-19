# Read data into memory
num.rows.train <- 7352
subject.train <- read.table("subject_train.txt", colClasses = c("integer"),
                            nrows = num.rows.train, comment.char = "")
y.train <- read.table("y_train.txt", colClasses = c("integer"),
                      nrows = num.rows.train, comment.char = "")
X.train <- read.table("X_train.txt", colClass = c("numeric"),
                      nrows = num.rows.train, comment.char = "")
num.rows.test <- 2947
subject.test <- read.table("subject_test.txt", colClasses = c("integer"),
                           nrows = num.rows.test, comment.char = "")
y.test <- read.table("y_test.txt", colClasses = c("integer"),
                     nrows = num.rows.test, comment.char = "")
X.test <- read.table("X_test.txt", colClass = c("numeric"),
                     nrows = num.rows.test, comment.char = "")

# Read provided names of features
feature.names <- read.table("features.txt",
                            colClasses = c("integer", "character"),
                            nrows = 561, comment.char = "")[, 2]

# Extract names of features that have to do with mean or standard deviation, and
# and replace characters such as "(", ")", "-", and "," so that the new names
# are legal R variable names
mean.indices <- grep("mean\\(\\)", feature.names)
mean.names <- feature.names[mean.indices]
mean.names <- gsub("mean\\(\\)", "mean", mean.names)
mean.names <- gsub("-", ".", mean.names)
std.indices <- grep("std\\(\\)", feature.names)
std.names <- feature.names[std.indices]
std.names <- gsub("std\\(\\)", "std", std.names)
std.names <- gsub("-", ".", std.names)

# Extract subset of measurements that have to do with mean or standard deviation
mean.std.indices <- union(mean.indices, std.indices)
mean.std.names <- union(mean.names, std.names)
X.train <- X.train[, mean.std.indices]
X.test <- X.test[, mean.std.indices]

# Merge training and test data together, and add column names
data.train <- cbind(subject.train, y.train, X.train)
data.test <- cbind(subject.test, y.test, X.test)
data <- rbind(data.train, data.test)
colnames(data) <- c("subject", "activity", mean.std.names)

# Replace integer activity labels with descriptive names, and convert to factors
data$activity <- as.character(data$activity)
data$activity[data$activity == "1"] <- "walking"
data$activity[data$activity == "2"] <- "walking.upstairs"
data$activity[data$activity == "3"] <- "walking.downstairs"
data$activity[data$activity == "4"] <- "sitting"
data$activity[data$activity == "5"] <- "standing"
data$activity[data$activity == "6"] <- "laying"
data$activity <- as.factor(data$activity)

# Create and write tidy data set with the average of each feature for each
# subject-activity pair
require(plyr)
summarized.data <- ddply(data, .(subject, activity), numcolwise(mean))
write.table(summarized.data, "tidy_data.txt", row.names = FALSE)