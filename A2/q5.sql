-- Hyperconsumers

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DROP TABLE IF EXISTS q5 CASCADE;

CREATE TABLE q5 (
    year VARCHAR(4) NOT NULL,
    name VARCHAR(65) NOT NULL,
    email VARCHAR(300) NOT NULL,
    items INTEGER NOT NULL
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps. (But give them better names!)
DROP VIEW IF EXISTS TotalItems CASCADE;
DROP VIEW IF EXISTS TotalUnits CASCADE;
DROP VIEW IF EXISTS YearlyRanks CASCADE;
DROP VIEW IF EXISTS Hyperconsumers CASCADE;
DROP VIEW IF EXISTS HyperconsumerInfo CASCADE;

-- Define views for your intermediate steps here:
--total amounts of each item purchased by each customer in each year
CREATE VIEW TotalItems AS
SELECT p.CID, l.IID, to_char(p.checkout_time, 'YYYY') AS year, SUM(l.quantity) AS total_units
FROM Purchase p 
JOIN LineItem l ON p.PID = l.PID
GROUP BY p.CID, l.IID, to_char(p.checkout_time, 'YYYY');
--total units purchased by each customer in each year
CREATE VIEW TotalUnits AS
SELECT CID, year, SUM(total_units) as items
FROM TotalItems
GROUP BY CID, year;
--customers ranked by the total units bought per year
CREATE VIEW YearlyRanks AS
SELECT 
    year, 
    CID, 
    items,
    DENSE_RANK() OVER (PARTITION BY year ORDER BY items DESC) as unit_rank
FROM TotalUnits;
--hyperconsumers who are in the top 5 for total units bought in any year
CREATE VIEW Hyperconsumers AS
SELECT year, CID, items
FROM YearlyRanks
WHERE unit_rank <= 5;
--add customer information to hyperconsumers
CREATE VIEW HyperconsumerInfo AS
SELECT h.year, c.first_name || ' ' || c.last_name as name, c.email, h.items
FROM Hyperconsumers h JOIN Customer c ON h.CID = c.CID;

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q5
SELECT year, name, email, items
FROM HyperconsumerInfo;
