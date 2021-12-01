--CLEANING THE DATA

USE GoogleCaseStudy;
-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
CHECK FOR (AND REMOVE) NON-UNIQUE RECORDS:
The ride_id field should be a unique data attribute for each record. If the same ride_id is used across multiple records, the ID is not unique and it
is impossible to know which record accurately represents the bike ride. Records that use the same ride_id should be removed from the dataset. 
*/

SELECT
	COUNT(ride_id),
	COUNT(DISTINCT ride_id),
	COUNT(ride_id) - COUNT(DISTINCT ride_id) as diff --Identified over 600 ride IDs used more than once
FROM TripData;

/*
Used a CTE to count how many times a specific ride_id appeared in the dataset. If a ride_id appeared more than once (i.e., row number is greater than or 
equal to 2), then the ride_id is a duplicate and records using that ride_id should be removed from the TripData table.
*/

WITH Duplicates AS 
	(
	SELECT
		ride_id,
		ROW_NUMBER() OVER (PARTITION BY ride_id ORDER BY ride_id) as rn
	FROM TripData
	)

DELETE FROM TripData
WHERE ride_id IN 
	(
		SELECT ride_id FROM Duplicates
		WHERE rn = 2
	);

-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*REMOVE UNUSABLE RECORDS:
After performing an initial review of the TripData table, I identified a number of records which should not be included in analysis/visualizations, including:
	1) Trips with negative ride durations (negative ride times are not possible)
	2) Trips that lasted less than 1 minute (ride times less than 1 minute may not have been real rides)
		- Note: In a real-world scenario, I would have consulted with internal team members to determine if 1 minute was an appropriate number to use
			to determine if a ride was "real" or not.
	3) Trips where the start/end bike station name included "test" (test records should not be used to make business decisions and should be deleted)
		- Note: There is a legitimate station named 'Watson Testing - Divvy'. Even though its name includes the word 'test', it should be kept in the dataset.
*/

SELECT COUNT(*) FROM TripData WHERE duration_sec < 0; -- about 3,000 records
SELECT COUNT(*) FROM TripData WHERE duration_sec BETWEEN 0 AND 59; -- about 80,000 records 
SELECT * FROM TripData WHERE 
	start_station_name NOT LIKE 'WATSON TESTING - DIVVY' AND 
	((start_station_name LIKE '%TEST%' OR start_station_name LIKE '%test%') OR
	(end_station_name LIKE '%TEST%' OR end_station_name LIKE '%test%')); -- about 100 records 

DELETE FROM TripData
WHERE duration_sec < 60;

DELETE FROM TripData
WHERE 
	start_station_name NOT LIKE 'WATSON TESTING - DIVVY' AND 
	((start_station_name LIKE '%TEST%' OR start_station_name LIKE '%test%') OR
	(end_station_name LIKE '%TEST%' OR end_station_name LIKE '%test%'));


-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHECK FOR (AND UPDATE) NULLS
Used a CASE statement to count the number of null values in the dataset. I used " ='' " (instead of "IS NULL") because IS NULL returned 0 null values 
across the entire dataset (which I knew was incorrect). It turns out that the empty values in this dataset must be empty strings (vs nulls). Using the =''
operater returns both NULL values as well as emptry string values.
*/

SELECT
	COUNT(CASE WHEN ride_id ='' THEN 1 ELSE NULL END) as id_null,
	COUNT(CASE WHEN rideable_type ='' THEN 1 ELSE NULL END) as type_null,
	COUNT(CASE WHEN started_at ='' THEN 1 ELSE NULL END) as start_time_null,
	COUNT(CASE WHEN ended_at ='' THEN 1 ELSE NULL END) as end_time_null,
	COUNT(CASE WHEN start_station_name ='' THEN 1 ELSE NULL END) as start_station_null,
	COUNT(CASE WHEN start_station_id ='' THEN 1 ELSE NULL END) as start_id_null,
	COUNT(CASE WHEN end_station_name ='' THEN 1 ELSE NULL END) as end_station_null,
	COUNT(CASE WHEN end_station_id ='' THEN 1 ELSE NULL END) as end_id_null,
	COUNT(CASE WHEN start_lat ='' THEN 1 ELSE NULL END) as start_lat_null,
	COUNT(CASE WHEN start_lng ='' THEN 1 ELSE NULL END) as start_lng_null,
	COUNT(CASE WHEN end_lat ='' THEN 1 ELSE NULL END) as end_lat_null,
	COUNT(CASE WHEN end_lng ='' THEN 1 ELSE NULL END) as end_lng_null,
	COUNT(CASE WHEN member_casual ='' THEN 1 ELSE NULL END) as member_casual_null
FROM
TripData;

/*
Over 500,000 records are missing start/end station names. Those same records are also missing station IDs. (If they did contain station IDs, the station
names could be populated using a JOIN statement with Station ID being the join key.) Latitude and longitude coordinates could be used to identify the station
name; however, when a station name is missing, the lat/long coordinates are only accurate to 2 decimal places (would need at least 5 or 6 decimal places 
to find a specific station location).

The best course of action here is to keep these records in the dataset, but update missing station names to 'Unknown'.
*/

UPDATE TripData
SET start_station_name = 'Unknown'
WHERE start_station_name ='';

UPDATE TripData
SET end_station_name = 'Unknown'
WHERE end_station_name ='';
