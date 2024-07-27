-- DATA CLEANING REPORT: CAR DETALS FROM CAR DEKHO

-- 1) INTRODUCTION
-- The "Car Details from Car Dekho" dataset contains information about used cars listed on the Car Dekho website 
-- The purpose of this dataset is to facilitate the creation of a comprehensive "Data Cleaning Report" and a user-friendly dashboard that can be used by used car buyers, sellers, and industry analysts. The data cleaning report will ensure the dataset is ready for further analysis, while the dashboard will provide a visual and interactive way to explore the used car market trends, identify popular car models, and understand the factors that influence the selling prices of used cars.

-- 2) DATA DESCRIPTION
-- The dataset contains the following columns:
	-- 1) name: The name of the car model.
	-- 2) year: The year the car was manufactured.
	-- 3) selling_price: The price at which the car is being sold.
	-- 4) km_driven: The total number of kilometers the car has been driven.
	-- 5) fuel: The type of fuel the car uses (e.g., Diesel, Petrol, CNG).
	-- 6) seller_type: The type of seller (e.g., Dealer, Individual).
	-- 7) transmission: The type of transmission (e.g., Manual, Automatic).
	-- 8) owner: The number of previous owners of the car.

-- 3) UPLOADING THE RAW DATA
SELECT *
FROM car_details_from_car_dekho;

-- 4) INSPECT THE DATA STRUCTURE
DESCRIBE car_details_from_car_dekho;

-- 5) STANDARIZED THE DATA 

SELECT `name`, TRIM(`name`)
FROM car_details_from_car_dekho;

UPDATE car_details_from_car_dekho
SET `name` = TRIM(`name`);

-- 6) MISSING VALUES
SELECT selling_price
FROM car_details_from_car_dekho
WHERE selling_price IS NULL;

-- 7) ADDRESSING DUPLICATES RECORDS

WITH cte AS (
SELECT *,
	ROW_NUMBER () OVER (
    PARTITION BY `name`,
				`year`,
                selling_price,
                km_driven,
                fuel,
                seller_type,
                transmission
                ORDER BY 
                `owner`) AS row_num
FROM car_details_from_car_dekho
ORDER BY seller_type
)
SELECT * 
FROM cte
WHERE row_num > 1 
ORDER BY `name`;

DELETE FROM car_details_from_car_dekho
WHERE (`name`, `year`, selling_price, km_driven, fuel, seller_type, transmission) IN (
    SELECT `name`, `year`, selling_price, km_driven, fuel, seller_type, transmission
    FROM (
        SELECT `name`, `year`, selling_price, km_driven, fuel, seller_type, transmission,
               ROW_NUMBER() OVER (PARTITION BY `name`, `year`, selling_price, km_driven, fuel, seller_type, transmission
                                  ORDER BY `owner`) AS row_num
        FROM car_details_from_car_dekho
    ) AS subquery
    WHERE row_num > 1
);

SELECT `name`, `year`, selling_price, km_driven, fuel, seller_type, transmission, COUNT(*) AS count
FROM car_details_from_car_dekho
GROUP BY `name`, `year`, selling_price, km_driven, fuel, seller_type, transmission
HAVING COUNT(*) > 1
ORDER BY `name`;

SELECT *
FROM car_details_from_car_dekho;

-- EXPLORATORY DATA ANALYSIS

SELECT MAX(`name`), MAX(selling_price), `year`
FROM car_details_from_car_dekho
GROUP BY `name`, `year`
ORDER BY 3 DESC;

SELECT MIN(`name`), MAX(selling_price), `year`, seller_type, transmission, `owner`, fuel, km_driven
FROM car_details_from_car_dekho
GROUP BY `name`, `year`, selling_price, seller_type, transmission, `owner`, fuel, km_driven
ORDER BY 2 DESC;

