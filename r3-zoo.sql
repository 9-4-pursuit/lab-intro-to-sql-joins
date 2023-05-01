/* https://sqlzoo.net/wiki/SQL_Tutorial
 * to run the database, run this on the terminal:
 * 1. psql
 * 2. \i r3-zoo.sql
 * 3. \q
*/

-- starting code
\echo Initial Database setup
DROP DATABASE IF EXISTS zoo;
CREATE DATABASE zoo;
\c zoo

CREATE TABLE world (
  id SERIAL PRIMARY KEY,
  name TEXT,
  continent TEXT,
  area INT,
  population BIGINT,
  gdp BIGINT
);

INSERT INTO world (name, continent, area, population, gdp)
VALUES
('Afghanistan',	'Asia',	652230, 25500100, 20343000000),
('Albania',	'Europe',	28748, 2831741, 12960000000),
('Algeria',	'Africa',	2381741, 37100000, 188681000000),
('Andorra',	'Europe',	468, 78115, 3712000000),
('Angola',	'Africa',	1246700, 20609294, 100990000000);
-- end starting code

-- See details of the table you created
\echo Database Table details
\d world;
SELECT * FROM world;



-- ** 0 SELECT basics **
\echo 1. Show the population of Afghanistan.
SELECT population FROM world
  WHERE name = 'Afghanistan';

\echo 2. Show the name and the population for "Albania", "Andorra" and "Afghanistan".
SELECT name, population FROM world
  WHERE name IN ('Albania', 'Andorra', 'Afghanistan');

\echo 3. Show the country and the area for countries with an area between 200,000 and 300,000.
SELECT name, area FROM world
  WHERE area BETWEEN 200000 AND 300000;



-- ** 1 SELECT name **
\echo 1. Find the country that start with "An".
SELECT name FROM world
  WHERE name LIKE 'An%';

\echo 2. Find the countries that end with "n".
SELECT name FROM world
  WHERE name LIKE '%n';

\echo 3. Find the countries that contain the letter "e".
SELECT name FROM world
  WHERE name LIKE '%e%';

\echo 4. Find the countries that start with "A" and end with "ra".
SELECT name FROM world
  WHERE name LIKE 'A%%ra';

\echo 5. Find the countries that have three or more "a" in the name.
SELECT name FROM world
  WHERE name LIKE '%a%a%a%';

\echo 6. Find the countries that have "t" as the second character.
SELECT name FROM world
 WHERE name LIKE '_t%'
ORDER BY name;

\echo 7. Find the countries that have two "o" characters separated by two others.
SELECT name FROM world
 WHERE name LIKE '%o__o%';

\echo 8. Find the countries that have exactly five characters.
SELECT name FROM world
 WHERE name LIKE '_____';

/* 
  From here it will give an error because there' no "capital" in our database.
*/
\echo 9. Find the country where the name is the capital city.
SELECT name FROM world
 WHERE name LIKE capital;
 -- WHERE name = capital;

\echo 10. Find the country where the capital is the country plus "City".
SELECT name FROM world
 WHERE capital LIKE concat(name, ' City');

\echo 11. Find the capital and the name where the capital includes the name of the country.
SELECT capital, name FROM world
 WHERE capital LIKE concat('%', name, '%');

\echo 12. Find the capital and the name where the capital is an extension of name of the country.
SELECT capital, name FROM world
 WHERE capital LIKE concat('%', name, '%') AND capital > name;



-- ** 6 JOIN **
-- starting code
\echo new Tables setup
CREATE TABLE game (
  id INT,
  mdate TEXT,
  stadium TEXT,
  team1 TEXT,
  team2 TEXT
);

CREATE TABLE goal (
  matchid INT,
  teamid TEXT,
  player TEXT,
  gtime SMALLINT
);

CREATE TABLE eteam (
  id TEXT,
  teamname TEXT,
  coach TEXT
);

INSERT INTO game (id, mdate, stadium, team1, team2)
VALUES
(1001, '8 June 2012', 'National Stadium (Warsaw)', 'POL', 'GRE'),
(1002, '8 June 2012', 'Stadion Miejski (Wroclaw)', 'RUS', 'CZE'),
(1003, '12 June 2012', 'Stadion Miejski (Wroclaw)', 'GRE', 'CZE'),
(1004, '12 June 2012', 'National Stadium (Warsaw)', 'POL', 'RUS');

