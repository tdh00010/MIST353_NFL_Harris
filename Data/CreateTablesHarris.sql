--Create a database for NFL app
--use master;

--Create DATABASE MIST353_NFL_RDB_Harris;

Use MIST353_NFL_RDB_Harris


-- Create tables for first iteration

create TABLE ConferenceDivision (
    ConferenceDivision INT identity(1,1)
        constraint PK_ConferenceDivision PRIMARY KEY,
    Conference NVARCHAR(50) NOT NULL,
        constraint CK_ConferenceNames CHECK (Conference IN ('AFC', 'NFC')),
    Division NVARCHAR(50) NOT NULL,
        constraint CK_DivisionNames CHECK (Division IN ('East', 'North', 'West', 'South'))
);

create TABLE Team (
    TeamID INT identity(1,1)
        constraint PK_Team PRIMARY KEY,
    TeamName NVARCHAR(50) Not Null,
    TeamCityState NVARCHAR(50) NOT NULL,
    TeamColor NVARCHAR(50) NOT NULL,
    ConferenceDivision INT NOT NULL,
        constraint FK_Team_ConferenceDivision FOREIGN KEY (ConferenceDivision) REFERENCES ConferenceDivision(ConferenceDivision)
);




        