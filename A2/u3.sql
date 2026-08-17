-- Customer Appreciation Week

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;


-- You may find it convenient to do this for each of the views
-- that define your intermediate steps. (But give them better names!)
DROP VIEW IF EXISTS FirstPurchases CASCADE;
DROP VIEW IF EXISTS YesterdayPurchases CASCADE;

-- Define views for your intermediate steps here:

-- Create new item
INSERT INTO Item VALUES (
	(SELECT COALESCE(MAX(IID), 0) + 1 FROM Item), 'Housewares', 
	'Company logo mug',
	 0.0
);

-- All purchases from yesterday
CREATE VIEW YesterdayPurchases AS
SELECT PID, CID, checkout_time
FROM Purchase
WHERE DATE_TRUNC('day', checkout_time) = DATE_TRUNC('day', NOW()) - INTERVAL '24:00:00';

-- All first purchases from yesterday
CREATE VIEW FirstPurchases AS
SELECT PID
FROM YesterdayPurchases y1
WHERE NOT EXISTS (
	SELECT *
	FROM YesterdayPurchases y2
	WHERE y1.CID = y2.CID AND
		    y1.checkout_time > y2.checkout_time
);

-- Add line items
INSERT INTO LineItem (
	SELECT PID, (SELECT IID FROM Item WHERE description = 'Company logo mug') AS IID, 1 AS quantity
	FROM FirstPurchases
);