INSERT INTO goal (matchid, teamid, player, gtime)
VALUES
(1001, 'POL', 'Robert Lewandowski', 17),
(1001, 'GRE', 'Dimitris Salpingidis', 51),
(1002, 'RUS', 'Alan Dzagoev', 15),
(1002, 'RUS', 'Roman Pavlyuchenko', 82);

INSERT INTO eteam (id, teamname, coach)
VALUES
('POL', 'Poland', 'Franciszek Smuda'),
('RUS', 'Russia', 'Dick Advocaat'),
('CZE', 'Czech Republic', 'Michal Bilek'),
('GRE', 'Greece', 'Fernando Santos');
-- end starting code

-- See details of the table you created
\echo new Tables details
SELECT * FROM game;
SELECT * FROM goal;
SELECT * FROM eteam;



\echo 1. Show matchid and player name for all goals scored by Russia.
SELECT matchid, player
 FROM goal
 WHERE teamid = 'RUS';

\echo 2. Show id, stadium, team1, team2 for game 1012.
SELECT id, stadium, team1, team2
 FROM game
 WHERE id = 1002;

\echo 3. Show the player, teamid, stadium and mdate for every Poland goal.
SELECT player, teamid, stadium , mdate
 FROM game
 JOIN goal ON (id=matchid AND teamid='POL');

\echo 4. Show the team1, team2 and player for every goal scored by a player called Mario player.
SELECT team1, team2, player
 FROM game
 JOIN goal ON (id=matchid AND player LIKE 'Alan%');

\echo 5. Show player, teamid, coach, gtime for all goals scored in the first 20 minutes gtime<=20.
SELECT player, teamid, coach, gtime
 FROM goal
 JOIN eteam ON (teamid=id AND gtime<=20);

\echo 6. List the the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
SELECT mdate, teamname
 FROM game
 JOIN eteam ON (team1=eteam.id AND coach LIKE '%Santos')

\echo 7. List the player for every goal scored in a game where the stadium was 'National Stadium (Warsaw)'.
SELECT player
 FROM goal
 JOIN game ON (id=matchid AND stadium='National Stadium (Warsaw)');

\echo 8. Show the name of all players who scored a goal against Czech Republic.
SELECT DISTINCT(player)
 FROM game
 JOIN goal ON matchid=id
 WHERE ((team1='CZE' OR team2='CZE') AND teamid!='CZE');

\echo 9. Show teamname and the total number of goals scored.
SELECT teamname, COUNT(player)
 FROM eteam
 JOIN goal ON id=teamid
 GROUP BY teamname;

\echo 10. Show the stadium and the number of goals scored in each stadium.
SELECT stadium, COUNT(player) AS goals
 FROM game
 JOIN goal ON (id=matchid)
 GROUP BY stadium;

\echo 11. For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT matchid, mdate, COUNT(player) AS goals
 FROM game
 JOIN goal ON (matchid=id AND (team1='POL' OR team2='POL'))
 GROUP BY matchid, mdate;

\echo 12. For every match where 'GRE' scored, show matchid, match date and the number of goals scored by 'GRE'.
SELECT id, mdate, COUNT(player) AS goals
 FROM game
 JOIN goal ON (id=matchid AND (team1='GRE' OR team2='GRE') AND teamid='GRE')
 GROUP BY id, mdate;

/* 13. List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.
mdate	team1	score1	team2	score2
1 July 2012	ESP	4	ITA	0
10 June 2012	ESP	1	ITA	1
10 June 2012	IRL	1	CRO	3
... */
SELECT
 mdate,
 team1, SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) AS score1,
 team2, SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) AS score2
 FROM game LEFT JOIN goal ON (id=matchid)
 GROUP BY mdate, matchid, team1, team2
 ORDER BY mdate, matchid, team1, team2



-- finish
DROP TABLE IF EXISTS world;
DROP TABLE IF EXISTS game;
DROP TABLE IF EXISTS goal;
DROP TABLE IF EXISTS eteam;