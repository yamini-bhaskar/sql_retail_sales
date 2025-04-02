--CREATING DATABASE
CREATE DATABASE retail_sales_db

--CREATE TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(50),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
	)

--DATA CLEANING

--Deleting rows with null values
DELETE FROM retail_sales
WHERE transactions_id IS NULL 
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR age IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL

--DATA EXPLORATION

--Number of Sales and Sales dollar
SELECT COUNT(*) as total_sale_count, sum(total_sale) as total_sale_dollar
FROM retail_sales

--Number of Unique customers
SELECT COUNT(distinct customer_id)
FROM retail_sales

--Number of unique product categories
SELECT COUNT(distinct category)
FROM retail_sales

--DATA ANALYSIS

--Retrieve sales made on '2022-11-05'
SELECT * 
FROM retail_sales
WHERE sale_date='2022-11-05'

--Retrieve the total transactions for the 'Clothing' category in November 2022 where the quantity sold is atleast 4.
SELECT * 
FROM retail_sales
WHERE 
	Category = 'Clothing' 
	AND Quantity >= 4
	AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'

--Find the average age of customers for each category
SELECT Category, CEIL(AVG(age))
FROM retail_sales
GROUP BY Category

--Calculate the average sale for each month. Find the best selling month in each year
SELECT Year, Month, CEIL(avg_sale) FROM (
	SELECT 
		EXTRACT(YEAR FROM sale_date) as Year, 
		EXTRACT(MONTH FROM sale_date) as Month, 
		AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
	FROM retail_sales
	GROUP BY Year, Month 
	) as sales_rank
WHERE Rank=1

--Extract the top 5 customers based on the highest total sales
SELECT customer_id, sum(total_sale)
FROM retail_sales
GROUP BY customer_id
ORDER BY sum(total_sale) DESC
LIMIT 5

--Retrieve the total number of transactions made by each gender within each category
SELECT Gender, Category, COUNT(DISTINCT transactions_id) as total_order
FROM retail_sales
GROUP BY Gender, Category

--Extract the number of orders placed based on the timing of the day (Example Morning < 12pm, Afternoon between 12pm & 5pm, Evening >= 5pm)
SELECT 
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS day_timing, 
	count(transactions_id)
FROM retail_sales
GROUP BY day_timing

--Retrieve the total sales quantity and dollar for each category
SELECT Category, SUM(quantity) as total_quantity, sum(total_sale) as total_dollar_sale
FROM retail_sales
GROUP BY Category

--Find the count of unique customers per product category
SELECT Category, COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY Category

