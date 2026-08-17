-- Fraud Prevention

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;


-- You may find it convenient to do this for each of the views
-- that define your intermediate steps. (But give them better names!)
DROP VIEW IF EXISTS InvalidPurchases CASCADE;
DROP VIEW IF EXISTS Last24Hrs CASCADE;

-- Define views for your intermediate steps here:

-- All purchases from the last 24 hrs
CREATE VIEW Last24Hrs AS
SELECT *
FROM Purchase 
WHERE checkout_time >= NOW() - INTERVAL '24:00:00';

-- Purchases after the fifth purchase per credit card
CREATE VIEW InvalidPurchases AS
SELECT *
FROM Last24Hrs p1
WHERE 5 <= (
	SELECT count(*)
	FROM Last24Hrs p2
	WHERE p1.card_pan = p2.card_pan AND
		    p1.checkout_time > p2.checkout_time
);

-- Delete from line item first as it references purchase
DELETE FROM LineItem
WHERE pid IN (
	SELECT pid
	FROM InvalidPurchases
);

-- Delete from purchase
DELETE FROM Purchase
WHERE pid IN (
	SELECT pid
	FROM InvalidPurchases
);