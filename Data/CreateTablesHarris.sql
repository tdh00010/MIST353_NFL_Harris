USE MIST353_NFL_RDB_Harris;
GO

IF OBJECT_ID('Team', 'U') IS NOT NULL
    DROP TABLE Team;
GO

IF OBJECT_ID('ConferenceDivision', 'U') IS NOT NULL
    DROP TABLE ConferenceDivision;
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
/*-- Step 1: Create a login at the server level

use master;

CREATE LOGIN NandaSurendra

WITH PASSWORD = 'MI$T353Instructor';



-- Step 2: Switch to your target database

USE MIST353_NFL_RDB_Harris;



-- Step 3: Create a database user mapped to the login

CREATE USER NandaSurendra

FOR LOGIN NandaSurendra;



-- Step 4: Grant EXECUTE permission on all stored procedures and UDFs

GRANT EXECUTE TO NandaSurendra;



-- Read access to all tables

GRANT SELECT TO NandaSurendra;*/
