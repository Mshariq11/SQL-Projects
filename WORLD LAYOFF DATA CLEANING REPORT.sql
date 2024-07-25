-- WORLD LAYOFF DATA CLEANING REPORT:

-- 1)INTRODUCTION:
-- This report outlines the data cleaning process performed on the world layoff dataset. The purpose of this data cleaning exercise is to prepare the dataset for further analysis and insights.

-- 2)DATA DESCRIPTION
-- The world layoff dataset contains information about layoffs that have occurred globally. The dataset includes the following columns:
	-- Company: The name of the company that conducted the layoffs.
    -- Location: The location where the layoffs occurred.
	-- Industry: The industry the company operates in.
    -- Total_laid_off: The total number of employees laid off.
    -- Percentage_laid_off: The percentage of employees laid off.
    -- Date: The date when the layoffs were announced.
	-- Stage: The stage of the company (e.g., startup, established).
	-- Country: The country where the layoffs occurred.
	-- Funds_raised_millions: The amount of funds raised by the company in millions.

-- 3) UPLOADIING THE RAW DATA AND MAKE A NEW WORKING TABLE
SELECT * 
FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * 
FROM layoffs_staging;

INSERT layoffs_staging
SELECT * 
FROM layoffs;

SELECT *
FROM layoffs_staging;

-- 4) INSPECT THE DATA STRUCTURE: 
DESCRIBE layoffs_staging;

-- 5) FORMATTING AND STANDARDIZING DATA:
-- Transformed the Date Format.
-- Trimmed the leading and trailing spaces from all column names.

SELECT company, TRIM(company)
FROM layoffs_staging;

UPDATE layoffs_staging
SET company = TRIM(company);

SELECT DISTINCT country
FROM layoffs_staging
ORDER BY 1; 

SELECT DISTINCT industry
FROM layoffs_staging
ORDER BY 1; 

UPDATE layoffs_staging
SET industry = 'crypto'
WHERE industry LIKE 'crypto%'
;

SELECT *
FROM layoffs_staging
WHERE country LIKE 'United States%'
ORDER BY 1; 

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging
ORDER BY 1;

UPDATE layoffs_staging
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%'
;

SELECT `date`
FROM layoffs_staging;

UPDATE layoffs_staging
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- 6) REMOVING DUPLICATES:

SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS 
(
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *   
FROM duplicate_cte
WHERE row_num > 1;

WITH duplicate_cte AS 
(
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE  
FROM duplicate_cte
WHERE row_num > 1;

-- 7) HANDLING MISSING VALUES:

SELECT *
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging
SET industry = NULL 
WHERE industry = '';

SELECT *
FROM layoffs_staging
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging
WHERE company = 'Airbnb';

SELECT t1.industry , t2.industry 
FROM layoffs_staging t1
JOIN layoffs_staging t2 
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging t1
JOIN layoffs_staging t2 
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging
WHERE company LIKE 'Bally%';

SELECT *
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

DELETE
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

-- EXPLORATORY DATA ANALYZE
SELECT *
FROM layoffs_staging;

ALTER TABLE layoffs_staging
DROP COLUMN row_num;

SELECT MAX(total_laid_off) , MAX(percentage_laid_off)
FROM layoffs_staging;

SELECT *
FROM layoffs_staging
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company 
ORDER BY 2 DESC;

SELECT MIN(`date`) , MAX(`date`)
FROM layoffs_staging;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY industry 
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY country 
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging
GROUP BY YEAR(`date`) 
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY stage 
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`, 1,7) AS `MONTH` , SUM(total_laid_off) 
FROM layoffs_staging
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_total AS
(
SELECT SUBSTRING(`date`, 1,7) AS `MONTH` , SUM(total_laid_off) AS total_off
FROM layoffs_staging
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH` , total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company , YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year(company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company , YEAR(`date`)
), Company_Year_Rank AS
(SELECT * , DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking  
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <=5 ; 


