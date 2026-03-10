-- Retail Sales Analysis SQL Project 

-- CREATE DATABASE
CREATE DATABASE Retail_Sales_Analysis;

-- CREATE TABLE
DROP TABLE IF EXISTS Retail_Sales ;

CREATE TABLE Retail_Sales(
				transactions_id	INT PRIMARY KEY,	
				sale_date	DATE,	
				sale_time	TIME,	
				customer_id	INT,	
				gender	VARCHAR(20),	
				age	INT,	
				category	VARCHAR(50),	
				quantiy	INT,	
				price_per_unit	NUMERIC(10,2),	
				cogs	NUMERIC(10,2),	
				total_sale	NUMERIC(10,2)	
);


-- Import Data CSV data in the table
COPY Retail_sales(transactions_id, sale_date, sale_time, customer_id, gender, 
age, category, quantiy, price_per_unit, cogs, total_sale
)
FROM 'D:\SQL Project\Retail Sales Analysis SQL Project\Retail Sales Analysis Dataset\SQL - Retail Sales Analysis_utf .csv'
DELIMITER ','
CSV HEADER;

-- Show all data
SELECT * FROM Retail_Sales;

-- Show first 10 rows 
SELECT * FROM Retail_Sales
LIMIT 10;

-- DATA CLEANING PART

-- Checking any null value present in the dataset
SELECT * FROM Retail_Sales
WHERE transactions_id IS NULL;

SELECT * FROM Retail_Sales
WHERE sale_date IS NULL;

SELECT * FROM Retail_Sales
WHERE sale_time IS NULL;

-- Instead of checking each column individually, I can check for NULL value like that

SELECT *
FROM Retail_Sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- As very less amount of row has missing value, So I will delete these rows

DELETE FROM Retail_Sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- DATA EXPLORATION PART

-- How many sales we have?
SELECT COUNT(transactions_id) as total_sale
FROM Retail_Sales;

-- How many unique customer we have?
SELECT COUNT(DISTINCT customer_id) AS total_unique_customer
From Retail_Sales;

-- How many category we have?
SELECT COUNT(DISTINCT category) as unique_category
FROM Retail_Sales;

-- Show the unique category name
SELECT DISTINCT category as category_name
FROM Retail_Sales;

-- DATA ANALYSIS AND BUSINESS KEY PROBLEMS AND SOLUTIONS

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM Retail_Sales
WHERE sale_date = '2022-11-05';

-- Q2. Write a SQL query to retrive all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 3 in the month of Nov-2022
SELECT *
FROM Retail_Sales
WHERE category='Clothing' 
AND quantiy >= 3
AND TO_CHAR(sale_date,'yyyy-mm') = '2022-11';

-- Q3. Write a SQL query to calculate the total sales for each cateogry.
SELECT category, 
	SUM(total_sale) as net_sale
From Retail_Sales
Group by category;

/*
SELECT category, 
	SUM(total_sale) as net_sale,
    COUNT(*) as total_sale_each_category
From Retail_Sales
Group by category;
*/

-- Q4. Write an SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT category,
	   ROUND(AVG(age),2) as average_age
From Retail_Sales
WHERE category = 'Beauty'
Group by 1;

-- Q5. Write a SQL query to find all transactions where the total sale is greater then 1000.
SELECT * FROM Retail_sales
WHERE total_sale > 1000;

-- Q6. Write a SQL query to find the total number of transactions made by each gender to each category.
SELECT  
        category,
		gender,
		Count(*) as total_transactions
From retail_sales
Group by category, gender
Order by category;

-- Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as average_sale
FROM Retail_Sales
GROUP BY year,month
ORDER BY year, month;

-- Q7. Too find out the best selling monthe in each year
SELECT
	year,
	month,
	average_sale
FROM
(
SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as average_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC ) AS RANK
FROM Retail_Sales
GROUP BY year,month) AS T1
WHERE RANK = 1;

-- Q8. Write a SQL query to find the top 5 customers based on the highest total_sale.
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM Retail_Sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

Select * From retail_sales;
-- Q9. Write a SQL query to find the number of unique customers who purchase item from each category.
SELECT category,
	Count(Distinct customer_id) as unique_customer
FROM Retail_Sales
GROUP BY category;

-- Q10. Write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 and 17, Evening<17)
WITH Hourly_sale 
AS (
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time)< 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as Shift
From retail_sales
)
SELECT Shift,
	Count(*)
From Hourly_sale
Group by Shift;
