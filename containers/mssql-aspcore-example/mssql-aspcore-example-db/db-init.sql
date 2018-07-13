CREATE DATABASE ProductCatalog
GO

USE ProductCatalog
GO

--  1 setup.sql

CREATE LOGIN WebLogin WITH PASSWORD = 'SQLPass1234!'
GO

DROP USER IF EXISTS WebUser
CREATE USER WebUser FROM LOGIN WebLogin
GO

DROP ROLE IF EXISTS WebUserRole
CREATE ROLE WebUserRole
GO

GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE TO WebUserRole
EXEC sp_addrolemember N'WebUserRole', N'WebUser' 
GO

DROP TABLE IF EXISTS Product
DROP SEQUENCE IF EXISTS ProductId
GO

CREATE SEQUENCE ProductId AS int START WITH 29

CREATE TABLE Product (
	ProductID int DEFAULT (NEXT VALUE FOR ProductId) PRIMARY KEY,
	Name nvarchar(50) NOT NULL,
	Color nvarchar(15) NULL,
	Size nvarchar(5) NULL,
	Price money NOT NULL,
	Quantity int NULL,
	CompanyID int,
	Data nvarchar(4000),
	Tags nvarchar(4000),
	DateModified datetime2(0) NOT NULL DEFAULT (GETUTCDATE())
)
GO

DECLARE @products NVARCHAR(MAX) = 
N'[{"ProductID":15,"Name":"Adjustable Race","Color":"Magenta","Size":"62","Price":100.0000,"Quantity":75,"CompanyID":1,"Data":{"Type":"Part","MadeIn":"China"},"DateModified":"2016-02-11T21:27:32"},{"ProductID":16,"Name":"Bearing Ball","Color":"Magenta","Size":"62","Price":15.9900,"Quantity":90,"CompanyID":2,"Data":{"ManufacturingCost":11.672700,"Type":"Part","MadeIn":"China"},"Tags":["promo"],"DateModified":"2016-02-11T21:27:32"},{"ProductID":17,"Name":"BB Ball Bearing","Color":"Magenta","Size":"62","Price":28.9900,"Quantity":80,"CompanyID":3,"Data":{"ManufacturingCost":21.162700,"Type":"Part","MadeIn":"China"},"DateModified":"2016-02-11T21:27:32"},{"ProductID":18,"Name":"Blade","Color":"Silver","Size":"62","Price":18.0000,"Quantity":45,"CompanyID":1,"Data":{},"Tags":["new"],"DateModified":"2016-02-11T21:27:32"},{"ProductID":19,"Name":"Sport-100 Helmet, Red","Color":"Black","Size":"72","Price":41.9900,"Quantity":38,"CompanyID":3,"Data":{"ManufacturingCost":30.652700,"Type":"Еquipment","MadeIn":"China"},"Tags":["promo"],"DateModified":"2016-02-11T21:27:32"},{"ProductID":20,"Name":"Sport-100 Helmet, Black","Color":"Black","Size":"72","Price":31.4900,"Quantity":60,"CompanyID":1,"Data":{"ManufacturingCost":22.987700,"Type":"Еquipment","MadeIn":"China"},"Tags":["new","promo"],"DateModified":"2016-02-11T21:27:32"},{"ProductID":21,"Name":"Mountain Bike Socks, M","Color":"White","Size":"M","Price":560.9900,"Quantity":30,"CompanyID":2,"Data":{"Type":"Clothes"},"Tags":["sales","promo"],"DateModified":"2016-02-11T21:27:32"},{"ProductID":22,"Name":"Mountain Bike Socks, L","Color":"White","Size":"L","Price":120.9900,"Quantity":20,"CompanyID":3,"Data":{"ManufacturingCost":88.322700,"Type":"Clothes"},"Tags":["sales","promo"],"DateModified":"2016-02-11T21:27:32"},{"ProductID":23,"Name":"Long-Sleeve Logo Jersey, XL","Color":"White","Size":"XL","Price":44.9900,"Quantity":60,"CompanyID":1,"Data":{"ManufacturingCost":32.842700,"Type":"Clothes"},"Tags":["sales","promo"],"DateModified":"2016-02-11T21:27:32"},{"ProductID":24,"Name":"Road-650 Black, 52","Color":"Black","Size":"52","Price":704.6900,"Quantity":70,"CompanyID":1,"Data":{"Type":"Bike","MadeIn":"UK"},"DateModified":"2016-02-11T21:27:32"},{"ProductID":25,"Name":"Mountain-100 Silver, 38","Color":"White","Size":"38","Price":359.9900,"Quantity":45,"CompanyID":1,"Data":{"ManufacturingCost":262.792700,"Type":"Bike","MadeIn":"UK"},"Tags":["promo"],"DateModified":"2016-02-11T21:27:32"},{"ProductID":26,"Name":"Road-250 Black, 48","Color":"Black","Size":"48","Price":299.0200,"Quantity":25,"CompanyID":2,"Data":{"ManufacturingCost":218.284600,"Type":"Bike","MadeIn":"UK"},"Tags":["new","promo"],"DateModified":"2016-02-11T21:27:32"},{"ProductID":27,"Name":"ML Bottom Bracket","Color":"Silver","Size":"36","Price":101.2400,"Quantity":50,"CompanyID":3,"Data":{"Type":"Part","MadeIn":"China"},"DateModified":"2016-02-11T21:27:32"},{"ProductID":28,"Name":"HL Bottom Bracket","Color":"Silver","Size":"36","Price":121.4900,"Quantity":65,"CompanyID":2,"Data":{"ManufacturingCost":88.687700,"Type":"Part","MadeIn":"China"},"DateModified":"2016-02-11T21:27:32"}]'
INSERT INTO Product (ProductID, Name, Color, Size, Price, Quantity, CompanyID, Data, Tags, DateModified)
SELECT ProductID, Name, Color, Size, Price, Quantity, CompanyID, Data, Tags, DateModified
FROM OPENJSON (@products) WITH(
	ProductID int,Name nvarchar(50),Color nvarchar(15),Size nvarchar(5),Price money,Quantity int,CompanyID int,
	Data nvarchar(MAX) AS JSON,Tags nvarchar(MAX) AS JSON,
	DateModified datetime2(0)
)
GO

