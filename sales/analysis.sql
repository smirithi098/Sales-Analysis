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


