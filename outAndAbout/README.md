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