DROP TABLE IF EXISTS Company
DROP SEQUENCE IF EXISTS CompanyId
GO
CREATE SEQUENCE CompanyId AS int START WITH 4
CREATE TABLE Company (
	CompanyID int PRIMARY KEY DEFAULT (NEXT VALUE FOR CompanyId),
	Name nvarchar(50) NOT NULL,
	Address nvarchar(100) NULL,
	Contact nvarchar(100) NULL,
	Email nvarchar(50) NULL,
	Phone nvarchar(50) NULL,
	Postcode nvarchar(20) NULL,
)
GO

declare @companies nvarchar(max) = 
N'[{"CompanyID":1,"Name":"A Datum Corporation","Email":"msavic@datum.com","Address":"Suite 10, 183838 Southwest Boulevard, Surrey","Contact":"Milunka Savic","Phone":"(381) 555-7639","Postcode":"46077"},{"CompanyID":2,"Name":"Contoso, Ltd.","Email":"zmisic@contoso.com","Address":"Unit 2, 2934 Night Road, Jolimont","Contact":"Zivojin Misic","Phone":"(360) 555-4901","Postcode":"98253"},{"CompanyID":3,"Name":"Consolidated Messenger","Contact":"Radomir Putnik","Email":"rputnik@consolidated-messanger.com","Address":"894 Market Day Street, West Mont","Phone":"(415) 555-1105","Postcode":"94101"}]'
INSERT INTO Company (CompanyID, Name, Address, Email, Phone, Postcode, Contact)
SELECT CompanyID, Name, Address, Email, Phone, Postcode, Contact
FROM OPENJSON (@companies)
	WITH(CompanyID int, Name nvarchar(50), Address nvarchar(100), Email nvarchar(50), Phone nvarchar(50), Postcode nvarchar(20),Contact nvarchar(100))
GO

DROP PROCEDURE IF EXISTS [dbo].[InsertProductFromJson]
GO
CREATE PROCEDURE [dbo].[InsertProductFromJson](@ProductJson NVARCHAR(MAX))
AS BEGIN

	INSERT INTO dbo.Product(Name,Color,Size,Price,Quantity,CompanyID,Data,Tags)
	OUTPUT  INSERTED.ProductID
	SELECT Name,Color,Size,Price,Quantity,CompanyID,Data,Tags
	FROM OPENJSON(@ProductJson)
		WITH (	Name nvarchar(100) N'strict $."Name"',
				Color nvarchar(30),
				Size nvarchar(10),
				Price money N'strict $."Price"',
				Quantity int,
				CompanyID int,
				Data nvarchar(max) AS JSON,
				Tags nvarchar(max) AS JSON) as json
END
GO

