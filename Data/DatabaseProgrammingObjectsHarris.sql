-- 3 queries
-- 1 each for ConferenceDivision and team tables, and 1 join query
USE MIST353_NFL_RDB_Harris;
go

/*--Query for ConferenceDivision table
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
GO*/

--4th query

Create or alter procedure procGetTeamsByConferenceDivision
(
    @Conference NVARCHAR(50) = null,
    @Division NVARCHAR(50) = null
)
AS
Begin
    SELECT T.TeamName, T.TeamColor, CD.Conference, CD.Division
    FROM Team AS T
    INNER JOIN ConferenceDivision AS CD
        ON T.ConferenceDivision = CD.ConferenceDivisionID
    WHERE (@Conference IS NULL OR CD.Conference =IsNull(@ConferenceName, Conference))
      AND (@Division IS NULL OR CD.Division = IsNull(@DivisionName, Division))
    ORDER BY T.TeamName;
End;
/*
execute ProcGetTeamsByConferenceDivision
@ConfernceName = 'AFC'
@DivisionName = 'North'

*/
GO
