/*
CREATING STATION LATITUTDE AND LONGITUDES
The latitude and longitude fields provided in the TripData table represent the GPS coordinates of the bike that was rented, not the GPS coordinates 
of the station from which it was rented. Since station information may be useful to plot on map in Tableau (when combined with aggregated trip data),
we need to calculate the latitude and longitude coordinates for each station in the dataset.
*/

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
/* 
CONSOLIDATE INFORMATION TO CREATE STATION DATA
In the TripData table, there are columns/attributes for Start Station as well as End Station. There are also Starting (and Ending) Latitude/Longitude 
coordinates for each bike ride. As mentioned above, these are the lat/long coordinates of the bike (not the station). This query creates a distinct 
list of stations and all lat/long coordinates of bikes that were rented from that station.
*/

USE GoogleCaseStudy;

CREATE TABLE #ConsolidatedStationInfo 
	(
		Station VARCHAR(max),
		Lat FLOAT,
		Long FLOAT
	);

INSERT INTO #ConsolidatedStationInfo
SELECT DISTINCT 
	start_station_name,
	start_lat,
	start_lng
FROM TripData 
UNION
SELECT DISTINCT 
	end_station_name,
	end_lat,
	end_lng
FROM TripData;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
/* 
CALCULATE AVERAGE STATION LAT/LONG
Now that we have a list station names and various lat/long coordinates associated with each station, we can calculate the average latitude and longitude 
of each bike ride (grouped by station). This will result in a list of unique stations and their lat/long coordinates. The query below creates a new 
table called Stations.
*/

SELECT 
	Station as station,
	AVG(Lat) as lat,
	AVG(Long) as long
INTO Stations
FROM #ConsolidatedStationInfo
GROUP BY Station;


--The query resulted in a list of 782 unique stations, and a latitude/longitude coordinate for each.