DROP PROCEDURE IF EXISTS dbo.UpdateProductFromJson
GO
CREATE PROCEDURE dbo.UpdateProductFromJson(@ProductID int, @ProductJson NVARCHAR(MAX))
AS BEGIN

	UPDATE dbo.Product SET
		Name = json.Name,
		Color = json.Color,
		Size = json.Size,
		Price = json.Price,
		Quantity = json.Quantity,
		Data = ISNULL(json.Data, dbo.Product.Data),
		Tags = ISNULL(json.Tags,dbo.Product.Tags)
	FROM OPENJSON(@ProductJson)
		WITH (	Name nvarchar(100) N'strict $."Name"',
				Color nvarchar(30),
				Size nvarchar(10),
				Price money N'strict $."Price"',
				Quantity int,
				Data nvarchar(max) AS JSON,
				Tags nvarchar(max) AS JSON) as json
	WHERE dbo.Product.ProductID = @ProductID

END
GO
DROP TABLE IF EXISTS Logs;
GO
CREATE TABLE Logs (
   Id int IDENTITY PRIMARY KEY,
   Message nvarchar(max) NULL,
   MessageTemplate nvarchar(max) NULL,
   Level nvarchar(128) NULL,
   TimeStamp datetimeoffset(7) NOT NULL,
   Exception nvarchar(max) NULL,
   Properties xml NULL,
   LogEvent nvarchar(max) NULL
);


-- 2 json.sql

--Combine standard columns with JSON columns.
select Name,Color,Size,Price,Quantity,Data,Tags
from Product

/* Basic Demo */


-- Get List of products
select ProductID, Name,Color,Size,Price,Quantity,
		JSON_VALUE(Data, '$.MadeIn') as MadeIn,
		JSON_QUERY(Tags) as Tags
from Product
FOR JSON PATH

-- Get Product details
select Name,Color,Size,Price,Quantity
from Product
where ProductID = 17
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER 

-- Insert new product
declare @p nvarchar(4000) = 
N'{"Name":"NEW","Color":"Magenta","Size":"62",
   "Price":28.9900,"Quantity":80}'
EXEC dbo.InsertProductFromJson @p

-- Update product
declare @p nvarchar(4000) =
N'{"Name":"HL Bottom Bracket","Price":121.4900,"Quantity":65}'

EXEC dbo.UpdateProductFromJson 28, @p

/* End Basic Demo */

/* Detailed Demo */

--Use JSON Data in queries
select ProductID, Name, Color, Size, Price, Quantity, Data, Tags,
		JSON_VALUE(Data, '$.MadeIn') as MadeIn
from Product
where JSON_VALUE(Data, '$.Type') = 'part'

--Use JSON data in any part of query
select JSON_VALUE(Data, '$.Type') as Type, Color,
		AVG( cast(JSON_VALUE(Data, '$.ManufacturingCost') as float) ) as Cost
from Product
group by JSON_VALUE(Data, '$.Type'), Color
having JSON_VALUE(Data, '$.Type') is not null
order by JSON_VALUE(Data, '$.Type')

--Update JSON Data
--Current values in row:
select Data,Tags
from Product
where ProductID = 16

--Update values in JSON columns:
update Product set
	Data = JSON_MODIFY(Data, '$.ManufacturingCost', 10),
	Tags = JSON_MODIFY(Tags, 'append $', 'new')
where ProductID = 16

--Verify changes.
select Data,Tags
from Product
where ProductID = 16

GO

--Convert JSON object to row.
declare @product nvarchar(4000) =
N'{"Name":"BB Ball Bearing","Color":"Magenta","Size":"62","Price":28.9900,"Quantity":80}'

SELECT *
FROM OPENJSON (@product)
	WITH (Name nvarchar(50),Color nvarchar(15),Size nvarchar(5),Price money,Quantity int)

GO

--Convert JSON array to set of rows.
DECLARE @products NVARCHAR(4000) = 
N'[
{"ProductID":15,"Name":"Adjustable Race","Color":"Magenta","Size":"62","Price":100.0000,"Quantity":75,"Data":{"Type":"Part","MadeIn":"China"}},
{"ProductID":16,"Name":"Bearing Ball","Color":"Magenta","Size":"62","Price":15.9900,"Quantity":90,"Data":{"ManufacturingCost":11.672700,"Type":"Part","MadeIn":"China"},"Tags":["promo"]},
{"ProductID":17,"Name":"BB Ball Bearing","Color":"Magenta","Size":"62","Price":28.9900,"Quantity":80,"Data":{"ManufacturingCost":21.162700,"Type":"Part","MadeIn":"China"}},
{"ProductID":18,"Name":"Blade","Color":"Magenta","Size":"62","Price":18.0000,"Quantity":45,"Data":{},"Tags":["new"]},
{"ProductID":19,"Name":"Sport-100 Helmet, Red","Color":"Red","Size":"72","Price":41.9900,"Quantity":38,"Data":{"ManufacturingCost":30.652700,"Type":"Еquipment","MadeIn":"China"},"Tags":["promo"]},
{"ProductID":20,"Name":"Sport-100 Helmet, Black","Color":"Black","Size":"72","Price":31.4900,"Quantity":60,"Data":{"ManufacturingCost":22.987700,"Type":"Еquipment","MadeIn":"China"},"Tags":["new","promo"]}
]'

