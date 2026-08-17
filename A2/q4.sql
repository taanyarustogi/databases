-- Best and Worst Categories

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DROP TABLE IF EXISTS q4 CASCADE;

CREATE TABLE q4 (
    month TEXT NOT NULL,
    highest_category TEXT NOT NULL,
    highest_sales_val FLOAT NOT NULL,
    lowest_category TEXT NOT NULL,
    lowest_sales_val FLOAT NOT NULL
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps. (But give them better names!)
DROP VIEW IF EXISTS AllMonths CASCADE;
DROP VIEW IF EXISTS MonthCategoryGrid CASCADE;
DROP VIEW IF EXISTS PurchasedItems CASCADE;
DROP VIEW IF EXISTS MonthlyCategorySales CASCADE;
DROP VIEW IF EXISTS MonthlyBestWorst CASCADE;
DROP VIEW IF EXISTS MonthlyBestWorstCategories CASCADE; 

-- Define views for your intermediate steps here:
--all months
CREATE VIEW AllMonths AS
SELECT to_char(generate_series(1, 12), 'FM09') AS month;
--all months and categories
CREATE VIEW MonthCategoryGrid AS
SELECT m.month, i.category
FROM AllMonths m CROSS JOIN (SELECT DISTINCT category FROM Item) i;
--purchased items with its category, sale amount and month
CREATE VIEW PurchasedItems AS
SELECT p.PID, l.IID, i.category, l.quantity * i.price AS sale, to_char(p.checkout_time, 'MM') AS month
FROM Purchase p
JOIN LineItem l ON p.PID = l.PID
JOIN Item i ON l.IID = i.IID
WHERE EXTRACT(YEAR FROM p.checkout_time) = 2024;
--total sales by month and category
CREATE VIEW MonthlyCategorySales AS
SELECT m.month, m.category, COALESCE(SUM(p.sale), 0) AS total_sales
FROM MonthCategoryGrid m
LEFT JOIN PurchasedItems p ON m.month = p.month AND m.category = p.category
GROUP BY m.month, m.category;
--highest and lowest sales value per month
CREATE VIEW MonthlyBestWorst AS
SELECT month,
       MAX(total_sales) AS highest_sales_val,
       MIN(total_sales) AS lowest_sales_val
FROM MonthlyCategorySales
GROUP BY month;
--highest and lowest category per month
CREATE VIEW MonthlyBestWorstCategories AS
SELECT m.month, m.highest_sales_val, m.lowest_sales_val, mc1.category AS highest_category, mc2.category AS lowest_category
FROM MonthlyBestWorst m 
JOIN MonthlyCategorySales mc1 ON m.month = mc1.month AND m.highest_sales_val = mc1.total_sales
JOIN MonthlyCategorySales mc2 ON m.month = mc2.month AND m.lowest_sales_val = mc2.total_sales; 

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q4
SELECT month, highest_category, highest_sales_val, lowest_category, lowest_sales_val
FROM MonthlyBestWorstCategories;

