--***********************************************************************************************************************--
-- Title: Assignment03DB_LuisValderrama
-- Desc: This file demonstrates how to select data from a database, use aggregate functions and clauses
-- Change Log: When,Who,What
-- 2021-04-24,Luis Valderrama, Created Assignment03DB_LuisValderrama, created/updated three data tables and query the DB
--***********************************************************************************************************************--

/*  
--[DATA DESIGN]--

Objective: Create database, three tables, add constraints, add data values from northwind DB, answer questions 1-11.

1- Create database, Assignment03DB_LuisValderrama;
2- Create Table (Attributes/Data Type): Categories (CategoryID/INT, CategoryName/NVARCHAR)
3- Create Table (Attributes/Data Type): Products (ProductID/INT, ProductName/NVARCHAR, CategoryID/INT, UnitPrice/MONEY)
4- Create Table (Attributes/Data Type): Inventories (InventoryID/INT, InventoryDate/DATE, ProductID/INT, Count/INT)
5- Add Constraints as follows:
	-- Categories Table:
		-- CategoryID = Primary Key Clustered
		-- CategoryName = Unique
	-- Products Table: 
		-- ProductID = Primary Key 
		-- ProductName = Unique
		-- CategoryID = Foreign Key
		-- UnitPrice = Check 
	-- Inventories Table: 
		-- InventoryID = Primary Key 
		-- InventoryDate = Default
		-- ProductID = Foreign Key
		-- Count = Check
6- Add table values from Northwind DB.
7- Answer questions 1 - 11
*/

Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'Assignment03DB_LuisValderrama')
 Begin 
  Alter Database [Assignment03DB_LuisValderrama] set Single_user With Rollback Immediate;
  Drop Database Assignment03DB_LuisValderrama;
 End
go

-- Create Database--
Create Database Assignment03DB_LuisValderrama;
go

Use Assignment03DB_LuisValderrama;
go

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Alter Table Categories 
 Add Constraint pkCategories 
  Primary Key (CategoryId);
go

Alter Table Categories 
 Add Constraint ukCategories 
  Unique (CategoryName);
go

Alter Table Products 
 Add Constraint pkProducts 
  Primary Key (ProductId);
go

Alter Table Products 
 Add Constraint ukProducts 
  Unique (ProductName);
go

Alter Table Products 
 Add Constraint fkProductsToCategories 
  Foreign Key (CategoryId) References Categories(CategoryId);
go

Alter Table Products 
 Add Constraint ckProductUnitPriceZeroOrHigher 
  Check (UnitPrice >= 0);
go

Alter Table Inventories 
 Add Constraint pkInventories 
  Primary Key (InventoryId);
go

Alter Table Inventories
 Add Constraint dfInventoryDate
  Default GetDate() For InventoryDate;
go

Alter Table Inventories
 Add Constraint fkInventoriesToProducts
  Foreign Key (ProductId) References Products(ProductId);
go

Alter Table Inventories 
 Add Constraint ckInventoryCountZeroOrHigher 
  Check ([Count] >= 0);
go

Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Inventories
(InventoryDate, ProductID, [Count])
Select '20170101' as InventoryDate, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
UNION
Select '20170201' as InventoryDate, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
UNION
Select '20170302' as InventoryDate, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Order By 1, 2
go

-- Show all of the data in the Categories, Products, and Inventories Tables
Select * from Categories;
go
Select * from Products;
go
Select * from Inventories;
go

/************************************ Questions and Answers ***********************************/

/*--Please Use Assignment03DB_LuisValderrama database to run the scripts for questions below--*/

Use Assignment03DB_LuisValderrama;
go

-- Question 1 (5 pts): Select the Category Id and Category Name of the Category 'Seafood'.

Select CategoryID, CategoryName 
From Categories
Where CategoryName = 'Seafood';
go

-- Question 2 (5 pts):  Select the Product Id, Product Name, and Product Price 
-- of all Products with the Seafood's Category Id. Ordered By the Products Price
-- highest to the lowest 

Select ProductID, ProductName, UnitPrice 
From Products
Where CategoryID = 8
Order By UnitPrice Desc; 
go

-- Question 3 (5 pts):  Select the Product Id, Product Name, and Product Price 
-- Ordered By the Products Price highest to the lowest. 
-- Show only the products that have a price Greater than $100. 

Select ProductID, ProductName, UnitPrice
From Products
Where UnitPrice > 100
Order By UnitPrice Desc; 
go

-- Question 4 (10 pts): Select the CATEGORY NAME, product name, and Product Price 
-- from both Categories and Products. Order the results by Category Name 
-- and then Product Name, in alphabetical order
-- (Hint: Join Products to Category)

Select Categories.CategoryName, Products.ProductName, Products.UnitPrice 
From Categories
Join Products
On Categories.CategoryID = Products.CategoryID
Order By CategoryName, ProductName Asc; 
go

-- Question 5 (5 pts): Select the Product Id and Number of Products in Inventory
-- for the Month of JANUARY. Order the results by the ProductIDs 

