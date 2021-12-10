--ANALYZING THE DATA

USE GoogleCaseStudy;

----------------------------------------------------------------------------------------------------------------------------------------------------
/*
INITIAL SUMMARY STATISTICS
Reviewed average/max/min durations (in minutes and days) as well as the total number of rides for each member type ('member' and 'casual' riders).
to glean some quick insights from the data.
*/

SELECT
	member_casual as member_type,
	COUNT(ride_id) as number_of_trips,
	AVG(duration_min) as avg_duration_min,
	AVG(duration_min)/1440 as avg_duration_days,
	MAX(duration_min) as max_duration_min,
	MAX(duration_min)/1440 as max_duration_days,
	MIN(duration_min) as min_duration_min,
	MIN(duration_min)/1440 as min_duration_days
FROM TripData
GROUP BY member_casual;


----------------------------------------------------------------------------------------------------------------------------------------------------
/*
CALCULATING PERCENT DIFFERENCE IN MEMBERSHIP TYPES
The query below showed that there were over 400,000 more Member rides than there were Casual rides (about 8% more).
*/

SELECT
	COUNT(CASE WHEN member_casual LIKE 'member' THEN ride_id END) as num_of_member_rides,
	COUNT(CASE WHEN member_casual LIKE 'casual' THEN ride_id END) as num_of_casual_rides,
	COUNT(CASE WHEN member_casual LIKE 'member' THEN ride_id END) - COUNT(CASE WHEN member_casual LIKE 'casual' THEN ride_id END) as diff,
	COUNT(ride_id) as total_rides,
	(CAST(COUNT(CASE WHEN member_casual LIKE 'member' THEN ride_id END) as FLOAT) - COUNT(CASE WHEN member_casual LIKE 'casual' THEN ride_id END)) / COUNT(ride_id) as diff_perc
FROM TripData;


----------------------------------------------------------------------------------------------------------------------------------------------------
--AVERAGE DURATION OF RIDES, BY DAY

SELECT
	member_casual,
	start_day_name,
	AVG(duration_min) as avg_duration
FROM TripData
GROUP BY member_casual, start_day_name, start_day_num
ORDER BY member_casual, start_day_num;


----------------------------------------------------------------------------------------------------------------------------------------------------
--AVERAGE DURATION OF RIDES, BY MONTH

SELECT
	member_casual,
	start_month_name,
	AVG(duration_min)
FROM TripData
GROUP BY member_casual, start_month_name, start_month_num
ORDER BY member_casual, start_month_num;

----------------------------------------------------------------------------------------------------------------------------------------------------
--RIDES BY BIKE TYPE (FOR EACH MEMBER TYPE)

SELECT
	member_casual,
	rideable_type,
	COUNT(ride_id) as rides_by_bike_type,
	SUM(COUNT(ride_id)) OVER (PARTITION BY member_casual) as total_rides_by_member_type,
	ROUND(CAST(COUNT(ride_id) as FLOAT)*100 / SUM(COUNT(ride_id)) OVER (PARTITION BY member_casual),2) as percent_total
FROM TripData
GROUP BY member_casual, rideable_type
ORDER BY 1,3


----------------------------------------------------------------------------------------------------------------------------------------------------
/*
VOLUME OF RIDES PER DAY (AS A PERCENT OF TOTAL RIDES BY MEMBER TYPE)
Considering that there are about 400,000 more membership rides than there are casual rides, the number of rides can be normalized as a percent 
(vs a count). To calculate the percent, the number of rides on a given weekday is simply divided by the total number of rides for that member type.
For example:
	- 50 Annual Member rides on Sundays
	- 100 total Annual Member rides
	- Therefore, 50% of the rides taken by Annual Members take place on Sundays (50 / 100 = 50%)
*/

SELECT
	member_casual as member_type,
	start_day_name as day,
	COUNT(ride_id) as num_rides,
	SUM(COUNT(ride_id)) OVER (PARTITION BY member_casual) as total_by_type,
	ROUND(CAST(COUNT(ride_id) as FLOAT) / SUM(COUNT(ride_id)) OVER (PARTITION BY member_casual),2) as percent_total
FROM TripData
GROUP BY start_day_name, member_casual, start_day_num
ORDER BY member_casual, start_day_num;

----------------------------------------------------------------------------------------------------------------------------------------------------
/*
VOLUME OF RIDES PER MONTH (AS A PERCENT OF TOTAL RIDES BY MEMBER TYPE)
Same query as above, but analyzed by month (instead of by day).
*/

SELECT
	member_casual as member_type,
	start_month_num,
	start_month_name as month,
	COUNT(ride_id) as num_rides,
	SUM(COUNT(ride_id)) OVER (PARTITION BY member_casual) as total_by_type,
	ROUND(CAST(COUNT(ride_id) as FLOAT)*100 / SUM(COUNT(ride_id)) OVER (PARTITION BY member_casual),2) as percent_total
FROM TripData
GROUP BY start_month_name, member_casual, start_month_num
ORDER BY member_casual, start_month_num;


----------------------------------------------------------------------------------------------------------------------------------------------------
/*
NUMBER OF RIDES PER STATION
This query returns the total number of trips taken from each station (with the most popular stations at the top of the list), and also
shows how many of those trips were with Casual riders and Member riders. It excludes stations where the station name is unknown.
*/

SELECT
	start_station_name,
	COUNT(CASE WHEN member_casual LIKE 'casual' THEN ride_id END) as casual_rides,
	COUNT(CASE WHEN member_casual LIKE 'member' THEN ride_id END) as member_rides,
	COUNT(ride_id) as total_rides
FROM TripData
WHERE start_station_name NOT LIKE 'Unknown'
GROUP BY start_station_name
ORDER BY 4 DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------
/*
NUMBER OF RIDES PER STATION (prepared for data visualization)
This query essentially returns the same information as the query above, but is prepared in a way that will be easier to visualize in Tableau.
It also includes GPS coordinates from the Stations table, which will allow density maps to be created (showing the locations of popular stations).
*/

SELECT
	start_station_name,
	lat,
	long,
	member_casual,
	COUNT(ride_id) rides_from_station
FROM TripData t
JOIN Stations s ON t.start_station_name = s.station
WHERE start_station_name NOT LIKE 'Unknown'
GROUP BY
	member_casual,
	start_station_name,
	lat,
	long
ORDER BY 1,4;

----------------------------------------------------------------------------------------------------------------------------------------------------
--TOP 3 MOST POPULAR STATIONS WITH MEMBERS (BASED ON NUMBER OF RIDES)

SELECT TOP 3
	start_station_name,
	COUNT(ride_id)
FROM TripData
WHERE member_casual = 'member' AND start_station_name NOT LIKE 'Unknown'
GROUP BY start_station_name
ORDER BY 2 DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------
--TOP 3 MOST POPULAR STATIONS WITH CASUAL RIDERS (BASED ON NUMBER OF RIDES)

SELECT TOP 3
	start_station_name,
	COUNT(ride_id)
FROM TripData
WHERE member_casual = 'casual' AND start_station_name NOT LIKE 'Unknown'
GROUP BY start_station_name
ORDER BY 2 DESC;
