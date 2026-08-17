SET search_path TO TicketSchema;

-- Populate Owners(oid, name, phone_number)
INSERT INTO Owners VALUES
(1, 'Alice Events Ltd',   '416-100-0001'),
(2, 'Bob Productions',    '416-100-0002'),
(3, 'Carol Venues Inc',   '416-100-0003'),
(4, 'Dave Entertainment', '416-100-0004'),
(5, 'Eve Concert Group',  '416-100-0005');

-- Populate Venue(vid, name, city, address, owner_id)
INSERT INTO Venue VALUES
(1,  'The Grand Hall',      'Toronto',   '1 King St W',    1),
(2,  'Riverside Arena',     'Toronto',   '2 Queen St W',   1),
(3,  'Lakeside Pavilion',   'Toronto',   '3 Front St W',   1),
(4,  'The Blue Room',       'Montreal',  '4 Rue Ste-Cat',  2),
(5,  'Metro Dome',          'Montreal',  '5 Blvd Rene',    2),
(6,  'Harbor Stage',        'Vancouver', '6 Granville St', 3),
(7,  'Mountain View Hall',  'Vancouver', '7 Robson St',    3),
(8,  'Prairie Center',      'Calgary',   '8 Centre St',    4),
(9,  'Capital Theatre',     'Ottawa',    '9 Elgin St',     5),
(10, 'East End Auditorium', 'Halifax',   '10 Barrington',  5);

-- Populate Section(sec_id, venue, name)
INSERT INTO Section VALUES
(1,  1,  'Floor'),  (2,  1,  'Balcony'),
(3,  2,  'Floor'),  (4,  2,  'Balcony'),
(5,  3,  'Floor'),  (6,  3,  'Balcony'),
(7,  4,  'Floor'),  (8,  4,  'Balcony'),
(9,  5,  'Floor'),  (10, 5,  'Balcony'),
(11, 6,  'Floor'),  (12, 6,  'Balcony'),
(13, 7,  'Floor'),  (14, 7,  'Balcony'),
(15, 8,  'Floor'),  (16, 8,  'Balcony'),
(17, 9,  'Floor'),  (18, 9,  'Balcony'),
(19, 10, 'Floor'),  (20, 10, 'Balcony');

-- Populate Seat(seat_id, name, section, accessible)

INSERT INTO Seat VALUES
-- Venue 1, Floor (sec_id=1): all 5 accessible
(1,  'A1', 1, true),  (2,  'A2', 1, true),  (3,  'A3', 1, true),
(4,  'A4', 1, true),  (5,  'A5', 1, true),
-- Venue 1, Balcony (sec_id=2): none accessible
(6,  'B1', 2, false), (7,  'B2', 2, false), (8,  'B3', 2, false),
(9,  'B4', 2, false), (10, 'B5', 2, false),

-- Venue 2, Floor (sec_id=3): 2 accessible
(11, 'A1', 3, true),  (12, 'A2', 3, true),  (13, 'A3', 3, false),
(14, 'A4', 3, false), (15, 'A5', 3, false),
-- Venue 2, Balcony (sec_id=4): none accessible
(16, 'B1', 4, false), (17, 'B2', 4, false), (18, 'B3', 4, false),
(19, 'B4', 4, false), (20, 'B5', 4, false),

-- Venue 3, Floor (sec_id=5): 2 accessible in base seats
(21, 'A1', 5, true),  (22, 'A2', 5, true),  (23, 'A3', 5, false),
(24, 'A4', 5, false), (25, 'A5', 5, false),
-- Venue 3, Balcony (sec_id=6): none accessible in base seats
(26, 'B1', 6, false), (27, 'B2', 6, false), (28, 'B3', 6, false),
(29, 'B4', 6, false), (30, 'B5', 6, false),

-- Venue 4, Floor (sec_id=7)
(31, 'A1', 7, true),  (32, 'A2', 7, true),  (33, 'A3', 7, false),
(34, 'A4', 7, false), (35, 'A5', 7, false),
-- Venue 4, Balcony (sec_id=8)
(36, 'B1', 8, false), (37, 'B2', 8, false), (38, 'B3', 8, false),
(39, 'B4', 8, false), (40, 'B5', 8, false),

