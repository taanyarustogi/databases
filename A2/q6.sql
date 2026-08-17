--Year-over-year sales

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DROP TABLE IF EXISTS q6 CASCADE;

CREATE TABLE q6 (
    IID INT NOT NULL,
    year1 INT NOT NULL,
    year1_avg FLOAT NOT NULL,
    year2 INT NOT NULL,
    year2_avg FLOAT NOT NULL,
    yoy_change FLOAT NOT NULL
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps. (But give them better names!)
DROP VIEW IF EXISTS MinMax CASCADE;
DROP VIEW IF EXISTS Years CASCADE;
DROP VIEW IF EXISTS ItemYearlyAvg CASCADE;
DROP VIEW IF EXISTS YoYCalculation CASCADE;

-- Define views for your intermediate steps here:
--minimum and maximum years from purchase
CREATE VIEW MinMax AS
SELECT 
    EXTRACT(YEAR FROM MIN(checkout_time))::INT AS min_year, 
    EXTRACT(YEAR FROM MAX(checkout_time))::INT AS max_year
FROM Purchase;
--all operational years
CREATE VIEW Years AS
SELECT generate_series(min_year, max_year) AS year
FROM MinMax;
--total average sales by item and year
CREATE VIEW ItemYearlyAvg AS
SELECT i.IID, y.year, 
       COALESCE(SUM(l.quantity), 0) / 12.0 AS avg_sales
FROM Item i
CROSS JOIN Years y
LEFT JOIN Purchase p ON EXTRACT(YEAR FROM p.checkout_time) = y.year
LEFT JOIN LineItem l ON p.PID = l.PID AND i.IID = l.IID
GROUP BY i.IID, y.year;
--year-over-year calculation with special handling for zero sales
CREATE VIEW YoYCalculation AS
SELECT 
    y1.IID, 
    y1.year AS year1, y1.avg_sales AS year1_avg,
    y2.year AS year2, y2.avg_sales AS year2_avg,
    CASE 
        WHEN y1.avg_sales = 0 AND y2.avg_sales = 0 THEN 0
        WHEN y1.avg_sales = 0 THEN 'Infinity'::float
        ELSE ((y2.avg_sales - y1.avg_sales) / y1.avg_sales) * 100
    END AS yoy_change
FROM ItemYearlyAvg y1
JOIN ItemYearlyAvg y2 ON y1.IID = y2.IID AND y2.year = y1.year + 1;
-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q6
SELECT * FROM YoYCalculation;