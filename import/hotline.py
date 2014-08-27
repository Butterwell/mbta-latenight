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
	##Fridays, Saturdays, and Sundays, after 10pm or before 3am
	#if (dt_opened > dt.datetime(2013,03,01)) and (wd in [4,5,6]) and (hour>=22 | hour <=3):
	#	#but not Friday before 3am or Sundays after 10pm
	#	if (not (wd==4 & hour<=3)) or (not (wd==6 & hour>=22)):
	#		data.append(row)
	if (dt_opened > dt.datetime(2013,03,01)):
		if (wd==4 and hour >=22) or (wd==5 and hour < 3) or (wd==5 and hour >=22) or (wd==6 and hour < 3):
			data.append(row)
data = np.array(data)


for row in data:
	row[1] = dt.datetime.strptime(row[1], "%m/%d/%Y %I:%M:%S %p").strftime("%m-%d-%Y %H:%M:%S")
	if row[22] == "":
		row[22] = ll2zip(float(row[26]),float(row[25]))
#re-arrange columns into: (note, tab width: 4)
						#datetime opened,	zipcode,	longitude,	latitude,	case# - check original csv for details
data = np.column_stack(	(data[:,1], 		data[:,22],	data[:,26],	data[:,25],	data[:,0])	)

open_file_object = csv.writer(open("hotline.csv", "wb"))
open_file_object.writerow(['opened','zipcode','longitude', 'latitude', 'case#'])
for row in data:
	open_file_object.writerow(row)
