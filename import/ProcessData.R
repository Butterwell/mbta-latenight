################################################################
# This script produces a clean dataset from the files provided #
# for the challenge                                            #
################################################################

## T RIDERSHIP DATA
print("======> LOADING T RIDERSHIP DATA");

# Load csv
ridership <- read.csv('../data/LateNight_thru_7June2014.csv', header=TRUE);
# Transform dates
ridership$scheduledate <- as.Date(ridership$scheduledate, "%m/%d/%Y");
# Delete nulls
ridership <- ridership[!is.na(ridership$scheduledate),];
# Create factors
ridership$latenightroute <- factor(ridership$latenightroute);
levels(ridership$latenightroute) <- c('N','Y');
names(ridership) <- c('dateOfService','latenight','line','station','day','hour','min','tx');
ridership$min <- ridership$min * 15
ridership$day <- factor(ridership$day);
levels(ridership$day) <- c('fri','sat');
# Datetime composition (advance day for dates after midnight)
ridership$date <- ridership$dateOfService;
ridership[ridership$hour==24,"date"] <- ridership[ridership$hour==24,"dateOfService"] + 1;
ridership[ridership$hour==25,"date"] <- ridership[ridership$hour==25,"dateOfService"] + 1;
ridership[ridership$hour==26,"date"] <- ridership[ridership$hour==26,"dateOfService"] + 1;
ridership[ridership$hour==24,"hour"] <- 0;
ridership[ridership$hour==25,"hour"] <- 1;
ridership[ridership$hour==26,"hour"] <- 2;
ridership$datetime <- as.POSIXct(strptime(paste(ridership$date,' ',ridership$hour,':',
        sprintf('%02d',ridership$min),':00',sep=''), "%Y-%m-%d %H:%M:%S"));

# Reorder fields
ridership <- data.frame(ridership$datetime, ridership$dateOfService, ridership$hour,
        ridership$min, ridership$day, ridership$latenight, ridership$line,
        ridership$station, ridership$tx);
names(ridership) <- c('datetime', 'dateOfService', 'hour', 'min', 'day', 'latenight',
                      'line', 'station', 'tx');



## LICENSES
print("======> LOADING LICENSING DATA");

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
food <- read.csv('../data/CityOfBoston_Active_Food_Establishment_Licenses.csv',
                 header=TRUE);
names(food) <- c('name', 'dba', 'address', 'city','state','zip','status','category',
                 'description','addedDate','dayPhone','propertyId','location');
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
food <- data.frame(food$license,food$category,food$name,food$dba,food$address,
                   food$status,food$milestone,food$zip,food$city,food$state,
                   food$dayPhone,food$propertyId,food$location,food$addedDate,
                   food$description);
names(food) <- c('license','category','name','dba','address','status','milestone',
                 'zip','city','state','dayPhone','propertyId','location','addedDate',
                 'description');
licenses <- rbind(licenses,food);
rm(food);


## CAB DATA
print("======> LOADING CAB DATA");

# Load start files
startFiles <- list.files(path = "../data", pattern = "^Start", all.files = FALSE,
                         full.names = FALSE, recursive = FALSE,
                         ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE);
cabStart <- NA;
for (i in seq_along(startFiles)) {
  print(paste("Processing file", startFiles[i],"..."));
  tmp <- read.csv(paste('../data',startFiles[i],sep="/"),header=TRUE);
  names(tmp) <- c('tripId','startLong','startLat','startDate','startTime','startZip');
  if (is.na(cabStart)) {
    cabStart <- tmp;
  }
  else {
    cabStart <- rbind(cabStart,tmp);
  }
}

rm(startFiles);



# Load end files
endFiles <- list.files(path = "../data", pattern = "^End", all.files = FALSE,
                       full.names = FALSE, recursive = FALSE,
                       ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE);
cabEnd <- NA;
for (i in seq_along(endFiles)) {
  print(paste("Processing file", endFiles[i],"..."));
  tmp <- read.csv(paste('../data',endFiles[i],sep="/"),header=TRUE);
  names(tmp) <- c('tripId','endLong','endLat','endDate','endTime','endZip');
  if (is.na(cabEnd)) {
    cabEnd <- tmp;
  }
  else {
    cabEnd <- rbind(cabEnd,tmp);
  }
}
rm(i);
rm(tmp);
rm(endFiles);

# Merge start and end files by tripId in single data frame
print('Merging by tripId...');
cab <- merge(cabStart,cabEnd,by='tripId',all=TRUE);
rm(cabStart);
rm(cabEnd);

# Date transformations
cab$startDate <- as.Date(substr(as.character(cab$startDate), 1,
                                nchar(as.character(cab$startDate))-5),"%m/%d/%Y");
cab$endDate <- as.Date(substr(as.character(cab$endDate), 1,
                                nchar(as.character(cab$endDate))-5),"%m/%d/%Y");

# Write out CSV files
print('Writing CSV files...');
write.csv(cab,'cab.csv',row.names=FALSE);
write.csv(licenses,'licenses.csv',row.names=FALSE);
write.csv(ridership,'ridership.csv',row.names=FALSE);

# Save R objects
print('Saving R objects...');
save(ridership,licenses,cab,file='lateNightT.R');

print('Done!');