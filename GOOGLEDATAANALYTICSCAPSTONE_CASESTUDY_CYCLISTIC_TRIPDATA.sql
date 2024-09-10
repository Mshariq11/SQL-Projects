-- PROJECT NAME: CYCLISTIC TRIP DATA 
-- SOURCE BY: GOOGLE DATA ANAYLTICS CAPSTONE 

-- QUESTIONNAIRE OF THE PROJECT:
-- 1) PURPOSE OF THE ANALYSIS:
	-- 1.1) OBJECTIVES 
	-- 1.2) KEY DELIVERABLES 
-- 2) DATA DESCRIPTION:
	-- 2.1) DATA FEATURES OR VARIABLES 
	-- 2.2) DATA SOURCE AND TIME PERIOD
	-- 2.3) DATA QUALITY/RELIABILITY
    -- 2.4) DATA CLEANING
-- 3) INSIGHTS:
	-- 3.1) KEY QUESTIONS FOR EXPLORATORY DATA ANALYSIS
	-- 3.2) EXPECTED INSIGHTS 

-- 1) PURPOSE OF THE ANALYSIS:
	-- 1.1) OBJECTIVES:
		-- THE KEY OBJECTIVES OF THIS DATA ANALYSIS IS TO UNDERSTAND THE USAGE PATTERNS AND BEHAVIORS OF CYCLISTIC’S BIKE SHARING SERVICE, WITH A FOCUS ON IDENTIFYING DIFFERENCES BETWEEN CASUAL RIDERS AND ANNUAL MEMBERS. 
	-- 1.2) KEY DELIVERABLES:
		-- THE INSIGHTS GENERATED FROM THIS ANALYSIS WILL BE USED TO INFORM CYCLISTIS’S MARKETING STRATEGIES, PRICING STRUCTURES, AND PRODUCT OFFERINGS TO BETTER SERVE THEIR CUSTOMER BASE AND DRIVE GROWTH IN ANNUAL MEMBERSHIP. 
    
-- 2) DATA DESCRIPTION: 
	-- 2.1) DATA FEATURES OR VARIABLES:  
		-- THE DIVVY DATA TRIP DATA INCLUDES THE FOLLOWING VARIABLES:
        -- RIDE ID: THE ID’S IS ASSIGNING TO EACH RIDE. ALL ID’S ARE UNIQUE. 
		-- RIDEABLE TYPE: THERE ARE TWO TYPES OF BIKES; ELECTRIC AND CLASSIC BIKE. 
		-- START AND END TIME: TIMESTAMP FOR THE START AND END OF EACH RIDE. 
		-- START AND END STATION: ID AND NAME OF THE STATION.
		-- MEMBER TYPE: THERE ARE TWO TYPES OF USERS; EITHER CASUAL OR ANNUAL MEMEBRS.
		-- START AND END LATITUDE: IDENTIFY THE LOCATION ACCORDING TO MAP SCALE.
		-- START AND END LONGITUDE: IDENTIFY THE LOCATION ACCORDING TO MAP SCALE.

	-- 2.2) DATA SOURCE AND TIME PERIOD:
		-- THE DATA COVERS A 12 MONTH PERIOD FROM FEBRARY 2022 TO JANUARY 2023.
        
	-- 2.3) DATA QUALITY / RELIABILITY:
		-- THE DATA QUALITY APPEARS TO BE GENERALLY GOOD, WITH MINIMAL MISSING VALUES OR INCONSISTENCIES. HOWEVER, THERE MAY BE SOME POTENTIAL BIASES IN THE DATA, AS THE DIVVY BIKE SHARING SERVICES IS PRIMARILY LOCATED IN THE DOWNTOWN CHICAGO AREA AND MAY NOT CAPTURE USAGE PATTERNS IN THE BROADER METROPOLITAN REGION. 
		
	-- 2.4) DATA IMPORT / CLEANING:
        
