# Loads datasets
load('../import/lateNightT.R');

library(plyr);

print('Loading data...');
txCabStart <- data.frame(cab$startZip, cab$startDate, 1);
names(txCabStart) <- c('zip','datetime','tx');

print('Rounding dates...');
# round DOWN dates
txCabStart$datetime <- as.POSIXct(format(strptime("1969-12-31 19:00", "%Y-%m-%d %H:%M") +
        round(as.numeric(txCabStart$datetime)/900)*900,"%Y-%m-%d %H:%M:%S"));

txCabEnd <- data.frame(cab$endZip, cab$endDate, 1);
names(txCabEnd) <- c('zip','datetime','tx');
# round UP dates
txCabEnd$datetime <- as.POSIXct(format(strptime("1969-12-31 19:00", "%Y-%m-%d %H:%M") +
        round(as.numeric(txCabEnd$datetime)/900)*900,"%Y-%m-%d %H:%M:%S"));

# group train transactions by zipcode and date
print('Grouping trains...');
txTrain <- ddply(ridership[!is.na(ridership$zip),], c('zip','datetime'), function(df)sum(df$tx));
names(txTrain) <- c('zip','datetime','tx');

# join datasets
txs <- rbind(txTrain,txCabStart,txCabEnd);
names(txs) <- c('zip','datetime','tx');

# group again, now with all the data
print('Final grouping...');
txs <- ddply(txs, c('zip','datetime'), function(df)sum(df$tx));
names(txs) <- c('zip','datetime','tx');

# Delete unneeded data frames
rm(txCabStart,txCabEnd,txTrain);

# Write out CSV file
print('Writing CSV file...');
write.csv(txs,'outandabout.csv',row.names=FALSE);

# Save R objects
print('Saving R object...');
save(txs,file='outAndAbout.R');

print('Done!');