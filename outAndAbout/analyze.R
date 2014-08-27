# Aggregate all datasets in one and analize possible correlations

load('txs.R');
load('crime.R');
ems <- read.csv('../import/EMS.csv',header=T);

merged <- merge(txs,crime, by=c('zip','year','nday'),all.x=T);
merged <- merge(merged,ems,by=c('year','nday'),all.x=T);

names(merged) <- c('year','nday','zip','people','crime','emergencies');

# Write out CSV file
print('Writing CSV file...');
write.csv(merged,'merged.csv',row.names=FALSE);

# Save R objects
print('Saving R object...');
save(merged,file='merged.R');

print('Done!');