-- LOAD THE DATASET:
	-- There are 12 CSV files divided on a monthly basis. First, I will join these 12 CSV files into one new working file.  

CREATE TABLE CYCLISITC_2022_TRIPDATA AS (
	SELECT * FROM divvy_tripdata_april_2022
    UNION ALL
    SELECT * FROM divvy_tripdata_aug_2022
    UNION ALL
    SELECT * FROM divvy_tripdata_dec_2022
    UNION ALL
    SELECT * FROM divvy_tripdata_feb_2022
    UNION ALL
    SELECT * FROM divvy_tripdata_jan_2023
    UNION ALL 
    SELECT * FROM divvy_tripdata_july_2022
    UNION ALL
    SELECT * FROM divvy_tripdata_june_2022
    UNION ALL
    SELECT * FROM divvy_tripdata_mar_2022
    UNION ALL
    SELECT * FROM divvy_tripdata_nov_2022
    UNION ALL 
    SELECT * FROM divvy_tripdata_oct_2022
    UNION ALL
    SELECT * FROM divvy_tripdata_sept_2022
    UNION ALL
    SELECT * FROM divvy_tripdata_may_2022
);

--  The original dataset has 27,328 rows and 13 columns.
SELECT *
FROM cyclisitc_2022_tripdata;

-- INSPECT THE DATA STRUCTURE
DESCRIBE cyclisitc_2022_tripdata;

ALTER TABLE cyclisitc_2022_tripdata
MODIFY COLUMN started_at TIMESTAMP,
MODIFY COLUMN ended_at TIMESTAMP;

-- STANDARIZED DATA FORMATS / INCONSISTENCIES: 
SELECT DISTINCT ride_id, rideable_type, started_at ,ended_at , start_station_name , start_station_id , end_station_name , end_station_id , start_lat , start_lng , end_lat , end_lng , member_casual
FROM cyclisitc_2022_tripdata;

UPDATE cyclisitc_2022_tripdata
SET member_casual = CASE 
                  WHEN member_casual = 'member' THEN 'Annual Member'
                  WHEN member_casual = 'casual' THEN 'Casual'
                  ELSE member_casual
                 END;

ALTER TABLE cyclisitc_2022_tripdata
RENAME COLUMN annual_casual TO members;

-- ADDRESSING DUPLICATES RECORDS:

SELECT *,
ROW_NUMBER () OVER (
	PARTITION BY ride_id, 
	rideable_type,
	started_at,
	ended_at,
	start_station_name,
	start_station_id,
	end_station_name,
	end_station_id,
	start_lat,
	start_lng,
	end_lat,
	end_lng,
	members
) AS row_num
FROM cyclisitc_2022_tripdata;

WITH CTE_DUP AS 
(
SELECT *, 
	ROW_NUMBER () OVER (
    PARTITION BY ride_id, 
	rideable_type,
	started_at,
	ended_at,
	start_station_name,
	start_station_id,
	end_station_name,
	end_station_id,
	start_lat,
	start_lng,
	end_lat,
	end_lng,
	members
    ORDER BY start_station_name
) AS row_num 
FROM cyclisitc_2022_tripdata
)
SELECT *
FROM CTE_DUP
WHERE row_num  > 1
ORDER BY ride_id; 


WITH CTE_DUP AS 
(
SELECT *, 
	ROW_NUMBER () OVER (
    PARTITION BY ride_id, 
	rideable_type,
	started_at,
	ended_at,
	start_station_name,
	start_station_id,
	end_station_name,
	end_station_id,
	start_lat,
	start_lng,
	end_lat,
	end_lng,
	members
    ORDER BY start_station_name
) AS row_num 
FROM cyclisitc_2022_tripdata
)
DELETE FROM cyclisitc_2022_tripdata
WHERE  (ride_id, rideable_type, started_at ,ended_at , start_station_name , start_station_id , end_station_name , end_station_id , start_lat , start_lng , end_lat , end_lng , members) IN 
	(SELECT ride_id, rideable_type, started_at ,ended_at , start_station_name , start_station_id , end_station_name , end_station_id , start_lat , start_lng , end_lat , end_lng , members
FROM CTE_DUP 
WHERE row_num > 1
);

