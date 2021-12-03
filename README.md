# Google Data Analytics Case Study: Cyclistic Bike-Share Analysis

### Table of Contents

* [Introduction](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#1-introduction)
* [Business Task](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#2-business-task)
* [Preparing the Data](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#3-preparing-the-data)
* [Processing/Cleaning the Data](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#4-processingcleaning-the-data)
* [Analyzing the Data](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#5-analyzing-the-data)
* [Visualizing/analyzing the Data](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#6-visualizingsharing-the-data)
* [Conclusion](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#5-analyzing-the-data)




### 1. Introduction 
------------
The scenario for this Case Study is as follows: I am a junior data analyst working in the marketing analyst team at Cyclistic, a fictional bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, the marketing team wants to understand how casual riders and annual members use Cyclistic bikes differently. (Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members.)

I created various SQL queries (using Microsoft SQL Server Management Studio) and Tableau to process, analyze and visualize the data from this case study. Links to the SQL scripts and my Tableau dashboard can be found below. 
- **SQL scripts**:
  - [Organizing the data](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/1.%20Organize.sql)
  - [Cleaning the data](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/2.%20Clean.sql)
  - [Creating a new "Stations" table](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/3.%20Create%20Stations.sql)
  - [Analyzing the data](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/4.%20Analyze.sql)
- **Tableau Dashboard**: 
  - [Click Here](https://public.tableau.com/views/Book2_16380472614180/Dashboard42?:language=en-US&:retry=yes&:display_count=n&:origin=viz_share_link)

The content in the following sections describes the process I followed to complete this case study.


### 2. Business Task
-----------
The Director of Marketing has set a clear goal: Design marketing strategies aimed at converting casual riders into annual members. In order to do that, however, the marketing analyst team needs to better understand how annual members and casual riders differ, why casual riders would buy a membership, and how digital media could affect their marketing tactics. 

Three questions will guide the future marketing program:
1. How do annual members and casual riders use Cyclistic bikes differently?
2. Why would casual riders buy Cyclistic annual memberships?
3. How can Cyclistic use digital media to influence casual riders to become members?

The Director of Marketing has assigned me with the first question: How do annual members and casual riders use Cyclistic bikes differently?

### 3. Preparing the Data
-----------
To answer this business question, I have been given access to Cyclistic's historical trip data, [located here](https://divvy-tripdata.s3.amazonaws.com/index.html). (Note: The trip datasets have a different name (i.e., Divvy) because Cyclistic is a fictional company. For the purposes of this case study, using the Divvy trip datasets are appropriate and will enable me to answer the business question. The data has been made available by Motivate International Inc. under this [license](https://www.divvybikes.com/data-license-agreement).

To prepare the data for analysis, I went through the following steps:
1. Downloaded 12 months of trip data (stored as 12 separate CSV files with a total of ~5 million rows). The files represent trips from October 2020 - September 2021.
2. Explored the files to get a sense of the structure of the data, the attributes contained within each file and each attribute's data types:

    | **Column**        | **Description**  | **Type**  |
    | ------------- |-------------| ---------|
    | ride_id       | ID of the bike ride | String |
    | rideable_type | Type of bike rented (classic, docked or electric)  |   String |
    | started_at    | Date/time the bike ride began     |   Date/time |
    | ended_at      | Date/time the bike ride ended | Date/time |
    | start_station_name | Name of the starting station   |   String |
    | start_station_id | ID of the start station     |    String |
    | end_station_name     | Name of the end station | String |
    | end_station_id      | ID of the end station    |   String |
    | start_lat | Latitude of the bike when the ride began     |    Decimal |
    | start_lng | Longitude of the bike when the ride began      |    Decimal |
    | end_lat | Latitude of the bike when the ride ended      |    Decimal |
    | end_lng | Longitude of the bike when the ride ended     |    Decimal |
    | member_casual | Type of rider (Annual Member or Casual)   |    String |


3. Identified the following limitations about the data:
   - **_No rider information_**: The dataset did not include any personal or demographic information about the riders. Therefore, I won't be able to identify any rider trends based on age, gender, etc...
   - **_No distance information_**: The dataset _does_ include latitude/longitude coordinates for the start/end of the bike rides. However, using the lat/long data provided, I could only calculate the straight-line (Euclidean) distance between the starting and ending points (not the actual distance the rider traveled on the road). 
        - For example, the starting/ending locations may only be 0.5 miles apart, however the rider may have taken the bike 2 or 3 miles around the city before returning the bike to the ending location. 
   - **_No station information_**: The only station information in the dataset is the name of the starting & ending stations. The latitude and longitude fields provided in the dataset represent the GPS coordinates of the bike that was rented, not the GPS coordinates of the station from which it was rented/returned. For example, each station in the dataset has thousands of lat/long coordinates associated with it (vs a single lat/long for the station itself).


### 4. Processing/Cleaning the Data
-----------
This section highlights how I went about preparing the data for analysis:
- **_Tools used_**: I used Microsoft SQL Server to process the data, primarily because it is widely rated as one of the top relational database management systems in the market, and this case study provided me with a great opportunity to become more familiar with the software.
- **_Steps Taken_**: 
  - Imported the 12 CSV files into SQL Server
  - Combined all 12 CSV files and created new data attributes (which will be used during analysis) using temp tables, Unions, Joins and CREATE/ALTER commands. [Here is a link to the SQL script](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/1.%20Organize.sql). The new data attributes created by this code include new fields for:
    - Duration of the ride (in minutes and seconds)
    - Starting day number (i.e., 1 = Sunday, 2 = Monday, etc.) & Starting day name (i.e., name of the day of the week)
    - Ending day number & name
    - Month number & month name
    - Day type (i.e., weeekend or week day)
    - Season
  - Cleaned the data (removed non-unique/duplicate values & incorrect data, checked for NULL values and removed NULLs using CTEs, conditional aggregation and DELETE/UPDATE commands. [Here is a link to the SQL script](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/2.%20Clean.sql).
    - Note, the script contains comments which explain why I chose to use certain queries, and the results of those queries). 
  - Created a new table, called Stations. The table contains disticnt list of the stations listed in the dataset (784 stations) and their respective latitude/longitude coordinates. I utilized temp tables, Unions and SELECT/INSERT INTO commands. [Here is a link to the SQL script](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/3.%20Create%20Stations.sql).


### 5. Analyzing the Data
-----------
I used SQL Server in this stage as well, and wrote various queries (using CASE statements, Window Functions, Joins and aggregations) in order to gain insights about the differences between Annual Members and Casual riders. [Here is a link to the SQL code](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/4.%20Analyze.sql) (**Note**: the code include comments which explain why I chose to use certain queries, and the results of those queries). Here's a brief summary of some of the the data I analyzed:
- Total number of bike rides (for the full 12-month period): There are about 8% more bike rides with Annual Members than there are with casual riders (about 400,000 more).
- Number or rides per day and month
- Average duration of rides (by day and month)
- Number of rides by bike type (i.e., electric, docked or classic), grouped by member type
- Number or riders per station (I combined station lat/long coordinates with the total number of rides from each station, allowing me to create a heat map in Tableau)


### 6. Visualizing/Sharing the Data
-----------
I created a dashboard within Tableau 
https://public.tableau.com/views/Book2_16380472614180/Dashboard42?:language=en-US&:display_count=n&:origin=viz_share_link


### 7. Conclusion
-----------