-- Venue 5, Floor (sec_id=9)
(41, 'A1', 9, true),  (42, 'A2', 9, true),  (43, 'A3', 9, false),
(44, 'A4', 9, false), (45, 'A5', 9, false),
-- Venue 5, Balcony (sec_id=10)
(46, 'B1', 10, false), (47, 'B2', 10, false), (48, 'B3', 10, false),
(49, 'B4', 10, false), (50, 'B5', 10, false),

-- Venue 6, Floor (sec_id=11)
(51, 'A1', 11, true),  (52, 'A2', 11, true),  (53, 'A3', 11, false),
(54, 'A4', 11, false), (55, 'A5', 11, false),
-- Venue 6, Balcony (sec_id=12)
(56, 'B1', 12, false), (57, 'B2', 12, false), (58, 'B3', 12, false),
(59, 'B4', 12, false), (60, 'B5', 12, false),

-- Venue 7, Floor (sec_id=13)
(61, 'A1', 13, true),  (62, 'A2', 13, true),  (63, 'A3', 13, false),
(64, 'A4', 13, false), (65, 'A5', 13, false),
-- Venue 7, Balcony (sec_id=14)
(66, 'B1', 14, false), (67, 'B2', 14, false), (68, 'B3', 14, false),
(69, 'B4', 14, false), (70, 'B5', 14, false),

-- Venue 8, Floor (sec_id=15)
(71, 'A1', 15, true),  (72, 'A2', 15, true),  (73, 'A3', 15, false),
(74, 'A4', 15, false), (75, 'A5', 15, false),
-- Venue 8, Balcony (sec_id=16)
(76, 'B1', 16, false), (77, 'B2', 16, false), (78, 'B3', 16, false),
(79, 'B4', 16, false), (80, 'B5', 16, false),

-- Venue 9, Floor (sec_id=17)
(81, 'A1', 17, true),  (82, 'A2', 17, true),  (83, 'A3', 17, false),
(84, 'A4', 17, false), (85, 'A5', 17, false),
-- Venue 9, Balcony (sec_id=18)
(86, 'B1', 18, false), (87, 'B2', 18, false), (88, 'B3', 18, false),
(89, 'B4', 18, false), (90, 'B5', 18, false),

-- Venue 10, Floor (sec_id=19)
(91,  'A1', 19, true),  (92,  'A2', 19, true),  (93,  'A3', 19, false),
(94,  'A4', 19, false), (95,  'A5', 19, false),
-- Venue 10, Balcony (sec_id=20)
(96,  'B1', 20, false), (97,  'B2', 20, false), (98,  'B3', 20, false),
(99,  'B4', 20, false), (100, 'B5', 20, false),

-- Extra seats for Venue 3 to satisfy query requirements
(101, 'A6',  5, true),  (102, 'A7',  5, true),  (103, 'A8',  5, true),
(104, 'A9',  5, true),  (105, 'A10', 5, true),  (106, 'A11', 5, true),
(107, 'A12', 5, true),  (108, 'A13', 5, true),  (109, 'A14', 5, true),
(110, 'A15', 5, true),  (111, 'A16', 5, true),  (112, 'A17', 5, true),
(113, 'A18', 5, true),  (114, 'A19', 5, true),  (115, 'A20', 5, true),
(116, 'A21', 5, true),  (117, 'A22', 5, false), (118, 'A23', 5, false),
(119, 'A24', 5, false), (120, 'A25', 5, false), (121, 'A26', 5, false),
(122, 'A27', 5, false), (123, 'A28', 5, false), (124, 'A29', 5, false),
(125, 'A30', 5, false),
(126, 'B6',  6, false), (127, 'B7',  6, false), (128, 'B8',  6, false),
(129, 'B9',  6, false), (130, 'B10', 6, false), (131, 'B11', 6, false),
(132, 'B12', 6, false), (133, 'B13', 6, false), (134, 'B14', 6, false),
(135, 'B15', 6, false), (136, 'B16', 6, false), (137, 'B17', 6, false),
(138, 'B18', 6, false), (139, 'B19', 6, false), (140, 'B20', 6, false),
(141, 'B21', 6, false), (142, 'B22', 6, false), (143, 'B23', 6, false),
(144, 'B24', 6, false), (145, 'B25', 6, false), (146, 'B26', 6, false),
(147, 'B27', 6, false), (148, 'B28', 6, false), (149, 'B29', 6, false),
(150, 'B30', 6, false);

