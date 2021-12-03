# Google Data Analytics Case Study: Cyclistic Bike-Share Analysis

### Table of Contents

* [Introduction](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#1-introduction)
* [Business Task](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#2-business-task)
* [Preparing the Data](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#3-prepraring-the-data)
* [Processing/Cleaning the Data](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#4-processingcleaning-the-data)
* [Analyzing the Data](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#5-analyzing-the-data)
* [Sharing/Visualizing the Data](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#5-analyzing-the-data)
* [Conclusion](https://github.com/josh-angert/google-data-analytics-case-study/blob/main/README.md#5-analyzing-the-data)




### 1. Introduction 
------------
The scenario for this Case Study is as follows: I am a junior data analyst working in the marketing analyst team at Cyclistic, a fictional bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, the marketing team wants to understand how casual riders and annual members use Cyclistic bikes differently. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members.

### 2. Business Task
-----------
The Director of Marketing has set a clear goal: Design marketing strategies aimed at converting casual riders into annual members. In order to do that, however, the marketing analyst team needs to better understand how annual members and casual riders differ, why casual riders would buy a membership, and how digital media could affect their marketing tactics. 

Three questions will guide the future marketing program:
1. How do annual members and casual riders use Cyclistic bikes differently?
2. Why would casual riders buy Cyclistic annual memberships?
3. How can Cyclistic use digital media to influence casual riders to become members?

The Director of Marketing has assigned me with the first question: How do annual members and casual riders use Cyclistic bikes differently?

### 3. Prepraring the Data
-----------
To answer this business question, I have been given access to Cyclistic's historical trip data, [located here](https://divvy-tripdata.s3.amazonaws.com/index.html). (Note: The trip datasets have a different name (i.e., Divvy) because Cyclistic is a fictional company. For the purposes of this case study, using the Divvy trip datasets are appropriate and will enable me to answer the business question. The data has been made available by Motivate International Inc. under this [license](https://www.divvybikes.com/data-license-agreement).

To prepare the data for analysis, I went through the following steps:
1. Downloaded 12 months of trip data (stored as 12 separate CSV files with a total of ~5 million rows). The files represent trips from October 2020 - September 2021
2. Explored the files to get a sense of the structure of the data, the attributes contained within each file and each attribute's data types 

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






4. Identified the following limitations with the data:
   - **No rider information**: 
   - No distance information
   - No station information


### 4. Processing/Cleaning the Data
-----------


### 5. Analyzing the Data
-----------

### 6. Sharing/Visualizing the Data
-----------

### 7. Conclusion
-----------