SELECT *
FROM OPENJSON (@products)
	WITH (	Name nvarchar(50),Color nvarchar(15),Size nvarchar(5),Price money,Quantity int,
			Type nvarchar(20) '$.Data.Type',
			Data nvarchar(max) AS JSON)

GO

--Query and analyze JSON array.
DECLARE @products NVARCHAR(MAX) = 
N'[{"ProductID":15,"Name":"Adjustable Race","Color":"Magenta","Size":"62","Price":100.0000,"Quantity":75,"Data":{"Type":"Part","MadeIn":"China"}},{"ProductID":16,"Name":"Bearing Ball","Color":"Magenta","Size":"62","Price":15.9900,"Quantity":90,"Data":{"ManufacturingCost":11.672700,"Type":"Part","MadeIn":"China"},"Tags":["promo"]},{"ProductID":17,"Name":"BB Ball Bearing","Color":"Magenta","Size":"62","Price":28.9900,"Quantity":80,"Data":{"ManufacturingCost":21.162700,"Type":"Part","MadeIn":"China"}},{"ProductID":18,"Name":"Blade","Color":"Magenta","Size":"62","Price":18.0000,"Quantity":45,"Data":{},"Tags":["new"]},{"ProductID":19,"Name":"Sport-100 Helmet, Red","Color":"Red","Size":"72","Price":41.9900,"Quantity":38,"Data":{"ManufacturingCost":30.652700,"Type":"Еquipment","MadeIn":"China"},"Tags":["promo"]},{"ProductID":20,"Name":"Sport-100 Helmet, Black","Color":"Black","Size":"72","Price":31.4900,"Quantity":60,"Data":{"ManufacturingCost":22.987700,"Type":"Еquipment","MadeIn":"China"},"Tags":["new","promo"]},{"ProductID":21,"Name":"Mountain Bike Socks, M","Color":"White","Size":"M","Price":560.9900,"Quantity":30,"Data":{"Type":"Clothes"},"Tags":["sales","promo"]},{"ProductID":22,"Name":"Mountain Bike Socks, L","Color":"White","Size":"L","Price":120.9900,"Quantity":20,"Data":{"ManufacturingCost":88.322700,"Type":"Clothes"},"Tags":["sales","promo"]},{"ProductID":23,"Name":"Long-Sleeve Logo Jersey, XL","Color":"Multi","Size":"XL","Price":44.9900,"Quantity":60,"Data":{"ManufacturingCost":32.842700,"Type":"Clothes"},"Tags":["sales","promo"]},{"ProductID":24,"Name":"Road-650 Black, 52","Color":"Black","Size":"52","Price":704.6900,"Quantity":70,"Data":{"Type":"Bike","MadeIn":"UK"}},{"ProductID":25,"Name":"Mountain-100 Silver, 38","Color":"Silver","Size":"38","Price":359.9900,"Quantity":45,"Data":{"ManufacturingCost":262.792700,"Type":"Bike","MadeIn":"UK"},"Tags":["promo"]},{"ProductID":26,"Name":"Road-250 Black, 48","Color":"Black","Size":"48","Price":299.0200,"Quantity":25,"Data":{"ManufacturingCost":218.284600,"Type":"Bike","MadeIn":"UK"},"Tags":["new","promo"]},{"ProductID":27,"Name":"ML Bottom Bracket","Price":101.2400,"Quantity":50,"Data":{"Type":"Part","MadeIn":"China"}},{"ProductID":28,"Name":"HL Bottom Bracket","Price":121.4900,"Quantity":65,"Data":{"ManufacturingCost":88.687700,"Type":"Part","MadeIn":"China"}}]'

SELECT ISNULL(Color, 'N/A') Color, AVG(Price) AvgPrice, MIN(Quantity) MinQuantity
FROM OPENJSON (@products)
	WITH (Name nvarchar(50),Color nvarchar(15),Size nvarchar(5),Price money,Quantity int)
