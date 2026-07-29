-- ==========================================================================================================================================
--                                               Superstore Sales Performance Analysis using SQL
-- ==========================================================================================================================================


-- ==========================================================================================================================================
--                                                           DATABASE SETUP
-- ==========================================================================================================================================

-- Create the database
-- CREATE DATABASE superstore_analysis;

-- Select the database
USE superstore_analysis;

-- Display all available databases
SHOW DATABASES;

-- Display the structure of the superstore table
DESCRIBE superstore;

-- Preview the first 10 rows
SELECT * FROM superstore LIMIT 10;

-- Count the total number of records
SELECT COUNT(*) AS total_rows FROM superstore;

-- ==========================================================================================================================================
--                                                         Data Overview
-- ==========================================================================================================================================

-- Display all columns in the Superstore table
SHOW COLUMNS FROM superstore;

-- Count the total number of unique customers
SELECT COUNT(DISTINCT `Customer Name`) AS customer_name FROM superstore;

-- Count the total number of unique products
SELECT COUNT(DISTINCT `Product Name`) AS Total_Products FROM superstore;

-- Count the total number of customer segments
SELECT COUNT(DISTINCT `Segment`) AS total_segment FROM superstore;

-- Count the total number of countries
SELECT COUNT(DISTINCT `Country`) AS total_segment FROM superstore;

-- Count the total number of cities
SELECT COUNT(DISTINCT `City`) AS total_segment FROM superstore;

-- Count the total number of states
SELECT COUNT(DISTINCT `State`) AS total_segment FROM superstore;

-- Count the total number of regions
SELECT COUNT(DISTINCT `Region`) AS total_segment FROM superstore;

-- Count the total number of product categories
SELECT COUNT(DISTINCT `Category`) AS total_segment FROM superstore;

-- Count the total number of product sub-categories
SELECT COUNT(DISTINCT `Sub-Category`) AS total_segment FROM superstore;

-- Find duplicate Order IDs
SELECT `Order ID`,
 COUNT(*) AS duplicate_count FROM superstore
GROUP BY `Order ID`
HAVING COUNT(*) > 1;

-- ==========================================================================================================================================
--                                                        01. Revenue Analysis
-- ==========================================================================================================================================

-- Create an index on the Revenue column to improve query performance
CREATE INDEX idx_revenue
ON superstore(Revenue);

-- Create a view to calculate total revenue
CREATE VIEW revenue_total AS
SELECT SUM(`Revenue`) FROM superstore;

-- Display total revenue
SELECT * FROM revenue_total;

-- Convert Order Date into a standard YYYY-MM-DD format
UPDATE superstore
SET `Order Date` =
CASE
    WHEN `Order Date` LIKE '%-%' THEN
        DATE_FORMAT(
            STR_TO_DATE(`Order Date`, '%d-%m-%Y'),
            '%Y-%m-%d'
        )

    WHEN `Order Date` LIKE '%/%' THEN
        DATE_FORMAT(
            STR_TO_DATE(`Order Date`, '%m/%d/%Y'),
            '%Y-%m-%d'
        )
END;

-- Change Order Date data type to DATE
ALTER TABLE superstore
MODIFY COLUMN `Order Date` DATE;

-- Calculate monthly revenue
SELECT
    DATE_FORMAT(`Order Date`, '%Y-%m') AS Month,
    SUM(Revenue) AS Monthly_Revenue
FROM superstore
GROUP BY Month
ORDER BY Month;

-- Calculate total revenue by category
SELECT `Category`,
SUM(`Revenue`) AS total_revenue
FROM superstore
GROUP BY `Category`
ORDER BY `Category` DESC;

-- Calculate total revenue by sub-category
SELECT `Sub-Category`,
SUM(`Revenue`) AS total_revenue 
FROM superstore
GROUP BY `Sub-Category`
ORDER BY `Sub-Category` DESC;

-- Calculate total revenue by region
SELECT `Region`,
SUM(`Revenue`) AS total_revenue 
FROM superstore
GROUP BY `Region`
ORDER BY `Region` DESC;

-- Calculate total revenue by customer segment
SELECT `Segment`,
SUM(`Revenue`) AS total_revenue
FROM superstore 
GROUP BY `Segment`
ORDER BY `Segment`;

-- Calculate total revenue by ship mode
SELECT `Ship Mode`,
SUM(`Revenue`) AS total_revenue
FROM superstore 
GROUP BY `Ship Mode`
ORDER BY `Ship Mode`;

-- Top 10 states by revenue
SELECT `State`,
SUM(`Revenue`) AS total_revenue
FROM superstore
GROUP BY `State`
ORDER BY total_revenue DESC
LIMIT 10;

