SET SEARCH_PATH TO TicketSchema;

DROP VIEW IF EXISTS VenueSeats CASCADE;
DROP VIEW IF EXISTS VenueAccessibleSeats CASCADE;

-- A row contains a venue id and the total number of seats in that venue.
CREATE VIEW VenueSeats AS
SELECT Section.venue,
       COUNT(DISTINCT Seat.seat_id) AS num_seats
FROM Seat JOIN Section ON Seat.section = Section.sec_id
GROUP BY Section.venue;

-- A row contains a venue id and the number of accessible seats in that
-- venue.
CREATE VIEW VenueAccessibleSeats AS
SELECT Section.venue,
       COUNT(DISTINCT Seat.seat_id) AS num_accessible
FROM Seat JOIN Section ON Seat.section = Section.sec_id
WHERE Seat.accessible
GROUP BY Section.venue;

-- Final Query
-- <venue> is the venue ID
-- <num_seats> is the total number of seats in the venue
-- <percentage_accessible> is the percentage of seats that are accessible
SELECT VenueSeats.venue,
       VenueSeats.num_seats,
       ROUND(
           (COALESCE(VenueAccessibleSeats.num_accessible, 0)::NUMERIC
               / VenueSeats.num_seats) * 100, 2
       ) AS percentage_accessible
FROM VenueSeats
LEFT JOIN VenueAccessibleSeats
    ON VenueSeats.venue = VenueAccessibleSeats.venue;
