# Aggregate all datasets in one and analize possible correlations

load('txs.R');
load('crime.R');
library(plyr);
ems <- read.csv('../import/EMSDaily.csv',header=T);
hotline <- read.csv('../import/hotline.csv',header=T);
names(hotline) <- c('year','nday','complaints');
hotline$events <- 1;

# Aggregate by zipcode
hotline <- ddply(hotline,c('year','nday'),function(df)sum(df$events));
names(hotline) <- c('year','nday','complaints');
txs <- ddply(txs, c('year','nday'), function(df)sum(df$tx));
names(txs) <- c('year','nday','people');
crime <- ddply(crime, c('year','nday'), function(df)sum(df$events));
names(crime) <- c('year','nday','crime');

# Merge datasets
merged <- merge(txs,crime, by=c('year','nday'),all.x=T);
merged <- merge(merged,ems,by=c('year','nday'),all.x=T);
merged <- merge(merged,hotline,by=c('year','nday'),all.x=T);

# Comparing variables
# Split and re-join by year
m2013 <- merged[merged$year == 2013,];
m2014 <- merged[merged$year == 2014,];
merged <- merge(m2013, m2014, by='nday',all=F);
merged <- data.frame(merged$nday, merged$people.x, merged$people.y,
      merged$crime.x, merged$crime.y, merged$incidents.x, merged$incidents.y,
      merged$complaints.x, merged$complaints.y);
names(merged) <- c('nday','people2013','people2014','crime2013','crime2014',
    'emergencies2013','emergencies2014','complaints2013','complaints2014');
 
# Delete entries prior to weekend of 3/28 (late night T started)
merged <- merged[merged$nday >= 25,];

# Delete outlier (point #7)
merged <- merged[c(1:6,8:20),];
      
# Plot differential in people vs. differential in crime
library(ggplot2);
compCrime <- data.frame(merged$people2014-merged$people2013,merged$crime2014-merged$crime2013);
names(compCrime) <- c('peopleIncrease','crimeIncrease');
png(filename='compCrime.png',width=600,height=600);
ggplot(compCrime, aes(x=peopleIncrease, y=crimeIncrease)) + geom_point() + stat_smooth(method="lm");
dev.off();

# Plot differential in people vs. differential in emergencies
compEmergencies <- data.frame(merged$people2014-merged$people2013,merged$emergencies2014-merged$emergencies2013);
names(compEmergencies) <- c('peopleIncrease','emergenciesIncrease');
png(filename='compEmergencies.png',width=600,height=600);
ggplot(compEmergencies, aes(x=peopleIncrease, y=emergenciesIncrease)) + geom_point() + stat_smooth(method="lm");
dev.off();

# Plot differential in people vs. differential in crime
compComplaints <- data.frame(merged$people2014-merged$people2013,merged$complaints2014-merged$complaints2013);
names(compComplaints) <- c('peopleIncrease','hotlineIncrease');
png(filename='compComplaints.png',width=600,height=600);
ggplot(compComplaints, aes(x=peopleIncrease, y=hotlineIncrease)) + geom_point() + stat_smooth(method="lm");
dev.off();

# Write out CSV file
print('Writing CSV file...');
write.csv(merged,'merged.csv',row.names=FALSE);

# Save R objects
print('Saving R object...');
save(merged,file='merged.R');

print('Done!');