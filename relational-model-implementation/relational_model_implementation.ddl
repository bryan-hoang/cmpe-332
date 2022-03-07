-- Adding `IF EXISTS` to avoid a potential "DATABASE doesn 't exist" error.
DROP DATABASE IF EXISTS covidDB;

CREATE DATABASE covidDB;

-- Ensuring tables aren't being accidentally created in other databases.
USE covidDB;

-- #region Creating the tables.
-- #region Strong entities.
CREATE TABLE Company(
  Name VARCHAR(20) NOT NULL,
  Street VARCHAR(20) NOT NULL,
  City VARCHAR(20) NOT NULL,
  Province VARCHAR(20) NOT NULL,
  -- e.g., "A1A1A1".
  PostalCode CHAR(6) NOT NULL,
  PRIMARY KEY(Name)
);

CREATE TABLE VaccineLot(
  -- e.g., "EY0578"
  LotNumber CHAR(6) NOT NULL,
  ProductionDate DATE NOT NULL,
  ExpiryDate DATE NOT NULL,
  DoseCount INTEGER NOT NULL,
  CompanyName VARCHAR(20) NOT NULL,
  -- One-to-many "Produces" relationship.
  PRIMARY KEY(LotNumber),
  FOREIGN KEY(CompanyName) REFERENCES Company(Name)
);

CREATE TABLE Patient(
  -- e.g., "1234567890", matching the definition of Health Number (HN)
  -- https://health.gov.on.ca/en/pro/publications/ohip/ebs_hcv_specs.aspx#glossary
  OHIPNumber CHAR(10) NOT NULL,
  FirstName VARCHAR(20) NOT NULL,
  LastName VARCHAR(20) NOT NULL,
  Birthdate DATE NOT NULL,
  PRIMARY KEY(OHIPNumber)
);

CREATE TABLE Spouse(
  -- e.g., "1234567890", matching the definition of Health Number (HN)
  -- https://health.gov.on.ca/en/pro/publications/ohip/ebs_hcv_specs.aspx#glossary
  OHIPNumber CHAR(10) NOT NULL,
  FirstName VARCHAR(20) NOT NULL,
  LastName VARCHAR(20) NOT NULL,
  PhoneNumber CHAR(10) NOT NULL,
  PatientOHIPNumber CHAR(10) NOT NULL,
  -- 1:1 "Has" relationship.
  PRIMARY KEY(OHIPNumber),
  FOREIGN KEY(PatientOHIPNumber) REFERENCES Patient(OHIPNumber)
);

CREATE TABLE VaccinationClinic(
  Name VARCHAR(20) NOT NULL,
  Street VARCHAR(20) NOT NULL,
  City VARCHAR(20) NOT NULL,
  Province VARCHAR(20) NOT NULL,
  -- e.g., "A1A1A1".
  PostalCode CHAR(6) NOT NULL,
  PRIMARY KEY(Name)
);

CREATE TABLE MedicalPractice(
  Name VARCHAR(20) NOT NULL,
  PhoneNumber CHAR(10) NOT NULL,
  PRIMARY KEY(Name)
);

CREATE TABLE HealthcareWorker(
  HealthcareWorkerID INTEGER AUTO_INCREMENT NOT NULL,
  FirstName VARCHAR(20) NOT NULL,
  LastName VARCHAR(20) NOT NULL,
  PRIMARY KEY(HealthcareWorkerID)
);

CREATE TABLE Nurse(
  HealthcareWorkerID INTEGER NOT NULL,
  PRIMARY KEY(HealthcareWorkerID),
  FOREIGN KEY(HealthcareWorkerID) REFERENCES HealthcareWorker(HealthcareWorkerID)
);

CREATE TABLE Doctor(
  HealthcareWorkerID INTEGER NOT NULL,
  -- One-to-many "Works with" relationship.
  MedicalPracticeName VARCHAR(20) NOT NULL,
  PRIMARY KEY(HealthcareWorkerID),
  FOREIGN KEY(HealthcareWorkerID) REFERENCES HealthcareWorker(HealthcareWorkerID),
  FOREIGN KEY(MedicalPracticeName) REFERENCES MedicalPractice(Name)
);

-- #endregion
-- #region Many-to-many relationships.
CREATE TABLE ShipsTo(
  VaccineLotNumber CHAR(6),
  VaccinationClinicName VARCHAR(20),
  PRIMARY KEY(VaccineLotNumber, VaccinationClinicName),
  FOREIGN KEY(VaccineLotNumber) REFERENCES VaccineLot(LotNumber),
  FOREIGN KEY(VaccinationClinicName) REFERENCES VaccinationClinic(Name)
);

CREATE TABLE Vaccination(
  VaccineLotNumber CHAR(6),
  PatientOHIPNumber CHAR(10),
  VaccinationClinicName VARCHAR(20),
  Date DATE NOT NULL,
  Time TIME NOT NULL,
  PRIMARY KEY(
    VaccineLotNumber,
    PatientOHIPNumber,
    VaccinationClinicName
  ),
  FOREIGN KEY(VaccineLotNumber) REFERENCES VaccineLot(LotNumber),
  FOREIGN KEY(PatientOHIPNumber) REFERENCES Patient(OHIPNumber),
  FOREIGN KEY(VaccinationClinicName) REFERENCES VaccinationClinic(Name)
);