-- Populate Concert(cid, name, concert_date, start_time, venue)
INSERT INTO Concert VALUES
(1, 'Jazz Night',        '2025-03-01', '20:00:00', 1),
(2, 'Rock Unplugged',    '2025-03-02', '19:00:00', 2),
(3, 'Pop Spectacular',   '2025-03-03', '21:00:00', 3),
(4, 'Classical Evening', '2025-04-01', '18:00:00', 4),
(5, 'EDM Festival',      '2025-04-02', '22:00:00', 5);

-- Populate TicketPrice(price_id, concert, section, price)
INSERT INTO TicketPrice VALUES
(1,  1, 1,  75.00),  -- Concert 1, Floor
(2,  1, 2,  50.00),  -- Concert 1, Balcony
(3,  2, 3,  80.00),  -- Concert 2, Floor
(4,  2, 4,  55.00),  -- Concert 2, Balcony
(5,  3, 5,  90.00),  -- Concert 3, Floor
(6,  3, 6,  60.00),  -- Concert 3, Balcony
(7,  4, 7,  70.00),  -- Concert 4, Floor
(8,  4, 8,  45.00),  -- Concert 4, Balcony
(9,  5, 9,  85.00),  -- Concert 5, Floor
(10, 5, 10, 55.00);  -- Concert 5, Balcony

-- Populate AppUser(uid, username)
INSERT INTO AppUser VALUES
(1, 'superfan'),
(2, 'jazzlover'),
(3, 'rockfan99'),
(4, 'popqueen'),
(5, 'concertgoer');

-- Populate Ticket(tid, concert, seat)

-- Concert 1: seats 1-8
INSERT INTO Ticket VALUES
(1, 1, 1),  (2, 1, 2),  (3, 1, 3),  (4, 1, 4),
(5, 1, 5),  (6, 1, 6),  (7, 1, 7),  (8, 1, 8);

-- Concert 3: all 30 Floor seats + 25 of 30 Balcony seats = 55 tickets
INSERT INTO Ticket VALUES
(9,  3, 21), (10, 3, 22), (11, 3, 23), (12, 3, 24), (13, 3, 25),
(14, 3, 101),(15, 3, 102),(16, 3, 103),(17, 3, 104),(18, 3, 105),
(19, 3, 106),(20, 3, 107),(21, 3, 108),(22, 3, 109),(23, 3, 110),
(24, 3, 111),(25, 3, 112),(26, 3, 113),(27, 3, 114),(28, 3, 115),
(29, 3, 116),(30, 3, 117),(31, 3, 118),(32, 3, 119),(33, 3, 120),
(34, 3, 121),(35, 3, 122),(36, 3, 123),(37, 3, 124),(38, 3, 125),
(39, 3, 26), (40, 3, 27), (41, 3, 28), (42, 3, 29), (43, 3, 30),
(44, 3, 126),(45, 3, 127),(46, 3, 128),(47, 3, 129),(48, 3, 130),
(49, 3, 131),(50, 3, 132),(51, 3, 133),(52, 3, 134),(53, 3, 135),
(54, 3, 136),(55, 3, 137),(56, 3, 138),(57, 3, 139),(58, 3, 140),
(59, 3, 141),(60, 3, 142),(61, 3, 143),(62, 3, 144),(63, 3, 145);

-- Populate Purchase(pur_id, user_id, ticket, purchase_time)

