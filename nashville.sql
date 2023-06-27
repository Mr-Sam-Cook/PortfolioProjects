SELECT *
FROM [dbo.NashvilleHousing]

/*
Cleaning Data in SQL Queries
*/


--Standardize Date Format
SELECT SaleDate
FROM [dbo.NashvilleHousing]


SELECT SaleDate, CONVERT(Date, SaleDate)
FROM [dbo.NashvilleHousing]


Update [dbo.NashvilleHousing]
set SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE [dbo.NashvilleHousing]
Add SaleDateConverted Date;

Update [dbo.NashvilleHousing]
set SaleDateConverted = CONVERT(Date, SaleDate)

SELECT SaleDateConverted  --Added new column
FROM [dbo.NashvilleHousing]


--Populate Property Address Data

SELECT PropertyAddress
FROM [dbo.NashvilleHousing]


SELECT PropertyAddress
FROM [dbo.NashvilleHousing]
WHERE PropertyAddress is null

SELECT *
FROM [dbo.NashvilleHousing]

SELECT *
FROM [dbo.NashvilleHousing]
order by ParcelID

SELECT A.ParcelID, A.PropertyAddress,B.ParcelID, B.PropertyAddress
FROM [dbo.NashvilleHousing] A
JOIN [dbo.NashvilleHousing] B
ON A.ParcelID = B.ParcelID 
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

SELECT A.ParcelID, A.PropertyAddress,B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM [dbo.NashvilleHousing] A
JOIN [dbo.NashvilleHousing] B
ON A.ParcelID = B.ParcelID 
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM [dbo.NashvilleHousing] A
JOIN [dbo.NashvilleHousing] B
ON A.ParcelID = B.ParcelID 
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL


--Breaking out address into individual Columns(Address, City, Sate)
SELECT PropertyAddress
FROM [dbo.NashvilleHousing]


SELECT 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)) as Address,CHARINDEX(',',PropertyAddress)
FROM [dbo.NashvilleHousing] --CharIndex returns an int 


SELECT 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) as Address
FROM [dbo.NashvilleHousing]

SELECT 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
FROM [dbo.NashvilleHousing]


ALTER TABLE [dbo.NashvilleHousing]
Add PropertySplitAddress NVARCHAR(255);

Update [dbo.NashvilleHousing]
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE [dbo.NashvilleHousing]
Add PropertySpliCity NVARCHAR(255);

Update [dbo.NashvilleHousing]
set PropertySpliCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT PropertySpliCity
FROM [dbo.NashvilleHousing]

SELECT PropertySplitAddress
FROM [dbo.NashvilleHousing]


SELECT OwnerAddress
FROM [dbo.NashvilleHousing]

--USING PARSENAME TO COME TO THE SAME CONCLUSION

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM [dbo.NashvilleHousing]

ALTER TABLE [dbo.NashvilleHousing]
Add OwnerSplitAddress NVARCHAR(255);

Update [dbo.NashvilleHousing]
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE [dbo.NashvilleHousing]
Add OwnerSplitCity NVARCHAR(255);

Update [dbo.NashvilleHousing]
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE [dbo.NashvilleHousing]
Add OwnerSplitState NVARCHAR(255);

Update [dbo.NashvilleHousing]
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)



--Changing Y and N to Yes and No in 'Sold as Vacant' field





--Removing Duplicats 



--Deleting unused columns 