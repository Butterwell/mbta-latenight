# Out and about
The purpose of this script is producing datasets containing number of events by zipcode in order to explore possible correlations between them.

## Transactions by zipcode (`txs.csv`)
This dataset contains the number of transactions per zipcode per 15-minute interval. We can use this data as a proxy for how many people were in a specific zipcode area at a given time. We will aggregate data from T station transactions and cab pick-ups and drop-offs. For simplicity, we will equate one cab transaction to one person, although we might introduce weights if we need to (maybe 1.5 people in average per ride).

There are four 15-minute windows: `00`, `15`, `30` and `45`. Since we are using the number of transactions as a proxy for the number of people at a speficic time, the following adjustments were made to the datasets:

* Train ridership: since these data are already divided in 15-minute blocks, their dates are unchanged.
* Bus ridership: no data is used (missing zipcodes or location of bus stops).
* Cab pick-ups and drop-offs: we will round them to the nearest 15-minunte interval.

####Field descriptions:

* `zip`: 5 digit string representation of the zipcode.
* `datetime`: date and time of the start of the 15-minute window. Format: `yyyy-mm-dd HH:MM:ss`.
* `tx`: number of transactions.

## Crimes by zipcode (`crime.csv`)
