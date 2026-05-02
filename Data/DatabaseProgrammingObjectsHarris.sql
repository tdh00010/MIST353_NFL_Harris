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

GO

CREATE OR ALTER PROCEDURE procGetTeamsForSpecifiedFan
(
    @NFLFanID INT
)
AS
BEGIN
    SELECT 
        T.TeamName,
        CD.Conference,
        CD.Division,
        T.TeamColor,
        FT.PrimaryTeam
    FROM NFLFan AS F
    INNER JOIN FanTeam AS FT
        ON F.NFLFanID = FT.NFLFanID
    INNER JOIN Team AS T
        ON FT.TeamID = T.TeamID
    INNER JOIN ConferenceDivision AS CD
        ON T.ConferenceDivision = CD.ConferenceDivisionID
    WHERE F.NFLFanID = @NFLFanID
    ORDER BY FT.PrimaryTeam DESC, T.TeamName;
END;
GO

--execute procGetTeamsForSpecifiedFan @NFLFanID = 1;
--execute procGetTeamsForSpecifiedFan @NFLFanID = 2;


CREATE OR ALTER PROCEDURE procScheduleGame
(
    @HomeTeamID INT,
    @AwayTeamID INT,
    @GameRound NVARCHAR(50),
    @GameDate DATE,
    @GameStartTime TIME,
    @StadiumID INT,
    @NFLAdminID INT
)
AS
BEGIN

    DECLARE @context VARBINARY(128) = CAST(@NFLAdminID AS VARBINARY(128));
    SET CONTEXT_INFO @context;

    INSERT INTO Game (HomeTeamID, AwayTeamID, GameRound, GameDate, GameStartTime, StadiumID)
    VALUES (@HomeTeamID, @AwayTeamID, @GameRound, @GameDate, @GameStartTime, @StadiumID);

END;

GO

CREATE OR ALTER TRIGGER trgTrackChangesOnSchedulingGame
ON Game
AFTER INSERT
AS
BEGIN
    DECLARE @NFLAdminID INT;
    DECLARE @GameID INT;
    DECLARE @ChangeType NVARCHAR(50);
    DECLARE @ChangeDescription NVARCHAR(500);
    DECLARE @GameRound NVARCHAR(50);
    DECLARE @GameDate DATE;
    DECLARE @GameStartTime TIME;
    DECLARE @HomeTeamID INT;
    DECLARE @AwayTeamID INT;
    DECLARE @StadiumID INT;
    DECLARE @HomeTeamName NVARCHAR(100);
    DECLARE @AwayTeamName NVARCHAR(100);
    DECLARE @StadiumName NVARCHAR(100);
    DECLARE @AdminFullName NVARCHAR(100);

    SET @NFLAdminID = CONVERT(INT, CONVERT(BINARY(4), CONTEXT_INFO()));

    SELECT 
        @GameID = GameID,
        @GameRound = GameRound,
        @GameDate = GameDate,
        @GameStartTime = GameStartTime,
        @HomeTeamID = HomeTeamID,
        @AwayTeamID = AwayTeamID,
        @StadiumID = StadiumID
    FROM inserted;

    SELECT @HomeTeamName = TeamName 
    FROM Team 
    WHERE TeamID = @HomeTeamID;

    SELECT @AwayTeamName = TeamName 
    FROM Team 
    WHERE TeamID = @AwayTeamID;

    SELECT @StadiumName = StadiumName 
    FROM Stadium 
    WHERE StadiumID = @StadiumID;

    SELECT @AdminFullName = Firstname + ' ' + Lastname 
    FROM AppUser 
    WHERE AppUserID = @NFLAdminID;

    SET @ChangeType = 'Insert';

    SET @ChangeDescription = 
        'Game scheduled with GameID: ' + CAST(@GameID AS NVARCHAR(50))
        + ': ' + @HomeTeamName + ' vs ' + @AwayTeamName
        + ' on ' + CAST(@GameDate AS NVARCHAR(50))
        + ' at ' + CAST(@GameStartTime AS NVARCHAR(50))
        + ' in stadium ' + @StadiumName
        + '. Game Round: ' + @GameRound
        + '. Scheduled by: ' + ISNULL(@AdminFullName, 'Unknown Admin');

    INSERT INTO AdminChangesTracker 
        (NFLAdminID, GameID, ChangeType, ChangeDescription)
    VALUES 
        (@NFLAdminID, @GameID, @ChangeType, @ChangeDescription);
