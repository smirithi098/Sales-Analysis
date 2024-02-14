USE sales_db;

-- Unique categories of products sold at all stores.
SELECT DISTINCT Product_Category FROM products;


-- All locations of stores across Mexico
SELECT DISTINCT Store_Location FROM stores;


-- Most stocked product category in each store location
SELECT Store_Location, Product_Category, stock
	FROM (
		SELECT s.Store_Location, p.Product_Category, SUM(i.Stock_On_Hand) AS stock,
			ROW_NUMBER() OVER(PARTITION BY s.Store_Location 
							ORDER BY SUM(i.Stock_On_Hand) DESC) AS row_num
			FROM stores s
			INNER JOIN inventory i ON s.Store_ID = i.Store_ID
			INNER JOIN products p ON p.Product_ID = i.Product_ID
			GROUP BY Store_Location, Product_Category
	) AS temp_table
	WHERE row_num = 1;


-- Number of stores opened in every location (by year)
SELECT Store_Location, year, COUNT(Store_ID) AS stores_opened
	FROM stores
	GROUP BY Store_Location, year
	ORDER BY year, stores_opened DESC;

-- Total revenue generated by each product
SELECT p.Product_Name, 
	FORMAT(ROUND(SUM(s.Units * p.Product_Price), 2), 'C', 'en-us') AS Total_Sales
	FROM products p
	INNER JOIN sales s ON p.Product_ID = s.Product_ID
	GROUP BY p.Product_Name
	ORDER BY Total_Sales DESC;

-- Highest performing month/quarter
WITH monthly_sales AS (
SELECT p.Product_ID AS ID, p.Product_Name AS Name,
	s.date_month AS Month,
	FORMAT(ROUND(SUM(s.Units * p.Product_Price), 2), 'C', 'en-us') AS Total_Sales
	FROM products p
	INNER JOIN sales s ON p.Product_ID = s.Product_ID
	GROUP BY p.Product_ID, p.Product_Name, s.date_month
)
SELECT Name, Month, Total_Sales
	FROM (
		SELECT *,
			ROW_NUMBER() OVER(PARTITION BY Month ORDER BY Total_Sales) AS Rank
			FROM monthly_sales
		) AS temp
	WHERE Rank = 1;

-- Profit earned for each product category
WITH earnings AS (
SELECT p.Product_Name, 
	SUM(s.Units) AS Units_Sold,
	ROUND(SUM(s.Units * p.Product_Price), 2) AS Revenue, 
	ROUND(SUM(s.Units * p.Product_Cost), 2) AS Cost
	FROM products p
	INNER JOIN sales s ON p.Product_ID = s.Product_ID
	GROUP BY p.Product_Name
)
SELECT Product_Name, Units_Sold,
	FORMAT(ROUND(Revenue - Cost, 2), 'C', 'en-us') AS Profit
	FROM earnings
	ORDER BY Units_Sold DESC;

-- Top 3 products sold in each store
WITH top_sold_product AS (
	SELECT p.Product_Name, sr.Store_Name, SUM(s.Units) AS sell_count,
		ROW_NUMBER() OVER(PARTITION BY sr.Store_Name 
			ORDER BY SUM(s.Units) DESC) AS ranking
		FROM sales s INNER JOIN products p
		ON s.Product_ID = p.Product_ID
		INNER JOIN stores sr
		ON s.Store_ID = sr.Store_ID
		GROUP BY p.Product_Name, sr.Store_Name
)
SELECT Product_Name, Store_Name, sell_count 
	FROM top_sold_product
	WHERE ranking < 4;

-- How much money is tied up in inventory?
SELECT p.Product_Name, s.Store_Name, 
		SUM(i.Stock_On_Hand * p.Product_Cost) AS money_on_stock
	FROM inventory i
	INNER JOIN products p
	ON i.Product_ID = p.Product_ID
	INNER JOIN stores s
	ON i.Store_ID = s.Store_ID
	GROUP BY p.Product_Name, s.Store_Name;




	
	



