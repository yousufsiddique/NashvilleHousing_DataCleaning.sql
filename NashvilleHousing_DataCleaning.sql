/*
Cleaning data
*/
SELECT *
From PortfolioProjects..[NashvilleHousing ]


--------------------------------------------------------------------------

--Standardize Date Format

SELECT SaleDate, CONVERT(Date,SaleDate) AS SaleDate
FROM PortfolioProjects..[NashvilleHousing ] 

--------------------------------------------------------------------------

--Populate Property Address

SELECT a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress , b.PropertyAddress) 
FROM PortfolioProjects..[NashvilleHousing ] a
JOIN PortfolioProjects.dbo.[NashvilleHousing ] b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress , b.PropertyAddress) 
FROM PortfolioProjects..[NashvilleHousing ] a
JOIN PortfolioProjects.dbo.[NashvilleHousing ] b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID

--------------------------------------------------------------------------

--Separating Address Into Individual Columns 

SELECT PropertyAddress
FROM PortfolioProjects..[NashvilleHousing ]

SELECT 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1) AS PropertySplitedAddress
FROM PortfolioProjects..[NashvilleHousing ]

SELECT 
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress)) AS PropertySplitedCity
FROM PortfolioProjects..[NashvilleHousing ]

ALTER TABLE PortfolioProjects..[NashvilleHousing ]
ADD PropertySplitedAddress nvarchar(255)

ALTER TABLE PortfolioProjects..[NashvilleHousing ]
ADD PropertySplitedCity nvarchar(255)

UPDATE PortfolioProjects..[NashvilleHousing ]
SET PropertySplitedAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1)

UPDATE PortfolioProjects..[NashvilleHousing ]
SET PropertySplitedCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress))




SELECT OwnerAddress
FROM PortfolioProjects..[NashvilleHousing ]

SELECT  PARSENAME(REPLACE(OwnerAddress,',','.'),3) Address
FROm PortfolioProjects..[NashvilleHousing ]

SELECT  PARSENAME(REPLACE(OwnerAddress,',','.'),2) City
FROm PortfolioProjects..[NashvilleHousing ]

SELECT  PARSENAME(REPLACE(OwnerAddress,',','.'),1) State
FROm PortfolioProjects..[NashvilleHousing ]


ALTER TABLE PortfolioProjects..[NashvilleHousing ]
ADD OwnerSplitedAddress nvarchar(255)

ALTER TABLE PortfolioProjects..[NashvilleHousing ]
ADD OwnerSplitedCity nvarchar(255)

ALTER TABLE PortfolioProjects..[NashvilleHousing ]
ADD OwnerSplitedState nvarchar(255)

Update PortfolioProjects..[NashvilleHousing ]
SET OwnerSplitedAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3) 

Update PortfolioProjects..[NashvilleHousing ]
SET OwnerSplitedCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2) 

Update PortfolioProjects..[NashvilleHousing ]
SET OwnerSplitedState = PARSENAME(REPLACE(OwnerAddress,',','.'),1) 

SELECT *
FROM PortfolioProjects..[NashvilleHousing ]



--------------------------------------------------------------------------

--Change Y and N to Yes And No in (SoldAsVacant)

Select DISTINCT(SoldAsVacant), count(SoldAsVacant)
FROM PortfolioProjects..[NashvilleHousing ]
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
 END
FROM PortfolioProjects..[NashvilleHousing ]

UPDATE PortfolioProjects..[NashvilleHousing ]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
 END
FROM PortfolioProjects..[NashvilleHousing ]

SELECT SoldAsVacant
FROM PortfolioProjects..[NashvilleHousing ]

SELECT SoldAsVacant
FROM PortfolioProjects..[NashvilleHousing ]
WHERE SoldAsVacant = 'Y' OR SoldAsVacant = 'N'



--------------------------------------------------------------------------

--Removing Duplicates

WITH RowNumCTE as(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
				UniqueID
				) row_num
FROM PortfolioProjects..[NashvilleHousing ]
)
DELETE
FROM RowNumCTE
WHERE row_num > 1

SELECT *
FROM RowNumCTE

--------------------------------------------------------------------------
--DELETE UNWANTED COLUMNS


ALTER TABLE PortfolioProjects..[NashvilleHousing ]
DROP Column PropertyAddress, OwnerAddress, TaxDistrict

SELECT *
FROM PortfolioProjects..[NashvilleHousing ]