group by Color
having MIN(Quantity) > 10
order by Color

GO

--Find rows that contain some value in JSON array.
select ProductID, Name, Color, Size, Price, Quantity, Tags
from Product
	 CROSS APPLY OPENJSON(Tags) 
where value = 'promo'

GO

--Format query results as JSON (with error).
select Name,Color,Size,Price,Quantity,Data,Tags
from Product
FOR JSON PATH

--Format query results as JSON.
select Name,Color,Size,Price,Quantity,JSON_QUERY(Data) as Data, JSON_QUERY(Tags) as Tags
from Product
FOR JSON PATH

--Export single row as JSON.
select Name,Color,Size,Price,Quantity,JSON_QUERY(Data) as Data, JSON_QUERY(Tags) as Tags
from Product
where ProductID = 17
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER


-- 3 setup-temporal.sql

DROP TABLE IF EXISTS History.Product
GO
DROP SCHEMA IF EXISTS History
GO
CREATE SCHEMA History
GO

CREATE TABLE History.Product(
	ProductID int NOT NULL,
	Name nvarchar(50) NOT NULL,
	Color nvarchar(15) NULL,
	Size nvarchar(5) NULL,
	Price money NOT NULL,
	Quantity int NULL,
	CompanyID int,
	Data nvarchar(4000),
	Tags nvarchar(4000),
	DateModified datetime2(0) NOT NULL,
	ValidTo datetime2(0) NOT NULL
)


