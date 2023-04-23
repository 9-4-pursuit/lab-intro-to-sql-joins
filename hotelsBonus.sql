DROP DATABASE IF EXISTS hotels;
CREATE DATABASE hotels;
\c hotels

CREATE TABLE hotels (id SERIAL PRIMARY KEY, name TEXT, city TEXT, state TEXT, pets BOOLEAN, rating numeric DEFAULT 5, CHECK (rating >= 0 AND rating <= 5));

INSERT INTO hotels (name, city, state, rating, pets)
VALUES
('Hotel California', null, 'California', 4, true),
('The Great Northern', 'Twin Peaks', 'Washington', 3, true),
('Hilbert''s Hotel', null, null, 1, false),
('Hotelicopter', 'Somewhere in the sky', null, 3, false),
('Fawlty Towers', 'Torquay on the English Riviera','England', 2, true),
('Grand Budapest Hotel', 'Republic of Zubrowka', null, 1, true);

SELECT * FROM hotels;

CREATE TABLE rooms (id SERIAL PRIMARY KEY, name TEXT, price numeric, vacant BOOLEAN, room_num INT, hotel_id INT);

INSERT INTO rooms (hotel_id, name, price, room_num, vacant)
VALUES
(1, 'Queen', 1200, 202, true),
(1, 'Queen', 1200, 303, true),
(1, 'King', 1400, 404, true),
(1, 'Penthouse', 2200, 707, true),
(2, 'Queen', 400, 201, true),
(2, 'Queen', 400, 302, false),
(2, 'King', 600, 403, false),
(2, 'Penthouse', 1200, 605, false),
(3, 'Room', null, null, null),
(4, null, 4000, null, true),
(5, 'Queen', 1200, 111, false),
(5, 'Queen', 1200, 222, false),
(5, 'King', 1400, 333, false),
(7, 'Queen', 1200, 1111, false),
(7, 'Queen', 1200, 2222, false),
(7, 'King', 1400, 3333, false);

SELECT * FROM rooms;

SELECT * FROM hotels FULL OUTER JOIN rooms ON hotels.id = rooms.hotel_id;

-- SELECT * FROM rooms FULL OUTER JOIN hotels ON hotels.id = rooms.hotel_id;

-- SELECT * FROM hotels INNER JOIN rooms ON hotels.id = rooms.hotel_id;

-- SELECT
--  AVG(price)
-- FROM
--  rooms
-- INNER JOIN
--  hotels
-- ON
--  hotels.id = rooms.hotel_id;

--  SELECT DISTINCT
--  hotels.name
-- FROM
--  hotels
-- JOIN
--  rooms
-- ON
--  hotels.id = rooms.hotel_id
-- WHERE
--  rooms.vacant IS TRUE;

\echo Query for hotels that allow pets

SELECT * FROM hotels WHERE pets = true;

\echo Query for hotels that allow pets AND have vacancies

SELECT * FROM hotels, rooms WHERE pets = true AND vacant = true;

\echo Query for the average room price for a hotel that allows pets

SELECT AVG(price) FROM rooms, hotels WHERE pets = true;

\echo Query for the most expensive room

SELECT MAX(price) FROM rooms;

\echo Query for the average price of a room that has a name that includes queen in it (case insensitive)

SELECT AVG(price) FROM rooms WHERE name ILIKE '%queen%';

\echo Query for the most expensive room

SELECT MAX(price) FROM rooms;

\echo Update a room at Hotel California with room number 202 from vacant-true to vacant false.

UPDATE rooms SET vacant = false WHERE hotel_id = 1 AND room_num = 202;

\echo Update all the rooms with the hotel_id of 7 to now have a hotel_id that matches the Grand Budapest Hotel

UPDATE rooms SET hotel_id = 6 WHERE hotel_id = 7;