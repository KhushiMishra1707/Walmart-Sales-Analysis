CREATE DATABASE IF NOT EXISTS Walmart;

CREATE TABLE Sales(
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    Branch VARCHAR(10) NOT NULL,
    City VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT NOT NULL,
    Total DECIMAL(12,4) NOT NULL,
    Date DATETIME NOT NULL,
    Time TIME NOT NULL,
    Payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT,
    gross_income DECIMAL(12,4) NOT NULL,
    rating FLOAT
);

select * from Sales;








-- -----------------------------------------------------------------------------------------------------------------
-- --------------------------------------Feature Engineering---------------------------------------------------------

-- time_of_day

SELECT 
time,
	(CASE
	    WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
        END
	) AS time_of_day
      FROM Sales;
      
      ALTER TABLE Sales ADD COLUMN time_of_day VARCHAR(20);
      
      UPDATE Sales
      SET time_of_day = (
      CASE
	    WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
        END
	);
      
      select * from Sales;
      
      -- day_name
      
SELECT 
     date,
     DAYNAME(date)
FROM sales;

ALTER TABLE Sales ADD COLUMN day_name VARCHAR(10);

UPDATE Sales
SET day_name = DAYNAME(date);


-- month_name

SELECT date,
monthname(date)
from sales;

ALTER TABLE Sales ADD Column month_name Varchar(10);

UPDATE Sales
SET month_name = MONTHNAME(date);


-- ----------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------GENERIC--------------------------------------------------------------------------------

-- How many unique citues does the data have?

select distinct City from Sales;

-- In which city is each branch located?

select distinct City, Branch from Sales


-- ----------------------------------------------------------------------------------------
-- --------------------------------------------PRODUCT----------------------------------------------

-- How many unique product lines does walmart have?

select count(distinct product_line) from Sales;

-- What is the most common payment method?

select payment_method,
count(payment_method) as cnt
from sales
group by payment_method
order by cnt desc;


-- What is the most selling product line?
select * from sales;

select product_line,
count(product_line) as p_cnt
from sales
group by product_line
order by p_cnt desc;


-- What is the total revenue by month?

select month_name as month,
sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;


-- What month has the largest COGS?

select * from sales;


-- What product line has the largest revenue?

select product_line,
sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;


-- What is the city with the largest revenue?

select * from sales;

select city, branch,
sum(total) as total_revenue
from sales
group by city, branch
order by total_revenue desc;


-- What product line has the largest vat?

select * from sales;

select product_line,
avg(vat) as avg_vat
from sales
group by product_line
order by avg_vat desc;


-- Fetch each product line and add a column to those product line showing "good", "bad". good if its greater than average sales.
select total, product_line, avg(total) as avg_sales
from sales
group by product_line
if total > avg_sales then "Good"



-- Which branch sold more products than average products sold?

select branch, sum(quantity) as qty
from sales
group by branch 
having sum(quantity) > (select avg(quantity) from sales);



-- What is the most common product line by gender?

select gender, product_line, count(gender) as total_cnt
from sales
group by gender, product_line
order by total_cnt desc;


-- What is the average rating of each product line?

select round(avg(rating),2) as avg_rating,
product_line
from sales
group by product_line
order by avg_rating desc;


-- ---------------------------------------------------------------------------------------------------
-- ------------------------------------------------------SALES-----------------------------------

-- Number of sales made in each time of the day per weekday?

select time_of_day,
count(*) as total_sales
from sales
where day_name = "Monday"
group by time_of_day;


-- Which of the customer types brings the most revenue?

select customer_type, sum(total) as total_rev
from sales
group by customer_type
order by total_rev desc;


-- Which city has the largest vat?
select city, avg(vat) as vat
from sales
group by city
order by vat desc;


-- Which customer type pays the most tax?

select customer_type,
avg(vat) as vat
from sales
group by customer_type
order by vat desc;


-- -----------------------------------------------------------------------------------------
-- -------------------------------------------CUSTOMER----------------------------------------

-- How many unique customer types does the data have?

select distinct customer_type from sales;


-- How many unique payment methods does the data have?

select distinct payment_method from sales;


-- Which customer type buys the most?

select distinct customer_type, count(*) as cstm_cnt from sales
group by customer_type;

-- What is the gender of most of the customers?

select gender, count(*) as gender_cnt
from sales
group by gender
order by gender_cnt desc;

-- What is the gender distribution per branch?

select gender, count(*) as gender_cnt
from sales
where branch = "C"
group by gender
order by gender_cnt desc;


-- Which time of the day do customers give most ratings?

select time_of_day,
avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;

-- Which time of the day do customers give most ratings per branch?

select time_of_day,
avg(rating) as avg_rating
from sales
where branch = "C"
group by time_of_day
order by avg_rating desc;

-- Which day of the week has the best avg ratings?

select day_name, avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc;


-- Which day of the week has the best avg ratings per branch?

select day_name, avg(rating) as avg_rating
from sales
where branch = "B"
group by day_name
order by avg_rating desc;
