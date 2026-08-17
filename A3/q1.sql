SET SEARCH_PATH TO TicketSchema;

DROP VIEW IF EXISTS PricesPerTicket CASCADE;
DROP VIEW IF EXISTS VenueSeats CASCADE;
DROP VIEW IF EXISTS TicketSales CASCADE;

-- A row contains a ticket id and its price, determined by the concert
-- and the section the seat belongs to.
CREATE VIEW PricesPerTicket AS
SELECT Ticket.tid, TicketPrice.price
FROM Ticket, Seat, TicketPrice
WHERE Ticket.seat = Seat.seat_id AND
      Seat.section = TicketPrice.section AND
      Ticket.concert = TicketPrice.concert;

-- A row contains a venue id and the total number of seats in that venue.
CREATE VIEW VenueSeats AS
SELECT Section.venue, COUNT(DISTINCT Seat.seat_id) AS num_seats
FROM Seat JOIN Section ON Seat.section = Section.sec_id
GROUP BY Section.venue;

-- A row contains a concert id, the number of tickets sold, and the
-- total revenue from ticket sales for that concert.
CREATE VIEW TicketSales AS
SELECT Ticket.concert,
       COUNT(Ticket.tid) AS tickets_sold,
       SUM(PricesPerTicket.price) AS value_sold
FROM Ticket JOIN PricesPerTicket ON Ticket.tid = PricesPerTicket.tid
WHERE Ticket.tid IN (SELECT ticket FROM Purchase)
GROUP BY Ticket.concert;

-- Final query
-- <cid> is the concert ID
-- <tickets_sold> is the number of tickets sold for this concert
-- <value_sold> is the total value of the tickets sold
-- <percentage_sold> is the percentage of the venue's seats that were sold
SELECT Concert.cid,
       COALESCE(TicketSales.tickets_sold, 0) AS tickets_sold,
       COALESCE(TicketSales.value_sold, 0) AS value_sold,
       ROUND(
           (COALESCE(TicketSales.tickets_sold, 0)::NUMERIC
               / VenueSeats.num_seats) * 100, 2
       ) AS percentage_sold
FROM Concert
JOIN VenueSeats ON Concert.venue = VenueSeats.venue
LEFT JOIN TicketSales ON Concert.cid = TicketSales.concert;