DECLARE @products NVARCHAR(MAX) =
N'[{"ProductID":15,"Name":"Adjustable Race","Price":75.9900,"Quantity":50,"CompanyID":1,"Data":{"Type":"Part","MadeIn":"China"},"DateModified":"2015-05-07T03:39:52","ValidTo":"2015-08-07T03:40:01"},{"ProductID":16,"Name":"Bearing Ball","Price":35.9900,"Quantity":80,"CompanyID":2,"Data":{"ManufacturingCost":11.672700,"Type":"Part","MadeIn":"China"},"Tags":["promo"],"DateModified":"2015-05-07T03:39:52","ValidTo":"2015-08-07T03:40:01"},{"ProductID":17,"Name":"BB Ball Bearing","Price":75.0000,"Quantity":20,"CompanyID":3,"Data":{"ManufacturingCost":21.162700,"Type":"Part","MadeIn":"China"},"DateModified":"2015-05-07T03:39:52","ValidTo":"2015-08-07T03:40:01"},{"ProductID":18,"Name":"Blade","Color":"Silver","Price":20.9900,"Quantity":70,"CompanyID":1,"Data":{},"Tags":["new"],"DateModified":"2015-05-07T03:40:01","ValidTo":"2015-08-07T03:40:01"},{"ProductID":15,"Name":"Adjustable Race","Color":"Magenta","Size":"62","Price":89.9900,"Quantity":80,"CompanyID":1,"Data":{"Type":"Part","MadeIn":"China"},"DateModified":"2015-08-07T03:40:01","ValidTo":"2015-11-07T03:40:09"},{"ProductID":16,"Name":"Bearing Ball","Color":"Blue","Size":"62","Price":15.9900,"Quantity":120,"CompanyID":2,"Data":{"ManufacturingCost":11.672700,"Type":"Part","MadeIn":"China"},"Tags":["promo"],"DateModified":"2015-08-07T03:40:01","ValidTo":"2015-11-07T03:40:09"},{"ProductID":17,"Name":"BB Ball Bearing","Color":"Magenta","Size":"62","Price":25.1900,"Quantity":65,"CompanyID":3,"Data":{"ManufacturingCost":21.162700,"Type":"Part","MadeIn":"China"},"DateModified":"2015-08-07T03:40:01","ValidTo":"2015-11-07T03:40:09"},{"ProductID":18,"Name":"Blade","Color":"Silver","Size":"62","Price":20.9900,"Quantity":80,"CompanyID":1,"Data":{},"Tags":["new"],"DateModified":"2015-08-07T03:40:01","ValidTo":"2015-11-07T03:40:09"},{"ProductID":18,"Name":"Blade","Color":"Silver","Size":"62","Price":20.1500,"Quantity":95,"CompanyID":1,"Data":{},"Tags":["new"],"DateModified":"2015-11-07T03:40:09","ValidTo":"2016-02-07T03:40:15"},{"ProductID":17,"Name":"BB Ball Bearing","Color":"Magenta","Size":"62","Price":37.9900,"Quantity":90,"CompanyID":3,"Data":{"ManufacturingCost":21.162700,"Type":"Part","MadeIn":"China"},"DateModified":"2015-11-07T03:40:09","ValidTo":"2016-02-07T03:40:15"},{"ProductID":16,"Name":"Bearing Ball","Color":"Blue","Size":"62","Price":0.0000,"Quantity":110,"CompanyID":2,"Data":{"ManufacturingCost":11.672700,"Type":"Part","MadeIn":"China"},"Tags":["promo"],"DateModified":"2015-11-07T03:40:09","ValidTo":"2016-02-07T03:40:15"},{"ProductID":15,"Name":"Adjustable Race","Color":"Magenta","Size":"62","Price":105.9900,"Quantity":100,"CompanyID":1,"Data":{"Type":"Part","MadeIn":"China"},"DateModified":"2015-11-07T03:40:09","ValidTo":"2016-02-07T03:40:15"},{"ProductID":26,"Name":"Road-250 Black, 48","Color":"Black","Size":"48","Price":1250.9900,"Quantity":90,"CompanyID":2,"Data":{"ManufacturingCost":218.284600,"Type":"Bike","MadeIn":"UK"},"Tags":["new","promo"],"DateModified":"2015-12-28T03:40:15","ValidTo":"2016-02-07T03:40:15"},{"ProductID":25,"Name":"Mountain-100 Silver, 38","Color":"Silver","Size":"38","Price":799.9900,"Quantity":90,"CompanyID":1,"Data":{"ManufacturingCost":262.792700,"Type":"Bike","MadeIn":"UK"},"Tags":["promo"],"DateModified":"2015-12-28T03:40:15","ValidTo":"2016-02-07T03:40:15"},{"ProductID":24,"Name":"Road-650 Black, 52","Color":"Black","Size":"52","Price":529.9900,"Quantity":90,"CompanyID":1,"Data":{"Type":"Bike","MadeIn":"UK"},"DateModified":"2015-12-28T03:40:15","ValidTo":"2016-02-07T03:40:15"},{"ProductID":23,"Name":"Long-Sleeve Logo Jersey, XL","Color":"Multi","Size":"XL","Price":49.9900,"Quantity":90,"CompanyID":1,"Data":{"ManufacturingCost":32.842700,"Type":"Clothes"},"Tags":["sales","promo"],"DateModified":"2015-12-28T03:40:15","ValidTo":"2016-02-07T03:40:15"},{"ProductID":22,"Name":"Mountain Bike Socks, L","Color":"White","Size":"L","Price":19.9900,"Quantity":90,"CompanyID":3,"Data":{"ManufacturingCost":88.322700,"Type":"Clothes"},"Tags":["sales","promo"],"DateModified":"2015-12-28T03:40:15","ValidTo":"2016-02-07T03:40:15"},{"ProductID":21,"Name":"Mountain Bike Socks, M","Color":"White","Size":"M","Price":9.5000,"Quantity":90,"CompanyID":2,"Data":{"Type":"Clothes"},"Tags":["sales","promo"],"DateModified":"2015-12-28T03:40:15","ValidTo":"2016-02-07T03:40:15"},{"ProductID":20,"Name":"Sport-100 Helmet, Black","Color":"Black","Price":45.9900,"Quantity":10,"CompanyID":1,"Data":{"ManufacturingCost":22.987700,"Type":"Еquipment","MadeIn":"China"},"Tags":["new","promo"],"DateModified":"2015-12-28T03:40:15","ValidTo":"2016-02-07T03:40:15"},{"ProductID":19,"Name":"Sport-100 Helmet, Red","Color":"Red","Price":34.9900,"Quantity":10,"CompanyID":3,"Data":{"ManufacturingCost":30.652700,"Type":"Еquipment","MadeIn":"China"},"Tags":["promo"],"DateModified":"2015-12-28T03:40:15","ValidTo":"2016-02-07T03:40:15"},{"ProductID":15,"Name":"Adjustable Race","Color":"Magenta","Size":"62","Price":32.9900,"Quantity":75,"CompanyID":1,"Data":{"Type":"Part","MadeIn":"China"},"DateModified":"2016-02-10T21:19:20","ValidTo":"2016-02-11T21:15:48"},{"ProductID":15,"Name":"Adjustable Race","Color":"Magenta","Size":"62","Price":100.0000,"Quantity":75,"CompanyID":1,"Data":{"Type":"Part","MadeIn":"China"},"DateModified":"2016-02-11T21:15:48","ValidTo":"2016-02-11T21:24:12"},{"ProductID":15,"Name":"Adjustable Race","Color":"Magenta","Size":"62","Price":120.0000,"Quantity":75,"CompanyID":1,"Data":{"Type":"Part","MadeIn":"China"},"DateModified":"2016-02-11T21:24:12","ValidTo":"2016-02-11T21:27:32"}]';
INSERT INTO History.Product(ProductID, Name, Color, Size, Price, Quantity, CompanyID, Data, Tags, DateModified, ValidTo)
SELECT ProductID, Name, Color, Size, Price, Quantity, CompanyID, Data, Tags, DateModified, ValidTo
FROM OPENJSON (@products) WITH(
	ProductID int, Name nvarchar(50),Color nvarchar(15),Size nvarchar(5),Price money,Quantity int,CompanyID int,
	Data nvarchar(MAX) AS JSON,Tags nvarchar(MAX) AS JSON,
	DateModified datetime2(0),ValidTo datetime2(0)
)
GO


