-- 3 queries
-- 1 each for ConferenceDivision and team tables, and 1 join query
--USE MIST353_NFL_RDB_Harris;
--GO

use [mist353-nfl-rdb-harris]
go

CREATE OR ALTER PROCEDURE procGetTeamsInSameConferenceDivisionAsSpecifiedTeam
    @TeamName NVARCHAR(50)
AS
BEGIN
    SELECT 
        OtherTeam.TeamName,
        OtherTeam.TeamCityState,
        OtherTeam.TeamColor,
        CD.Conference,
        CD.Division
    FROM Team AS MyTeam
    INNER JOIN Team AS OtherTeam
        ON MyTeam.ConferenceDivision = OtherTeam.ConferenceDivision
    INNER JOIN ConferenceDivision AS CD
        ON MyTeam.ConferenceDivision = CD.ConferenceDivisionID
    WHERE MyTeam.TeamName = @TeamName
      AND OtherTeam.TeamName <> @TeamName
    ORDER BY OtherTeam.TeamName;
END;
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
GO 

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


execute ProcGetTeamsByConferenceDivision
@ConfernceName = 'AFC'
@DivisionName = 'North'; */

GO
select * from Team

--FindAllTeamsInMyDivision

DECLARE @MyTeamName NVARCHAR(50) = 'Pittsburgh Steelers';

SELECT 
    OtherTeam.TeamName, OtherTeam.TeamCityState,CD.Conference,CD.Division
FROM Team AS MyTeam
INNER JOIN Team AS OtherTeam 
    ON MyTeam.ConferenceDivision = OtherTeam.ConferenceDivision
INNER JOIN ConferenceDivision AS CD
    ON MyTeam.ConferenceDivision = CD.ConferenceDivisionID
WHERE MyTeam.TeamName = @MyTeamName
ORDER BY OtherTeam.TeamName;

GO

create or alter procedure procValidateUser
(
    @Email NVARCHAR(100),
    @PasswordHash NVARCHAR(200)
)
AS
BEGIN
    select AppUserID, Firstname + ' ' + Lastname as Fullname, UserRole
    from AppUser
    where Email = @Email
      and PasswordHash = convert(Varbinary(200),@PasswordHash,1);
END;

--execute procValidateUser @Email = 'tom.brady@example.com', @PasswordHash = 0x01;
--select * from AppUser;