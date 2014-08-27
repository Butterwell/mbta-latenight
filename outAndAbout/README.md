# Out and about
The purpose of this script is producing datasets containing number of events by zipcode in order to explore possible correlations between them.

## Transactions by zipcode (`txs.csv`)
This dataset contains the number of transactions per zipcode per day. We can use this data as a proxy for how many people were in a specific zipcode area in a specific night. We will aggregate data from T station transactions and cab pick-ups and drop-offs. For simplicity, we will equate one cab transaction to one person, although we might introduce weights if we need to (maybe 1.5 people in average per ride).

####Field descriptions:

* `zip`: 5 digit string representation of the zipcode.
* `year`: year.
* `nday`: day number in the year, only counting Fridays and Saturdays (i.e.: the first Friday of the year is day #1, the following Saturday #2, the following week's Friday #3 and so on).
* `tx`: number of transactions. Includes transactions from 10 pm until 4 am of the following day.

## Crimes by zipcode (`crime.csv`)
This dataset contains the number of crime events reported per zipcode per day.

####Field descriptions:

* `zip`: 5 digit string representation of the zipcode.
* `year`: year.
* `nday`: day number in the year, only counting Fridays and Saturdays (i.e.: the first Friday of the year is day #1, the following Saturday #2, the following week's Friday #3 and so on).
* `events`: number of reported events. Includes events from 10 pm until 4 am of the following day.

## Merged dataset (`merged.csv`)
This dataset merges the transport data, crime, ems and hotline reports into a single dataset. It groups the fields by zipcode, year and day. The EMS data is for the whole weekend (repeats values), and does not vary by zipcode either.

####Field descriptions:

* `year`: year.
* `nday`: day number in the year, only counting Fridays and Saturdays (i.e.: the first Friday of the year is day #1, the following Saturday #2, the following week's Friday #3 and so on).
* `zip`: 5 digit string representation of the zipcode.
* `people`: proxy for number of people in the area. Based on the transportation dataset.
* `crime`: crime events.
* `emergencies`: number of emergencies for the whole weekend and region.
* `complaints`: number of complaints, based on the Mayor's hotline dataset.