-- HANDLING MISSING VALUES 
SELECT
    COUNT(CASE WHEN ride_id IS NULL THEN 1 END) AS NULL_RIDEID,
    COUNT(CASE WHEN rideable_type IS NULL THEN 1 END) AS NULL_RIDABLE_TYPE,
    COUNT(CASE WHEN started_at IS NULL THEN 1 END) AS NULL_STARTED_AT,
    COUNT(CASE WHEN ended_at IS NULL THEN 1 END) AS NULL_ENDED_AT,
    COUNT(CASE WHEN start_station_name IS NULL THEN 1 END) AS NULL_STATION_NAME,
    COUNT(CASE WHEN start_station_id IS NULL THEN 1 END) AS NULL_START_STATION_ID,
    COUNT(CASE WHEN end_station_name IS NULL THEN 1 END) AS NULL_END_STATION_NAME,
    COUNT(CASE WHEN end_station_id IS NULL THEN 1 END) AS NULL_END_STATION_ID,
    COUNT(CASE WHEN start_lat IS NULL THEN 1 END) AS NULL_START_LAT,
    COUNT(CASE WHEN start_lng IS NULL THEN 1 END) AS NULL_START_LNG,
    COUNT(CASE WHEN end_lat IS NULL THEN 1 END) AS NULL_END_LAT,
    COUNT(CASE WHEN end_lng IS NULL THEN 1 END) AS NULL_END_LNG,
    COUNT(CASE WHEN members IS NULL THEN 1 END) AS NULL_MEMBERs
FROM cyclisitc_2022_tripdata;

-- 3) INSIGHTS:
	-- 3.1) KEY QUESTIONS FOR EXPLORATORY DATA ANALYSIS:
		-- MAIN USER OF GROUPS (CASUAL VS. ANNUAL)
		-- USER GROUPS IN TERMS OF TRIP DURATION, DISTANCE, START/END LOCATIONS, AND TIME OF DAY/DAY OF WEEK.
		-- IDENTIFY THE SEASONAL TRENDS (SUMMER vs. WINTER)
		-- SPATIAL PATTERNS SUCH AS POPULAR START/END STATIONS
    
	-- 3.2) EXPECTED INSIGHTS  

	--  The original dataset had 27,328 rows, which was reduced to 23,605 rows and 13 columns after removing missing values and duplicates.
SELECT 
  (SELECT COUNT(*) FROM cyclisitc_2022_tripdata) AS total_rows,
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = 'cyclisitc_2022_tripdata') AS total_columns;

-- All ride IDs are unique and have 16 characters.
SELECT LENGTH(ride_id) AS LENGTH_ride_id, COUNT(ride_id) AS no_of_rows
FROM cyclisitc_2022_tripdata
GROUP BY length_ride_id;

-- The bike types used are Classic Bike (11,646), Electric Bike (11,358), and Docked Bike (601).
SELECT DISTINCT rideable_type, COUNT(rideable_type) AS NO_OF_TRIPS
FROM cyclisitc_2022_tripdata
GROUP BY rideable_type;

-- START AND END TIME
SELECT DISTINCT started_at, ended_at, COUNT(started_at) AS START_ID, COUNT(ended_at) AS ENDED
FROM cyclisitc_2022_tripdata
GROUP BY started_at, ended_at;

-- The majority of users (19,877) used the bikes for less than a minute, followed by 3,445 day users and 283 users who used the bikes for hours.
SELECT 
  SUM(CASE WHEN trip_duration_minutes >= 1440 THEN 1 ELSE 0 END) AS day_user_count,
  SUM(CASE WHEN trip_duration_minutes >= 60 AND trip_duration_minutes < 1440 THEN 1 ELSE 0 END) AS hourly_user_count,
  SUM(CASE WHEN trip_duration_minutes < 60 THEN 1 ELSE 0 END) AS minute_user_count