ALTER TABLE Product
	DROP COLUMN IF EXISTS ValidTo

ALTER TABLE Product
	ADD ValidTo datetime2(0) NOT NULL 
		CONSTRAINT Product_ValidTo_EndTime DEFAULT ('9999-12-31 23:59:59')

GO

ALTER TABLE Product
	ADD PERIOD FOR SYSTEM_TIME (DateModified, ValidTo)

GO

ALTER TABLE Product
	SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = History.Product))

GO

drop function if exists dbo.diff_Product
go
create function dbo.diff_Product (@id int, @date datetime2(0))
returns table
as
return (
	select v1.[key] as [Column], v1.value as v1, v2.value as v2
	from OPENJSON(
			(select * from Product where ProductID = @id FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) v1
		join OPENJSON(
			(select * from Product for system_time as of @date where ProductID = @id FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) v2
		on v1.[key] = v2.[key]
	where v1.value <> v2.value
)
GO


drop procedure if exists dbo.GetProducts
go
create procedure dbo.GetProducts as 
begin

	select Product.ProductID, Product.Name, Product.Color, Product.Price, Product.Quantity,
			JSON_VALUE(Product.Data, '$.MadeIn') as MadeIn, JSON_QUERY(Product.Tags) as Tags,
			ProductHistory.*
	from Product
		left join History.Product as ProductHistory
			on Product.ProductID = ProductHistory.ProductID
	order by Product.ProductID asc, ProductHistory.DateModified desc
	FOR JSON AUTO, ROOT('data')

end
GO

drop procedure if exists dbo.GetProductsAsOf
go
create procedure dbo.GetProductsAsOf (@date datetime2) as 
begin

	select Product.ProductID, Product.Name, Product.Color, Product.Price, Product.Quantity,
			JSON_VALUE(Product.Data, '$.MadeIn') as MadeIn, JSON_QUERY(Product.Tags) as Tags,
			Product.DateModified,
			ProductDifferences.*
	from Product FOR SYSTEM_TIME AS OF @date
		outer apply dbo.diff_Product(Product.ProductID, @date) as ProductDifferences
	order by Product.ProductID asc
	FOR JSON AUTO, ROOT('data')

end
GO

GO
drop procedure if exists dbo.RestoreProduct
GO
create procedure dbo.RestoreProduct (@productid int, @date datetime2) as 
begin

	MERGE Product
	USING (
		select ProductID, Name, Color, Size, Price, Quantity, CompanyID, Tags, Data
		from Product FOR SYSTEM_TIME AS OF @date
		where ProductID = @productid)
		AS Restored (ProductID, Name, Color, Size, Price, Quantity, CompanyID, Tags, Data)
	ON (Product.ProductID = Restored.ProductID)
	WHEN MATCHED THEN
		update set
				Name = restored.Name,
				Color = restored.Color,
				Size = restored.Size,
				Price = restored.Price,
				Quantity = restored.Quantity,
				CompanyId = restored.CompanyID,
				Data = restored.Data,
				Tags = restored.Tags
	WHEN NOT MATCHED THEN
		insert (ProductID, Name, Color, Size, Price, Quantity, CompanyID, Data, Tags)
		values (ProductID, Name, Color, Size, Price, Quantity, CompanyID, Data, Tags);
end
GO

-- 4 temporal.sql

--Note: Run setup.sql script to create ProductCatalog database.
USE ProductCatalog
GO

-- Find the time when the first product(s) were inserted.
select min(DateModified) from History.Product;

--List of current products.
select ProductID, Name, Color, Size, Price, Quantity
from Product;

--Go back in time and show the list of products. 
select ProductID, Name, Color, Size, Price, Quantity
from Product FOR SYSTEM_TIME AS OF '2015-07-28 13:20:00';

--Show the difference between current version of the product with ID 17 and version that existed in past. 
select *
from dbo.diff_Product(17, '2015-07-28 13:20:00');

--Return full history of changes for product with ID 17.
select ProductID, Name, Color, Size, Price, Quantity, DateModified, ValidTo
from Product FOR SYSTEM_TIME ALL
where productid = 17
order by DateModified desc;

--Update product with ID 17.
update Product
set Color = 'Silver'
where productid = 17;

--Verify that color is changed to 'Silver'.
select ProductID, Name, Color, Size, Price, Quantity, DateModified, ValidTo
from Product
where productid = 17;

--Return history of the product. You should see one additional row in history.
select ProductID, Name, Color, Size, Price, Quantity, DateModified, ValidTo
from Product FOR SYSTEM_TIME ALL
where productid = 17
order by DateModified desc;

--Restore product. Overwrite the latest version with the verison that was valid last year.
exec RestoreProduct 17, '2015-11-07 03:40:09';

--Return history of the product with id 17 and verify that it current version and '2015-11-07 03:40:09' version are identical.  
select ProductID, Name, Color, Size, Price, Quantity, DateModified, ValidTo
from Product FOR SYSTEM_TIME ALL
where productid = 17
order by DateModified desc;

-- Identify "spikes" in product price changes.
with history as (

	select ProductID, Name, Price, DateModified,
			LAG (Price, 1) over (partition by ProductID order by DateModified) as PrevPrice,
			LEAD (Price, 1) over (partition by ProductID order by DateModified) as NextPrice
	 from dbo.Product for system_time all

)
select DateModified, ProductID, Name, PrevPrice, Price,  NextPrice
from history
where PrevPrice = NextPrice
	AND ABS(NextPrice - Price)/NextPrice >=0.1

-- 5 data-masking.sql
ALTER TABLE  Company
ALTER COLUMN Email ADD MASKED WITH (FUNCTION = 'email()')

ALTER TABLE  Company
ALTER COLUMN Phone ADD MASKED WITH (FUNCTION = 'partial(5,"XXXXXXX",2)')

ALTER TABLE  Company
ALTER COLUMN Postcode ADD MASKED WITH (FUNCTION = 'default()')


/* TRY IT:

EXECUTE AS USER = 'WebUser';
SELECT * FROM Company;
REVERT;

*/

-- 6 rls

DROP SECURITY POLICY IF EXISTS dbo.ClientAccessPolicy
GO
DROP FUNCTION IF EXISTS dbo.pUserCanAccessCompanyData
GO

CREATE FUNCTION 
dbo.pUserCanAccessCompanyData(@CompanyID int)
	RETURNS TABLE
	WITH SCHEMABINDING
AS RETURN (
	SELECT 1 as canAccess WHERE
	 
	SESSION_CONTEXT(N'CompanyID') = '-1'
	OR CAST(SESSION_CONTEXT(N'CompanyID') as int) = @CompanyID)

GO

/*
TRY IT:
EXEC sp_set_session_context 'CompanyID', '-1'
select SESSION_CONTEXT(N'CompanyID')
SELECT * FROM dbo.pUserCanAccessCompanyData(1)
*/

CREATE SECURITY POLICY dbo.ClientAccessPolicy
	ADD FILTER PREDICATE dbo.pUserCanAccessCompanyData(CompanyID) ON dbo.Product
	WITH (State=ON)
GO

/*
EXEC sp_set_session_context 'CompanyID', '-1'
SELECT * FROM Product

EXEC sp_set_session_context 'CompanyID', 1
SELECT * FROM Product

EXEC sp_set_session_context 'CompanyID', 2
SELECT * FROM Product

EXEC sp_set_session_context 'CompanyID', 777
SELECT * FROM Product
*/

-- Add RLS on history data
ALTER SECURITY POLICY dbo.ClientAccessPolicy
	ADD FILTER PREDICATE dbo.pUserCanAccessCompanyData(CompanyID) ON History.Product
GO

/*
	Don't allow company to enter a product for different company.
*/
ALTER SECURITY POLICY dbo.ClientAccessPolicy
	ADD BLOCK PREDICATE dbo.pUserCanAccessCompanyData(CompanyID) ON dbo.Product
GO

/*
	Don't show other companies to current company.
*/
ALTER SECURITY POLICY dbo.ClientAccessPolicy
	ADD FILTER PREDICATE dbo.pUserCanAccessCompanyData(CompanyID) ON dbo.Company
GO