END;
GO

-- To create dropdown lists for the NFLAdmin to select Teams and Stadiums to schedule games.

CREATE OR ALTER PROCEDURE procGetAllTeams
AS
BEGIN
    SELECT 
        TeamID, 
        TeamName
    FROM Team
    ORDER BY TeamName;
END;
GO

--EXEC procGetAllTeams;


CREATE OR ALTER PROCEDURE procGetAllStadiums
AS
BEGIN
    SELECT 
        StadiumID, 
        StadiumName
    FROM Stadium
    ORDER BY StadiumName;
END;
GO

--EXEC procGetAllStadiums;


-- To get all changes made by a specified logged in NFLAdmin.

CREATE OR ALTER PROCEDURE procGetAllChangesMadeBySpecifiedAdmin
(
    @NFLAdminID INT
)
AS
BEGIN
    SELECT 
        ACT.ChangeDateTime, 
        ACT.ChangeType, 
        ACT.ChangeDescription, 
        G.GameRound, 
        G.GameDate, 
        G.GameStartTime,
        HT.TeamName AS HomeTeam, 
        AT.TeamName AS AwayTeam, 
        S.StadiumName
    FROM AdminChangesTracker ACT 
    INNER JOIN Game G
        ON ACT.GameID = G.GameID
    INNER JOIN Team HT
        ON G.HomeTeamID = HT.TeamID
    INNER JOIN Team AT
        ON G.AwayTeamID = AT.TeamID
    INNER JOIN Stadium S
        ON G.StadiumID = S.StadiumID
    WHERE ACT.NFLAdminID = @NFLAdminID
    ORDER BY ACT.ChangeDateTime DESC;
END;
GO

--EXEC procGetAllChangesMadeBySpecifiedAdmin @NFLAdminID = 5;


-- Disabling and enabling triggers on the Game table. When and Why?

-- DISABLE TRIGGER trgTrackChangesOnSchedulingGame ON Game;
-- DISABLE TRIGGER ALL ON Game;

-- ENABLE TRIGGER trgTrackChangesOnSchedulingGame ON Game;
-- ENABLE TRIGGER ALL ON Game;
GO


-- Adding TeamLogo column to Team table safely

IF COL_LENGTH('Team', 'TeamLogo') IS NULL
BEGIN
    ALTER TABLE Team
    ADD TeamLogo VARBINARY(MAX);
END;
GO

CREATE OR ALTER PROCEDURE dbo.procUpdateTeamLogo
(
    @TeamName NVARCHAR(50),
    @TeamLogo VARBINARY(MAX)
)
AS
BEGIN
    UPDATE dbo.Team
    SET TeamLogo = @TeamLogo
    WHERE TeamName = @TeamName;
END;
GO

-- Get teams with logos for a specified fan

CREATE OR ALTER PROCEDURE procGetTeamsWithLogosForSpecifiedFan
(
    @NFLFanID INT
)
AS
BEGIN
    SELECT 
        T.TeamName, 
        CD.Conference, 
        CD.Division, 
        T.TeamColor,
        FT.PrimaryTeam, 
        T.TeamLogo
    FROM FanTeam FT 
    INNER JOIN Team T
        ON FT.TeamID = T.TeamID
    INNER JOIN ConferenceDivision CD
        ON T.ConferenceDivision = CD.ConferenceDivisionID
    WHERE FT.NFLFanID = @NFLFanID;
END;
GO

--EXEC procGetTeamsWithLogosForSpecifiedFan @NFLFanID = 1;
