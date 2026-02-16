--Insert data
--Insert all the CONferenceDivision data (8 rows)
--Insert team data for AFC North (4 rows)

INSERT INTO ConferenceDivision (Conference, Division)
VALUES
('AFC', 'East'),
('AFC', 'North'),
('AFC', 'South'),
('AFC', 'West'),
('NFC', 'East'),
('NFC', 'North'),
('NFC', 'South'),
('NFC', 'West');

INSERT INTO Team (TeamName, TeamCityState, TeamColor, ConferenceDivision)
VALUES
('Ravens', 'Baltimore, MD', 'Purple/Black', 2),
('Bengals', 'Cincinnati, OH', 'Orange/Black', 2),
('Browns', 'Cleveland, OH', 'Brown/Orange', 2),
('Steelers', 'Pittsburgh, PA', 'Black/Gold', 2);
