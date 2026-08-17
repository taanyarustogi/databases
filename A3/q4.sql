SET SEARCH_PATH TO TicketSchema;

DROP VIEW IF EXISTS UserTickets CASCADE;

-- Number of tickets purchased by each user
CREATE VIEW UserTickets AS
SELECT user_id, count(ticket) AS num_tickets
FROM Purchase
GROUP BY user_id;

-- Final query
-- <user_id> is the id of the user
-- <num_tickets> is the number of tickets bought by the user
-- This contains only users who have bought the most tickets
SELECT AppUser.username, UserTickets.num_tickets
FROM AppUser JOIN UserTickets ON AppUser.uid = UserTickets.user_id
WHERE UserTickets.num_tickets = (
    SELECT max(num_tickets)
    FROM UserTickets
);