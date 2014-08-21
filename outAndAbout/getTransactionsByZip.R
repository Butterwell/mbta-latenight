################################################################
# This script aggregates the transactions from T and cab by    #
# 1-hour timeslots and zipcode (Friday and Saturday nights)    #
################################################################

# Loads datasets
load('../import/lateNightT.R');

library(plyr);

print('Loading data...');
txCabStart <- data.frame(cab$startZip, cab$startDate, 1);
names(txCabStart) <- c('zip','datetime','tx');
txCabStart <- txCabStart[!is.na(txCabStart$zip) & !is.na(txCabStart$datetime),];
txCabEnd <- data.frame(cab$endZip, cab$endDate, 1);
names(txCabEnd) <- c('zip','datetime','tx');
txCabEnd <- txCabEnd[!is.na(txCabEnd$zip) & !is.na(txCabEnd$datetime),];
txTrain <- data.frame(ridership$zip, ridership$datetime, ridership$tx);
names(txTrain) <- c('zip','datetime','tx');
txTrain <- txTrain[!is.na(txTrain$zip) & !is.na(txTrain$datetime),];

# join datasets
print('Joining datasets...');
txs <- rbind(txTrain,txCabStart,txCabEnd);
names(txs) <- c('zip','datetime','tx');

# Convert dates to POSIXlt
txs$datetime <- as.POSIXlt(txs$datetime);

# Filter out txs not in weekend nights and out of range (3/1/2013-6/1/2014)
print('Adjusting dates and filtering...');
txs <- txs[txs$datetime >= as.POSIXct('2013-03-01','%Y-%m-%d') &
            txs$datetime <= as.POSIXct('2014-06-02','%Y-%m-%d'),];
txs$hour <- txs$datetime[['hour']];
txs <- txs[txs$hour %in% c(22,23,0,1,2,3),];


# Bring records after midnight to previous day
txs[txs$hour %in% c(0,1,2,3),'datetime'] <- txs[txs$hour %in% c(0,1,2,3),'datetime'] - (24*60*60);
txs$wday <- txs$datetime[['wday']];
txs <- txs[txs$wday %in% c(5,6),];
txs$zip <- as.factor(txs$zip);
txs$wday <- as.factor(txs$wday);
levels(txs$wday) <- c('fri','sat');
txs$hour[txs$hour %in% c(0,1,2,3)] <- txs$hour[txs$hour %in% c(0,1,2,3)] + 24;
txs$year <- txs$datetime[['year']];
txs$year <- as.factor(txs$year);
levels(txs$year) <- c('2013', '2014');


# Calculate day number
txs$nday <- NA;
txs$nday[txs$wday == 'fri' & txs$year == '2013'] <- as.integer(((txs$datetime[
    txs$wday == 'fri' & txs$year == '2013'][['yday']]-3)*2/7)+1);
txs$nday[txs$wday == 'sat' & txs$year == '2013'] <- as.integer(((txs$datetime[
    txs$wday == 'sat' & txs$year == '2013'][['yday']]-3)*2/7)+2);
txs$nday[txs$wday == 'fri' & txs$year == '2014'] <- as.integer(((txs$datetime[
    txs$wday == 'fri' & txs$year == '2014'][['yday']]-2)*2/7)+1);
txs$nday[txs$wday == 'sat' & txs$year == '2014'] <- as.integer(((txs$datetime[
    txs$wday == 'sat' & txs$year == '2014'][['yday']]-2)*2/7)+2);

# group transactions
print('Grouping...');
txs <- data.frame(txs$zip, txs$year, txs$nday, txs$wday, txs$hour, txs$tx);
names(txs) <- c('zip','year','nday','wday','hour','tx');
txs <- ddply(txs, c('zip','year','nday'), function(df)sum(df$tx));
names(txs) <- c('zip','year','nday','tx');


# Delete unneeded data frames
rm(txCabStart,txCabEnd,txTrain,cab,licenses,ridership);

# Write out CSV file
print('Writing CSV file...');
write.csv(txs,'txs.csv',row.names=FALSE);

# Save R objects
print('Saving R object...');
save(txs,file='txs.R');

print('Done!');