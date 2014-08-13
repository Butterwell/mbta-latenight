# Import Script

This script takes the challenge dataset files from `../data`, loads them, merges them and performs some transformations to produce the three tidy datasets described below. It saves them both in an R object and in three separate CSV files.

## T Ridership dataset (`ridership.csv`)
Data is number of transactions recorded by MBTA fare gates, buses, and light rail vehicles. Only includes transactions after 10pm on Fridays and Saturdays from March 1 2013 to June 14 2014. Transactions grouped by date, route or line, and 15-minute window.

####Field descriptions:

* `datetime`: date and time of the start of the 15-minute window. Format: `yyyy-mm-dd HH:MM:ss`.
* `dateOfService`: date of the service. The date does not advance for after-midnight hours. Format: `yyyy-mm-dd`.
* `hour`: hour of the service. Values (10pm to 2am): `22`, `23`, `0`, `1` and `2`.
* `min`: 15-minute window. Values: `0`, `15`, `30` and `45`.
* `day`: day of the week of the service. As in `dateOfServie`, the day does not advance for after-midnight hours. Values: `fri` and `sat`.
* `latenight`: `0` = no late night service scheduled, `1` = late night service scheduled. This only indicates whether a route currently has late night service, not whether it had late night on that particular day.Intended to facilitate comparisons for routes whose hours were extended. Some routes will still have transactions after 1am even though they do not have extended hours, this is because their last trip is around 1am.
* `line`: line of service. Values: `Bus`, `Blue`, `Green`, `Orange`, `Red` and `Silver`.
* `station`: name of the station of service.
* `tx`: number of transactions (people that got in).

## Licensing information dataset

## Cab trips dataset