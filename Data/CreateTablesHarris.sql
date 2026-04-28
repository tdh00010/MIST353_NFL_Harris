--USE MIST353_NFL_RDB_Harris;
use [mist353-nfl-rdb-harris]
GO

if(OBJECT_ID('AdminChangesTracker') is not null)
    drop table AdminChangesTracker;
if(OBJECT_ID('TeamStadium') is not null)
    drop table TeamStadium;
if(OBJECT_ID('Game') is not null)
    drop table Game;
if(OBJECT_ID('Stadium') is not null)
    drop table Stadium;

if(Object_ID('FanTeam') IS NOT NULL)
    drop table FanTeam;
IF(OBJECT_ID('NFLFAN') IS NOT NULL)
    drop table NFLFan;
IF(OBJECT_ID('NFLAdmin') IS NOT NULL)
    drop table NFLAdmin;

IF OBJECT_ID('Team', 'U') IS NOT NULL
    DROP TABLE Team;

IF OBJECT_ID('ConferenceDivision', 'U') IS NOT NULL
    DROP TABLE ConferenceDivision;
if(OBJECT_ID('AppUser', 'U') IS NOT NULL)
    drop table AppUser;

GO

CREATE TABLE ConferenceDivision (
    ConferenceDivisionID INT IDENTITY(1,1)
        CONSTRAINT PK_ConferenceDivision PRIMARY KEY,
    Conference NVARCHAR(50) NOT NULL
        CONSTRAINT CK_ConferenceNames CHECK (Conference IN ('AFC', 'NFC')),
    Division NVARCHAR(50) NOT NULL
        CONSTRAINT CK_DivisionNames CHECK (Division IN ('East', 'North', 'West', 'South')),
    CONSTRAINT UK_ConferenceDivision UNIQUE (Conference, Division)
);
GO

CREATE TABLE Team (
    TeamID INT IDENTITY(1,1)
        CONSTRAINT PK_Team PRIMARY KEY,
    TeamName NVARCHAR(50) NOT NULL,
    TeamCityState NVARCHAR(50) NOT NULL,
    TeamColor NVARCHAR(100) NOT NULL,
    ConferenceDivision INT NOT NULL,
    CONSTRAINT FK_Team_ConferenceDivision
        FOREIGN KEY (ConferenceDivision)
        REFERENCES ConferenceDivision(ConferenceDivisionID)
);
GO

create table AppUser(
    AppUserID INT identity(1,1) constraint PK_AppUser primary key,
    Firstname NVARCHAR(50) NOT NULL,
    Lastname NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL constraint UK_AppUserEmail unique,
    PasswordHash Varbinary(200) NOT NULL,
    Phone NVARCHAR(20) NULL,
    UserRole NVARCHAR(20) NOT NULL constraint CK_AppUserRole check (UserRole in (N'NFLAdmin', N'NFLFan'))

);

GO
create table NFLFan(
    NFLFanID INT
    constraint PK_NFLFan primary key,
    constraint FK_NFLFan_AppUser foreign key (NFLFanID) references AppUser(AppUserID)
);

GO

create table NFLAdmin(
    NFLAdminID INT
    constraint PK_NFLAdmin primary key,
    constraint FK_NFLAdmin_AppUser foreign key (NFLAdminID) references AppUser(AppUserID)
);

GO

GO

create table FanTeam(
    FanTeamID INT identity(1,1) constraint PK_FanTeam primary key,
    NFLFanID INT NOT NULL, constraint FK_FanTeam_NFLFan foreign key (NFLFanID) references NFLFan(NFLFanID),
    TeamID INT NOT NULL, constraint FK_FanTeam_Team foreign key (TeamID) references Team(TeamID),
    constraint UK_FanTeam unique (NFLFanID, TeamID),
    PrimaryTeam BIT NOT NULL
);

go

create table Stadium (
    StadiumID INT identity(1,1) 
        constraint PK_Stadium PRIMARY KEY,
    StadiumName NVARCHAR(100) NOT NULL,
    StadiumCityState NVARCHAR(50) NOT NULL,
    Capacity INT NOT NULL
);

go

create table TeamStadium (
    TeamStadiumID INT identity(1,1) 
        constraint PK_TeamStadium PRIMARY KEY,
    TeamID INT NOT NULL 
        constraint FK_TeamStadium_Team FOREIGN KEY REFERENCES Team(TeamID),
    StadiumID INT NOT NULL
        constraint FK_TeamStadium_Stadium FOREIGN KEY REFERENCES Stadium(StadiumID),
    StartYear INT NOT NULL,
    EndYear INT NULL,
    constraint UK_TeamStadium UNIQUE (TeamID, StadiumID, StartYear)
);

go

create table Game (
    GameID INT identity(1,1) 
        constraint PK_Game PRIMARY KEY,
    GameRound NVARCHAR(50) NOT NULL
        constraint CK_GameRound CHECK (GameRound IN ('Wild Card', 'Divisional', 'Conference', 'Super Bowl')),
    GameDate DATE NOT NULL,
    GameStartTime TIME NOT NULL,
    HomeTeamID INT NOT NULL 
        constraint FK_Game_HomeTeam FOREIGN KEY REFERENCES Team(TeamID),
    AwayTeamID INT NOT NULL
        constraint FK_Game_AwayTeam FOREIGN KEY REFERENCES Team(TeamID),
    StadiumID INT NOT NULL
        constraint FK_Game_Stadium FOREIGN KEY REFERENCES Stadium(StadiumID),
    HomeTeamScore INT NULL,
    AwayTeamScore INT NULL,
    WinningTeamID INT NULL
        constraint FK_Game_WinningTeam FOREIGN KEY REFERENCES Team(TeamID),
    constraint CK_Game_Teams CHECK (HomeTeamID != AwayTeamID),
    constraint UK_Game UNIQUE (HomeTeamID, AwayTeamID, GameDate)
);

go

create table AdminChangesTracker (
    AdminChangesTrackerID INT identity(1,1) 
        constraint PK_AdminChangesTracker PRIMARY KEY,
    NFLAdminID INT NOT NULL
        constraint FK_AdminChangesTracker_NFLAdmin FOREIGN KEY REFERENCES NFLAdmin(NFLAdminID),
    GameID INT NOT NULL
        constraint FK_AdminChangesTracker_Game FOREIGN KEY REFERENCES Game(GameID),
    ChangeDateTime DATETIME NOT NULL DEFAULT GETDATE(),
    ChangeType NVARCHAR(50) NOT NULL
        constraint CK_AdminChangesTracker_ChangeType CHECK (ChangeType IN (N'Insert', N'Update', N'Delete')),
    ChangeDescription NVARCHAR(500) NOT NULL
);