FROM
(
  SELECT 
    *, 
    TIMESTAMPDIFF(MINUTE, started_at, ended_at) AS trip_duration_minutes
  FROM cyclisitc_2022_tripdata
) t;

-- There are 1,218 rows with missing start/end station names or IDs, and some values are duplicated.
SELECT DISTINCT start_station_id, end_station_id, start_station_name, end_station_name, members, COUNT(start_station_name) AS ROWS_COUNT, COUNT(end_station_name), COUNT(members)
FROM cyclisitc_2022_tripdata
GROUP BY start_station_name, end_station_name, start_station_id, end_station_id, members
ORDER BY start_station_id;

-- Further analysis is needed to identify user groups based on trip duration, distance, start/end locations, and time of day/day of week.
CREATE TABLE NEW_CYCLISTIC AS (
  SELECT
    ride_id, rideable_type, 
    started_at, 
    EXTRACT(HOUR FROM started_at) AS start_hour,
    EXTRACT(MINUTE FROM started_at) AS start_minute,
    EXTRACT(SECOND FROM started_at) AS start_second,
    ended_at,
    EXTRACT(HOUR FROM ended_at) AS end_hour,
    EXTRACT(MINUTE FROM ended_at) AS end_minute,
    EXTRACT(SECOND FROM ended_at) AS end_second,
    ROUND(
      (DATEDIFF(ended_at, started_at) * 24 * 60) +
      (TIMESTAMPDIFF(MINUTE, started_at, ended_at)),
      1
    ) AS ride_length_minutes,
    CASE WHEN WEEKDAY(started_at) = 0 THEN 'Monday'
         WHEN WEEKDAY(started_at) = 1 THEN 'Tuesday'
         WHEN WEEKDAY(started_at) = 2 THEN 'Wednesday'
         WHEN WEEKDAY(started_at) = 3 THEN 'Thursday'
         WHEN WEEKDAY(started_at) = 4 THEN 'Friday'
         WHEN WEEKDAY(started_at) = 5 THEN 'Saturday'
         WHEN WEEKDAY(started_at) = 6 THEN 'Sunday'
    END AS day_of_week,
    MONTH(started_at) AS month,
    start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, members
  FROM cyclisitc_2022_tripdata
);

-- 23605 ROWS ARE AFFECTED
SELECT *
FROM NEW_CYCLISTIC;

-- IDENTIFY DUPLICATES RECORDS INDIVIDUALLY:
SELECT
  ride_id,
  COUNT(*) AS duplicate_count
FROM NEW_CYCLISTIC
GROUP BY ride_id
HAVING COUNT(*) > 1;

SELECT *
FROM new_cyclistic
WHERE ride_id = '54FCB271F53ADA06';

-- SOME OF THE COLUMNS ARE STILL SIMILAR SO DELETE THE DUPLICATED RECORDS AGAIN. 
WITH cte AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY ride_id ORDER BY started_at) AS rn
  FROM new_cyclistic
)
SELECT * 
FROM cte
WHERE rn > 1;

-- Delete the duplicate records
DELETE FROM new_cyclistic
WHERE (ride_id, started_at) IN (
  SELECT ride_id, started_at
  FROM (
    SELECT
      ride_id,
      started_at,
      ROW_NUMBER() OVER (PARTITION BY ride_id ORDER BY started_at) AS rn
    FROM new_cyclistic
  ) t
  WHERE rn > 1
);

-- After removing more duplicate records, the dataset is divided into annual members and casual users for each bike type.
-- 16934 ROWS ARE AFFECTED
SELECT * 
FROM new_cyclistic;

