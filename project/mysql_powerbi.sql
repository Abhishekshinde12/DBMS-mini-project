CREATE DATABASE IF NOT EXISTS salesDataWalmart;

-- WE HAVE SETTED THIS DATABASE AS DEFAULT HENCE NO NEED TO MENTION THE DB NAME FOR THE QUERIES EVERYTIME

-- already filterd null values here
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(50) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity  INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(12,4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9) NOT NULL,
    gross_income DECIMAL(10,2) NOT NULL,
    rating FLOAT(2,1) NOT NULL
);


--  -----------------------------Feature engineering-------------------------------------------------

--  calculating the time_of_date  (evening , afternoon , morning) and for this we use case statement (like switch case)

SELECT time , ( CASE 
					WHEN  `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
					WHEN  `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
                    ELSE "EVENING"
				END )  AS time_of_date
FROM sales ;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- we change the settings to update or delete without a where clause and also reconnect to the server under query tab
UPDATE sales SET time_of_day = (
CASE 
	WHEN  `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN  `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "EVENING"
END );


-- day_name . DAYNAME - gives the day

SELECT date , DAYNAME(date) AS day_name FROM sales;
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
UPDATE sales SET day_name = DAYNAME(date);


-- month_name 

SELECT date , MONTHNAME(date) FROM sales;
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales SET month_name = MONTHNAME(date);




-- ----------------------- GENERIC ANALYSIS ------------------------------------

-- How many unique cities does the data have
SELECT DISTINCT city FROM sales;

-- How many branches do we have
SELECT DISTINCT branch FROM sales;

-- In which city is each individual branch
SELECT DISTINCT city , branch FROM sales;

-- How many unique product lines does it have
SELECT COUNT(DISTINCT product_line) FROM sales;

-- Most common payment method
SELECT payment_method , COUNT(payment_method) AS cnt FROM sales GROUP BY payment_method ORDER BY cnt DESC;

-- What is the most selling product line
SELECT product_line , COUNT(product_line) AS cnt FROM sales GROUP BY product_line ORDER BY cnt DESC;

-- total revenue by month
SELECT month_name AS month , SUM(total) AS total_revenue FROM sales GROUP BY month_name ORDER BY total_revenue DESC;

-- what month has the largest cogs
SELECT month_name AS month , SUM(cogs) AS cogs FROM sales GROUP BY month_name ORDER BY cogs DESC;

-- What product line had the largest revenue?
SELECT product_line , SUM(total) AS total_revenue FROM sales GROUP BY product_line ORDER BY total_revenue ;

-- city with largest revenue
SELECT branch , city , SUM(total) AS total_revenue FROM sales GROUP BY city , branch ORDER BY total_revenue DESC;

-- Product_line with larges VAT
SELECT product_line , AVG(VAT) as avg_tax FROM sales GROUP BY product_line ORDER BY avg_tax DESC;

-- which Branch sold more products than avg
SELECT branch , SUM(quantity) AS qty FROM sales GROUP BY branch HAVING qty > (SELECT AVG(quantity) FROM sales);

-- most common product line by gender
SELECT gender , product_line , COUNT(gender) AS total_cnt FROM sales GROUP BY gender , product_line ORDER BY total_cnt DESC;





-- ----------------------------------------------------SALES-------------------------------------------------------------------

-- No. of sales made in each time of the day per weekday

SELECT time_of_day , COUNT(*) AS total_sales FROM sales WHERE day_name = "Sunday" GROUP BY time_of_day ORDER BY total_sales DESC;

-- which of the customer types bring the most revenue
SELECT customer_type , SUM(total) AS total_revenue FROM sales GROUP BY customer_type ORDER BY total_revenue DESC;

-- which city has the largest tax percent / VAT 
SELECT city , AVG(VAT) AS VAT FROM sales GROUP BY city ORDER BY VAT DESC;

-- which customer pays the most VAT
SELECT customer_type , AVG(VAT) AS VAT FROM sales GROUP BY customer_type ORDER BY VAT DESC ;




-- ------------------------------------CUSTOMER-----------------------------------------------------

-- unique customer_type
SELECT DISTINCT(customer_type) FROM sales;

-- how many unique payment methods does the data have
SELECT DISTINCT(payment_method) FROM sales;

-- which cutomer type buys the most
SELECT customer_type , COUNT(*) AS custm_cnt FROM sales GROUP BY customer_type;

-- most common gender
SELECT gender , COUNT(*) AS gender_count FROM sales GROUP BY gender ORDER BY gender_count DESC;

-- gender distribution per branch
SELECT gender, branch , COUNT(*) AS gender_count FROM sales WHERE branch = "A" GROUP BY gender ORDER BY gender_count DESC;
SELECT gender, branch , COUNT(*) AS gender_count FROM sales WHERE branch = "B" GROUP BY gender ORDER BY gender_count DESC;
SELECT gender, branch , COUNT(*) AS gender_count FROM sales WHERE branch = "C" GROUP BY gender ORDER BY gender_count DESC;

-- which time of the day do the customers give most ratings
SELECT time_of_day , AVG(rating) AS avg_rating FROM sales GROUP BY time_of_day ORDER BY avg_rating DESC ;

-- which time of the day do the customers give most ratings per branch
SELECT time_of_day, branch , AVG(rating) AS avg_rating FROM sales WHERE branch = "C" GROUP BY time_of_day ORDER BY avg_rating DESC ;

-- which day of the week has the best avg ratings
SELECT day_name , AVG(rating) AS avg_rating FROM sales GROUP BY day_name ORDER BY avg_rating DESC;


-- -------------------------------------------------Miscelanious--------------------------------------------------------

-- total revenue
SELECT SUM(total) FROM sales ;

-- avg transaction price
SELECT AVG(total) FROM sales;


-- avg cost for each product category
SELECT product_line , AVG(total/quantity) FROM sales GROUP BY product_line ;

-- total gross income
SELECT SUM(gross_income) FROM sales;

-- count of sales as per category
SELECT product_line , SUM(quantity) FROM sales GROUP BY product_line;