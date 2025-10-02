CREATE TABLE Patient (
    Patient_ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M','F')),
    DOB DATE,
    Email VARCHAR2(100) UNIQUE,
    Phone VARCHAR2(20),
    Address VARCHAR2(200),
    Username VARCHAR2(50),
    Password VARCHAR2(50)
);

CREATE TABLE Doctor (
    Doctor_ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Specialization VARCHAR2(100),
    Username VARCHAR2(50),
    Password VARCHAR2(50)
);

CREATE TABLE Appointment (
    Appointment_ID NUMBER PRIMARY KEY,
    Appointment_Date DATE,
    Appointment_Time VARCHAR2(10),
    Status VARCHAR2(20),
    Clinic_Number NUMBER,
    Patient_ID NUMBER,
    Doctor_ID NUMBER,
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)
);

CREATE TABLE Prescription (
    Prescription_ID NUMBER PRIMARY KEY,
    Date DATE,
    Doctor_Advice VARCHAR2(200),
    Followup_Required VARCHAR2(5),
    Patient_ID NUMBER,
    Doctor_ID NUMBER,
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)
);

CREATE TABLE Invoice (
    Invoice_ID NUMBER PRIMARY KEY,
    Invoice_Date DATE,
    Amount NUMBER(10,2),
    Payment_Status VARCHAR2(20),
    Payment_Method VARCHAR2(50),
    Patient_ID NUMBER,
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID)
);

CREATE TABLE Tests (
    Test_ID NUMBER PRIMARY KEY,
    Blood_Test VARCHAR2(50),
    XRay VARCHAR2(50),
    MRI VARCHAR2(50),
    CT_Scan VARCHAR2(50)
);

UPDATE Patient SET Phone='03001234567', Email='newmail@email.com' WHERE Patient_ID=1;
UPDATE Invoice SET Payment_Status='Paid' WHERE Payment_Status='Unpaid';
DELETE FROM Appointment WHERE Status='Cancelled';
DELETE FROM Invoice WHERE Patient_ID=2;
SELECT * FROM Appointment WHERE Status='Booked';
SELECT * FROM Invoice WHERE Payment_Status='Unpaid';
SELECT Blood_Test FROM Tests;
SELECT * FROM Prescription WHERE Date=DATE '2025-09-02';

SELECT p.Name AS PatientName, d.Name AS DoctorName
FROM Appointment a
JOIN Patient p ON a.Patient_ID = p.Patient_ID
JOIN Doctor d ON a.Doctor_ID = d.Doctor_ID;

SELECT t.*, d.Name AS DoctorName
FROM Tests t
JOIN Appointment a ON t.Test_ID = a.Appointment_ID
JOIN Doctor d ON a.Doctor_ID = d.Doctor_ID;

SELECT pr.*
FROM Prescription pr
JOIN Patient p ON pr.Patient_ID = p.Patient_ID
WHERE p.Name='Ali Khan';

SELECT pr.*, d.Name AS DoctorName
FROM Prescription pr
JOIN Doctor d ON pr.Doctor_ID = d.Doctor_ID
WHERE pr.Followup_Required='Yes';
