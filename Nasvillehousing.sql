--preview of the dataset

SELECT *
  FROM [NASHVILLE CLEANING].[dbo].[Nashville]

-- data cleaning begins
-- adding a new column "SaleDateConverted" to an existing table

ALTER TABLE Nashville
ADD SaleDateConverted Date

-- updating "SaleDateConverted" by converting the values from the "SaleDate" column into the date format using the "CONVERT" function.
UPDATE Nashville
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- previewing our new column 
SELECT SaleDateConverted
FROM [NASHVILLE CLEANING].[dbo].[Nashville]

--Property Address 
SELECT PropertyAddress
FROM [NASHVILLE CLEANING].[dbo].[Nashville]

--lets check where property address is null
SELECT PropertyAddress
FROM [NASHVILLE CLEANING].[dbo].[Nashville]
WHERE PropertyAddress IS NULL

--lets also look at every field where property is null
SELECT *
FROM [NASHVILLE CLEANING].[dbo].[Nashville]
WHERE PropertyAddress IS NULL

--lets also look at every field with ParcelId
SELECT *
FROM [NASHVILLE CLEANING].[dbo].[Nashville]
ORDER BY ParcelID

-- using self join, we check for parcelID that have same ID with it and has address
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM [NASHVILLE CLEANING].[dbo].[Nashville] a
JOIN [NASHVILLE CLEANING].[dbo].[Nashville] b
    ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- using isnull to populate address of the second parcelId to replace the null values from the propertyaddress
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [NASHVILLE CLEANING].[dbo].[Nashville] a
JOIN [NASHVILLE CLEANING].[dbo].[Nashville] b
    ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL
 
-- lets update our propertyAddress
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [NASHVILLE CLEANING].[dbo].[Nashville] a
JOIN [NASHVILLE CLEANING].[dbo].[Nashville] b
    ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- lets preview
SELECT *
FROM [NASHVILLE CLEANING].[dbo].[Nashville]
WHERE PropertyAddress IS NULL

-- Breaking PropertyAddress into columns (Address, City)
SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
       SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM [NASHVILLE CLEANING].[dbo].[Nashville]

-- adding a new column "Property split Address", "Property split city"and updating "Property split Address" and "Property split city" to an existing table

ALTER TABLE [NASHVILLE CLEANING].[dbo].[Nashville]
ADD PropertySplitAddress NVARCHAR(255)

UPDATE [NASHVILLE CLEANING].[dbo].[Nashville]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE [NASHVILLE CLEANING].[dbo].[Nashville]
ADD PropertySplitCity NVARCHAR(255)

UPDATE [NASHVILLE CLEANING].[dbo].[Nashville]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

-- previewing our new column 
SELECT *
FROM [NASHVILLE CLEANING].[dbo].[Nashville]

-- Breaking OwnerAddress into columns (Address, City, State)
SELECT OwnerAddress
FROM [NASHVILLE CLEANING].[dbo].[Nashville]

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
       PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	   PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM [NASHVILLE CLEANING].[dbo].[Nashville]

-- adding a new column "Owner split Address", "Owner split city", "Owner split state" and updating "Owner split Address", "Owner split city", "Owner split state" to an existing table

ALTER TABLE [NASHVILLE CLEANING].[dbo].[Nashville]
ADD OwnerSplitAddress NVARCHAR(255)

UPDATE [NASHVILLE CLEANING].[dbo].[Nashville]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE [NASHVILLE CLEANING].[dbo].[Nashville]
ADD OwnerSplitCity NVARCHAR(255)

UPDATE [NASHVILLE CLEANING].[dbo].[Nashville]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE [NASHVILLE CLEANING].[dbo].[Nashville]
ADD OwnerSplitState NVARCHAR(255)

UPDATE [NASHVILLE CLEANING].[dbo].[Nashville]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- previewing our new column 
SELECT *
FROM [NASHVILLE CLEANING].[dbo].[Nashville]

-- Replacing Y and N to Yes and No in Soldasvacant column
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [NASHVILLE CLEANING].[dbo].[Nashville]
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END 
   FROM [NASHVILLE CLEANING].[dbo].[Nashville]

UPDATE [NASHVILLE CLEANING].[dbo].[Nashville]
SET SoldAsVacant = 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

----Using CTEs and Windows function to remove duplicate rows But lets View them first
WITH RowNumCTE AS (
     SELECT *,
	 ROW_NUMBER() OVER (
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				   UniqueID
				   )row_num
FROM [NASHVILLE CLEANING].[dbo].[Nashville]
)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

-- Deleting duplicate rows
WITH RowNumCTE AS (
     SELECT *,
	 ROW_NUMBER() OVER (
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				   UniqueID
				   )row_num
FROM [NASHVILLE CLEANING].[dbo].[Nashville]
)

DELETE
FROM RowNumCTE
WHERE row_num > 1

--Deleting unused column
SELECT OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
 FROM [NASHVILLE CLEANING].[dbo].[Nashville]

ALTER TABLE [NASHVILLE CLEANING].[dbo].[Nashville]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

SELECT *
 FROM [NASHVILLE CLEANING].[dbo].[Nashville]