-- Top 10 cities by revenue
SELECT `City`,
SUM(`Revenue`) AS total_revenue
FROM superstore 
GROUP BY `City`
ORDER BY total_revenue DESC
LIMIT 10;

-- Average revenue by customer segment
SELECT
    Segment,
    AVG(Revenue) AS Average_Revenue
FROM superstore
GROUP BY Segment
ORDER BY Average_Revenue DESC;


-- Average revenue by region
SELECT
    Region,
    AVG(Revenue) AS Average_Revenue
FROM superstore
GROUP BY Region
ORDER BY Average_Revenue DESC;

-- Total revenue by year
SELECT
    YEAR(`Order Date`) AS Year,
    SUM(Revenue) AS Total_Revenue
FROM superstore
GROUP BY Year
ORDER BY Year;

-- Average revenue by year
SELECT
    YEAR(`Order Date`) AS Year,
    AVG(Revenue) AS Average_Revenue
FROM superstore
GROUP BY Year
ORDER BY Year;

-- Display orders with revenue greater than 1000
SELECT *
FROM superstore
WHERE Revenue > 1000;

-- Calculate monthly revenue with running total using a window function
SELECT
    DATE_FORMAT(`Order Date`,'%Y-%m') AS Month,
    SUM(Revenue) AS Monthly_Revenue,
    SUM(SUM(Revenue)) OVER(
        ORDER BY DATE_FORMAT(`Order Date`,'%Y-%m')
    ) AS Running_Total
FROM superstore
GROUP BY Month;

-- ==========================================================================================================================================
--                                                       02 Profit Analysis
-- ==========================================================================================================================================

-- Create a view to calculate total profit
CREATE VIEW profit_total AS
SELECT
    SUM(Profit) AS Total_Profit
FROM superstore;

-- Display total profit
SELECT *
FROM profit_total;

-- Calculate total profit by region
SELECT
    Region,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Region
ORDER BY Total_Profit DESC;

-- Calculate monthly profit
SELECT
    DATE_FORMAT(`Order Date`, '%Y-%m') AS Month,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Month
ORDER BY Month;

-- Calculate total profit by category
SELECT
    Category,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Category
ORDER BY Total_Profit DESC;

-- Calculate total profit by sub-category
SELECT
    `Sub-Category`,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY `Sub-Category`
ORDER BY Total_Profit DESC;

-- Calculate total profit by customer segment
SELECT
    Segment,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Segment
ORDER BY Total_Profit DESC;

-- Display the top 10 most profitable states
SELECT
    State,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY State
ORDER BY Total_Profit DESC
LIMIT 10;

-- Display the bottom 10 least profitable states
SELECT
    State,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY State
ORDER BY Total_Profit ASC
LIMIT 10;

-- Display the top 10 most profitable cities
SELECT
    City,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY City
ORDER BY Total_Profit DESC
LIMIT 10;

-- Display the bottom 10 least profitable cities
SELECT
    City,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY City
ORDER BY Total_Profit ASC
LIMIT 10;

-- Calculate average profit by customer segment
SELECT
    Segment,
    AVG(Profit) AS Average_Profit
FROM superstore
GROUP BY Segment
ORDER BY Average_Profit DESC;

-- Calculate average profit by region
SELECT
    Region,
    AVG(Profit) AS Average_Profit
FROM superstore
GROUP BY Region
ORDER BY Average_Profit DESC;

-- Calculate yearly profit
SELECT
    YEAR(`Order Date`) AS Year,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Year
ORDER BY Year;

-- Create a view to calculate profit margin for each order
CREATE VIEW Profit_Margin AS
SELECT
    `Order ID`,
    Revenue,
    Profit,
    ROUND((Profit / Revenue) * 100, 2) AS Profit_Margin_Percentage
FROM superstore;

-- Display profit margin for each order
SELECT *
FROM Profit_Margin;

-- Calculate average profit margin by category
SELECT
    Category,
    ROUND(AVG((Profit / Revenue) * 100), 2) AS Average_Profit_Margin
FROM superstore
GROUP BY Category
ORDER BY Average_Profit_Margin DESC;

-- Calculate average profit margin by customer segment
SELECT
    Segment,
    ROUND(AVG((Profit / Revenue) * 100), 2) AS Average_Profit_Margin
FROM superstore
GROUP BY Segment
ORDER BY Average_Profit_Margin DESC;

-- Calculate average profit margin by region
SELECT
    Region,
    ROUND(AVG((Profit / Revenue) * 100), 2) AS Average_Profit_Margin
