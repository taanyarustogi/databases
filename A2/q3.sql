-- Curators

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DROP TABLE IF EXISTS q3 CASCADE;

CREATE TABLE q3 (
    CID INT NOT NULL,
    category_name TEXT NOT NULL,
    PRIMARY KEY(CID, category_name)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps. (But give them better names!)
DROP VIEW IF EXISTS PurchasesWithCategories CASCADE;
DROP VIEW IF EXISTS CustomerCategoryCounts CASCADE;
DROP VIEW IF EXISTS CategoryCounts CASCADE;
DROP VIEW IF EXISTS BoughtAllInCategory CASCADE;
DROP VIEW IF EXISTS ReviewsWithCategories CASCADE;
DROP VIEW IF EXISTS ReviewCategoryCounts CASCADE;
DROP VIEW IF EXISTS ReviewedAllInCategory CASCADE;
DROP VIEW IF EXISTS Curators CASCADE;
--customers with the items they purchased and its category
CREATE VIEW PurchasesWithCategories AS
SELECT p.CID, l.IID, i.category
FROM Purchase p
JOIN LineItem l ON p.PID = l.PID
JOIN Item i ON l.IID = i.IID;
--customers with the number of items they purchased in each category
CREATE VIEW CustomerCategoryCounts AS
SELECT CID, category, COUNT(DISTINCT IID) as count
FROM PurchasesWithCategories
GROUP BY CID, category;
--total number of items in each category
CREATE VIEW CategoryCounts AS
SELECT category, COUNT(DISTINCT IID) as count
FROM Item
GROUP BY category;
--customers who bought all the items in a cateogry
CREATE VIEW BoughtAllInCategory AS
SELECT c.CID, c.category
FROM CustomerCategoryCounts c
JOIN CategoryCounts cc ON c.category = cc.category
WHERE c.count = cc.count;
--reviewers with the items they reviewed and its category
CREATE VIEW ReviewsWithCategories AS
SELECT r.CID, r.IID, i.category
FROM Review r
JOIN Item i ON r.IID = i.IID
WHERE r.comment IS NOT NULL; 
--reviewers with the number of items they reviewed in each category
CREATE VIEW ReviewCategoryCounts AS
SELECT CID, category, COUNT(DISTINCT IID) as count
FROM ReviewsWithCategories
GROUP BY CID, category;
--reviewers who reviewed all the items in a cateogry
CREATE VIEW ReviewedAllInCategory AS
SELECT c.CID, c.category
FROM ReviewCategoryCounts c
JOIN CategoryCounts cc ON c.category = cc.category
WHERE c.count = cc.count;
--people who bought all items in a category and reviewed all items in the same category
CREATE VIEW Curators AS
SELECT CID, category
FROM BoughtAllInCategory
INTERSECT 
SELECT CID, category
FROM ReviewedAllInCategory;

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q3
SELECT CID, category AS category_name
FROM Curators;