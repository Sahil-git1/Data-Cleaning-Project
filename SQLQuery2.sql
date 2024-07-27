-- Data Cleaning Using Sql

-- Viewing dataset
select * 
from [Nashville Housing Data for Data Cleaning CSV]

-- Sales data
select SaleDate
from [Nashville Housing Data for Data Cleaning CSV]

-- Populate Property Address Data
select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress) 
from [Nashville Housing Data for Data Cleaning CSV] a
join [Nashville Housing Data for Data Cleaning CSV] b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a
set a.PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress) 
from [Nashville Housing Data for Data Cleaning CSV] a
join [Nashville Housing Data for Data Cleaning CSV] b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

-- Separating Property address 
alter table [Nashville Housing Data for Data Cleaning CSV] 
add address VARCHAR(255)
alter table [Nashville Housing Data for Data Cleaning CSV] 
add city VARCHAR(255)


update [Nashville Housing Data for Data Cleaning CSV]
set address = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

update [Nashville Housing Data for Data Cleaning CSV]
set city = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))


-- Separating Property OwnerAddress
select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from [Nashville Housing Data for Data Cleaning CSV]


alter table [Nashville Housing Data for Data Cleaning CSV] 
add Owner_Address VARCHAR(255)
alter table [Nashville Housing Data for Data Cleaning CSV] 
add OwnerCity VARCHAR(255)
alter table [Nashville Housing Data for Data Cleaning CSV] 
add OwnerState VARCHAR(255)

update [Nashville Housing Data for Data Cleaning CSV]
set Owner_Address = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

update [Nashville Housing Data for Data Cleaning CSV]
set Ownercity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)
update [Nashville Housing Data for Data Cleaning CSV]
set OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

--Converting 0,1 to Yes Or No
ALTER TABLE [Nashville Housing Data for Data Cleaning CSV]
ALTER COLUMN SoldAsVacant Varchar(50);



update [Nashville Housing Data for Data Cleaning CSV]
set SoldAsVacant =
case when SoldAsVacant = 0 then 'No'
     when SoldAsVacant = 1 then 'Yes'
	 else SoldAsVacant
	 end;

--Removing Duplicates 
with RowNumCTE as (
select * ,
ROW_NUMBER() over (
partition by  ParcelId,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by 
UniqueID )row_num
from [Nashville Housing Data for Data Cleaning CSV]
)
delete
from RowNumCTE
where row_num>1

-- Delete Unused Columns
alter table [Nashville Housing Data for Data Cleaning CSV]
drop column PropertyAddress,OwnerAddress,TaxDistrict


