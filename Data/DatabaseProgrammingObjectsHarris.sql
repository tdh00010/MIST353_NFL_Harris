-- 3 queries
-- 1 each for ConferenceDivision and team tables, and 1 join query
USE MIST353_NFL_RDB_Harris;
GO

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

CREATE OR ALTER PROCEDURE procGetTeamsByConferenceDivision
(
    @Conference NVARCHAR(50) = NULL,
    @Division NVARCHAR(50) = NULL
)
AS
BEGIN
    SELECT 
        T.TeamName,T.TeamColor,CD.Conference,CD.Division
    FROM Team AS T
    INNER JOIN ConferenceDivision AS CD
        ON T.ConferenceDivision = CD.ConferenceDivisionID
    WHERE (@Conference IS NULL OR CD.Conference = @Conference)
      AND (@Division IS NULL OR CD.Division = @Division)
    ORDER BY T.TeamName;
END;


/*execute ProcGetTeamsByConferenceDivision
@ConfernceName = 'AFC'
@DivisionName = 'North*/

GO
select * from Team

DECLARE @MyTeamName NVARCHAR(50) = 'Pittsburgh Steelers';

SELECT OtherTeam.TeamName
FROM Team AS MyTeam
INNER JOIN Team AS OtherTeam
    ON MyTeam.ConferenceDivision = OtherTeam.ConferenceDivision
WHERE MyTeam.TeamName = @MyTeamName
  AND OtherTeam.TeamName <> @MyTeamName;

--FindAllTeamsInMyDivision

