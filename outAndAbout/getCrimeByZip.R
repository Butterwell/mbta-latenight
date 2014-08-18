################################################################
# This script produces a clean dataset from the City of Boston #
# crime dataset found at http://data.cityofboston.gov          #
################################################################

# Load dataset
print('Importing data...');
unzip('../data/crime.zip', exdir='../data')
crime <- read.csv('../data/Crime_Incident_Reports.csv', header=TRUE);

# Convert date
crime$FROMDATE <- as.POSIXct(strptime(crime$FROMDATE,"%m/%d/%Y %I:%M:%S %p"));
# Filter out entries prior to 2013-03-01
crime <- crime[crime$FROMDATE >= as.POSIXct(strptime("2013-03-01", "%Y-%m-%d")),];
crime <- crime[!is.na(crime$COMPNOS),];
# Limit to just weekend
crime <- crime[crime$DAY_WEEK == 'Friday' | crime$DAY_WEEK == 'Saturday' | crime$DAY_WEEK == 'Sunday',];

# Split longitude and latitude
print('Splitting longitude and latitude...');
crime$long <- NA;
crime$lat <- NA;
for (i in seq_along(crime$Location)) {
  crime$lat[i] <- as.numeric(substr(strsplit(as.character(crime$Location[i]),",")[[1]][1],2,12));
  crime$long[i] <- as.numeric(substr(strsplit(as.character(crime$Location[i]),",")[[1]][2],2,
    nchar(strsplit(as.character(crime$Location[i]),",")[[1]][2])-1));
}
rm(i);

# Obtain zipcodes from long/lat (estimation by closeness to zip centroids)
print('Mapping zipcodes by proximity...');
zipcodes <- read.csv('../data/zipcode.csv',header=TRUE);
zipcodes <- zipcodes[zipcodes$state == 'MA',c(4,5,1)];

getClosestZip <- function(lat,long) {

    temp <- zipcodes;
    temp$latitude <- temp$latitude - lat;
    temp$longitude <- temp$longitude - long;
    temp$dif <- temp$latitude^2 + temp$longitude^2;
    return(temp[which.min(temp$dif),3]);
}

crime$zip <- NA;
for (i in 1:dim(crime)[1]) {
    crime$zip[i] <- getClosestZip(crime$lat[i],crime$long[i]);
}
rm(i);

# Make sure we have nice 5-digit strings as zipcodes
crime$zip <- sprintf('%05.0f',as.numeric(as.character(crime$zip)));
crime$zip[crime$zip=='000NA'] <- NA;

# round DOWN dates to 15-minute intervals
crime$FROMDATE <- as.POSIXct(format(strptime("1969-12-31 19:00", "%Y-%m-%d %H:%M") +
        round(as.numeric(crime$FROMDATE)/900)*900,"%Y-%m-%d %H:%M:%S"));

# Delete unneeded fields
crime <- data.frame(crime$INCIDENT_TYPE_DESCRIPTION,crime$FROMDATE,crime$WEAPONTYPE,
    crime$Shooting,crime$DOMESTIC,crime$long,crime$lat,crime$zip);
names(crime) <- c('type','datetime','weaponType','shooting','domestic','long','lat','zip');


# Write out CSV file
print('Writing CSV file...');
write.csv(crime,'crime.csv',row.names=FALSE);

# Save R objects
print('Saving R objects...');
save(crime,file='crime.R');

# Remove temp variables
rm(getClosestZip,zipcodes);
print('Done!');