SELECT * FROM walmartsalesdata;

-- Data Preprocessing
ALTER TABLE walmartsalesdata
MODIFY COLUMN `Date` DATE;

ALTER TABLE walmartsalesdata
MODIFY COLUMN `Time` TIME;

-- Add additional columns to use along
ALTER TABLE walmartsalesdata
ADD COLUMN Shift VARCHAR(20);

UPDATE walmartsalesdata
SET Shift =
(CASE 
WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
WHEN `time` BETWEEN '12:00:01' AND '16:00:00' THEN 'Afternoon'
ELSE 'Evening'
END);

ALTER TABLE walmartsalesdata
ADD COLUMN `Day` VARCHAR(20);

UPDATE walmartsalesdata
SET `Day` = dayname(`Date`);

ALTER TABLE walmartsalesdata
ADD COLUMN `Month` VARCHAR(10);

UPDATE walmartsalesdata
SET `Month` = monthname(`Date`);

-- Exploratory Data Analysis

-- Generic
-- How many unique cities does the data have?
SELECT DISTINCT CITY
FROM walmartsalesdata;

-- In which City is each branch
SELECT DISTINCT Branch, City
FROM walmartsalesdata
ORDER BY Branch;

-- Product
-- How many unique Product Lines does the data have?
SELECT DISTINCT `Product line`
FROM walmartsalesdata;

-- What is the most common payment method?
SELECT Payment, COUNT(Payment) As Total_Payments 
FROM walmartsalesdata
GROUP BY Payment
ORDER BY Total_Payments DESC;

-- What is the most selling Product Line?
SELECT `Product line`, SUM(Quantity) AS Products_Sold
FROM walmartsalesdata
GROUP BY `Product line`
ORDER BY Products_Sold DESC;

-- What is the total revenue by month?
SELECT `Month`, ROUND(SUM(Total),2) AS Total_Revenue
FROM walmartsalesdata
GROUP BY `Month`;

-- Which month had the largest COGS?
SELECT `Month`, ROUND(SUM(cogs),2) AS Total_COGS
FROM walmartsalesdata
GROUP BY `Month`
ORDER BY Total_COGS DESC;

-- What Product Line had the largest revenue?
SELECT `Product line`, ROUND(SUM(Total),2) AS Total_Revenue
FROM walmartsalesdata
GROUP BY `Product line`
ORDER BY Total_Revenue DESC;

-- Which City had the largest Revenue?
SELECT City, ROUND(SUM(Total),2) AS Total_Revenue
FROM walmartsalesdata
GROUP BY City
ORDER BY Total_Revenue DESC;

-- Which product line had the highest VAT?
SELECT `Product line`, ROUND(AVG(`Tax 5%`),2) AS Avg_VAT
FROM walmartsalesdata
GROUP BY `Product line`
ORDER BY Avg_VAT DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
ALTER TABLE walmartsalesdata
ADD COLUMN Remark VARCHAR(5);

UPDATE walmartsalesdata
SET Remark = 
(CASE 
WHEN Total > (SELECT AVG(Total) from walmartsalesdata) THEN 'Good'
ELSE 'Bad'
END);


-- Which branch sold more products than average product sold?
SELECT Branch, SUM(Quantity) AS Products_sold
FROM walmartsalesdata
GROUP BY Branch
HAVING Products_sold > (SELECT AVG(Quantity) FROM walmartsalesdata)
ORDER BY Products_sold;

-- What is the most common product line by gender?
SELECT Gender, `Product line`, COUNT(`Product line`)
FROM walmartsalesdata
GROUP BY Gender, `Product line`
ORDER BY COUNT(`Product line`) DESC;

-- What is the average rating of each product line?
SELECT `Product line`, ROUND(AVG(Rating),2) AS Avg_Rating
FROM walmartsalesdata
GROUP BY `Product line`
ORDER BY Avg_Rating DESC;


-- Sales
-- Number of sales made in each time of the day
SELECT `Day`, `Shift`, COUNT(DISTINCT `Invoice ID`) AS Total_Sales
FROM walmartsalesdata
GROUP BY `Day`, `Shift`
ORDER BY Total_Sales DESC;


-- Which of the customer types brings the most revenue?
SELECT `Customer type`, ROUND(SUM(Total),2) AS Total_Revenue
FROM walmartsalesdata
GROUP BY `Customer type`
ORDER BY Total_Revenue DESC;


-- Which city has the highest tax percent/ VAT (Value Added Tax)?
SELECT City, ROUND(SUM(`Tax 5%`),2) AS Total_VAT
FROM walmartsalesdata
GROUP BY City
ORDER BY Total_VAT DESC;

-- Which customer type pays the most in VAT?
SELECT `Customer type`, ROUND(SUM(`Tax 5%`),2) AS Total_VAT
FROM walmartsalesdata
GROUP BY `Customer type`
ORDER BY Total_VAT DESC;

-- Customer
-- How many unique customer types does the data have?
SELECT DISTINCT `Customer type`
FROM walmartsalesdata;

-- How many unique payment methods does the data have?
SELECT DISTINCT Payment
FROM walmartsalesdata;

-- What is the most common customer type?
SELECT `Customer type`, COUNT(*)
FROM walmartsalesdata
GROUP BY `Customer type`
ORDER BY COUNT(*) DESC;


-- Which customer type buys the most?
SELECT `Customer type`, COUNT(`Invoice ID`)
FROM walmartsalesdata
GROUP BY `Customer type`
ORDER BY COUNT(`Invoice ID`) DESC;


-- What is the gender of most of the customers?
SELECT Gender, COUNT(Gender)
FROM walmartsalesdata
GROUP BY Gender
ORDER BY COUNT(Gender) DESC;


-- What is the gender distribution per branch?
SELECT Branch, Gender, COUNT(Gender)
FROM walmartsalesdata
GROUP BY Branch, Gender
ORDER BY COUNT(Gender) DESC;

-- Which time of the day do customers give most ratings?
SELECT Shift, ROUND(AVG(Rating),2) AS Avg_Rating
FROM walmartsalesdata
GROUP BY Shift
ORDER BY Avg_Rating DESC; 

-- Which time of the day do customers give most ratings per branch?
SELECT Shift, Branch, ROUND(AVG(Rating),2) AS Avg_Rating
FROM walmartsalesdata
GROUP BY Shift, Branch
ORDER BY Avg_Rating DESC; 


-- Which day of the week has the best avg ratings?
SELECT `Day`, ROUND(AVG(Rating),2) AS Avg_Rating
FROM walmartsalesdata
GROUP BY `Day`
ORDER BY Avg_Rating DESC; 


-- Which day of the week has the best average ratings per branch?
SELECT `Day`, Branch, ROUND(AVG(Rating),2) AS Avg_Rating
FROM walmartsalesdata
GROUP BY `Day`, Branch
ORDER BY Avg_Rating DESC; 