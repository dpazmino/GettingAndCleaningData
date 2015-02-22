# GettingAndCleaningData
R Course Work
The run_analysis.R file will read in the test and training data sets.  The script will first get the column information
from the root directory of the extracted zip file.  The script also assumes the working directory and the extracted files
share the same directory.

The script will then load each test and training data file into a data frame.  It will also load the activity files and 
the subject files into separate dataframes.  The script will then create a dataframe that only has the columns
we want, which is a subset of the main dataframe.  We then merge in the activity and subject columns into this data frame.

We will merge the data and then tidy the data.  This is a two step process and I used gather to bring in all the observations
into one column and the measures into one column.  The dimensions are activity and subject.

Now we have to break down the new column into three columns.  It seems that observations are done by vectors, observation types,
and either mean or std.  I used dcast to average each observations.
