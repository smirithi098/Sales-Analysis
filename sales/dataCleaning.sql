USE sales_db;

-- ####################### PRODUCTS TABLE ###########################

-- Remove '$' sign from price columns
UPDATE products 
	SET Product_Cost = REPLACE(Product_Cost, '$', '');

UPDATE products 
	SET Product_Price = REPLACE(Product_Price, '$', '');

-- Change data type from varchar to float
ALTER TABLE products ALTER COLUMN Product_Cost float;
ALTER TABLE products ALTER COLUMN Product_Price float;

-- ####################### SALES TABLE ###########################

-- Create new columns for month, year and quarter from the Date column
ALTER TABLE sales ADD 
	date_year int,
	date_month int,
	date_qtr int;


UPDATE sales SET 
	date_year = DATEPART(YEAR, Date),
	date_month = DATEPART(MONTH, Date),
	date_qtr = DATEPART(QUARTER, Date);

-- ####################### STORES TABLE ###########################

-- Create new columns for month, year and quarter from the Date column
ALTER TABLE stores ADD 
	year int,
	month int,
	qtr int;


UPDATE stores SET 
	year = DATEPART(YEAR, Store_Open_Date),
	month = DATEPART(MONTH, Store_Open_Date),
	qtr = DATEPART(QUARTER, Store_Open_Date);