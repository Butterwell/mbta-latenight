# Aggregate all datasets in one and analize possible correlations

load('txs.R');
load('crime.R');
library(plyr);
ems <- read.csv('../import/EMSDaily.csv',header=T);
hotline <- read.csv('../import/hotline.csv',header=T);
names(hotline) <- c('year','nday','complaints');
hotline$events <- 1;
hotline <- ddply(hotline,c('year','nday'),function(df)sum(df$events));

merged <- merge(txs,crime, by=c('zip','year','nday'),all.x=T);
merged <- merge(merged,ems,by=c('year','nday'),all.x=T);
merged <- merge(merged,hotline,by=c('year','nday'),all.x=T);


names(merged) <- c('year','nday','zip','people','crime','emergencies','complaints');

# Write out CSV file
print('Writing CSV file...');
write.csv(merged,'merged.csv',row.names=FALSE);

# Save R objects
print('Saving R object...');
save(merged,file='merged.R');

# Comparing variables
# Split and re-join by year
m2013 <- merged[merged$year == 2013,];
m2014 <- merged[merged$year == 2014,];
merged <- merge(m2013, m2014, by=c('nday','zip'),all=F);
merged <- data.frame(merged$nday, merged$zip, merged$people.x, merged$people.y,
      merged$crime.x, merged$crime.y, merged$emergencies.x, merged$emergencies.y,
      merged$complaints.x, merged$complaints.y);
names(merged) <- c('nday','zip','people2013','people2014','crime2013','crime2014',
      'emergencies2013','emergencies2014','complaints2013','complaints2014');
 
# Delete entries prior to weekend of 3/28 (late night T started)
merged <- merged[merged$nday >= 25,];
 
# Aggregate by zipcode
mzip <- ddply(merged, 'nday', c(function(df)sum(df$people2013),function(df)sum(df$people2014),
        function(df)sum(df$crime2013,na.rm=T),function(df)sum(df$crime2014,na.rm=T),
        function(df)sum(df$emergencies2013,na.rm=T),function(df)sum(df$emergencies2014,na.rm=T),
        function(df)sum(df$complaints2013,na.rm=T),function(df)sum(df$complaints2014,na.rm=T)));
names(mzip) <- c('nday','people2013','people2014','crime2013','crime2014',
      'emergencies2013','emergencies2014','complaints2013','complaints2014');

# Delete outlier (point #7)
mzip <- mzip[c(1:6,8:20),];
      
# Plot differential in people vs. differential in crime
library(ggplot2);
compCrime <- data.frame(mzip$people2014-mzip$people2013,mzip$crime2014-mzip$crime2013);
names(compCrime) <- c('peopleIncrease','crimeIncrease');
png(filename='compCrime.png',width=600,height=600);
ggplot(compCrime, aes(x=peopleIncrease, y=crimeIncrease)) + geom_point() + stat_smooth(method="lm");
dev.off();

# Plot differential in people vs. differential in emergencies
compEmergencies <- data.frame(mzip$people2014-mzip$people2013,mzip$emergencies2014-mzip$emergencies2013);
names(compEmergencies) <- c('peopleIncrease','emergenciesIncrease');
png(filename='compEmergencies.png',width=600,height=600);
ggplot(compEmergencies, aes(x=peopleIncrease, y=emergenciesIncrease)) + geom_point() + stat_smooth(method="lm");
dev.off();

# Plot differential in people vs. differential in crime
compComplaints <- data.frame(mzip$people2014-mzip$people2013,mzip$complaints2014-mzip$complaints2013);
names(compComplaints) <- c('peopleIncrease','hotlineIncrease');
png(filename='compComplaints.png',width=600,height=600);
ggplot(compComplaints, aes(x=peopleIncrease, y=hotlineIncrease)) + geom_point() + stat_smooth(method="lm");
dev.off();

print('Done!');