FROM superstore
GROUP BY Region
ORDER BY Average_Profit_Margin DESC;

-- Calculate monthly average profit margin
SELECT
    DATE_FORMAT(`Order Date`, '%Y-%m') AS Month,
    ROUND(AVG((Profit / Revenue) * 100), 2) AS Average_Profit_Margin
FROM superstore
GROUP BY Month
ORDER BY Month;


-- ==========================================================================================================================================
--                                                       03 - Customer Analysis
-- ==========================================================================================================================================

-- Create an index on Customer Name to improve query performance
CREATE INDEX idx_customer_name
ON superstore(`Customer Name`);

-- Count total customers by region
SELECT 
`Region`,
COUNT( `Customer Name`) AS total_customers
FROM superstore
GROUP BY `Region`
ORDER BY total_customers DESC;

-- Count unique customers by region
SELECT
    Region,
    COUNT(DISTINCT `Customer Name`) AS Unique_Customers
FROM superstore
GROUP BY Region
ORDER BY Unique_Customers DESC;

-- Top 10 customers by total revenue
SELECT
    `Customer Name`,
    SUM(Revenue) AS Total_Revenue
FROM superstore
GROUP BY `Customer Name`
ORDER BY Total_Revenue DESC
LIMIT 10;

-- Top 10 customers by total profit
SELECT
    `Customer Name`,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY `Customer Name`
ORDER BY Total_Profit DESC
LIMIT 10;

-- Top 10 customers by total number of orders
SELECT
    `Customer Name`,
    COUNT(`Order ID`) AS Total_Orders
FROM superstore
GROUP BY `Customer Name`
ORDER BY Total_Orders DESC
LIMIT 10;

-- Total orders by customer segment
SELECT
    Segment,
    COUNT(`Order ID`) AS Total_Orders
FROM superstore
GROUP BY Segment
ORDER BY Total_Orders DESC;

-- Top 10 customers by average revenue per order
SELECT
    `Customer Name`,
    ROUND(AVG(Revenue),2) AS Average_Revenue
FROM superstore
GROUP BY `Customer Name`
ORDER BY Average_Revenue DESC
LIMIT 10;

-- Rank customers based on total revenue using a window function
SELECT
    `Customer Name`,
    SUM(Revenue) AS Total_Revenue,
    RANK() OVER (ORDER BY SUM(Revenue) DESC) AS Revenue_Rank
FROM superstore
GROUP BY `Customer Name`;

-- ==========================================================================================================================================
--                                                      04 - Product Analysis
-- ==========================================================================================================================================

-- Create an index on Product Name to improve query performance
CREATE INDEX idx_product_name
ON superstore(`Product Name`);

-- Calculate total revenue for each product
SELECT 
`Product Name`,
SUM(`Revenue`) AS total_revenue
FROM superstore
GROUP BY `Product Name`
ORDER BY total_revenue DESC;

-- Calculate total quantity sold for each product
SELECT 
`Product Name`,
SUM(`Quantity`) AS total_quantity
FROM superstore
GROUP BY `Product Name`
ORDER BY total_quantity DESC;

-- Display the most profitable products
SELECT
`Product Name`,
SUM(`Profit`) AS total_profit
FROM superstore
GROUP BY `Product Name`
ORDER BY total_Profit DESC;

-- Display the least profitable products
SELECT
`Product Name`,
SUM(`Profit`) AS total_profit
FROM superstore
GROUP BY `Product Name`
ORDER BY total_Profit ASC;

-- Rank products based on total revenue using a window function
SELECT
    `Product Name`,
    SUM(Revenue) AS Total_Revenue,
    DENSE_RANK() OVER(ORDER BY SUM(Revenue) DESC) AS Product_Rank
FROM superstore
GROUP BY `Product Name`;

-- ==========================================================================================================================================
--                                                    05 - Order & Shipping Analysis
-- ==========================================================================================================================================

-- Create an index on Order Date to improve query performance
CREATE INDEX idx_order_date
ON superstore(`Order Date`);

-- Count total orders by ship mode
SELECT
    `Ship Mode`,
    COUNT(`Order ID`) AS Total_Orders
FROM superstore
GROUP BY `Ship Mode`
ORDER BY Total_Orders DESC;

-- Count records with Ship Date in DD-MM-YYYY format
SELECT COUNT(*) AS Dash_Date_Format
FROM superstore
WHERE `Ship Date` LIKE '%-%';

-- Count records with Ship Date in MM/DD/YYYY format
SELECT COUNT(*) AS Slash_Date_Format
FROM superstore
WHERE `Ship Date` LIKE '%/%';

