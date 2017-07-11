DROP DATABASE IF EXISTS projectDB;

CREATE DATABASE IF NOT EXISTS projectDB
  DEFAULT CHARACTER SET utf8
  DEFAULT COLLATE utf8_general_ci;

USE projectDB;

DROP TABLE IF EXISTS Administrator;
CREATE TABLE Administrator (
  AdministratorID int(5) NOT NULL AUTO_INCREMENT, 
  Password        varchar(255), 
  FirstName       varchar(255), 
  LastName        varchar(255), 
  PRIMARY KEY (AdministratorID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS Volunteer;
CREATE TABLE Volunteer (
  VolunteerID int(5) NOT NULL AUTO_INCREMENT, 
  Password    varchar(255), 
  FirstName   varchar(255), 
  LastName    varchar(255), 
  Gender      varchar(10), 
  Email       varchar(255), 
  PRIMARY KEY (VolunteerID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS Runner;
CREATE TABLE Runner (
  RunnerID       int(5) NOT NULL AUTO_INCREMENT, 
  VolunteerID    int(5), 
  Password       varchar(255), 
  FirstName      varchar(255), 
  LastName       varchar(255), 
  Gender         varchar(10), 
  DateOfBirth    date, 
  Email          varchar(255), 
  Country        varchar(255), 
  ProfilePicture varchar(255), 
  PRIMARY KEY (RunnerID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE Runner 
  ADD INDEX IDX_Runner_VolunteerID (VolunteerID), 
  ADD CONSTRAINT FK_Runner_VolunteerID FOREIGN KEY (VolunteerID) 
    REFERENCES Volunteer (VolunteerID) ON DELETE CASCADE ON UPDATE CASCADE;

DROP TABLE IF EXISTS Event;
CREATE TABLE Event (
  EventID     int(5) NOT NULL AUTO_INCREMENT, 
  Name        varchar(255), 
  Distance    float, 
  DateOfEvent date, 
  TimeStart   time, 
  Price       decimal(10, 2), 
  PRIMARY KEY (EventID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS RaceKitChoice;
CREATE TABLE RaceKitChoice (
  RaceKitID    int(5) NOT NULL AUTO_INCREMENT, 
  Name         varchar(255), 
  Description  varchar(255), 
  Price        decimal(10, 2), 
  Photo        varchar(255), 
  EventID int(5) NOT NULL, 
  PRIMARY KEY (RaceKitID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE RaceKitChoice 
  ADD INDEX IDX_RaceKitChoice_EventID (EventID), 
  ADD CONSTRAINT FK_RaceKitChoice_EventID FOREIGN KEY (EventID) 
    REFERENCES Event (EventID) ON DELETE CASCADE ON UPDATE CASCADE;

DROP TABLE IF EXISTS Sponsor;
CREATE TABLE Sponsor (
  SponsorID int(5) NOT NULL AUTO_INCREMENT, 
  Password  varchar(255), 
  FirstName varchar(255), 
  LastName  varchar(255), 
  Company   varchar(255), 
  Email     varchar(255), 
  PRIMARY KEY (SponsorID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS Charity;
CREATE TABLE Charity (
  CharityID   int(5) NOT NULL AUTO_INCREMENT, 
  Name        varchar(255), 
  Description varchar(255), 
  WebsiteUrl  varchar(255), 
  Logo        varchar(255), 
  PRIMARY KEY (CharityID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS EventRegister;
CREATE TABLE EventRegister (
  RegID            int(5) NOT NULL AUTO_INCREMENT, 
  RunnerID         int(5) NOT NULL, 
  EventID          int(5) NOT NULL, 
  CheckInTime      time, 
  FinishTime       time, 
  TopSpeed         float, 
  PaymentConfirmed tinyint(1) DEFAULT '0', 
  PaymentTotal     int(11), 
  RaceKitID        int(5) NOT NULL, 
  RaceKitSent      tinyint(1) DEFAULT '0', 
  PRIMARY KEY (RegID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE EventRegister ADD INDEX IDX_EventRegister_EventID (EventID), 
  ADD CONSTRAINT FK_EventRegister_EventID FOREIGN KEY (EventID) 
    REFERENCES Event (EventID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE EventRegister ADD INDEX IDX_EventRegister_RaceKitID (RaceKitID), 
  ADD CONSTRAINT FK_EventRegister_RaceKitID FOREIGN KEY (RaceKitID) 
    REFERENCES RaceKitChoice (RaceKitID) ON DELETE CASCADE ON UPDATE CASCADE;
    
ALTER TABLE EventRegister ADD INDEX IDX_EventRegister_RunnerID (RunnerID), 
  ADD CONSTRAINT FK_EventRegister_RunnerID FOREIGN KEY (RunnerID) 
    REFERENCES Runner (RunnerID) ON DELETE CASCADE ON UPDATE CASCADE;

DROP TABLE IF EXISTS SponsorRecord;
CREATE TABLE SponsorRecord (
  SponsorID        int(5) NOT NULL, 
  CharityID        int(5) NOT NULL, 
  RegID            int(5) NOT NULL, 
  Amount           decimal(10, 2), 
  PaymentConfirmed tinyint(1) DEFAULT '0', 
  PRIMARY KEY (SponsorID, CharityID, RegID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE SponsorRecord ADD INDEX IDX_SponsorRecord_RegID (RegID), 
  ADD CONSTRAINT FK_SponsorRecord_RegID FOREIGN KEY (RegID) 
    REFERENCES EventRegister (RegID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE SponsorRecord ADD INDEX IDX_SponsorRecord_CharityID (CharityID), 
  ADD CONSTRAINT FK_SponsorRecord_CharityID FOREIGN KEY (CharityID) 
    REFERENCES Charity (CharityID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE SponsorRecord ADD INDEX IDX_SponsorRecord_SponsorID (SponsorID), 
  ADD CONSTRAINT FK_SponsorRecord_SponsorID FOREIGN KEY (SponsorID) 
    REFERENCES Sponsor (SponsorID) ON DELETE CASCADE ON UPDATE CASCADE;
