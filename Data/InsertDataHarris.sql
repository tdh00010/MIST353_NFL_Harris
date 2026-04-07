--Insert data
--Insert all the CONferenceDivision data (8 rows)
--Insert team data for AFC North (4 rows)

--USE MIST353_NFL_RDB_Harris;
use [mist353-nfl-rdb-harris]
--DELETE FROM Team;
--DELETE FROM ConferenceDivision;
INSERT INTO ConferenceDivision (Conference, Division)
values
('AFC', 'North'),
('AFC', 'South'),
('AFC', 'East'),
('AFC', 'West'),
('NFC', 'North'),
('NFC', 'South'),
('NFC', 'East'),
('NFC', 'West');

GO
SELECT * FROM ConferenceDivision ORDER BY ConferenceDivisionID;
GO

-- Information for AFC North Teams
INSERT INTO Team (TeamName, TeamCityState, TeamColor, ConferenceDivision)
VALUES
('Baltimore Ravens', 'Baltimore, MD', 'Purple, Black, Metallic Gold', 1),
('Cincinnati Bengals', 'Cincinnati, OH', 'Black, Orange, White', 1),
('Cleveland Browns', 'Cleveland, OH', 'Brown, Orange, White', 1),
('Pittsburgh Steelers', 'Pittsburgh, PA', 'Black, Gold, White', 1),
('Houston Texans', 'Houston, TX', 'Deep Steel Blue, Battle Red, Liberty White', 2),
('Indianapolis Colts', 'Indianapolis, IN', 'Speed Blue, White', 2),
('Jacksonville Jaguars', 'Jacksonville, FL', 'Teal, Black, Gold, White', 2),
('Tennessee Titans', 'Tennessee', 'Titans Blue, Titans Navy, Red, Silver', 2),

('Buffalo Bills', 'Buffalo, NY', 'Royal Blue, Red, White', 3),
('Miami Dolphins', 'Miami, FL', 'Aqua Green, Orange, White', 3),
('New England Patriots', 'New England', 'Navy Blue, Red, Silver, White', 3),
('New York Jets', 'New York City, NY', 'Gotham Green, Spotlight White, Stealth Black', 3),

('Denver Broncos', 'Denver, CO', 'Bronco Orange, Navy Blue, White', 4),
('Kansas City Chiefs', 'Kansas City, MO', 'Red, Gold, White', 4),
('Las Vegas Raiders', 'Las Vegas, NV', 'Silver, Black, White', 4),
('Los Angeles Chargers', 'Los Angeles, CA', 'Powder Blue, Sunshine Gold, White', 4),

('Chicago Bears', 'Chicago, IL', 'Navy Blue, Orange, White', 5),
('Detroit Lions', 'Detroit, MI', 'Honolulu Blue, Silver, White', 5),
('Green Bay Packers', 'Green Bay, WI', 'Dark Green, Gold, White', 5),
('Minnesota Vikings', 'Minneapolis, MN', 'Purple, Gold, White', 5),

('Atlanta Falcons', 'Atlanta, GA', 'Red, Black, White', 6),
('Carolina Panthers', 'Charlotte, NC', 'Panther Blue, Panther Black, Silver, White', 6),
('New Orleans Saints', 'New Orleans, LA', 'Old Gold, Black, White', 6),
('Tampa Bay Buccaneers', 'Tampa Bay, FL', 'Red, Pewter, Black, White', 6),

('Dallas Cowboys', 'Dallas, TX', 'Navy Blue, Metallic Silver, White', 7),
('New York Giants', 'New York City, NY', 'Royal Blue, Red, White', 7),
('Philadelphia Eagles', 'Philadelphia, PA', 'Midnight Green, Silver, Black, White', 7),
('Washington Commanders', 'Washington D.C.', 'Burgundy Red, Gold Metallic Red, White', 7),

('Arizona Cardinals', 'Phoenix, AZ ', 'Cardinal Red, Black, White ', 8),
('Los Angeles Rams ', 'Los Angeles, CA ', 'Rams Royal Blue , Solor Gold , White ', 8),
('San Francisco 49ers ', 'San Francisco, CA ', '49ers Red , Metallic Gold , White ', 8),
('Seattle Seahawks ', 'Seattle, WA ', 'College Navy , Action Green , Wolf Grey , White ', 8);

GO
--select * from Team order by TeamID;

insert into AppUser (Firstname, Lastname, Email, Phone, PasswordHash, UserRole)
VALUES
('Tom', 'Brady', 'tom.brady@example.com', '555-1234', 0x01, N'NFLFan'),
('Aaron', 'Rodgers', 'aaron.rodgers@example.com', '555-9012', 0x01, N'NFLFan'),
('Drew', 'Brees', 'drew.brees@example.com', '555-2222', 0x01, N'NFLFan'),
('Patrick', 'Mahomes', 'patrick.mahomes@example.com', '555-7890', 0x01, N'NFLFan'),
('Bill', 'Belichick', 'bill.belichick@example.com', '555-5678', 0x01, N'NFLAdmin'),
('Sean', 'McVay', 'sean.mcay@example.com', '555-3456', 0x01, N'NFLAdmin'),
('Mike', 'Tomlin', 'mike.tomlin@example.com', '555-1111', 0x01, N'NFLAdmin'),
('Andy', 'Reid', 'andy.reid@example.com', '555-3333', 0x01, N'NFLAdmin');
GO
insert into NFLFan (NFLFanID)
VALUES
(1),
(2),
(3),
(4);
GO
insert into NFLAdmin (NFLAdminID)
VALUES
(5),
(6),
(7),
(8);
GO
--select * from Team;
insert into FanTeam (NFLFanID, TeamID, PrimaryTeam)
VALUES
(1, 11, 1),
(1, 24, 0), -- Tom Brady is a fan of New England Patriots and Tampa Bay Buccaneers, but Patriots is his primary team
(2, 19, 1),
(2, 12, 0),
(2, 4, 0),-- Aaron Rodgers is a fan of Green Bay Packers, New York Jets, and Pittsburgh Steelers, but Packers is his primary team
(3, 23, 1), -- Drew Brees is a fan New Orleans Saints (primary) and Los Angeles Chargers
(3, 16, 0),
(4, 14, 1); -- Patrick Mahomes is a fan of Kansas City Chiefs (primary)