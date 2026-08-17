SET SEARCH_PATH TO TicketSchema;

-- Final query
-- <oid> is the ID of the owner
-- <num_venues> is the number of venues they own
SELECT Owners.oid, count(Venue.vid) AS num_venues
FROM Owners LEFT JOIN Venue ON Owners.oid = Venue.owner_id 
GROUP BY oid;