-- Helpfulness


-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DROP TABLE IF EXISTS q2 CASCADE;

create table q2(
    CID INTEGER,
    name TEXT NOT NULL,
    helpfulness_category TEXT NOT NULL
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps. (But give them better names!)
DROP VIEW IF EXISTS ReviewVotes CASCADE;
DROP VIEW IF EXISTS HelpfulReviews CASCADE;
DROP VIEW IF EXISTS NumberReviews CASCADE;
DROP VIEW IF EXISTS HelpfulnessScore CASCADE;
DROP VIEW IF EXISTS HelpfulnessCategory CASCADE;
DROP VIEW IF EXISTS ReviewerInfo CASCADE;

-- Define views for your intermediate steps here:
--number of true and false votes per review
CREATE VIEW ReviewVotes AS
SELECT reviewer, IID,
       COUNT(CASE WHEN helpfulness = True THEN 1 END) as trues,
       COUNT(CASE WHEN helpfulness = False THEN 1 END) as falses
FROM Helpfulness
GROUP BY reviewer, IID;
--reviews where the number of true votes is greater than the number of false votes
CREATE VIEW HelpfulReviews AS
SELECT reviewer, IID
FROM ReviewVotes
WHERE trues > falses;
--customers who have writen reviews, the number of helpful reviews they have, and the total number of reviews they have written
CREATE VIEW NumberReviews AS
SELECT r.CID as CID, COUNT(DISTINCT h.IID) as number_helpful, COUNT(DISTINCT r.IID) as total_reviews
FROM Review r LEFT JOIN HelpfulReviews h ON r.CID = h.reviewer AND r.IID = h.IID
GROUP BY r.CID;
--calculate the helpful score of all customers who have written reviews
CREATE VIEW HelpfulnessScore AS
SELECT CID, number_helpful::FLOAT/total_reviews as helpfulness_score
FROM NumberReviews;
--categorize customers who have written reviews based on their helpfulness score
CREATE VIEW HelpfulnessCategory AS
SELECT CID,
CASE
    WHEN helpfulness_score >= 0.8 THEN 'very helpful'
    WHEN helpfulness_score >= 0.5 THEN 'somewhat helpful'
    ELSE 'not helpful'
END AS helpfulness_category
FROM HelpfulnessScore;
--add customers who have not written reviews as 'not helpful' and add customer information
CREATE VIEW ReviewerInfo AS
SELECT c.CID, c.first_name || ' ' || c.last_name as name, COALESCE(h.helpfulness_category, 'not helpful') as helpfulness_category
FROM Customer c LEFT JOIN HelpfulnessCategory h ON c.CID = h.CID;

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q2
SELECT * FROM ReviewerInfo