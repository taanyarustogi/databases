-- Unrated products


-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DROP TABLE IF exists q1 CASCADE;

CREATE TABLE q1(
    CID INTEGER,
    first_name TEXT NOT NULL,
	last_name TEXT NOT NULL,
    email TEXT	
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps. (But give them better names!)
DROP VIEW IF EXISTS UnratedItems CASCADE;
DROP VIEW IF EXISTS PurchasesWithUnratedItems CASCADE;
DROP VIEW IF EXISTS CustomersWithUnratedItems CASCADE;
DROP VIEW IF EXISTS CustomersWithThreeUnratedItems CASCADE;

-- Define views for your intermediate steps here:
--items without reviews
CREATE VIEW UnratedItems AS
SELECT IID
FROM Item
EXCEPT
SELECT DISTINCT IID
FROM Review;
--purchases with items without reviews
CREATE VIEW PurchasesWithUnratedItems AS
SELECT DISTINCT PID, IID
FROM LineItem
WHERE IID IN (SELECT IID FROM UnratedItems);
--customers with purchases with items without reviews
CREATE VIEW CustomersWithUnratedItems AS
SELECT DISTINCT p.CID, r.IID
FROM Purchase p JOIN PurchasesWithUnratedItems r ON p.PID = r.PID;
-- customers with 3 or more items without reviews
CREATE VIEW CustomersWithThreeUnratedItems AS 
SELECT c.CID, c.first_name, c.last_name, c.email
FROM Customer c JOIN CustomersWithUnratedItems r ON c.CID = r.CID
GROUP BY c.CID, c.first_name, c.last_name, c.email
HAVING COUNT(DISTINCT r.IID) >= 3;

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q1
SELECT * FROM CustomersWithThreeUnratedItems;

