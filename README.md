# NASHVILLEHOUSING DATA CLEANING USING SQL

![nashville image](https://user-images.githubusercontent.com/116097143/229492942-6b2c7410-d28f-4654-be3c-d4273d52875d.jpg)


In this project, I worked with Nashville Housing Data, a dataset containing information about land and properties in Nashville, the capital city of the U.S. state of Tennessee.

I used SQL in Microsoft SQL Management Server Studio to explore and clean the dataset

## DATA COLLECTION

The dataset was gotten from [Kaggle](https://www.kaggle.com/datasets/tmthyjames/nashville-housing-data).

## METADATA:
The dataset is composed of 56,477 rows with the following columns below

* UniqueID — id number attributed to a buyer.
* ParcelID — code attributed to a land.
* LandUse — shows the different uses of land.
* PropertyAddress —	physical address for each property
* SaleDate — date when the land was sold
* SalesPrice — cost of land
* LegalReference — citation is the practice of crediting and referring to authoritative documents and sources.
* SoldAsVacant  —
* OwnerName  — name of land owner
* OwnerAddress — owners house address
* Acreage — size of an area of land in acres
* TaxDistrict —	tax levy for property
* LandValue — the worth of the land
* BuildingValue  — worth of the building
* Total Value — landvalue + building value
* YearBuilt — year the building was built
* Bedrooms  — numbers of bedrooms
* FullBath — a bathroom that includes a shower, a bathtub, a sink, and a toilet.
* HalfBath — a half bathroom only contains a sink and a toilet

## MY OBSERVATIONS

Going through the dataset, I observed that the dataset needs thorough cleaning.

![nashville](https://user-images.githubusercontent.com/116097143/229502819-445d04d1-7a6f-44ce-802f-654221b334e0.png)
![nashville2](https://user-images.githubusercontent.com/116097143/229502828-f6d7f73e-9f2a-492c-a8eb-1ed34939e2bf.png)

* The Date is not in the standard format.
* PropertyAddress contains NULL
* PropertyAddress has both the City and House Address in the same column.
* OwnerAddress has the state, city, and address on the same column.
* some rows contains duplicate value that need to be removed.
* Columns which would not be useful for the analysis and therefore should be deleted.
* SaleDate
* SoldAsVacant column has a variety of data values (Yes, No, Y, N). Converted all values to Yes, No responses

## DATA CLEANING

I converted the SaleDate to the standard date format and updated it to my existing table

SaleDate            |  Saledateconverted
:-------------------------:|:-------------------------:
![saledate](https://user-images.githubusercontent.com/116097143/229505981-329fdfad-f0a2-461d-a2a5-2386f751c1eb.png)  |  ![saledateconverted](https://user-images.githubusercontent.com/116097143/229505989-391ed2d6-6d09-4df4-96f0-cf5c58fc049f.png)

## PropertyAddress Replacing null values with ParcelID 
Populate property address of the second parcelId to replace the null values
PropertyAddress            |  PropertyAddress
:-------------------------:|:-------------------------:
![Screenshot 2023-04-03 140045](https://user-images.githubusercontent.com/116097143/229548987-7c111b7d-eaa2-451b-8f48-aa78995d3398.png)  |  ![Screenshot 2023-04-03 140521](https://user-images.githubusercontent.com/116097143/229549449-f5a81249-1332-42b5-9e52-ab60807fb5ff.png)

## PropertyAddress Spliting into Address and City using CHARINDEX and updated it to my existing table
PropertyAddress            |  Address Split
:-------------------------:|:-------------------------:
![propertyaddress](https://user-images.githubusercontent.com/116097143/229563807-fe5d1437-d58a-4f68-9a78-50c13712ce7b.png)  |  ![address ](https://user-images.githubusercontent.com/116097143/229564907-fa02bc7c-1496-41fd-aea1-72858d30d93b.png)

## OwnerAddress Spliting into Address, City and State
OwnerAddress            |  Address Split
:-------------------------:|:-------------------------:
![Screenshot 2023-04-03 172833](https://user-images.githubusercontent.com/116097143/229574191-03d64b8b-c745-4e96-82db-5c664532c125.png)  |  ![Screenshot 2023-04-03 174206](https://user-images.githubusercontent.com/116097143/229574867-1a7ce7b6-5b7d-4c95-94d4-e21cbe7cb959.png)

## Replacing Y and N to Yes and No in SoldAsVacant column
SoldAsVacant            |  SoldAsVacant
:-------------------------:|:-------------------------:
![Screenshot 2023-04-03 175305](https://user-images.githubusercontent.com/116097143/229578519-4672d049-5bd8-4746-a1bc-2482b0f061f3.png)  |  ![Screenshot 2023-04-03 180211](https://user-images.githubusercontent.com/116097143/229578538-d8ccc7ef-78f2-482f-8374-3cc443a49d3a.png)

# NOTE: Not a good practice to delete raw data from table, instead create CTEs if you must
## Using CTEs and Windows function to remove duplicate data
we have 104 duplicate rows
duplicate rows            |  deleted rows
:-------------------------:|:-------------------------:
![Screenshot 2023-04-03 184425](https://user-images.githubusercontent.com/116097143/229587013-7a4966c6-885e-4872-ae19-4fd5151e0554.png)  |  ![Screenshot 2023-04-03 185003](https://user-images.githubusercontent.com/116097143/229588202-cf68e45f-6372-4087-9d05-9ca256fc1abb.png)

## Deleting unused columns 
OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
unused columns            |  cleaned column names
:-------------------------:|:-------------------------:
![Screenshot 2023-04-03 190122](https://user-images.githubusercontent.com/116097143/229591302-79572a61-35b1-4da3-af35-ff5817906bc9.png) |  ![Screenshot 2023-04-03 190439](https://user-images.githubusercontent.com/116097143/229591308-8d42b3db-ec50-47b0-908b-cf73179260d6.png)

Now we are left with 56,373 ROWS. THE ESSENCE OF THIS PROJECT IS TO MAKE THE DATA SET CLEAN AND USEABLE.

# THANK YOU FOR STICKING WITH ME 







