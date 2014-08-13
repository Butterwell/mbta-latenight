################################################################
# This script produces a clean dataset from the files provided #
# for the challenge                                            #
################################################################

## RIDERSHIP DATA

# Load csv
ridership <- read.csv('../data/LateNight_thru_7June2014.csv', header=TRUE);
# Transform dates
ridership$scheduledate <- as.Date(ridership$scheduledate, "%m/%d/%Y");
# Delete nulls
ridership <- ridership[!is.na(ridership$scheduledate),];
# Create factors
ridership$latenightroute <- factor(ridership$latenightroute);
levels(ridership$latenightroute) <- c('N','Y');
names(ridership) <- c('date','latenight','line','station','day','hour','min','tx');
ridership$min <- ridership$min * 15
ridership$day <- factor(ridership$day);
levels(ridership$day) <- c('fri','sat');