-- Classic bike users:
		-- Annual membership: 5181
		-- Casual users: 3108
-- Electric bike users:
		-- Annual membership: 5090
		-- Casual users: 3187
-- Docked bike users:
		-- Annual membership: 191
		-- Casual users: 177 
SELECT DISTINCT rideable_type, members, COUNT(members)
FROM new_cyclistic
GROUP BY rideable_type, members; 

-- The total ride length rows are 16,934, but 2,249 are negative due to data inconsistencies, leaving 14,685 positive ride lengths.
SELECT members, COUNT(ride_length_minutes)
FROM new_cyclistic
WHERE ride_length_minutes LIKE '-%'
GROUP BY members;

-- HOURLY USER'S GROUP
	-- The top 5 users by total hours used are all annual members, with the top user having 17 hours of usage.
SELECT EXTRACT(HOUR FROM started_at) AS HOURLY_USER, members, COUNT(ride_id) AS total_users
FROM new_cyclistic
GROUP BY HOURLY_USER, members
ORDER BY members;

-- DAYS OF WEEK USERS GROUP:
	-- The top 5 users by day of the week are all annual members, with Monday being the most popular day.
SELECT day_of_week, members, COUNT(ride_id) AS total_trips
FROM new_cyclistic
GROUP BY day_of_week, members
ORDER BY members;

-- USER GROUP BASED ON MONTH:
	-- February, Annual members: 3966 users
	-- February, Casual members: 2732 users
	-- June, Annual members: 2008 users
	-- June, Annual members: 1125 users
	-- October, Annual members: 1093 users
SELECT `month`, members, COUNT(ride_id) AS total_trips
FROM new_cyclistic
GROUP BY `month`, members
ORDER BY members;

-- AVERAGE MONTHLY RIDE LENGTH
	-- Highest average duration in January, Casual members
	-- Second highest average duration in January, Annual members
	-- Third highest average duration in March, Casual members
	-- Fourth highest average duration in April, Casual members
	-- Fifth highest average duration in March, Annual members
SELECT `month`, members, AVG(ride_length_minutes) AS avg_ride_duration
FROM new_cyclistic
GROUP BY month, members;

-- AVERAGE WEEKLY RIDE LENGTH
	-- Highest average duration on Monday, Casual members
	-- Second highest average duration on Tuesday, Casual members
	-- Third highest average duration on Friday, Casual members
	-- Fourth highest average duration on Monday, Annual members
	-- Fifth highest average duration on Wednesday, Casual members
SELECT day_of_week, members, AVG(ride_length_minutes) AS avg_ride_duration
FROM new_cyclistic
GROUP BY day_of_week, members;

-- AVERAGE HOURLY RIDE LENGTH
	-- Highest average duration is 5 hours, Casual members
	-- Second highest average duration is 15 hours, Casual members
	-- Third highest average duration is 5 hours, Annual members
	-- Fourth highest average duration is 8 hours, Casual members
	-- Fifth highest average duration is 13 hours, Casual members
SELECT EXTRACT(HOUR FROM started_at) AS hour_of_day, members, AVG(ride_length_minutes) AS avg_ride_duration
FROM new_cyclistic
GROUP BY hour_of_day, members;

-- STATION LOCATION:
	-- Highest trips: 681 by Casual members, no station name provided
	-- Second highest trips: 647 by Annual members, no station name provided
	-- Third highest trips: 38 by Annual members, end station name: "HALSTED ST & CLYBOURN AVE"
	-- Fourth highest trips: 20 by Annual members, station names: "FORT DEARBORN" and "RHODES AVE"
	-- Fifth highest trips: 19 by Annual members, end station name: "WABASH AVE"
SELECT start_station_name, end_station_name, members,  AVG(start_lat), AVG(end_lat), AVG(start_lat), AVG(end_lng),
  COUNT(ride_id) AS total_trips
FROM new_cyclistic
GROUP BY start_station_name, end_station_name, members;