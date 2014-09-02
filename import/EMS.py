import datetime as dt
import csv
import numpy as np

csv_file_object = csv.reader(open('../data/EMS.csv', 'rb'))
header = csv_file_object.next()
data = []
for row in csv_file_object:
	data.append(row)

data = np.array(data)

for row in data:
	row[0] = dt.datetime.strptime(row[0].split('-')[0], "%m/%d/%y").strftime("%Y %W %w")

data = np.c_[ [x.split(' ')[0] for x in data[:,0]], [str(2*int(x.split(' ')[1])-1) for x in data[:,0]], data[:,1]]

open_file_object = csv.writer(open("EMS.csv", "wb"))
open_file_object.writerow(['year', 'nday', 'emergencyResponses'])
for row in data:
	open_file_object.writerow(row)
