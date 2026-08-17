/*
Could Not:
	- A venue must have a minimum of 10 seats. This cannot be done without 
	counting rows across the Seat and Section tables. This cannot be done with
	DDL
	- The section referenced in TicketPrice must belong to the same venue as
	the concert it is paired with. This requires a join across Concert, Venue,
	Section, and TicketPrice so it cannot be done with DDL.
	- The seat referenced in a Ticket must belong to the same venue as the
	concert in that Ticket. This requires joining Ticket, Concert, Seat, and
	Section so it cannot be done with DDL.

Did Not:
	- None

Extra Constraints:
	- A ticket cannot be sold for the same seat at the same concert twice: 
	UNIQUE(concert, seat) in Ticket. Otherwise, two users can buy tickets for 
	the same seat and same concert.
	- A ticket price can only be defined once per concert-section pair: 
	UNIQUE(concert, section) in TicketPrice. This is just for simplicity and
	to avoid redundancy.
	- A ticket can only be purchased once (by one user): UNIQUE(ticket) in 
	Purchase. Otherwise two users can buy the same ticket for the same seat
	and concert.

Assumptions:
	- Aside from the vid, no attributes of a venue are unique. Two venues can
	have the same name, city and address (possibly two cities with the same name
	in different countries). This is an unlikely scenario but not impossible nor
	is it restricted in the domain definition so it was left as a possibility.
	- Prices are stored as NUMERIC(10, 2) to avoid floating-point precision
	errors when dealing with currency.
	- VARCHAR fields have a max length of 255 as no limits were provided.
*/

DROP SCHEMA IF EXISTS TicketSchema CASCADE;
CREATE SCHEMA TicketSchema;
SET SEARCH_PATH TO TicketSchema;

-- A row represents an owner of one or more venues.
-- <oid> is the owner ID
-- <name> is the name of the owner
-- <phone_number> is the owner's phone number
CREATE TABLE Owners (
    oid INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(255) UNIQUE NOT NULL
);

-- A row represents a venue where concerts are held.
-- <vid> is the venue ID
-- <name> is the name of the venue
-- <city> is the city where the venue is located
-- <address> is the street address of the venue
-- <owner_id> is the oid of the owner
CREATE TABLE Venue (
    vid INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    owner_id INT REFERENCES Owners(oid) NOT NULL
);

-- A row represents a named section within a venue (e.g. "Floor").
-- <sec_id> is the section ID
-- <venue> is the vid of the venue this section belongs to
-- <name> is the name of the section, unique within the venue
CREATE TABLE Section (
    sec_id INT PRIMARY KEY,
    venue INT REFERENCES Venue(vid) NOT NULL,
    name VARCHAR(255) NOT NULL,
    UNIQUE (venue, name)
);

-- A row represents a single seat within a section of a venue.
-- <seat_id> is the seat ID
-- <name> is the seat identifier (e.g. "B7"), unique within the section
-- <section> is the sec_id of the section the seat belongs to
-- <accessible> indicates if the seat is accessible to people with
--              mobility issues
CREATE TABLE Seat (
    seat_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    section INT REFERENCES Section(sec_id) NOT NULL,
    accessible BOOLEAN NOT NULL,
    UNIQUE(name, section)
);

-- A row represents a concert held at a specific venue on a specific date.
-- <cid> is the concert ID
-- <name> is the name of the concert
-- <concert_date> is the date of the concert
-- <start_time> is the time at which the concert begins
-- <venue> is the vid of the venue at which the concert is being held
CREATE TABLE Concert (
    cid INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    concert_date DATE NOT NULL,
    start_time TIME NOT NULL,
    venue INT REFERENCES Venue(vid) NOT NULL,
    UNIQUE(concert_date, start_time, venue)
);

-- A row represents the ticket price for a given section at a concert.
-- <price_id> is the price ID
-- <concert> is the cid of the concert
-- <section> is the sec_id of the section
-- <price> is the price of a ticket in that section for that concert
CREATE TABLE TicketPrice (
    price_id INT PRIMARY KEY,
    concert INT REFERENCES Concert(cid) NOT NULL,
    section INT REFERENCES Section(sec_id) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    UNIQUE(concert, section)
);

-- A row represents an available ticket for a specific seat at a concert.
-- <tid> is the ticket ID
-- <concert> is the cid of the concert the ticket is for
-- <seat> is the seat_id of the seat that the ticket is for
CREATE TABLE Ticket (
    tid INT PRIMARY KEY,
    concert INT REFERENCES Concert(cid) NOT NULL,
    seat INT REFERENCES Seat(seat_id) NOT NULL,
    UNIQUE(concert, seat)
);

-- A row represents a registered user of the app.
-- <uid> is the user ID
-- <username> is the user's unique username
CREATE TABLE AppUser (
    uid INT PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL
);

-- A row represents a purchase of one ticket by one user.
-- <pur_id> is the purchase ID
-- <user_id> is the uid of the user who made the purchase
-- <ticket> is the tid of the ticket that was purchased
-- <purchase_time> is the date and time the purchase was made
CREATE TABLE Purchase (
    pur_id INT PRIMARY KEY,
    user_id INT REFERENCES AppUser(uid) NOT NULL,
    ticket INT REFERENCES Ticket(tid) UNIQUE NOT NULL,
    purchase_time TIMESTAMP NOT NULL
);
