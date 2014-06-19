Processing of Human Activity Recognition Data
===========

This is a description of the processing performed to clean and tidy a human
activity recognition data set obtained from the UCI Machine Learning Repository
(http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

## Repository content

This GitHub repository contains an R script, run_analysis.R, that performs the
analysis and processing.  In order for the script to be run properly, the
following files from the original data package must be in the same working
directory as the script:

* subject_train.txt
* y_train.txt
* X_train.txt
* subject_test.txt
* y_test.txt
* X_test.txt
* features.txt

The repository also contains an output tidy data file, tidy_data.txt, which is
described below.

## Analysis and processing done by run_analysis.R

The script run_analysis.R first reads the content of the 7 files (listed above)
into memory.  In extracting the measurements on the mean and standard deviation
for each measurement, we make the following assumptions:

* The variables relevant to the mean for each measurement are those with names (provided in features.txt) that contain the string "mean()" (for example, "tBodyAcc-mean()-X").  This assumption precludes variables with names such as "fBodyAcc-meanFreq()-X" or "angle(tBodyAccMean,gravity)".
* The variables relevant to the standard deviation for each measurement are those with names (provided in features.txt) that contain the string "std()".

The variables that fit the above criteria are extracted from the training and test data sets.  The script then proceeds to modify the names of the extracted variables to make them more descriptive and robust, by doing the following:

* Whenever the string "mean()" is found in a name, it is replaced by "mean".
* Whenever the string "std()" is found in a name, it is replaced by "std".
* Whenever the character "-" is found in a name, it is replaced by ".".

For example, "tBodyAcc-mean()-X" is turned into "tBodyAcc.mean.X", and "tBodyAcc-std()-Z" is turned into "tBodyAcc.std.Z".  The new variable names have the benefit of being valid R variable names, which do not allow characters such as "-" or "(".  As a result, the $ operator can be applied to the data frame to access those variables.  The dots in the variable names act to separate different meaningful descriptive components.   The first component in the name states what the measurement is (e.g., "tBodyAcc" refers to the time domain signal of the accelerometer reading), the second component indicates whether the variable is a mean or standard deviation, and the third component, if present, indicates the axial direction (X, Y, or Z).

The activity codes found in the file activity_labels.txt (the y variable values) are mapped to descriptive string labels in the processed data set, as follows:

* 1 - "walking"
* 2 - "walking.upstairs"
* 3 - "walking.downstairs"
* 4 - "sitting"
* 5 - "standing"
* 6 - "laying"

More details regarding the variables can be found in CodeBook.md.

The training and test data frames are then combined.  As the last step, a new tidy data set that contains the average of each subject-activity pair for each variable is created, which has 180 observations (rows) and 68 variables (columns).  This data set is output as tidy_data.txt.