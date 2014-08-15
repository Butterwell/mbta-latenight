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

# Map zipcodes for known stations
ridership$zip <- NA;
ridership$zip[ridership$station == 'Airport'] <- '02128';
ridership$zip[ridership$station == 'Alewife'] <- '02140';
ridership$zip[ridership$station == 'Andrew Square'] <- '02127';
ridership$zip[ridership$station == 'Aquarium'] <- '02110';
ridership$zip[ridership$station == 'Arlington'] <- '02476';
ridership$zip[ridership$station == 'Ashmont '] <- '02124';
ridership$zip[ridership$station == 'Back Bay'] <- '02116';
ridership$zip[ridership$station == 'Beachmont'] <- '02151';
###### TODO!! Find and replace actual zipcodes below this line!
ridership$zip[ridership$station == 'Bowdoin'] <- '00000';
ridership$zip[ridership$station == 'Boylston'] <- '00000';
ridership$zip[ridership$station == 'Braintree'] <- '00000';
ridership$zip[ridership$station == 'Broadway '] <- '00000';
ridership$zip[ridership$station == 'Central Square'] <- '00000';
ridership$zip[ridership$station == 'Charles MGH'] <- '00000';
ridership$zip[ridership$station == 'Chinatown'] <- '00000';
ridership$zip[ridership$station == 'Community College'] <- '00000';
ridership$zip[ridership$station == 'Copley Square'] <- '00000';
ridership$zip[ridership$station == 'Courthouse '] <- '00000';
ridership$zip[ridership$station == 'Davis Square'] <- '00000';
ridership$zip[ridership$station == 'Downtown Crossing'] <- '00000';
ridership$zip[ridership$station == 'Fields Corner'] <- '00000';
ridership$zip[ridership$station == 'Forest Hills '] <- '00000';
ridership$zip[ridership$station == 'Government Center'] <- '00000';
ridership$zip[ridership$station == 'Green Street '] <- '00000';
ridership$zip[ridership$station == 'Harvard'] <- '00000';
ridership$zip[ridership$station == 'Haymarket'] <- '00000';
ridership$zip[ridership$station == 'Hynes'] <- '00000';
ridership$zip[ridership$station == 'Jackson Square'] <- '00000';
ridership$zip[ridership$station == 'JFK/U Mass'] <- '00000';
ridership$zip[ridership$station == 'Kendall Square '] <- '00000';
ridership$zip[ridership$station == 'Kenmore Square'] <- '00000';
ridership$zip[ridership$station == 'Lechmere'] <- '00000';
ridership$zip[ridership$station == 'Malden Center '] <- '00000';
ridership$zip[ridership$station == 'Mass Ave'] <- '00000';
ridership$zip[ridership$station == 'Mattapan Line'] <- '00000';
ridership$zip[ridership$station == 'Maverick '] <- '00000';
ridership$zip[ridership$station == 'North Quincy'] <- '00000';
ridership$zip[ridership$station == 'North Station'] <- '00000';
ridership$zip[ridership$station == 'Oak Grove'] <- '00000';
ridership$zip[ridership$station == 'Orient Heights'] <- '00000';
ridership$zip[ridership$station == 'Park Street'] <- '00000';
ridership$zip[ridership$station == 'Porter Square '] <- '00000';
ridership$zip[ridership$station == 'Prudential'] <- '00000';
ridership$zip[ridership$station == 'Quincy Adams'] <- '00000';
ridership$zip[ridership$station == 'Quincy Center'] <- '00000';
ridership$zip[ridership$station == 'Revere Beach'] <- '00000';
ridership$zip[ridership$station == 'Riverside'] <- '00000';
ridership$zip[ridership$station == 'Roxbury Crossing '] <- '00000';
ridership$zip[ridership$station == 'Ruggles'] <- '00000';
ridership$zip[ridership$station == 'Savin Hill'] <- '00000';
ridership$zip[ridership$station == 'Science Park'] <- '00000';
ridership$zip[ridership$station == 'Shawmut'] <- '00000';
ridership$zip[ridership$station == 'South Station'] <- '00000';
ridership$zip[ridership$station == 'State Street '] <- '00000';
ridership$zip[ridership$station == 'Stony Brook'] <- '00000';
ridership$zip[ridership$station == 'Suffolk Downs'] <- '00000';
ridership$zip[ridership$station == 'Sullivan Square'] <- '00000';
ridership$zip[ridership$station == 'Symphony'] <- '00000';
ridership$zip[ridership$station == 'Tufts Medical Center'] <- '00000';
ridership$zip[ridership$station == 'Wellington '] <- '00000';
ridership$zip[ridership$station == 'Wollaston'] <- '00000';
ridership$zip[ridership$station == 'Wonderland'] <- '00000';
ridership$zip[ridership$station == 'Wood Island'] <- '00000';
ridership$zip[ridership$station == 'World Trade Center'] <- '00000';



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
licenses$location <- NA;
licenses$addedDate <- NA;
food$milestone <- NA;
food$license <- NA;
food <- data.frame(food$license,food$category,food$name,food$dba,food$address,
                   food$status,food$milestone,food$zip,food$location,food$addedDate);
