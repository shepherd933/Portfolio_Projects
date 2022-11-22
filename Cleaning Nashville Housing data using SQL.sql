use [Shepherd_Portfolio];

/* Select all data from our table */

select * from Houses;

-------------------------------------------------------------------------------------------------------------


/*  standardizing the date and remove hh:mm:ss*/

ALTER TABLE Houses
Add ConvertedSaleDate Date;

Update Houses
SET ConvertedSaleDate = CONVERT(Date,SaleDate)

Update Houses
SET SaleDate = CONVERT(Date,ConvertedSaleDate)

----------------------------------------------------------------------------------------------------------------

/*  populating NULL Property_Address field*/ 

Select *
From Houses
Where PropertyAddress is null
order by ParcelID;

Select a.ParcelID, a.PropertyAddress,
       b.ParcelID, b.PropertyAddress,
	   ISNULL(a.PropertyAddress,b.PropertyAddress)
From Houses a
       JOIN Houses b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Houses a
JOIN Houses b
	on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


------------------------------------------------------------------------------------------------------------------

/*Breaking out Owner Address into Individual Columns (Street, City, State)*/

Select OwnerAddress
From Houses

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Houses

ALTER TABLE Houses
Add OwnerSplitStreet Nvarchar(300);

Update Houses
SET OwnerSplitStreet =
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE Houses
Add OwnerSplitCity Nvarchar(300);

Update Houses
SET OwnerSplitCity = 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE Houses
Add OwnerSplitState Nvarchar(300);

Update Houses
SET OwnerSplitState =
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

select * from Houses;

--------------------------------------------------------------------------------------------------------------------------


/*Change Y and N to Yes and No in "Sold as Vacant" field */

Select Distinct(SoldAsVacant), Count(SoldAsVacant) as countofPeople
From Houses
Group by SoldAsVacant
order by Count(SoldAsVacant)

Select SoldAsVacant,
 CASE When SoldAsVacant = 'Y' THEN 'Yes'
	  When SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
 END
From Houses


Update Houses
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

Select SoldAsVacant ,count(*) as Sold_Amount
from Houses
group by SoldAsVacant
order by Sold_Amount desc


---------------------------------------------------------------------------------------------------------

/*Delete Unused Columns */

Select *
From Houses


ALTER TABLE Houses
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate