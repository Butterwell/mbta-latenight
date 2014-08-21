################################################################
# This script produces a clean dataset from the City of Boston #
# crime dataset found at http://data.cityofboston.gov          #
################################################################

# Load dataset
print('Importing data...');
unzip('../data/crime.zip', exdir='../data')
crime <- read.csv('../data/Crime_Incident_Reports.csv', header=TRUE);

# Convert date
crime$FROMDATE <- as.POSIXlt(strptime(crime$FROMDATE,"%m/%d/%Y %I:%M:%S %p"));
# Filter out entries prior to 2013-03-01 or after 2014-06-1 and not on weekend nights
crime <- crime[crime$FROMDATE >= as.POSIXct(strptime("2013-03-01", "%Y-%m-%d")) &
            crime$FROMDATE <= as.POSIXct('2014-06-02','%Y-%m-%d') ,];
crime <- crime[!is.na(crime$COMPNOS),];
crime$hour <- crime$FROMDATE[['hour']];
crime <- crime[crime$hour %in% c(22,23,0,1,2,3),];

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


# Delete unneeded fields
crime <- data.frame(crime$INCIDENT_TYPE_DESCRIPTION,crime$FROMDATE,crime$hour,crime$WEAPONTYPE,
    crime$Shooting,crime$DOMESTIC,crime$long,crime$lat,crime$zip);
names(crime) <- c('type','datetime','hour','weaponType','shooting','domestic','long','lat','zip');
crime$datetime <- as.POSIXlt(crime$datetime);

# Bring records after midnight to previous day
crime[crime$hour %in% c(0,1,2,3),'datetime'] <- crime[crime$hour %in% c(0,1,2,3),'datetime'] - (24*60*60);
crime$wday <- crime$datetime[['wday']];
crime <- crime[crime$wday %in% c(5,6),];
crime$wday <- as.factor(crime$wday);
levels(crime$wday) <- c('fri','sat');
crime$hour[crime$hour %in% c(0,1,2,3)] <- crime$hour[crime$hour %in% c(0,1,2,3)] + 24;
crime$year <- crime$datetime[['year']];
crime$year <- as.factor(crime$year);
levels(crime$year) <- c('2013', '2014');

# Calculate day number
crime$nday <- NA;
crime$nday[crime$wday == 'fri' & crime$year == '2013'] <- as.integer(((crime$datetime[
    crime$wday == 'fri' & crime$year == '2013'][['yday']]-3)*2/7)+1);
crime$nday[crime$wday == 'sat' & crime$year == '2013'] <- as.integer(((crime$datetime[
    crime$wday == 'sat' & crime$year == '2013'][['yday']]-3)*2/7)+2);
crime$nday[crime$wday == 'fri' & crime$year == '2014'] <- as.integer(((crime$datetime[
    crime$wday == 'fri' & crime$year == '2014'][['yday']]-2)*2/7)+1);
crime$nday[crime$wday == 'sat' & crime$year == '2014'] <- as.integer(((crime$datetime[
    crime$wday == 'sat' & crime$year == '2014'][['yday']]-2)*2/7)+2);

# group transactions
print('Grouping...');
crime <- data.frame(crime$zip, crime$year, crime$nday, crime$wday, crime$hour);
names(crime) <- c('zip','year','nday','wday','hour');
crime$events <- 1;
crime <- ddply(crime, c('zip','year','nday'), function(df)sum(df$events));
names(crime) <- c('zip','year','nday','events');

# Delete unneeded data frames
rm(getClosestZip,zipcodes);

# Write out CSV file
print('Writing CSV file...');
write.csv(crime,'crime.csv',row.names=FALSE);

# Save R objects
print('Saving R objects...');
save(crime,file='crime.R');

# Remove temp variables
rm(getClosestZip,zipcodes);
print('Done!');