CREATE TABLE NurseWorksAt(
  HealthcareWorkerID INTEGER NOT NULL,
  VaccinationClinicName VARCHAR(20) NOT NULL,
  PRIMARY KEY(HealthcareWorkerID, VaccinationClinicName),
  FOREIGN KEY(HealthcareWorkerID) REFERENCES HealthcareWorker(HealthcareWorkerID),
  FOREIGN KEY(VaccinationClinicName) REFERENCES VaccinationClinic(Name)
);

CREATE TABLE DoctorWorksAt(
  HealthcareWorkerID INTEGER NOT NULL,
  VaccinationClinicName VARCHAR(20),
  PRIMARY KEY(HealthcareWorkerID, VaccinationClinicName),
  FOREIGN KEY(HealthcareWorkerID) REFERENCES HealthcareWorker(HealthcareWorkerID),
  FOREIGN KEY(VaccinationClinicName) REFERENCES VaccinationClinic(Name)
);

-- #endregion
-- #region Multi-valued attributes.
CREATE TABLE HealthcareWorkerCredentials(
  HealthcareWorkerID INTEGER NOT NULL,
  Credential VARCHAR(20) NOT NULL,
  PRIMARY KEY(HealthcareWorkerID, Credential),
  FOREIGN KEY(HealthcareWorkerID) REFERENCES HealthcareWorker(HealthcareWorkerID)
);

-- #endregion
-- #endregion
-- #region Creating the initial data.
INSERT INTO
  Company
VALUES
  (
    'CovidCare',
    '123 Fake St',
    'Toronto',
    'Ontario',
    'A1A1A1'
  ),
  (
    'Vaccine Inc.',
    '456 Fake St',
    'Toronto',
    'Ontario',
    'A1A1A1'
  ),
  (
    'Vaccine Ltd.',
    '789 Fake St',
    'Toronto',
    'Ontario',
    'A1A1A1'
  );

INSERT INTO
  VaccineLot
VALUES
  (
    'EY0578',
    '2020-01-01',
    '2021-01-01',
    1123,
    'CovidCare'
  ),
  (
    'EY05E8',
    '2021-01-01',
    '2022-01-01',
    1210,
    'Vaccine Inc.'
  ),
  (
    'EY0577',
    '2022-01-01',
    '2023-01-01',
    1120,
    'Vaccine Ltd.'
  );

INSERT INTO
  Patient
VALUES
  ('1234567890', 'John', 'Doe', '1980-01-01'),
  ('1234567893', 'Jane', 'Smith', '1983-01-01');

INSERT INTO
  Spouse
VALUES
  (
    '1234567891',
    'Jane',
    'Doe',
    '6131234567',
    '1234567890'
  ),
  (
    '1234567892',
    'John',
    'Smith',
    '6131234568',
    '1234567893'
  );

INSERT INTO
  VaccinationClinic
VALUES
  (
    'Toronto',
    '123 Fake St',
    'Toronto',
    'Ontario',
    'A1A1A1'
  ),
  (
    'London',
    '456 Fake St',
    'London',
    'Ontario',
    'A1A1A1'
  ),
  (
    'Ottawa',
    '789 Fake St',
    'Ottawa',
    'Ontario',
    'A1A1A1'
  );

INSERT INTO
  MedicalPractice
VALUES
  ('Frontenac', '6131234567'),
  ('Treatments R Us', '6131234568'),
  ('McDoctors', '6131234569');

INSERT INTO
  HealthcareWorker
VALUES
  (1, 'Sally', 'Doe'),
  (2, 'Bob', 'Smith'),
  (3, 'Dr. John', 'Sally'),
  (4, 'Dr. Jane', 'Bob'),
  (5, 'Dr. John', 'Crane');

INSERT INTO
  Nurse
VALUES
  (1),
  (3),
  (5);

INSERT INTO
  Doctor
VALUES
  (2, 'Frontenac'),
  (4, 'Treatments R Us');

INSERT INTO
  ShipsTo
VALUES
  ('EY0578', 'Toronto'),
  ('EY05E8', 'Toronto'),
  ('EY0577', 'London');

INSERT INTO
  Vaccination
VALUES
  (
    'EY0578',
    '1234567890',
    'Toronto',
    '2020-01-01',
    '12:00:00'
  ),
  (
    'EY05E8',
    '1234567890',
    'Toronto',
    '2021-01-01',
    '12:00:00'
  ),
  (
    'EY0577',
    '1234567890',
    'London',
    '2022-01-01',
    '12:00:00'
  );

INSERT INTO
  NurseWorksAt
VALUES
  (1, 'Toronto'),
  (3, 'Toronto'),
  (5, 'London');

INSERT INTO
  DoctorWorksAt
VALUES
  (2, 'Toronto'),
  (4, 'London');

INSERT INTO
  HealthcareWorkerCredentials
VALUES
  (1, 'Nurse'),
  (2, 'Doctor'),
  (3, 'Doctor'),
  (4, 'Doctor'),
  (5, 'Doctor');

-- #endregion
