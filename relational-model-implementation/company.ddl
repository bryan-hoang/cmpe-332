-- Adding `IF EXISTS` to avoid a potential "DATABASE doesn 't exist" error.
DROP DATABASE IF EXISTS companydb;

CREATE DATABASE companydb;

USE companydb;

CREATE TABLE Department(
  DName VARCHAR(15) NOT NULL,
  DNumber INTEGER NOT NULL,
  MGRSSN CHAR(11) NOT NULL,
  MgrStartDate DATE,
  PRIMARY KEY(DNumber)
);

CREATE TABLE Employee(
  SSN CHAR(11) NOT NULL,
  BDate DATE,
  Sex CHAR(1),
  Address VARCHAR(40),
  Salary INTEGER,
  FName CHAR(20),
  Minit CHAR(1),
  LName CHAR(20),
  Dno INTEGER,
  SuperSSN CHAR(11),
  PRIMARY KEY(SSN)
);

CREATE TABLE Project(
  PName CHAR(20) NOT NULL,
  PNumber INTEGER NOT NULL,
  PLocation CHAR(40),
  DNum INTEGER NOT NULL,
  PRIMARY KEY(PNumber),
  FOREIGN KEY(DNum) REFERENCES Department(DNumber)
);

CREATE TABLE Dependent(
  dependent_name CHAR(40) NOT NULL,
  Sex CHAR(1),
  Bdate DATE,
  Relationship CHAR(10),
  ESSN CHAR(11) NOT NULL,
  PRIMARY KEY(dependent_name, ESSN),
  FOREIGN KEY(ESSN) REFERENCES Employee(SSN)
);

CREATE TABLE Works_On(
  ESSN CHAR(11) NOT NULL,
  PNo INTEGER NOT NULL,
  Hours DECIMAL(5, 2),
  PRIMARY KEY(ESSN, PNo),
  FOREIGN KEY(ESSN) REFERENCES Employee(SSN),
  FOREIGN KEY(PNo) REFERENCES Project(PNumber)
);

CREATE TABLE DeptLocations(
  Dnumber INTEGER NOT NULL,
  DLocation VARCHAR(40) NOT NULL,
  PRIMARY KEY(Dnumber, DLocation),
  FOREIGN KEY(Dnumber) REFERENCES Department(DNumber)
);

INSERT INTO
  Employee
VALUES
  (
    '123456789',
    '1965-01-09',
    'M',
    '731 Fondren, Houston, TX',
    30000,
    'John',
    'B',
    'Smith',
    5,
    '333445555'
  ),
  (
    '333445555',
    '1955-12-08',
    'M',
    '638 Voss, Houston, TX',
    40000,
    'Franklin',
    'T',
    'Wong',
    5,
    '888665555'
  ),
  (
    '999887777',
    '1968-07-19',
    'F',
    '3321 Castle, Spring,TX',
    25000,
    'Alicia',
    'J',
    'Zelaya',
    4,
    '987654321'
  ),
  (
    '987654321',
    '1941-06-20',
    'F',
    '291 Berry, Bellaire, TX',
    43000,
    'Jennifer',
    'S',
    'Wallace',
    4,
    '888665555'
  ),
  (
    '666884444',
    '1962-09-15',
    'M',
    '975 Fire Oak, Humble, TX',
    38000,
    'Ramesh',
    'K',
    'Narayan',
    5,
    '333445555'
  ),
  (
    '453453453',
    '1972-07-31',
    'F',
    '5631 Rice, Houston, TX',
    25000,
    'Joyce',
    'A',
    'English',
    5,
    '333445555'
  ),
  (
    '987987987',
    '1969-03-29',
    'M',
    '980 Dallas, Houston, TX',
    25000,
    'Ahmad',
    'V',
    'Jabbar',
    4,
    '987654321'
  ),
  (
    '888665555',
    '1937-11-10',
    'M',
    '450 Stone, Houston, TX',
    55000,
    'James',
    'E',
    'Borg',
    1,
    NULL
  );

INSERT INTO
  Department
VALUES
  ('Research', 5, '333445555', '1988-05-22'),
  ('Administration', 4, '987654321', '1995-01-01'),
  ('Headquarters', 1, '888665555', '1981-06-19');

INSERT INTO
  Project
VALUES
  ('ProductX', 1, 'Bellaire', 5),
  ('ProductY', 2, 'Sugarland', 5),
  ('ProductZ', 3, 'Houston', 5),
  ('Computerization', 10, 'Stafford', 4),
  ('Reorganization', 20, 'Houston', 1),
  ('Newbenefits', 30, 'Stafford', 4);

INSERT INTO
  Dependent
VALUES
  (
    'Alice',
    'F',
    '1966-04-05',
    'DAUGHTER',
    '333445555'
  ),
  (
    'Theodore',
    'M',
    '1963-10-25',
    'SON',
    '333445555'
  ),
  ('Joy', 'F', '1958-05-03', 'SPOUSE', '333445555'),
  (
    'Abner',
    'M',
    '1942-02-28',
    'SPOUSE',
    '987654321'
  ),
  ('Michael', 'M', '1988-01-04', 'SON', '123456789'),
  (
    'Alice',
    'F',
    '1988-12-30',
    'DAUGHTER',
    '123456789'
  ),
  (
    'Elizabeth',
    'F',
    '1967-05-05',
    'SPOUSE',
    '123456789'
  );

INSERT INTO
  Works_On
VALUES
  ('123456789', 1, 32.5),
  ('123456789', 2, 7.5),
  ('666884444', 3, 40.0),
  ('453453453', 1, 20.0),
  ('453453453', 2, 20.0),
  ('333445555', 2, 10.0),
  ('333445555', 3, 10.0),
  ('333445555', 10, 10.0),
  ('333445555', 20, 10.0),
  ('999887777', 30, 30.0),
  ('999887777', 10, 10.0),
  ('987987987', 10, 35.0),
  ('987987987', 30, 5.0),
  ('987654321', 30, 20.0),
  ('987654321', 20, 15.0),
  ('888665555', 20, NULL);

INSERT INTO
  DeptLocations
VALUES
  (1, 'Houston'),
  (4, 'Stafford'),
  (5, 'Bellaire'),
  (5, 'Sugarland'),
  (5, 'Houston');
