--data cleaning using sql

SELECT *
FROM [PORTFOLIO PROJECT]..Nashvillehousing

--Saledate conversion

ALTER TABLE Nashvillehousing
ADD SaleDateConverted Date

UPDATE Nashvillehousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

SELECT SaleDateConverted
FROM [PORTFOLIO PROJECT]..Nashvillehousing

--Property Address 
SELECT *
FROM [PORTFOLIO PROJECT]..Nashvillehousing
ORDER BY ParcelID

--LETS do a self join

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [PORTFOLIO PROJECT]..Nashvillehousing a
JOIN [PORTFOLIO PROJECT]..Nashvillehousing b
   ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
   WHERE a.PropertyAddress IS NULL

   UPDATE a
   SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [PORTFOLIO PROJECT]..Nashvillehousing a
JOIN [PORTFOLIO PROJECT]..Nashvillehousing b
   ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
   WHERE a.PropertyAddress IS NULL

 --Spliting PropertyAddress by city, state 
 SELECT 
     SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) AS Address,
	 SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) AS City
FROM [PORTFOLIO PROJECT].[dbo].[Nashvillehousing]

ALTER TABLE Nashvillehousing
ADD PropertysplitAddress Nvarchar(255)

UPDATE Nashvillehousing
SET PropertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE Nashvillehousing
ADD PropertysplitCity Nvarchar(255)

UPDATE Nashvillehousing
SET PropertysplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

SELECT * 
FROM [PORTFOLIO PROJECT].[dbo].[Nashvillehousing]

--Spliting owner address
SELECT OwnerAddress 
FROM [PORTFOLIO PROJECT].[dbo].[Nashvillehousing]

SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',','.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)
FROM [PORTFOLIO PROJECT].[dbo].[Nashvillehousing]

ALTER TABLE Nashvillehousing
ADD OwnersplitAddress Nvarchar(255)

UPDATE Nashvillehousing
SET OwnersplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.') , 3)

ALTER TABLE Nashvillehousing
ADD OwnersplitCity Nvarchar(255)

UPDATE Nashvillehousing
SET OwnersplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.') , 2)

ALTER TABLE Nashvillehousing
ADD OwnersplitState Nvarchar(255)

UPDATE Nashvillehousing
SET OwnersplitState = PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)

SELECT * 
FROM [PORTFOLIO PROJECT].[dbo].[Nashvillehousing]

--Change Y and N to Yes and No in Soldasvacant column
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [PORTFOLIO PROJECT].[dbo].[Nashvillehousing]
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END AS SoldAsVacantClean
   FROM [PORTFOLIO PROJECT].[dbo].[Nashvillehousing]

UPDATE Nashvillehousing
SET SoldAsVacant = 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END 

--Using CTEs and Windows function to remove duplicate
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
FROM [PORTFOLIO PROJECT].[dbo].[Nashvillehousing]
)

--DELETE
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

--Deleting unused column
SELECT *
FROM [PORTFOLIO PROJECT].[dbo].[Nashvillehousing]

ALTER TABLE [PORTFOLIO PROJECT].[dbo].[Nashvillehousing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [PORTFOLIO PROJECT].[dbo].[Nashvillehousing]
DROP COLUMN SaleDate