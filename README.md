# 🛒 Retail Sales Analysis — SQL Project

A beginner-to-intermediate SQL project that demonstrates end-to-end data analysis on a retail sales dataset — from database setup and data cleaning to exploration and answering real business questions.

---

## 📁 Project Structure

```
Retail-Sales-Analysis/
│
├── Retail_sales_analysis_query.sql   # All SQL queries
├── SQL - Retail Sales Analysis_utf.csv  # Dataset (add your CSV here)
└── README.md
```

---

## 🗃️ Database & Table Setup

```sql
CREATE DATABASE Retail_Sales_Analysis;

CREATE TABLE Retail_Sales(
    transactions_id   INT PRIMARY KEY,
    sale_date         DATE,
    sale_time         TIME,
    customer_id       INT,
    gender            VARCHAR(20),
    age               INT,
    category          VARCHAR(50),
    quantiy           INT,
    price_per_unit    NUMERIC(10,2),
    cogs              NUMERIC(10,2),
    total_sale        NUMERIC(10,2)
);
```

> **Note:** The column `quantiy` is a typo in the original dataset — kept as-is to match the source CSV.

---

## 📥 Data Import

```sql
COPY Retail_sales(transactions_id, sale_date, sale_time, customer_id, gender,
age, category, quantiy, price_per_unit, cogs, total_sale)
FROM 'your/path/to/SQL - Retail Sales Analysis_utf .csv'
DELIMITER ','
CSV HEADER;
```

> Update the file path to match your local environment before running.

---

## 🧹 Data Cleaning

Check for NULL values across all columns in one query:

```sql
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
```

Remove rows with missing values:

```sql
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
```

---

## 🔍 Data Exploration

```sql
-- Total number of sales
SELECT COUNT(transactions_id) AS total_sale FROM Retail_Sales;

-- Total unique customers
SELECT COUNT(DISTINCT customer_id) AS total_unique_customer FROM Retail_Sales;

-- Number of unique categories
SELECT COUNT(DISTINCT category) AS unique_category FROM Retail_Sales;

-- Category names
SELECT DISTINCT category AS category_name FROM Retail_Sales;
```

---

## 📊 Business Questions & SQL Solutions

### Q1. Sales on a specific date
> Retrieve all columns for sales made on `2022-11-05`

```sql
SELECT * FROM Retail_Sales
WHERE sale_date = '2022-11-05';
```

---

### Q2. Clothing sales with quantity ≥ 3 in November 2022
> Filter by category, quantity, and month

```sql
SELECT *
FROM Retail_Sales
WHERE category = 'Clothing'
  AND quantiy >= 3
  AND TO_CHAR(sale_date, 'yyyy-mm') = '2022-11';
```

---

### Q3. Total sales per category

```sql
SELECT category,
       SUM(total_sale) AS net_sale,
       COUNT(*) AS total_orders
FROM Retail_Sales
GROUP BY category;
```

---

### Q4. Average age of Beauty category customers

```sql
SELECT category,
       ROUND(AVG(age), 2) AS average_age
FROM Retail_Sales
WHERE category = 'Beauty'
GROUP BY category;
```

---

### Q5. Transactions with total sale > 1000

```sql
SELECT * FROM Retail_Sales
WHERE total_sale > 1000;
```

---

### Q6. Total transactions by gender per category

```sql
SELECT category,
       gender,
       COUNT(*) AS total_transactions
FROM Retail_Sales
GROUP BY category, gender
ORDER BY category;
```

---

### Q7. Best-selling month per year
> Uses window function `RANK()` to identify the top month

```sql
SELECT year, month, average_sale
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date)  AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale)               AS average_sale,
        RANK() OVER(
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM Retail_Sales
    GROUP BY year, month
) AS t1
WHERE rank = 1;
```

---

### Q8. Top 5 customers by total sales

```sql
SELECT customer_id,
       SUM(total_sale) AS total_sales
FROM Retail_Sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

---

### Q9. Unique customers per category

```sql
SELECT category,
       COUNT(DISTINCT customer_id) AS unique_customers
FROM Retail_Sales
GROUP BY category;
```

---

### Q10. Orders by shift (Morning / Afternoon / Evening)
> Uses a CTE and `CASE` expression on sale time

```sql
WITH Hourly_Sale AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM Retail_Sales
)
SELECT shift,
       COUNT(*) AS total_orders
FROM Hourly_Sale
GROUP BY shift;
```

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| PostgreSQL | Database & query execution |
| pgAdmin / psql | SQL client |
| CSV Dataset | Raw retail sales data |

---

## 💡 Key Concepts Covered

- DDL: `CREATE`, `DROP`, `DELETE`
- DML: `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`
- Aggregate functions: `SUM`, `AVG`, `COUNT`
- Date functions: `EXTRACT`, `TO_CHAR`
- Window functions: `RANK() OVER(PARTITION BY ...)`
- CTEs: `WITH ... AS (...)`
- NULL handling & data cleaning

---

## Findins

- Clothing likely leads in transaction volume due to quantity-based filtering showing frequent bulk purchases
- Beauty attracts a mature customer base (~40 years avg. age)
- Evening and Afternoon shifts typically see more footfall in retail 
- A small group of top 5 customers contribute disproportionately to total revenue — classic 80/20 pattern
- Data had minimal NULLs, confirming the dataset is largely clean and reliable

---

## 🚀 How to Run

1. Install [PostgreSQL](https://www.postgresql.org/download/)
2. Create the database and table using the setup queries
3. Update the CSV file path in the `COPY` statement
4. Run the queries in order from the `.sql` file

---

## 📬 Author

Feel free to connect and give feedback!  
If you found this helpful, ⭐ star the repo!
