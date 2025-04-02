# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `retail_sales_db`

This project is designed to demonstrates my SQL skills by exploring, cleaning, and analyzing retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_sales_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retail_sales_db;

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
	);
```

### 2. Data Exploration & Cleaning

- **Sales Count**: Determine the total quantity of sales and total sales dollar in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) as total_sale_count, sum(total_sale) as total_sale_dollar
FROM retail_sales;

SELECT COUNT(distinct customer_id)
FROM retail_sales;

SELECT COUNT(distinct category)
FROM retail_sales;

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
	OR total_sale IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Retrieve sales made on '2022-11-05'**:
```sql
SELECT * 
FROM retail_sales
WHERE sale_date='2022-11-05';
```

2. **Retrieve the total transactions for the 'Clothing' category in November 2022 where the quantity sold is atleast 4**:
```sql
SELECT * 
FROM retail_sales
WHERE 
	Category = 'Clothing' 
	AND Quantity >= 4
	AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'

--Find the average age of customers for each category
SELECT Category, CEIL(AVG(age))
FROM retail_sales
GROUP BY Category;
```

3. **Calculate the average sale for each month. Find the best selling month in each year**:
```sql
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
```

4. **Extract the top 5 customers based on the highest total sales**:
```sql
SELECT customer_id, sum(total_sale)
FROM retail_sales
GROUP BY customer_id
ORDER BY sum(total_sale) DESC
LIMIT 5;
```

5. **Retrieve the total number of transactions made by each gender within each category**:
```sql
SELECT Gender, Category, COUNT(DISTINCT transactions_id) as total_order
FROM retail_sales
GROUP BY Gender, Category;
```

6. **Extract the number of orders placed based on the timing of the day (Example Morning < 12pm, Afternoon between 12pm & 5pm, Evening >= 5pm)**:
```sql
SELECT 
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS day_timing, 
	count(transactions_id)
FROM retail_sales
GROUP BY day_timing
```

7. **Retrieve the total sales quantity and dollar for each category**:
```sql
SELECT Category, SUM(quantity) as total_quantity, sum(total_sale) as total_dollar_sale
FROM retail_sales
GROUP BY Category
```

8. **Find the count of unique customers per product category**:
```sql
SELECT Category, COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY Category
```
## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.


