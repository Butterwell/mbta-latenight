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


## LICENSES

# Load and bind files
require(gdata);
licenses <- read.xls('../data/CLB.xlsx',sheet=1,header=TRUE);
names(licenses) <- c('license','category','name','dba','address','status','milestone');
CV7A <- read.xls('../data/CV7A.xlsx',sheet=1,header=TRUE);
CV7A[,'milestone'] <- NA;
names(CV7A) <- c('license','category','name','dba','address','status','milestone');
licenses <- rbind(licenses,CV7A);
rm(CV7A);
CV7M <- read.xls('../data/CV7M.xlsx',sheet=1,header=TRUE);
names(CV7M) <- c('license','category','name','dba','address','status','milestone');
licenses <- rbind(licenses,CV7M);
rm(CV7M);
FB <- read.xls('../data/FB.xlsx',sheet=1,header=TRUE);
names(FB) <- c('license','category','name','dba','address','status','milestone');
licenses <- rbind(licenses,FB);
rm(FB);
FW <- read.xls('../data/FW.xlsx',sheet=1,header=TRUE);
names(FW) <- c('license','category','name','dba','address','status','milestone');
licenses <- rbind(licenses,FW);
rm(FW);
GOP <- read.xls('../data/GOP.xlsx',sheet=1,header=TRUE);
names(GOP) <- c('license','category','name','dba','address','status','milestone');
licenses <- rbind(licenses,GOP);
rm(GOP);
INN <- read.xls('../data/INN.xlsx',sheet=1,header=TRUE);
names(INN) <- c('license','category','name','dba','address','status','milestone');
licenses <- rbind(licenses,INN);
rm(INN);
TAV <- read.xls('../data/INN.xlsx',sheet=1,header=TRUE);
names(TAV) <- c('license','category','name','dba','address','status','milestone');
licenses <- rbind(licenses,TAV);
rm(TAV);


## CAB DATA

# Load files