-- Add a new column to store Ship Date as DATE
ALTER TABLE superstore
ADD COLUMN ship_date_new DATE;

-- Convert Ship Date from DD-MM-YYYY format
UPDATE superstore
SET ship_date_new = STR_TO_DATE(`Ship Date`, '%d-%m-%Y')
WHERE `Ship Date` LIKE '%-%';

-- Convert Ship Date from MM/DD/YYYY format
UPDATE superstore
SET ship_date_new = STR_TO_DATE(`Ship Date`, '%m/%d/%Y')
WHERE `Ship Date` LIKE '%/%';

-- Calculate delivery time for each order
SELECT
    `Order ID`,
    `Order Date`,
    `Ship Date`,
    DATEDIFF(
        CASE
            WHEN `Ship Date` LIKE '%-%'
                THEN STR_TO_DATE(`Ship Date`, '%d-%m-%Y')
            WHEN `Ship Date` LIKE '%/%'
                THEN STR_TO_DATE(`Ship Date`, '%m/%d/%Y')
        END,
        STR_TO_DATE(`Order Date`, '%Y-%m-%d')
    ) AS delivery_time
FROM superstore;

-- Count total orders by region
SELECT
    Region,
    COUNT(`Order ID`) AS Total_Orders
FROM superstore
GROUP BY Region
ORDER BY Total_Orders DESC;

-- Count total orders by category
SELECT
    Category,
    COUNT(`Order ID`) AS Total_Orders
FROM superstore
GROUP BY Category
ORDER BY Total_Orders DESC;

-- Count total orders by customer segment
SELECT
    Segment,
    COUNT(`Order ID`) AS Total_Orders
FROM superstore
GROUP BY Segment
ORDER BY Total_Orders DESC;

-- Count total orders by state
SELECT
    State,
    COUNT(`Order ID`) AS Total_Orders
FROM superstore
GROUP BY State
ORDER BY Total_Orders DESC;

-- Calculate average order value
 SELECT
    ROUND(AVG(Order_Revenue),2) AS Average_Order_Value
FROM
(
    SELECT
        `Order ID`,
        SUM(Revenue) AS Order_Revenue
    FROM superstore
    GROUP BY `Order ID`
) AS Orders;

-- Calculate average delivery time by region
SELECT
    Region,
    ROUND(AVG(DATEDIFF(`Ship Date`,`Order Date`)),2) AS Average_Delivery_Time
FROM superstore
GROUP BY Region
ORDER BY Average_Delivery_Time;

-- Count total orders by month
SELECT
    DATE_FORMAT(`Order Date`,'%Y-%m') AS Month,
    COUNT(`Order ID`) AS Total_Orders
FROM superstore
GROUP BY Month
ORDER BY Month;

-- Count total orders by year
SELECT
    YEAR(`Order Date`) AS Year,
    COUNT(`Order ID`) AS Total_Orders
FROM superstore
GROUP BY Year
ORDER BY Year;

-- ==========================================================================================================================================
--                                                        06 - Discount Analysis
-- ==========================================================================================================================================

-- Calculate the total discount offered
SELECT
    SUM(Discount) AS Total_Discount
FROM superstore;

-- Calculate the average discount
SELECT
    ROUND(AVG(Discount),2) AS Average_Discount
FROM superstore;

-- Calculate the average discount by category
SELECT
    Category,
    ROUND(AVG(Discount),2) AS Average_Discount
FROM superstore
GROUP BY Category
ORDER BY Average_Discount DESC;

-- Calculate the average discount by region
SELECT
    Region,
    ROUND(AVG(Discount),2) AS Average_Discount
FROM superstore
GROUP BY Region
ORDER BY Average_Discount DESC;

-- Calculate the average discount by customer segment
SELECT
segment,
ROUND(AVG(Discount),2) AS average_discount
FROM superstore
GROUP BY segment
ORDER BY average_discount DESC;

-- Display the top 10 products with the highest average discount
SELECT
    `Product Name`,
    ROUND(AVG(Discount),2) AS Average_Discount
FROM superstore
GROUP BY `Product Name`
ORDER BY Average_Discount DESC
LIMIT 10;

-- Analyze the relationship between discount and average profit
SELECT
    Discount,
    ROUND(AVG(Profit),2) AS Average_Profit
FROM superstore
GROUP BY Discount
ORDER BY Discount;

-- Calculate the average discount by year
SELECT
    YEAR(`Order Date`) AS Year,
    ROUND(AVG(Discount), 2) AS Average_Discount
FROM superstore
GROUP BY Year
ORDER BY Year;
