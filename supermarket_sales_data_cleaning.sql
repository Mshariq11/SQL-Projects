-- DATA CLEANING PROJECT 

-- 1) INTRODUCTION

-- 2) DATA DESCRIPTION 


-- 3) UPLOAD THE DATA 
SELECT * 
FROM supermarket_sales;

-- 4) INSPECT THE DATA STRUCTURE:

DESCRIBE supermarket_sales;

SELECT *
FROM supermarket_sales;

ALTER TABLE supermarket_sales
MODIFY COLUMN `Date` DATE,
MODIFY COLUMN `Time` TIME,
MODIFY COLUMN `Unit Price` DECIMAL(10,2),
MODIFY COLUMN `Tax 5%` DECIMAL(10,2),
MODIFY COLUMN Total DECIMAL(10,2),
MODIFY COLUMN cogs DECIMAL(10,2),
MODIFY COLUMN `gross margin percentage` DECIMAL(10,2),
MODIFY COLUMN `Gross Income` DECIMAL(10,2),
MODIFY COLUMN Rating DECIMAL(10,2)
;

-- 5) STANDARIZED THE DATA

ALTER TABLE supermarket_sales
RENAME COLUMN `Invoice ID` TO InvoiceID,
RENAME COLUMN `Customer Type` TO Customer_type,
RENAME COLUMN `Product line` TO Product_line,
RENAME COLUMN `Unit Price` TO Unit_price,
RENAME COLUMN `Tax 5%` TO `Tax_5%`,
RENAME COLUMN `gross margin percentage` TO gross_margin_percentage,
RENAME COLUMN `Gross Income` TO gross_Income;

SELECT DISTINCT Customer_type, Gender, Branch, Product_line
FROM supermarket_sales;

-- 6) MISSING VALUES
SELECT *
FROM supermarket_sales;

SELECT a.InvoiceID, a.Product_line, b.InvoiceID, b.Product_line
FROM supermarket_sales a
LEFT JOIN supermarket_sales b
    ON a.InvoiceID = b.InvoiceID
   AND a.Quantity <> b.Quantity
WHERE a.Product_line IS NULL;

UPDATE supermarket_sales a
JOIN supermarket_sales b
    ON a.InvoiceID = b.InvoiceID
    AND a.InvoiceID <> b.InvoiceID
SET a.Product_line = b.Product_line
WHERE a.Product_line IS NULL;

-- 7) ADDRESSING DUPLICATES RECORDS 

WITH cte AS(
SELECT *,
	ROW_NUMBER () OVER (
    PARTITION BY InvoiceID,
				Branch,
                City,
                Customer_type,
                Gender,
                Product_line,
                Unit_price,
                Quantity,
                `Tax_5%`,
                Total,
                `Date`,
                `Time`,
                Payment,
                cogs,
                gross_margin_percentage,
                gross_Income,
                Rating
                ) AS row_num
FROM supermarket_sales
)
SELECT * 
FROM cte
WHERE row_num = 1;

WITH cte AS (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY InvoiceID,
                  Branch,
                  City,
                  Customer_type,
                  Gender,
                  Product_line,
                  Unit_price,
                  Quantity,
                  `Tax_5%`,
                  Total,
                  `Date`,
                  `Time`,
                  Payment,
                  cogs,
                  gross_margin_percentage,
                  gross_Income,
                  Rating
      ORDER BY InvoiceID
    ) AS row_num
  FROM supermarket_sales
)
DELETE FROM supermarket_sales
WHERE (InvoiceID, Branch, City, Customer_type, Gender, Product_line, Unit_price, Quantity, `Tax_5%`, Total, `Date`, `Time`, Payment, cogs, gross_margin_percentage, gross_Income, Rating) IN (
  SELECT InvoiceID, Branch, City, Customer_type, Gender, Product_line, Unit_price, Quantity, `Tax_5%`, Total, `Date`, `Time`, Payment, cogs, gross_margin_percentage, gross_Income, Rating
  FROM cte
  WHERE row_num > 1
);

-- 8) EXPLORATORY DATA ANAYLSIS
SELECT *
FROM supermarket_sales;

SELECT MAX(`Date`) , MIN(`Date`)
FROM supermarket_sales;

SELECT SUBSTRING(`Date`, 1,7) AS `MONTH` , SUM(Unit_price) 
FROM supermarket_sales
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_total AS
(
SELECT SUBSTRING(`Date`, 1,7) AS `MONTH` , SUM(Unit_price) AS Unit_price
FROM supermarket_sales
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH` , Unit_price,
SUM(Unit_price) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT Gender, MAX(Product_line), Month(`date`), Branch, SUM(gross_Income), SUM(Quantity), SUM(gross_margin_percentage)
FROM supermarket_sales
GROUP BY Gender , Month(`date`), Branch
ORDER BY 1 DESC;


