-- DATA CLEANING REPORT: NASHVILLE HOUSING DATA 

-- 1) INTRODUCTION
-- This report outlines the data cleaning process performed on the Nashville housing dataset. The goal of this project is to prepare the data for further analysis by addressing various data quality issues, such as missing values, inconsistent data formats, and duplicate records.

-- 2) DATA DESCRIPTION 
-- The Nashville housing dataset contains information about residential properties in the Nashville area. The dataset includes the following columns:
-- UniqueID: Unique identifier for each property
-- ParcelID: Unique identifier for each parcel of land
-- LandUse: The type of land use (e.g., residential, commercial, etc.)
-- PropertyAddress: The physical address of the property
-- SaleDate: The date the property was sold
-- SalePrice: The price the property was sold for
-- LegalReference: The legal reference number for the property sale
-- SoldAsVacant: Indicates whether the property was sold as vacant or not
-- OwnerName: The name of the property owner
-- OwnerAddress: The address of the property owner
-- Acreage: The size of the property in acres
-- TaxDistrict: The tax district the property is located in
-- LandValue: The value of the land
-- BuildingValue: The value of the building
-- TotalValue: The total value of the property
-- YearBuilt: The year the building was constructed
-- Bedrooms: The number of bedrooms in the property
-- FullBath: The number of full bathrooms in the property
-- HalfBath: The number of half bathrooms in the property

-- 3) UPLOADIING THE RAW DATA
SELECT *
FROM nashville_housing_data_2013_2016;

-- 4) INSPECT THE DATA STRUCTURE: 
DESCRIBE nashville_housing_data_2013_2016;

-- 3) STANDARIZED THE DATA:
-- Transformed the SaleDate column from text format to date format.
-- Trimmed the leading and trailing spaces from all column names.

SELECT `Sale Date`
FROM nashville_housing_data_2013_2016;

UPDATE nashville_housing_data_2013_2016
SET `Sale Date` = CAST(`Sale Date` AS DATE);

ALTER TABLE nashville_housing_data_2013_2016
MODIFY COLUMN `Sale Date` DATE;

ALTER TABLE nashville_housing_data_2013_2016
RENAME COLUMN `Unnamed: 0` TO UniqueID,
RENAME COLUMN `Parcel ID` TO ParcelID,
RENAME COLUMN `Property Address` TO PropertyAddress,
RENAME COLUMN `Sale Date` TO SaleDate,
RENAME COLUMN `Sale Price` TO SalePrice,
RENAME COLUMN `Legal Reference` TO LegalReference,
RENAME COLUMN `Sold As Vacant` TO SoldAsVacant,
RENAME COLUMN `Multiple Parcels Involved in Sale` TO MultipleParcelsInvolvedInSale,
RENAME COLUMN `Owner Name` TO OwnerName,
RENAME COLUMN `Tax District` TO TaxDistrict,
RENAME COLUMN `Land Value` TO LandValue,
RENAME COLUMN `Building Value` TO BuildingValue,
RENAME COLUMN `Total Value` TO TotalValue,
RENAME COLUMN `Finished Area` TO FinishedArea,
RENAME COLUMN `Foundation Type` TO FoundationType,
RENAME COLUMN `Year Built` TO YearBuilt,
RENAME COLUMN `Exterior Wall` TO ExteriorWall,
RENAME COLUMN `Full Bath` TO FullBath,
RENAME COLUMN `Half Bath` TO HalfBath;

-- JOINING PARCELID AND PROPERTY ADDRESS:
-- Joined the ParcelID and PropertyAddress columns based on the unique UniqueID to create a more complete and consistent representation of property information.

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM nashville_housing_data_2013_2016 a
LEFT JOIN nashville_housing_data_2013_2016 b
    ON a.ParcelID = b.ParcelID
   AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

UPDATE nashville_housing_data_2013_2016 a
JOIN nashville_housing_data_2013_2016 b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = b.PropertyAddress
WHERE a.PropertyAddress IS NULL;


-- ADDRESSING DUPLICATES RECORDS:

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) AS row_num
From nashville_housing_data_2013_2016
order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;
 
WITH RowNumCTE AS (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY ParcelID,
                   PropertyAddress,
                   SalePrice,
                   SaleDate,
                   LegalReference
      ORDER BY UniqueID
    ) AS row_num
  FROM nashville_housing_data_2013_2016
  ORDER BY ParcelID
)
DELETE FROM RowNumCTE
WHERE row_num > 1;
   
SELECT *
FROM nashville_housing_data_2013_2016;













