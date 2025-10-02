CREATE TABLE Members (
    MemberID NUMBER PRIMARY KEY,
    Name VARCHAR2(50) NOT NULL,
    Email VARCHAR2(50) UNIQUE,
    JoinDate DATE DEFAULT SYSDATE
);

CREATE TABLE Books (
    BookID NUMBER PRIMARY KEY,
    Title VARCHAR2(50) NOT NULL,
    Author VARCHAR2(50),
    CopiesAvailable NUMBER CHECK (CopiesAvailable >= 0)
);

CREATE TABLE IssuedBooks (
    IssueID NUMBER PRIMARY KEY,
    MemberID NUMBER,
    BookID NUMBER,
    IssueDate DATE DEFAULT SYSDATE,
    ReturnDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

INSERT INTO Members VALUES (1,'Ali','ali@email.com',DEFAULT);
INSERT INTO Members VALUES (2,'Sara','sara@email.com',DEFAULT);
INSERT INTO Members VALUES (3,'Ahmed','ahmed@email.com',DEFAULT);

INSERT INTO Books VALUES (101,'Database Systems','Silberschatz',5);
INSERT INTO Books VALUES (102,'Operating Systems','Galvin',3);
INSERT INTO Books VALUES (103,'Computer Networks','Tanenbaum',2);

INSERT INTO IssuedBooks VALUES (1,1,101,DEFAULT,NULL);
UPDATE Books SET CopiesAvailable = CopiesAvailable - 1 WHERE BookID = 101;

SELECT m.Name, b.Title
FROM Members m
JOIN IssuedBooks i ON m.MemberID = i.MemberID
JOIN Books b ON i.BookID = b.BookID;

INSERT INTO Members VALUES (1,'Duplicate','dup@email.com',DEFAULT);
INSERT INTO IssuedBooks VALUES (2,99,101,DEFAULT,NULL);
INSERT INTO Books VALUES (104,'AI Basics','Russell',-5);

SELECT Name FROM Members WHERE MemberID NOT IN (SELECT MemberID FROM IssuedBooks);
SELECT Title FROM Books WHERE CopiesAvailable = (SELECT MAX(CopiesAvailable) FROM Books);
SELECT MemberID FROM IssuedBooks GROUP BY MemberID ORDER BY COUNT(*) DESC FETCH FIRST 1 ROWS ONLY;
SELECT Title FROM Books WHERE BookID NOT IN (SELECT BookID FROM IssuedBooks);
SELECT MemberID, BookID FROM IssuedBooks WHERE ReturnDate IS NULL AND IssueDate < SYSDATE - 30;
