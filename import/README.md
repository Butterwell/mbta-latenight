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
* `zip`: zipcode (only for T stations, `NA` otherwise).

## Licensing information dataset (`licenses.csv`)
List of food and alcohol related licenses.

####Field descriptions:

* `license`: license number. Not available (`NA`) for food establishments (types `FT` and `FS`).
* `category`: category of the establishment:
  * `CV7MW`: Common Victualler License with Malt & Wines
  * `CV7MWR`: Restricted Common Victualler License with Malt & Wines
  * `CV7MWA`: Airport Common Victualler License with Malt & Wines
  * `CV7MWLA`: Common Victualler License with Malt, Wines & Liqueurs
  * `CV7MWLR`: Restricted Common Victualler License with Malt, Wines & Liqueurs
  * `CV7MWLA`: Airport Common Victualler with Malt, Wines & Liqueurs
  * `CV7AL`: Common Victualler License with All Alcoholic Beverages
  * `CV7ALR`: Restricted Common Victualler License with All Alcoholic Beverages
  * `CV7ALA`: Airport Common Victualler License with All Alcoholic Beverages
  * `GOPAL`: General on Premise License with All Alcoholic Beverages
  * `GOPALR`: Restricted General on Premise License with All Alcoholic Beverages
  * `GOPMW`: General on Premise License with Malt & Wines
  * `TAVAL`: Tavern All Alcoholic Beverages License
  * `TAVMW`: Tavern Malt and Wines License
  * `INNMW`: Innholders License with Malt & Wines
  * `INNAL`: Innholders License with All Alcoholic Beverages
  * `INNALR`: Restricted Innholders License with All Alcoholic Beverages
  * `FW`: Farmer Winery License
  * `FB`: Farmer Brewers License
  * `CLBALA`: Airport Club License with All Alcoholic Beverages
  * `CLBAL`: Club License with All Alcoholic Beverages
  * `CLBALR`: Restricted Club License with All Alcoholic Beverages
  * `CLBMW`: Club License with Malt & Wines
  * `CLBMWR`: Restricted Club License with Malt & Wines
  * `CLBMWA`: Airport Club License with Malt & Wines
  * `CLBALV`: Veterans Club License with All Alcoholic Beverages
  * `FT`: Food with takeout
  * `FS`: Food without takeout
* `name`: business name.
* `dba`: doing business as.
* `address`: establishment's address.
* `status`: status of the license. It can be either `Active`, `Inactive` or `Void`.
* `milestone`: milestone of the licensing process. It can be `Intake`, `Renewal`, `Waiting`, `Board Vote` and `Pay Fees`. Not available (`NA`) for food establishments (types `FT` and `FS`).
* `zip`: zipcode.
* `long`: longitude. Only for food establishments (types `FT` and `FS`).
* `lat`: latitude. Only for food establishments (types `FT` and `FS`).
* `addedDate`: date the license was added. Only for food establishments (types `FT` and `FS`). Format: `yyyy-mm-dd HH:MM:ss`.

## Cab trips dataset (`cab.csv`)
Information about cab trips with times and pick-up and drop-off locations (except for residential areas, where only the zipcode is available). This file was too big. Instead of making it part of the repository, a zipped version can be downloaded [here](https://s3.amazonaws.com/dl-bucket/mbta-latenightT/cab.zip) (60MB).

####Field descriptions
* `tripId`: unique idientifier for the trip.
* `startDate`: pick-up date and time. Format: `yyyy-mm-dd HH:MM:ss`.
* `startLong`: pick-up location's longitude.
* `startLat`: pick-up location's latitude.
* `startZip`: pick-up zipcode.
* `endDate`: drop-off date and time. Format: `yyyy-mm-dd HH:MM:ss`.
* `endLong`: drop-off location's longitude.
* `endLat`: drop-off location's latitude.
* `endZip`: drop-off zipcode.