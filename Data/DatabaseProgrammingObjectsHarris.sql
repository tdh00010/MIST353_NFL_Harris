-- 3 queries
-- 1 each for ConferenceDivision and team tables, and 1 join query
USE MIST353_NFL_RDB_Harris;
GO

--Query for ConferenceDivision table
SELECT
    ConferenceDivisionID,
    Conference,
    Division
FROM ConferenceDivision
ORDER BY Conference, Division;
GO

--Query for Team table
SELECT
    TeamID,TeamName,TeamCityState,TeamColor,ConferenceDivision
FROM Team
ORDER BY TeamName;

GO

--JOIN query (Teams with their Conference + Division)
SELECT
    t.TeamID,t.TeamName,t.TeamCityState,cd.Conference,cd.Division
FROM Team AS t
INNER JOIN ConferenceDivision AS cd
    ON t.ConferenceDivision = cd.ConferenceDivisionID
ORDER BY t.TeamName;
GO