--ORGANIZING THE DATA

USE GoogleCaseStudy;
--------------------------------------------------------------------------------------------------------------------------------------

--Created a temp table called "Trips Combined" to combine all 12 csv Tripdata files into one master dataset.

CREATE TABLE #Trips_Combined (
	ride_id VARCHAR(50),
	rideable_type VARCHAR(50),
	started_at DATETIME,
	ended_at DATETIME,
	start_station_name VARCHAR(max),
	start_station_id VARCHAR(50),
	end_station_name VARCHAR(max),
	end_station_id VARCHAR(50),
	start_lat FLOAT,
	start_lng FLOAT,
	end_lat FLOAT,
	end_lng FLOAT,
	member_casual VARCHAR(50)
);

INSERT INTO #Trips_Combined
SELECT * FROM [202010-divvy-tripdata] UNION ALL
SELECT * FROM [202011-divvy-tripdata] UNION ALL
SELECT * FROM [202012-divvy-tripdata] UNION ALL
SELECT * FROM [202101-divvy-tripdata] UNION ALL
SELECT * FROM [202102-divvy-tripdata] UNION ALL
SELECT * FROM [202103-divvy-tripdata] UNION ALL
SELECT * FROM [202104-divvy-tripdata] UNION ALL
SELECT * FROM [202105-divvy-tripdata] UNION ALL
SELECT * FROM [202106-divvy-tripdata] UNION ALL
SELECT * FROM [202107-divvy-tripdata] UNION ALL
SELECT * FROM [202108-divvy-tripdata] UNION ALL
SELECT * FROM [202109-divvy-tripdata];

---------------------------------------------------------------------------------------------------------------------------------------------

--Created a second temp table called "Trip Calculations" to establish new data attributes (which will be used to analyze/visualize the data).

CREATE TABLE #Trip_Calculations (
	ride_id VARCHAR(50),
	duration_sec INT,
	duration_min INT,
	start_day_num INT,
	start_day_name VARCHAR(50),
	start_month_num INT,
	start_month_name VARCHAR(50),
	day_type VARCHAR(50)
);

INSERT INTO #Trip_Calculations 
SELECT
	ride_id,
	DATEDIFF(SECOND, started_at, ended_at),
	DATEDIFF(MINUTE, started_at, ended_at),
	DATEPART(WEEKDAY,started_at),
	DATENAME(WEEKDAY,started_at),
	DATEPART(MONTH,started_at),
	DATENAME(MONTH,started_at),
	CASE 
		WHEN DATEPART(WEEKDAY,started_at) = 1 OR DATEPART(WEEKDAY,started_at) = 7 THEN 'Weekend' 
		ELSE 'Weekday' END
FROM #Trips_Combined;

---------------------------------------------------------------------------------------------------------------------------------------------

--Finally, created one master table using SELECT INTO (called "Trip Data") which combines the two previous temp tables.
--Note: I could not SELECT * from both temp tables because the ride_id field exists in both temp tables.

SELECT
	a.*,
	duration_sec,
	duration_min,
	start_day_num,
	start_day_name,
	start_month_num,
	start_month_name,
	day_type
INTO TripData
FROM #Trips_Combined a
JOIN #Trip_Calculations b ON a.ride_id = b.ride_id;

---------------------------------------------------------------------------------------------------------------------------------------------
/*
Realized that having a field for each season of the year may be helpful when visualizing data, so I created a new field and set the values 
using a CASE statement.
*/

ALTER TABLE TripData
ADD season VARCHAR(50);

UPDATE TripData
SET season = 
CASE 
	WHEN (start_month_num BETWEEN 3 AND 5) THEN 'Spring'
	WHEN (start_month_num BETWEEN 6 AND 8) THEN 'Summer'
	WHEN (start_month_num BETWEEN 9 AND 11) THEN 'Fall'
	ELSE 'Winter' 
	END;

	