-- Luis Notes: The results of this script is similar to the screen capture provided on the Assignment03
-- word doc. However, the quantity seems to vary. I believe it is because of a random function used to 
-- create the data as noted on the word doc.

Select ProductID, Count 
From Inventories
Where InventoryDate Between '01/01/2017' And '01/31/2017'  
Order By ProductID Asc;
go  

-- Question 6 (10 pts): Select the Category Name, Product Name, and Product Price 
-- from both Categories and Products. Order the results by price highest to lowest.
-- Show only the products that have a PRICE FROM $10 TO $20. 

Select Categories.CategoryName, Products.ProductName, Products.UnitPrice 
From Categories
Join Products
On Categories.CategoryID = Products.CategoryID
Where UnitPrice Between 10 And 20
Order By UnitPrice Desc; 
go

-- Question 7 (10 pts) Select the Product Id and Number of Products in Inventory
-- for the Month of JANUARY. Order the results by the ProductIDs
-- and where the ProductID are only the ones in the seafood category
-- (Hint: Use a subquery to get the list of productIds with a category ID of 8)

-- Luis Notes: The results of this script is similar to the screen capture provided on the Assignment03
-- word doc. However, the quantity seems to vary. I believe it is because of a random function used to 
-- create the data as noted on the word doc.

Select Products.ProductID, Inventories.Count 
From Products
Join Inventories
On Products.ProductID = Inventories.ProductID
Where InventoryDate Between '01/01/2017' And '01/31/2017' 
And CategoryID = 8
Order By ProductID Asc; 
go

-- Question 8 (10 pts) Select the PRODUCT NAME and Number of Products in Inventory
-- for the Month of January. Order the results by the Product Names
-- and where the ProductID as only the ones in the seafood category
-- (Hint: Use a Join between Inventories and Products to get the Name)

-- Luis Notes: The results of this script is similar to the screen capture provided on the Assignment03
-- word doc. However, the quantity seems to vary. I believe it is because of a random function used to 
-- create the data as noted on the word doc.

Select Products.ProductName, Inventories.Count 
From Products
Join Inventories
On Products.ProductID = Inventories.ProductID
Where InventoryDate Between '01/01/2017' And '01/31/2017' 
And CategoryID = 8
Order By ProductName Asc; 
go 

-- Question 9 (10 pts) Select the Product Name and Number of Products in Inventory
-- for both JANUARY and FEBURARY. Show what the MAXIMUM AMOUNT IN INVENTORY was 
-- and where the ProductID as only the ones in the seafood category
-- and Order the results by the Product Names. 
-- (Hint: If Jan count was 5, but Feb count was 15, show 15)

-- Luis Notes: The results of this script is similar to the screen capture provided on the Assignment03
-- word doc. However, the quantity seems to vary. I believe it is because of a random function used to 
-- create the data as noted on the word doc.

Select Products.ProductName, Max(Inventories.Count) As [MaxAmountInInventory] 
From Products
Join Inventories
On Products.ProductID = Inventories.ProductID
Where InventoryDate Between '01/01/2017' And '02/28/2017' 
And CategoryID = 8 
Group By ProductName
Order By ProductName Asc; 
go  

-- Question 10 (10 pts) Select the Product Name and Number of Products in Inventory
-- for both JANUARY and FEBURARY. Show what the MAX AMOUNT IN INVENTORY was 
-- and where the ProductID as only the ones in the seafood category
-- and Order the results by the Product Names. 
-- Restrict the results to rows with a MAXIMUM COUNT OF 10 OR HIGHER

-- Luis Notes: The results of this script is similar to the screen capture provided on the Assignment03
-- word doc. However, the quantity seems to vary. I believe it is because of a random function used to 
-- create the data as noted on the word doc.

Select Products.ProductName, Max(Inventories.Count) As [MaxAmountInInventory] 
From Products
Join Inventories
On Products.ProductID = Inventories.ProductID
Where InventoryDate Between '01/01/2017' And '02/28/2017' 
And CategoryID = 8 
Group By ProductName
Having Max(Inventories.Count) >= 10
Order By ProductName Asc; 
go 

-- Question 11 (20 pts) Select the CATEGORY NAME, Product Name and Number of Products in Inventory
-- for both JANUARY and FEBURARY. Show what the MAX AMOUNT IN INVENTORY was 
-- and where the ProductID as only the ones in the seafood category
-- and Order the results by the Product Names. 
-- Restrict the results to rows with a maximum count of 10 or higher

-- Luis Notes: The results of this script is similar to the screen capture provided on the Assignment03
-- word doc. However, the quantity seems to vary. I believe it is because of a random function used to 
-- create the data as noted on the word doc.

Select Categories.CategoryName, Products.ProductName, Max(Inventories.Count) As [MaxAmountInInventory] 
From Products
Join Inventories
On Products.ProductID = Inventories.ProductID
Join Categories
On Categories.CategoryID = Products.CategoryID
Where InventoryDate Between '01/01/2017' And '02/28/2017' 
And CategoryName = 'Seafood' 
Group By CategoryName, ProductName
Having Max(Inventories.Count) >= 10
Order By ProductName Asc; 
go 

/***************************************************************************************/