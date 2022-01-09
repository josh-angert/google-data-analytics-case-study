# Google Data Analytics Capstone Project: Cyclistic Bike-Share Analysis

### Table of Contents

* [Introduction](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#1-introduction)
* [Business Task](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#2-business-task)
* [Preparing the Data](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#3-preparing-the-data)
* [Processing/Cleaning the Data](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#4-processingcleaning-the-data)
* [Analyzing the Data](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#5-analyzing-the-data)
* [Visualizing/Sharing the Data](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#6-visualizingsharing-the-data)
* [Conclusion](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#7-conclusion)




### 1. Introduction 
------------
The scenario for this Case Study is as follows: I am a junior data analyst working in the marketing analyst team at Cyclistic, a fictional bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, the marketing team wants to understand how casual riders and annual members use Cyclistic bikes differently. (Customers who purchase single-ride or full-day passes are referred to as Casual Riders, and customers who purchase annual memberships are referred to as Annual Members.)

I created various SQL queries (using Microsoft SQL Server Management Studio) and Tableau to process, analyze and visualize the data from this case study. Links to the SQL scripts and my Tableau dashboard can be found below. 
- **SQL scripts**:
  - [Organizing the data](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/1.%20Organize.sql)
  - [Cleaning the data](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/2.%20Clean.sql)
  - [Creating a new "Stations" table](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/3.%20Create%20Stations.sql)
  - [Analyzing the data](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/4.%20Analyze.sql)
- **Tableau Dashboard**: 
  - [Click Here](https://public.tableau.com/views/Book2_16380472614180/Dashboard?:language=en-US&publish=yes&:display_count=n&:origin=viz_share_link)

The following sections describe the process I followed to complete this Case Study.


### 2. Business Task
-----------
The Director of Marketing set a clear goal: Design marketing strategies to convert Casual Riders into Annual Members. Three questions guide the future marketing program:
1. How do Casual Riders and Annual Members use Cyclistic bikes differently?
2. Why would Casual Riders buy Cyclistic annual memberships?
3. How can Cyclistic use digital media to influence casual riders to become Annual Members?

The Director of Marketing has tasked me with answering the first question: _How do Casual Riders and Annual Members use Cyclistic bikes differently?_

### 3. Preparing the Data
-----------
To answer this business question, I was provided access to Cyclistic's historical trip data, [located here](https://divvy-tripdata.s3.amazonaws.com/index.html). (Note: The trip datasets have a different name (i.e., Divvy) because Cyclistic is a fictional company. For this Case Study, using the Divvy trip datasets are appropriate and will enable me to answer the business question. The data was made available by Motivate International Inc. under this [license](https://www.divvybikes.com/data-license-agreement).

To prepare the data for analysis, I went through the following steps:
1. Downloaded 12 months of trip data (stored as 12 separate CSV files with a total of ~5 million rows). The files represent trips from October 2020 - September 2021.
2. Explored the files to get a sense of the structure of the data, the attributes contained within each file and each attribute's data types:

    | **Column Name**        | **Description**  | **Type**  |
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
   - **_No Rider Information_**: The dataset did not include any personal or demographic information about the riders. Therefore, I was unable to identify any rider trends based on age, gender, etc...
   - **_No Information on Total Distance Traveled_**: The dataset includes latitude/longitude coordinates of the starting and ending points of each ride. However, there was no way to determine which of the many possible routes a given rider would travel between their trip's starting and ending points.
        - For example, the starting and ending locations may only be 0.5 miles apart; however, the rider may have ridden the bike 2 or 3 miles around the city before reaching the ending location. 
   - **_No Station GPS Coordinates_**: The only station information in the dataset is that of each starting and ending station's name. The latitude and longitude fields provided represent the GPS coordinates of the rented bike, not the GPS coordinates of the station from which it was rented/returned. 
        - Note: While this was a limitation, I developed a solution using [this SQL script](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/3.%20Create%20Stations.sql) to calculate a unique GPS coordinate for each station. This allowed me plot each station's location on a map of Chicago and visualize the number of bikes rented from each station.


### 4. Processing/Cleaning the Data
-----------
This section highlights how I went about preparing the data for analysis:
- **_Tools used_**: I used Microsoft SQL Server to process the data, primarily because it is widely rated as one of the top relational database management systems in the market. This Case Study provided me with an opportunity to become more familiar with the software.
- **_Steps Taken_**: 
  - Imported the 12 CSV files into SQL Server
  - Combined all 12 CSV files and created new data attributes using temp tables, Unions, Joins and CREATE/ALTER commands. [Here is a link to the SQL script](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/1.%20Organize.sql). I created the new data attributes for use during analysis. The new attributes include new fields for:
    - Duration of the ride (in minutes and seconds)
    - Starting day number (i.e., 1 = Sunday, 2 = Monday, etc.) & Starting day name (i.e., name of the day of the week)
    - Ending day number & ending day name
    - Month number & month name
    - Day type (i.e., weekend or week day)
    - Season
  - Cleaned the data (removed non-unique/duplicate values and incorrect data, checked for NULL values and removed NULLs using CTEs, conditional aggregation and DELETE/UPDATE commands. [Here is a link to the SQL script](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/2.%20Clean.sql).
    - Note, the script contains comments which explain why I chose to use certain queries, and the results of those queries). 
  - Created a new table, called Stations. The table contains a list of all stations from the dataset (784 stations) and calculates their respective latitude/longitude coordinates. I utilized temp tables, Unions and SELECT/INSERT INTO commands. [Here is a link to the SQL script](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/3.%20Create%20Stations.sql).


### 5. Analyzing the Data
-----------
I used **_Microsoft SQL Server_** in this stage as well, and wrote various queries (using CASE statements, Window Functions, Joins and aggregations) to gain insights into the differences between Annual Members and Casual Riders. [Here is a link to the SQL code](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/4.%20Analyze.sql) (**Note**: the code includes comments which explain why I chose to use certain queries, and the results of those queries). The following is a brief list of some of the queries used:
- Total number of bike rides (for the full 12-month period): There are about 8% more bike rides with Annual Members than there are with Casual Riders (about 400,000 more).
- Number of rides per day and month
- Average duration of rides per day and month
- Number of rides by bike type (i.e., electric, docked, or classic), grouped by member type
- Number of riders per station (I combined station lat/long coordinates with the total number of rides from each station, allowing me to create a heat map in Tableau. A user can filter the heat map between member types, zoom in and out, and reposition the map.)
- Top 3 most popular stations (based on number of rides) for Annual Members and Casual Riders


### 6. Visualizing/Sharing the Data
-----------
To wrap things up, I created a dashboard (using **_Tableau_**) to summarize the key insights needed to answer the business question at hand: _How do Annual Members differ from Casual Riders?_ [Here is a link to the Tableau dashboard](https://public.tableau.com/views/Book2_16380472614180/Dashboard?:language=en-US&publish=yes&:display_count=n&:origin=viz_share_link).

And here is a screenshot of the dashboard:

<img src="https://github.com/josh-angert/google-data-analytics-case-study/blob/main/Tableau%20Screenshot.PNG" width="700">

### 7. Conclusion
-----------
Here are the key differences between Annual Members and Casual Riders (source data is from October 2020 - September 2021):

| **Measure**       | **Insights**  |
| ----------------- |-------------|
| # of Rides        | There were **8% more bike rides** with Annual Members than there were with Casual Riders          |
| Time of Year      | Peak popularity for both Annual Members _and_ Casual Riders is **between June and September**        |
| Day of Week       |**Casual Riders prefer _weekends_**, whereas **Annual Members prefer the _weekdays_**              |
| Avg Ride Duration | Casual Riders, on average, ride their bikes about **2X longer** than Annual Members (average duration of 32 min for Casual Riders vs 14 min for Annual Members)|
| Type of Bike      | Classic bikes account for **59% of rides with Members**, whereas Casual Riders use Classic bikes 48% of the time. Also, Casual Riders use Docked Bikes **7% more often than Members**  |                               
| Popular Stations  | Casual Riders overwhelmingly start their rides **near tourist attractions** (i.e., Millennium Park, Navy Pier, etc.) whereas the stations with the highest activity for Annual Members are spread more evenly throughout the city     |