-- superfan (uid=1): 25 tickets
INSERT INTO Purchase VALUES
(1,  1, 1,  '2025-02-01 10:00:00'),
(2,  1, 2,  '2025-02-01 10:01:00'),
(3,  1, 3,  '2025-02-01 10:02:00'),
(4,  1, 4,  '2025-02-01 10:03:00'),
(5,  1, 5,  '2025-02-01 10:04:00'),
(6,  1, 6,  '2025-02-01 10:05:00'),
(7,  1, 7,  '2025-02-01 10:06:00'),
(8,  1, 8,  '2025-02-01 10:07:00'),
(9,  1, 9,  '2025-02-10 09:00:00'),
(10, 1, 10, '2025-02-10 09:01:00'),
(11, 1, 11, '2025-02-10 09:02:00'),
(12, 1, 12, '2025-02-10 09:03:00'),
(13, 1, 13, '2025-02-10 09:04:00'),
(14, 1, 14, '2025-02-10 09:05:00'),
(15, 1, 15, '2025-02-10 09:06:00'),
(16, 1, 16, '2025-02-10 09:07:00'),
(17, 1, 17, '2025-02-10 09:08:00'),
(18, 1, 18, '2025-02-10 09:09:00'),
(19, 1, 19, '2025-02-10 09:10:00'),
(20, 1, 20, '2025-02-10 09:11:00'),
(21, 1, 21, '2025-02-10 09:12:00'),
(22, 1, 22, '2025-02-10 09:13:00'),
(23, 1, 23, '2025-02-10 09:14:00'),
(24, 1, 24, '2025-02-10 09:15:00'),
(25, 1, 25, '2025-02-10 09:16:00');

-- jazzlover (uid=2): 10 tickets
INSERT INTO Purchase VALUES
(26, 2, 26, '2025-02-11 11:00:00'),
(27, 2, 27, '2025-02-11 11:01:00'),
(28, 2, 28, '2025-02-11 11:02:00'),
(29, 2, 29, '2025-02-11 11:03:00'),
(30, 2, 30, '2025-02-11 11:04:00'),
(31, 2, 31, '2025-02-11 11:05:00'),
(32, 2, 32, '2025-02-11 11:06:00'),
(33, 2, 33, '2025-02-11 11:07:00'),
(34, 2, 34, '2025-02-11 11:08:00'),
(35, 2, 35, '2025-02-11 11:09:00');

-- rockfan99 (uid=3): 10 tickets
INSERT INTO Purchase VALUES
(36, 3, 36, '2025-02-12 14:00:00'),
(37, 3, 37, '2025-02-12 14:01:00'),
(38, 3, 38, '2025-02-12 14:02:00'),
(39, 3, 39, '2025-02-12 14:03:00'),
(40, 3, 40, '2025-02-12 14:04:00'),
(41, 3, 41, '2025-02-12 14:05:00'),
(42, 3, 42, '2025-02-12 14:06:00'),
(43, 3, 43, '2025-02-12 14:07:00'),
(44, 3, 44, '2025-02-12 14:08:00'),
(45, 3, 45, '2025-02-12 14:09:00');

-- popqueen (uid=4): 9 tickets
INSERT INTO Purchase VALUES
(46, 4, 46, '2025-02-13 15:00:00'),
(47, 4, 47, '2025-02-13 15:01:00'),
(48, 4, 48, '2025-02-13 15:02:00'),
(49, 4, 49, '2025-02-13 15:03:00'),
(50, 4, 50, '2025-02-13 15:04:00'),
(51, 4, 51, '2025-02-13 15:05:00'),
(52, 4, 52, '2025-02-13 15:06:00'),
(53, 4, 53, '2025-02-13 15:07:00'),
(54, 4, 54, '2025-02-13 15:08:00');

-- concertgoer (uid=5): 9 tickets
INSERT INTO Purchase VALUES
(55, 5, 55, '2025-02-14 16:00:00'),
(56, 5, 56, '2025-02-14 16:01:00'),
(57, 5, 57, '2025-02-14 16:02:00'),
(58, 5, 58, '2025-02-14 16:03:00'),
(59, 5, 59, '2025-02-14 16:04:00'),
(60, 5, 60, '2025-02-14 16:05:00'),
(61, 5, 61, '2025-02-14 16:06:00'),
(62, 5, 62, '2025-02-14 16:07:00'),
(63, 5, 63, '2025-02-14 16:08:00');
