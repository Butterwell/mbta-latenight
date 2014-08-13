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
# Extract zip codes
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}
licenses$zip <- substrRight(as.character(licenses$address), 5);
rm(substrRight);

# Food establishments
food <- read.csv('../data/CityOfBoston_Active_Food_Establishment_Licenses.csv',header=TRUE);
names(food) <- c('name', 'dba', 'address', 'city','state','zip','status','category','description','addedDate','dayPhone','propertyId','location');
food$address <- paste(food$address,food$city,food$state,food$zip);
licenses$city <- NA;
licenses$state <- NA;
licenses$dayPhone <- NA;
licenses$propertyId <- NA;
licenses$location <- NA;
licenses$addedDate <- NA;
licenses$description <- NA;
food$milestone <- NA;
food$license <- NA;
food <- data.frame(food$license,food$category,food$name,food$dba,food$address,food$status,food$milestone,food$zip,food$city,food$state,food$dayPhone,food$propertyId,food$location,food$addedDate,food$description);
names(food) <- c('license','category','name','dba','address','status','milestone','zip','city','state','dayPhone','propertyId','location','addedDate','description');
licenses <- rbind(licenses,food);
rm(food);


## CAB DATA

# Load files
