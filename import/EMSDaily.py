import datetime as dt
import csv
import numpy as np

csv_file_object = csv.reader(open('../data/EMSDaily.csv', 'rb'))
header = csv_file_object.next()
data = []
for row in csv_file_object:
	data.append(row)

data = np.array(data)

for row in data:
	row[0] = dt.datetime.strptime(row[0], "%m/%d/%Y").strftime("%Y %W %w")

years = [x.split(' ')[0] for x in data[:,0]]
ndays = [ (2*int(x.split(' ')[1])- (1 if x.split(' ')[2]=='5' else 0)) for x in data[:,0]]
incidents = data[:,1]
data = np.c_[ years, ndays, incidents ]

open_file_object = csv.writer(open("EMSDaily.csv", "wb"))
open_file_object.writerow(['year', 'nday', 'incidents'])
for row in data:
	open_file_object.writerow(row)
