USE MIST353_NFL_RDB_Harris;
GO

-- Drop tables in correct order (child first)
IF OBJECT_ID('Team') IS NOT NULL
    DROP TABLE Team;

IF OBJECT_ID('ConferenceDivision') IS NOT NULL
    DROP TABLE ConferenceDivision;
GO


-- Create ConferenceDivision table
CREATE TABLE ConferenceDivision (
    ConferenceDivision INT IDENTITY(1,1)
        CONSTRAINT PK_ConferenceDivision PRIMARY KEY,

    Conference NVARCHAR(50) NOT NULL
        CONSTRAINT CK_ConferenceNames CHECK (Conference IN ('AFC', 'NFC')),

    Division NVARCHAR(50) NOT NULL
        CONSTRAINT CK_DivisionNames CHECK (Division IN ('East', 'North', 'West', 'South')),

    CONSTRAINT UK_ConferenceDivision UNIQUE (Conference, Division)
);
GO


-- Create Team table
CREATE TABLE Team (
    TeamID INT IDENTITY(1,1)
        CONSTRAINT PK_Team PRIMARY KEY,

    TeamName NVARCHAR(50) NOT NULL,
    TeamCityState NVARCHAR(50) NOT NULL,
    TeamColor NVARCHAR(50) NOT NULL,

    ConferenceDivision INT NOT NULL,
    CONSTRAINT FK_Team_ConferenceDivision
        FOREIGN KEY (ConferenceDivision)
        REFERENCES ConferenceDivision(ConferenceDivision)
);
GO
