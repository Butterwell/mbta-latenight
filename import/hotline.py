import datetime as dt
import csv
import numpy as np

# utility for longitude, latitude in Massachusetts
zip_file_object = csv.reader(open('zipcode.csv', 'rb'))
header = zip_file_object.next()
data_zip = []
for row in zip_file_object:
	data_zip.append(row)

data_zip = np.array(data_zip)
MA = np.array([row for row in data_zip if row[2]=='MA'])

#minimum Eucliean distance to centroid of land mass of zip code
def ll2zip(longitude, latitude):
	distance = [(float(MA[i,4])-longitude)**2 + (float(MA[i,4])-latitude)**2 for i in range(MA.shape[0])]
	return MA[distance.index(min(distance)),0]



csv_file_object = csv.reader(open('../data/Mayor_s_24_Hour_Hotline__Service_Requests.csv', 'rb'))
header = csv_file_object.next()
data = []
for row in csv_file_object:
	dt_opened = dt.datetime.strptime(row[1], "%m/%d/%Y %I:%M:%S %p")
	wd = dt_opened.weekday()
	hour = dt_opened.hour
	if (dt_opened > dt.datetime(2013,03,01)):
		if (wd==4 and hour >=22) or (wd==5 and hour >=22):			
			row[1] = dt_opened.strftime("%Y %W %w")
			#print dt_opened.strftime("Friday or Saturday evening %m/%d/%Y %H:%M:%S ?")
			data.append(row)
		if (wd==5 and hour < 3) or (wd==6 and hour < 3):
			row[1] = (dt_opened-dt.timedelta(1)).strftime("%Y %W %w")
			#print dt_opened.strftime("Saturday or Sunday morning %m/%d/%Y %H:%M:%S ?")
			data.append(row)

data = np.array(data)

for row in data:
	if row[22] == "":
		row[22] = ll2zip(float(row[26]),float(row[25]))

ndays = [ (2*int(x.split(' ')[1])- (1 if x.split(' ')[2]=='5' else 0)) for x in data[:,1]]
data[:,1] = [x[1].split(' ')[0] for x in data]
#re-arrange columns into: (note, tab width: 4)
						#yearOpened,	nday,	zipcode,	longitude,	latitude,	case# - check original csv for details
data = np.column_stack(	(data[:,1], 	ndays,	data[:,22],	data[:,26],	data[:,25],	data[:,0])	)

#fk it - not elegant, don't read
for row in data:
	if row[2] == -1:
		row[1] -= 1
		row[2] = 103

open_file_object = csv.writer(open("hotline.csv", "wb"))
open_file_object.writerow(['yearOpened', 'nday','zipcode','longitude', 'latitude', 'case#'])
for row in data:
	open_file_object.writerow(row)