names(food) <- c('license','category','name','dba','address','status','milestone',
                 'zip','location','addedDate');
licenses <- rbind(licenses,food);
rm(food);

# Convert dates to POSIX
licenses$addedDate <- as.POSIXct(strptime(licenses$addedDate, "%m/%d/%Y %I:%M:%S %p"));
# Split longitude and latitude
licenses$long <- NA;
licenses$lat <- NA;
for (i in seq_along(licenses$location)) {
  licenses$long[i] <- as.numeric(substr(strsplit(licenses$location[i],",")[[1]][1],2,12));
  licenses$lat[i] <- as.numeric(substr(strsplit(licenses$location[i],",")[[1]][2],2,
    nchar(strsplit(licenses$location[i],",")[[1]][2])-1));
}
# Purge unneeded fields
licenses <- data.frame(licenses$license,licenses$category,licenses$name,licenses$dba,
                  licenses$address,licenses$status,licenses$milestone,licenses$zip,
                  licenses$long,licenses$lat,licenses$addedDate);
names(licenses) <- c('license','category','name','dba','address','status','milestone',
                 'zip','long','lat','addedDate');


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
rm(i,tmp,endFiles);

# Merge start and end files by tripId in single data frame
print('Merging by tripId...');
cab <- merge(cabStart,cabEnd,by='tripId',all=TRUE);
rm(cabStart,cabEnd);

# Date transformations
cab$startDate <- strptime(paste(substr(as.character(cab$startDate), 1,
              nchar(as.character(cab$startDate))-5),cab$startTime),"%m/%d/%Y %H:%M:%S");
cab$endDate <- strptime(paste(substr(as.character(cab$endDate), 1,
              nchar(as.character(cab$endDate))-5),cab$endTime),"%m/%d/%Y %H:%M:%S");
# Delete unneeded fields
cab <- data.frame(cab$tripId,cab$startDate,cab$startLong,cab$startLat,cab$startZip,
                  cab$endDate,cab$endLong,cab$endLat,cab$endZip);
names(cab) <- c('tripId','startDate','startLong','startLat','startZip',
                'endDate','endLong','endLat','endZip');

# Make sure we have nice 5-digit strings as zipcodes
ridership$zip <- sprintf('%05.0f',as.numeric(as.character(ridership$zip)));
ridership$zip[ridership$zip=='000NA'] <- NA;
licenses$zip <- sprintf('%05.0f',as.numeric(as.character(licenses$zip)));
licenses$zip[licenses$zip=='000NA'] <- NA;
cab$startZip <- sprintf('%05.0f',as.numeric(as.character(cab$startZip)));
cab$startZip[cab$startZip=='000NA'] <- NA;
cab$endZip <- sprintf('%05.0f',as.numeric(as.character(cab$endZip)));
cab$endZip[cab$endZip=='000NA'] <- NA;


# Write out CSV files
print('Writing CSV files...');
write.csv(cab,'cab.csv',row.names=FALSE);
write.csv(licenses,'licenses.csv',row.names=FALSE);
write.csv(ridership,'ridership.csv',row.names=FALSE);

# Save R objects
print('Saving R objects...');
save(ridership,licenses,cab,file='lateNightT.R');

print('Done!');