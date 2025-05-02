USE master;

GO

IF EXISTS (SELECT name FROM sys.databases WHERE name='BankDatabaseBRAM')
	BEGIN
		ALTER DATABASE BankDatabaseBRAM SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE BankDatabaseBRAM;
	END

GO

CREATE DATABASE BankDatabaseBRAM;

GO

USE BankDatabaseBRAM;

GO

SET NOCOUNT ON;

GO

CREATE TABLE Country(
  CountryID INT IDENTITY(1,1) NOT NULL,
  Name VARCHAR(200) NOT NULL,
  ISOCode CHAR(3) NOT NULL,
  CONSTRAINT PK_Country PRIMARY KEY(CountryID),
  CONSTRAINT UQ_Country_ISOCode UNIQUE(ISOCode)
);

CREATE TABLE Region(
  RegionID INT IDENTITY(1,1) NOT NULL,
  Name VARCHAR(200) NOT NULL,
  CountryID INT NOT NULL,
  CONSTRAINT PK_Region PRIMARY KEY(RegionID),
  CONSTRAINT FK_Region_Country FOREIGN KEY(CountryID) REFERENCES Country(CountryID)
);

CREATE TABLE City(
  CityID INT IDENTITY(1,1) NOT NULL,
  Name VARCHAR(200) NOT NULL,
  RegionID INT NOT NULL,
  CONSTRAINT PK_City PRIMARY KEY(CityID),
  CONSTRAINT FK_City_Region FOREIGN KEY(RegionID) REFERENCES Region(RegionID)
);

CREATE TABLE PostalCode(
  PostalCodeID INT IDENTITY(1,1) NOT NULL,
  Code VARCHAR(20) NOT NULL,
  CityID INT NOT NULL,
  CONSTRAINT PK_PostalCode PRIMARY KEY(PostalCodeID),
  CONSTRAINT FK_PostalCode_City FOREIGN KEY(CityID) REFERENCES City(CityID)
);

CREATE TABLE Address(
  AddressID INT IDENTITY(1,1) NOT NULL,
  Street VARCHAR(200) NOT NULL,
  HouseNumber VARCHAR(20) NOT NULL,
  PostalCodeID INT NOT NULL,
  CONSTRAINT PK_Address PRIMARY KEY(AddressID),
  CONSTRAINT FK_Address_PostalCode FOREIGN KEY(PostalCodeID) REFERENCES PostalCode(PostalCodeID)
);

CREATE TABLE Branch(
  BranchID INT IDENTITY(1,1) NOT NULL,
  BranchName VARCHAR(200) NOT NULL,
  CreatedDate DATETIME NOT NULL,
  PhoneNumber VARCHAR(50) NULL,
  SWIFTCode VARCHAR(20) NULL,
  AddressID INT NOT NULL,
  CONSTRAINT PK_Branch PRIMARY KEY(BranchID),
  CONSTRAINT FK_Branch_Address FOREIGN KEY(AddressID) REFERENCES Address(AddressID)
);

CREATE TABLE EmployeeRole(
  EmployeeRoleID INT IDENTITY(1,1) NOT NULL,
  Name VARCHAR(100) NOT NULL,
  CONSTRAINT PK_EmployeeRole PRIMARY KEY(EmployeeRoleID),
  CONSTRAINT UQ_EmployeeRole_Name UNIQUE(Name)
);

CREATE TABLE Gender(
  GenderID INT IDENTITY(1,1) NOT NULL,
  Name VARCHAR(50) NOT NULL,
  CONSTRAINT PK_Gender PRIMARY KEY(GenderID),
  CONSTRAINT UQ_Gender_Name UNIQUE(Name)
);

CREATE TABLE AccountType(
  AccountTypeID INT IDENTITY(1,1) NOT NULL,
  Name VARCHAR(100) NOT NULL,
  CONSTRAINT PK_AccountType PRIMARY KEY(AccountTypeID),
  CONSTRAINT UQ_AccountType_Name UNIQUE(Name)
);

CREATE TABLE TransactionType(
  TransactionTypeID INT IDENTITY(1,1) NOT NULL,
  Name VARCHAR(100) NOT NULL,
  CONSTRAINT PK_TransactionType PRIMARY KEY(TransactionTypeID),
  CONSTRAINT UQ_TransactionType_Name UNIQUE(Name)
);

CREATE TABLE CardType(
  CardTypeID INT IDENTITY(1,1) NOT NULL,
  Name VARCHAR(100) NOT NULL,
  CONSTRAINT PK_CardType PRIMARY KEY(CardTypeID),
  CONSTRAINT UQ_CardType_Name UNIQUE(Name)
);

CREATE TABLE MerchantCategory(
  MerchantCategoryID INT IDENTITY(1,1) NOT NULL,
  Name VARCHAR(100) NOT NULL,
  CONSTRAINT PK_MerchantCategory PRIMARY KEY(MerchantCategoryID),
  CONSTRAINT UQ_MerchantCategory_Name UNIQUE(Name)
);

CREATE TABLE LoanType(
  LoanTypeID INT IDENTITY(1,1) NOT NULL,
  Name VARCHAR(100) NOT NULL,
  CONSTRAINT PK_LoanType PRIMARY KEY(LoanTypeID),
  CONSTRAINT UQ_LoanType_Name UNIQUE(Name)
);

CREATE TABLE DispositionRole(
  DispositionRoleID INT IDENTITY(1,1) NOT NULL,
  Name VARCHAR(100) NOT NULL,
  CONSTRAINT PK_DispositionRole PRIMARY KEY(DispositionRoleID),
  CONSTRAINT UQ_DispositionRole_Name UNIQUE(Name)
);

CREATE TABLE CustomerLoanRole(
  CustomerLoanRoleID INT IDENTITY(1,1) NOT NULL,
  Name VARCHAR(100) NOT NULL,
  CONSTRAINT PK_CustomerLoanRole PRIMARY KEY(CustomerLoanRoleID),
  CONSTRAINT UQ_CustomerLoanRole_Name UNIQUE(Name)
);

CREATE TABLE Currency(
  CurrencyID INT IDENTITY(1,1) NOT NULL,
  Code CHAR(3) NOT NULL,
  Name VARCHAR(100) NOT NULL,
  ExchangeRate DECIMAL(18,6) NOT NULL,
  RateDate DATE NOT NULL,
  CONSTRAINT PK_Currency PRIMARY KEY(CurrencyID),
  CONSTRAINT UQ_Currency_Code UNIQUE(Code)
);

CREATE TABLE Customer(
  CustomerID INT IDENTITY(1,1) NOT NULL,
  FirstName VARCHAR(100) NOT NULL,
  MiddleName VARCHAR(100) NULL,
  LastName VARCHAR(100) NOT NULL,
  NationalID VARCHAR(50) NOT NULL,
  BirthDate DATE NOT NULL,
  Email VARCHAR(255) NULL,
  PhoneNumber VARCHAR(50) NULL,
  CreatedDate DATETIME NOT NULL,
  GenderID INT NOT NULL,
  AddressID INT NOT NULL,
  BranchID INT NOT NULL,
  CONSTRAINT PK_Customer PRIMARY KEY(CustomerID),
  CONSTRAINT UQ_Customer_NationalID UNIQUE(NationalID),
  CONSTRAINT FK_Customer_Gender FOREIGN KEY(GenderID) REFERENCES Gender(GenderID),
  CONSTRAINT FK_Customer_Address FOREIGN KEY(AddressID) REFERENCES Address(AddressID),
  CONSTRAINT FK_Customer_Branch FOREIGN KEY(BranchID) REFERENCES Branch(BranchID)
);

CREATE TABLE Employee(
  EmployeeID INT IDENTITY(1,1) NOT NULL,
  FirstName VARCHAR(100) NOT NULL,
  LastName VARCHAR(100) NOT NULL,
  BirthDate DATE NOT NULL,
  Email VARCHAR(255) NOT NULL,
  PhoneNumber VARCHAR(50) NULL,
  HireDate DATE NOT NULL,
  CreatedDate DATETIME NOT NULL,
  GenderID INT NOT NULL,
  BranchID INT NOT NULL,
  AddressID INT NOT NULL,
  EmployeeRoleID INT NOT NULL,
  ManagerID INT NULL,
  CONSTRAINT PK_Employee PRIMARY KEY(EmployeeID),
  CONSTRAINT FK_Employee_Gender FOREIGN KEY (GenderID) REFERENCES Gender(GenderID),
  CONSTRAINT FK_Employee_Branch FOREIGN KEY (BranchID) REFERENCES dbo.Branch(BranchID),
  CONSTRAINT FK_Employee_Address FOREIGN KEY(AddressID) REFERENCES Address(AddressID),
  CONSTRAINT FK_Employee_Role FOREIGN KEY(EmployeeRoleID) REFERENCES EmployeeRole(EmployeeRoleID),
  CONSTRAINT FK_Employee_Manager FOREIGN KEY(ManagerID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE Account(
  AccountID INT IDENTITY(1,1) NOT NULL,
  AccountNumber VARCHAR(50) NOT NULL,
  IBAN VARCHAR(34) NULL,
  SWIFTCode VARCHAR(20) NULL,
  Balance DECIMAL(18,2) NOT NULL,
  CreatedDate DATETIME NOT NULL,
  AccountTypeID INT NOT NULL,
  CurrencyID INT NOT NULL,
  CONSTRAINT PK_Account PRIMARY KEY(AccountID),
  CONSTRAINT UQ_Account_AccountNumber UNIQUE(AccountNumber),
  CONSTRAINT UQ_Account_IBAN UNIQUE(IBAN),
  CONSTRAINT FK_Account_Type FOREIGN KEY(AccountTypeID) REFERENCES AccountType(AccountTypeID),
  CONSTRAINT FK_Account_Currency FOREIGN KEY(CurrencyID) REFERENCES Currency(CurrencyID)
);

CREATE TABLE Disposition(
  DispositionID INT IDENTITY(1,1) NOT NULL,
  CustomerID INT NOT NULL,
  AccountID INT NOT NULL,
  DispositionRoleID INT NOT NULL,
  CONSTRAINT PK_Disposition PRIMARY KEY(DispositionID),
  CONSTRAINT FK_Disposition_Customer FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID),
  CONSTRAINT FK_Disposition_Account FOREIGN KEY(AccountID) REFERENCES Account(AccountID),
  CONSTRAINT FK_Disposition_Role FOREIGN KEY(DispositionRoleID) REFERENCES DispositionRole(DispositionRoleID)
);

CREATE TABLE SavingsAccountDetail(
  SavingsAccountID INT IDENTITY(1,1) NOT NULL,
  InterestRate DECIMAL(5,2) NOT NULL,
  MinimumBalance DECIMAL(18,2) NOT NULL,
  AccountID INT NOT NULL,
  CONSTRAINT PK_SavingsAccountDetail PRIMARY KEY(SavingsAccountID),
  CONSTRAINT UQ_SavingsDetail_Account UNIQUE(AccountID),
  CONSTRAINT FK_SavingsDetail_Account FOREIGN KEY(AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE Card(
  CardID INT IDENTITY(1,1) NOT NULL,
  CardNumber VARCHAR(19) NOT NULL,
  CVV CHAR(4) NOT NULL,
  IssuedDate DATE NOT NULL,
  ExpiryMonth TINYINT NOT NULL,
  ExpiryYear SMALLINT NOT NULL,
  CardTypeID INT NOT NULL,
  AccountID INT NOT NULL,
  CONSTRAINT PK_Card PRIMARY KEY(CardID),
  CONSTRAINT UQ_Card_CardNumber UNIQUE(CardNumber),
  CONSTRAINT FK_Card_Type FOREIGN KEY(CardTypeID) REFERENCES CardType(CardTypeID),
  CONSTRAINT FK_Card_Account FOREIGN KEY(AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE Merchant(
  MerchantID INT IDENTITY(1,1) NOT NULL,
  Name VARCHAR(200) NOT NULL,
  MerchantCategoryID INT NOT NULL,
  CONSTRAINT PK_Merchant PRIMARY KEY(MerchantID),
  CONSTRAINT FK_Merchant_Category FOREIGN KEY(MerchantCategoryID) REFERENCES MerchantCategory(MerchantCategoryID)
);

CREATE TABLE Payee(
  PayeeID INT IDENTITY(1,1) NOT NULL,
  Name VARCHAR(200) NOT NULL,
  AccountNumber VARCHAR(50) NULL,
  SWIFTCode VARCHAR(20) NULL,
  MerchantID INT NULL,
  CONSTRAINT PK_Payee PRIMARY KEY(PayeeID),
  CONSTRAINT FK_Payee_Merchant FOREIGN KEY(MerchantID) REFERENCES Merchant(MerchantID)
);

CREATE TABLE [Transaction](
  TransactionID BIGINT IDENTITY(1,1) NOT NULL,
  TransactionDate DATETIME NOT NULL,
  Amount DECIMAL(18,2) NOT NULL,
  Description VARCHAR(255) NULL,
  MerchantID INT NULL,
  PayeeID INT NULL,
  AccountID INT NOT NULL,
  TransactionTypeID INT NOT NULL,
  CurrencyID INT NOT NULL,
  CONSTRAINT PK_Transaction PRIMARY KEY(TransactionID),
  CONSTRAINT FK_Transaction_Merchant FOREIGN KEY(MerchantID) REFERENCES Merchant(MerchantID),
  CONSTRAINT FK_Transaction_Payee FOREIGN KEY(PayeeID) REFERENCES Payee(PayeeID),
  CONSTRAINT FK_Transaction_Account FOREIGN KEY(AccountID) REFERENCES Account(AccountID),
  CONSTRAINT FK_Transaction_Type FOREIGN KEY(TransactionTypeID) REFERENCES TransactionType(TransactionTypeID),
  CONSTRAINT FK_Transaction_Currency FOREIGN KEY(CurrencyID) REFERENCES Currency(CurrencyID)
);

CREATE TABLE CardTransaction(
  CardTransactionID BIGINT IDENTITY(1,1) NOT NULL,
  TransactionID BIGINT NOT NULL,
  CardID INT NOT NULL,
  PostedDate DATETIME NOT NULL,
  Amount DECIMAL(18,2) NOT NULL,
  MerchantID INT NOT NULL,
  CONSTRAINT PK_CardTransaction PRIMARY KEY(CardTransactionID),
  CONSTRAINT UQ_CardTransaction_TransactionID UNIQUE(TransactionID),
  CONSTRAINT FK_CardTransaction_Transaction FOREIGN KEY(TransactionID) REFERENCES [Transaction](TransactionID),
  CONSTRAINT FK_CardTransaction_Card FOREIGN KEY(CardID) REFERENCES Card(CardID),
  CONSTRAINT FK_CardTransaction_Merchant FOREIGN KEY(MerchantID) REFERENCES Merchant(MerchantID)
);

CREATE TABLE Loan(
  LoanID BIGINT IDENTITY(1,1) NOT NULL,
  PrincipalAmount DECIMAL(18,2) NOT NULL,
  InterestRate DECIMAL(5,2) NOT NULL,
  TermMonths INT NOT NULL,
  StartDate DATE NOT NULL,
  EmployeeID INT NOT NULL,
  CurrencyID INT NOT NULL,
  LoanTypeID INT NOT NULL,
  CONSTRAINT PK_Loan PRIMARY KEY(LoanID),
  CONSTRAINT FK_Loan_Employee FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID),
  CONSTRAINT FK_Loan_Currency FOREIGN KEY(CurrencyID) REFERENCES Currency(CurrencyID),
  CONSTRAINT FK_Loan_Type FOREIGN KEY(LoanTypeID) REFERENCES LoanType(LoanTypeID)
);

CREATE TABLE CustomerLoan(
  CustomerLoanID BIGINT IDENTITY(1,1) NOT NULL,
  CustomerID INT NOT NULL,
  LoanID BIGINT NOT NULL,
  CustomerLoanRoleID INT NOT NULL,
  CONSTRAINT PK_CustomerLoan PRIMARY KEY(CustomerLoanID),
  CONSTRAINT FK_CustomerLoan_Customer FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID),
  CONSTRAINT FK_CustomerLoan_Loan FOREIGN KEY(LoanID) REFERENCES Loan(LoanID),
  CONSTRAINT FK_CustomerLoan_Role FOREIGN KEY(CustomerLoanRoleID) REFERENCES CustomerLoanRole(CustomerLoanRoleID)
);

CREATE TABLE LoanPayment(
  LoanPaymentID BIGINT IDENTITY(1,1) NOT NULL,
  PaymentDate DATE NOT NULL,
  PaymentAmount DECIMAL(18,2) NOT NULL,
  RemainingBalance DECIMAL(18,2) NOT NULL,
  LoanID BIGINT NOT NULL,
  CONSTRAINT PK_LoanPayment PRIMARY KEY(LoanPaymentID),
  CONSTRAINT FK_LoanPayment_Loan FOREIGN KEY(LoanID) REFERENCES Loan(LoanID)
);
GO

/*Insert the fake-data, Generated with ChatGPT o3*/

INSERT INTO Gender (Name) VALUES ('Male'), ('Female');               
INSERT INTO AccountType (Name) VALUES ('Checking'), ('Savings');    
INSERT INTO Currency (Code, Name, ExchangeRate, RateDate)
VALUES ('SEK','Swedish Krona',1.000000,'2025-05-01');               
INSERT INTO DispositionRole (Name) VALUES ('Owner'), ('Viewer');    

DECLARE @CountryID INT,@RegionID INT,@CityID INT,@PostalCodeID INT;

INSERT Country (Name, ISOCode) VALUES ('Sweden','SWE');
SET @CountryID = SCOPE_IDENTITY();

INSERT Region (Name, CountryID) VALUES ('Stockholms län',@CountryID);
SET @RegionID = SCOPE_IDENTITY();

INSERT City (Name, RegionID) VALUES ('Stockholm',@RegionID);
SET @CityID = SCOPE_IDENTITY();

INSERT PostalCode (Code, CityID) VALUES ('11122',@CityID);
SET @PostalCodeID = SCOPE_IDENTITY();

DECLARE @BranchAddressID INT,@BranchID INT;

INSERT Address (Street,HouseNumber,PostalCodeID)
VALUES ('Hamngatan','4',@PostalCodeID);
SET @BranchAddressID = SCOPE_IDENTITY();

INSERT Branch (BranchName,CreatedDate,PhoneNumber,SWIFTCode,AddressID)
VALUES ('Kungsträdgården Branch','2020-01-15 09:00:00',
        '+46-8-12345600','KUNGSSE1',@BranchAddressID);
SET @BranchID = SCOPE_IDENTITY();

DECLARE @Cust TABLE (Seq INT IDENTITY(1,1), CustID INT);

DECLARE @AdrId INT;

DECLARE @tmp TABLE
(
  FirstName     NVARCHAR(50),
  MiddleName    NVARCHAR(50),
  LastName      NVARCHAR(50),
  NationalID    NVARCHAR(20),
  BirthDate     DATE,
  Email         NVARCHAR(100),
  PhoneNumber   NVARCHAR(30),
  GenderID      INT,
  Street        NVARCHAR(100),
  HouseNumber   NVARCHAR(20)
);

INSERT INTO @tmp VALUES
('Anna',   NULL,'Andersson','199001012345','1990-01-01','anna.andersson@example.se','+46-70-1111111',2,'Sveavägen','10'),
('Erik',   NULL,'Svensson','198812123456','1988-12-12','erik.svensson@example.se','+46-70-2222222',1,'Drottninggatan','15'),
('Maria', 'L.','Larsson','199505056789','1995-05-05',NULL,'+46-70-3333333',2,'Birger Jarlsgatan','33'),
('Johan',  NULL,'Karlsson','199203098765','1992-03-09','johan.karlsson@example.se',NULL,1,'Götgatan','84'),
('Elin',   NULL,'Nilsson','198707301234','1987-07-30','elin.nilsson@example.se','+46-70-4444444',2,'Kungsgatan','12'),
('Peter',  NULL,'Lindberg','197911111234','1979-11-11',NULL,'+46-70-5555555',1,'Fleminggatan','27'),
('Sara',  'M.','Björk','199812243210','1998-12-24','sara.bjork@example.se',NULL,2,'Norr Mälarstrand','56'),
('Daniel', NULL,'Holm','199404152468','1994-04-15','daniel.holm@example.se','+46-70-6666666',1,'Lilla Nygatan','3'),
('Linda',  NULL,'Berg','199306173579','1993-06-17','linda.berg@example.se','+46-70-7777777',2,'Bondegatan','22'),
('Markus', NULL,'Ek','198402280987','1984-02-28',NULL,'+46-70-8888888',1,'St Eriksgatan','89');

DECLARE @Seq INT = 0, @Tot INT;
SELECT @Tot = COUNT(*) FROM @tmp;

WHILE @Seq < @Tot
BEGIN
  SET @Seq = @Seq + 1;

  INSERT Address (Street,HouseNumber,PostalCodeID)
  SELECT Street,HouseNumber,@PostalCodeID
  FROM @tmp WHERE (SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1))) = @Seq;
  SET @AdrId = SCOPE_IDENTITY();

  INSERT Customer
        (FirstName,MiddleName,LastName,NationalID,BirthDate,Email,
         PhoneNumber,CreatedDate,GenderID,AddressID,BranchID)
  SELECT FirstName,MiddleName,LastName,NationalID,BirthDate,Email,
         PhoneNumber,FORMAT(GETDATE(),'yyyy-MM-dd HH:mm:ss'),
         GenderID,@AdrId,@BranchID
  FROM @tmp WHERE (SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1))) = @Seq;

  INSERT INTO @Cust(CustID) VALUES (SCOPE_IDENTITY());
END

DECLARE @Acc TABLE (Seq INT IDENTITY(1,1), AccID INT);

DECLARE @IBANPrefix NVARCHAR(34) = 'SE89500000000001984000000';

DECLARE @i INT=1;
WHILE @i <= 8
BEGIN
  INSERT Account (AccountNumber,IBAN,SWIFTCode,Balance,CreatedDate,AccountTypeID,CurrencyID)
  VALUES (FORMAT(1984000000+@i,'1984000000#'),
          @IBANPrefix + FORMAT(@i,'D2'),       
          'KUNGSSE1',
          CASE @i
             WHEN 1 THEN 25000.00
             WHEN 2 THEN 18000.00
             WHEN 3 THEN  9500.00
             WHEN 4 THEN 30500.00
             WHEN 5 THEN  6700.00
             WHEN 6 THEN 41200.00
             WHEN 7 THEN 12500.00
             ELSE            52300.00
          END,
          DATEADD(DAY, 30*(@i-1), '2023-06-01'),  
          CASE WHEN @i%2=1 THEN 1 ELSE 2 END,     
          1);
  INSERT INTO @Acc(AccID) VALUES (SCOPE_IDENTITY());
  SET @i = @i + 1;
END

INSERT Disposition (CustomerID, AccountID, DispositionRoleID)
SELECT c1.CustID, a1.AccID, 1
FROM @Cust c1
JOIN @Acc a1 ON c1.Seq = a1.Seq
WHERE c1.Seq BETWEEN 1 AND 7;

INSERT Disposition (CustomerID, AccountID, DispositionRoleID)
SELECT c.CustID, (SELECT AccID FROM @Acc WHERE Seq=8), 1
FROM @Cust c WHERE c.Seq IN (8,9);

INSERT Disposition (CustomerID, AccountID, DispositionRoleID)
SELECT (SELECT CustID FROM @Cust WHERE Seq=10),
       (SELECT AccID FROM @Acc  WHERE Seq=1),
       2;

GO

INSERT INTO CardType (Name)
SELECT 'Visa'
WHERE NOT EXISTS (SELECT 1 FROM CardType WHERE Name='Visa');

DECLARE @CardTypeVisa INT = (SELECT CardTypeID FROM CardType WHERE Name='Visa');

INSERT INTO TransactionType (Name)
SELECT 'Purchase'
WHERE NOT EXISTS (SELECT 1 FROM TransactionType WHERE Name='Purchase');

DECLARE @TranTypePurchase INT = (SELECT TransactionTypeID FROM TransactionType WHERE Name='Purchase');

INSERT INTO MerchantCategory (Name)
SELECT 'Electronics'
WHERE NOT EXISTS (SELECT 1 FROM MerchantCategory WHERE Name='Electronics');

DECLARE @MCCElectronics INT = (SELECT MerchantCategoryID FROM MerchantCategory WHERE Name='Electronics');

INSERT INTO Merchant (Name, MerchantCategoryID)
SELECT 'TechStore AB', @MCCElectronics
WHERE NOT EXISTS (SELECT 1 FROM Merchant WHERE Name='TechStore AB');

DECLARE @MerchantTech INT = (SELECT MerchantID FROM Merchant WHERE Name='TechStore AB');

-- 2.2  Resolve AccountIDs via Customer/Disposition
DECLARE
    @CustAnna   INT = (SELECT CustomerID FROM Customer WHERE FirstName='Anna'  AND LastName='Andersson'),
    @CustErik   INT = (SELECT CustomerID FROM Customer WHERE FirstName='Erik'  AND LastName='Svensson'),
    @CustLinda  INT = (SELECT CustomerID FROM Customer WHERE FirstName='Linda' AND LastName='Berg'),
    @CustDaniel INT = (SELECT CustomerID FROM Customer WHERE FirstName='Daniel' AND LastName='Holm');

DECLARE
    @AccAnna  INT = (SELECT AccountID FROM Disposition WHERE CustomerID=@CustAnna  AND DispositionRoleID=1),
    @AccErik  INT = (SELECT AccountID FROM Disposition WHERE CustomerID=@CustErik  AND DispositionRoleID=1),
    @AccJoint INT = (SELECT TOP 1 AccountID FROM Disposition WHERE CustomerID IN (@CustLinda,@CustDaniel) AND DispositionRoleID=1);

-- 2.3  Insert Cards
DECLARE @CardAnna INT, @CardErik INT, @CardJoint INT;

INSERT Card (CardNumber, CVV, IssuedDate, ExpiryMonth, ExpiryYear, CardTypeID, AccountID)
VALUES ('4111111111111111','123','2024-06-01',6,2027,@CardTypeVisa,@AccAnna);
SET @CardAnna = SCOPE_IDENTITY();

INSERT Card (CardNumber, CVV, IssuedDate, ExpiryMonth, ExpiryYear, CardTypeID, AccountID)
VALUES ('4111111111112222','456','2024-08-15',8,2028,@CardTypeVisa,@AccErik);
SET @CardErik = SCOPE_IDENTITY();

INSERT Card (CardNumber, CVV, IssuedDate, ExpiryMonth, ExpiryYear, CardTypeID, AccountID)
VALUES ('4111111111113333','789','2025-01-10',1,2029,@CardTypeVisa,@AccJoint);
SET @CardJoint = SCOPE_IDENTITY();

-- 2.4  Insert Transactions & CardTransactions
DECLARE @TranID BIGINT;

-- Anna's purchase
INSERT [Transaction] (TransactionDate, Amount, Description, MerchantID, AccountID,
                    TransactionTypeID, CurrencyID)
VALUES (DATEADD(MINUTE,-120,SYSDATETIME()), -699.00, 'Electronics purchase',
        @MerchantTech, @AccAnna, @TranTypePurchase, 1);
SET @TranID = SCOPE_IDENTITY();

INSERT CardTransaction (TransactionID, CardID, PostedDate, Amount, MerchantID)
VALUES (@TranID, @CardAnna, SYSDATETIME(), -699.00, @MerchantTech);

-- Erik's purchase
INSERT [Transaction] (TransactionDate, Amount, Description, MerchantID, AccountID,
                    TransactionTypeID, CurrencyID)
VALUES (DATEADD(DAY,-1,SYSDATETIME()), -1299.00, 'Laptop accessories',
        @MerchantTech, @AccErik, @TranTypePurchase, 1);
SET @TranID = SCOPE_IDENTITY();

INSERT CardTransaction (TransactionID, CardID, PostedDate, Amount, MerchantID)
VALUES (@TranID, @CardErik, SYSDATETIME(), -1299.00, @MerchantTech);

-- Purchase on joint account (Linda/Daniel)
INSERT [Transaction] (TransactionDate, Amount, Description, MerchantID, AccountID,
                    TransactionTypeID, CurrencyID)
VALUES (DATEADD(DAY,-3,SYSDATETIME()), -299.00, 'Headphones',
        @MerchantTech, @AccJoint, @TranTypePurchase, 1);
SET @TranID = SCOPE_IDENTITY();

INSERT CardTransaction (TransactionID, CardID, PostedDate, Amount, MerchantID)
VALUES (@TranID, @CardJoint, SYSDATETIME(), -299.00, @MerchantTech);

GO

/*Creating Views*/

CREATE OR ALTER VIEW dbo.vwCustomerOverview
AS
WITH CustAccounts AS (
    SELECT
        d.CustomerID,
        COUNT(DISTINCT d.AccountID)       AS NumAccounts,
        SUM(a.Balance)                    AS TotalBalanceSEK
    FROM dbo.Disposition d
    JOIN dbo.Account     a ON a.AccountID = d.AccountID
    GROUP BY d.CustomerID
)
SELECT
    c.CustomerID,
    CONCAT_WS(' ',
        c.FirstName,
        NULLIF(c.MiddleName,''),
        c.LastName
    )                                     AS FullName,
    g.Name                                AS Gender,
    c.BirthDate,
    c.Email,
    c.PhoneNumber,
    CONCAT_WS(', ',
        CONCAT(a.Street, ' ', a.HouseNumber),
        CONCAT(pc.Code, ' ', ci.Name)
    )                                     AS Address,
    b.BranchName,
    ca.NumAccounts,
    ca.TotalBalanceSEK
FROM dbo.Customer      c
JOIN dbo.Gender        g  ON g.GenderID        = c.GenderID
JOIN dbo.Address       a  ON a.AddressID       = c.AddressID
JOIN dbo.PostalCode    pc ON pc.PostalCodeID   = a.PostalCodeID
JOIN dbo.City          ci ON ci.CityID         = pc.CityID
JOIN dbo.Branch        b  ON b.BranchID        = c.BranchID
LEFT JOIN CustAccounts ca ON ca.CustomerID     = c.CustomerID;
GO


CREATE OR ALTER VIEW dbo.vwEmployeeHierarchy AS
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName,' ',e.LastName)      AS FullName,
    er.Name                                 AS Role,
    b.BranchName,
    CONCAT(m.FirstName,' ',m.LastName)      AS ManagerName
FROM Employee e
JOIN EmployeeRole er ON er.EmployeeRoleID = e.EmployeeRoleID
JOIN Branch       b  ON b.BranchID       = e.BranchID
LEFT JOIN Employee m ON m.EmployeeID     = e.ManagerID;

GO

INSERT INTO EmployeeRole (Name)
SELECT v.Name
FROM (VALUES
      ('Branch Manager'),
      ('Teller'),
      ('Loan Officer'),
      ('Customer Service'),
      ('IT Support')
) AS v(Name)
LEFT JOIN EmployeeRole er ON er.Name = v.Name
WHERE er.EmployeeRoleID IS NULL;

DECLARE
    @RoleMgr  INT = (SELECT EmployeeRoleID FROM EmployeeRole WHERE Name='Branch Manager'),
    @RoleTel  INT = (SELECT EmployeeRoleID FROM EmployeeRole WHERE Name='Teller'),
    @RoleLoan INT = (SELECT EmployeeRoleID FROM EmployeeRole WHERE Name='Loan Officer'),
    @RoleCS   INT = (SELECT EmployeeRoleID FROM EmployeeRole WHERE Name='Customer Service'),
    @RoleIT   INT = (SELECT EmployeeRoleID FROM EmployeeRole WHERE Name='IT Support');

-- 1.2  Reuse first PostalCode & Branch
DECLARE
    @PostalCodeID INT = (SELECT TOP 1 PostalCodeID FROM PostalCode ORDER BY PostalCodeID),
    @BranchID     INT = (SELECT TOP 1 BranchID     FROM Branch     WHERE BranchName='Kungsträdgården Branch');

DECLARE @AdrID INT, @MgrID INT;

-- 1.3  Manager: Karin Hansson (Female)
INSERT Address (Street, HouseNumber, PostalCodeID)
VALUES ('Regeringsgatan','45',@PostalCodeID);
SET @AdrID = SCOPE_IDENTITY();

INSERT Employee (FirstName, LastName, BirthDate, Email, PhoneNumber, HireDate, CreatedDate,
                 AddressID, EmployeeRoleID, ManagerID, GenderID, BranchID)
VALUES ('Karin','Hansson','1980-09-12','karin.hansson@bank.se','+46-8-900100',
        '2010-05-10', SYSDATETIME(),
        @AdrID, @RoleMgr, NULL, 2, @BranchID);
SET @MgrID = SCOPE_IDENTITY();

-- 1.4  Four direct reports
DECLARE @Staff TABLE
(
  FirstName NVARCHAR(50),
  LastName  NVARCHAR(50),
  BirthDate DATE,
  Email     NVARCHAR(100),
  Phone     NVARCHAR(30),
  GenderID  INT,
  RoleID    INT,
  Street    NVARCHAR(100),
  HouseNo   NVARCHAR(20)
);

INSERT INTO @Staff VALUES
('Lars',  'Persson',   '1992-02-25','lars.persson@bank.se',   '+46-8-900200',1,@RoleTel,'Hornsgatan','74'),
('Sofia', 'Bergström', '1994-07-18','sofia.bergstrom@bank.se','+46-8-900300',2,@RoleCS ,'Vasagatan','11'),
('Oskar', 'Lind',      '1988-05-02','oskar.lind@bank.se',     '+46-8-900400',1,@RoleLoan,'Östgötagatan','19'),
('Eva',   'Dahl',      '1990-11-30','eva.dahl@bank.se',       '+46-8-900500',2,@RoleIT ,'Hantverkargatan','62');

DECLARE @i INT = 0, @tot INT = (SELECT COUNT(*) FROM @Staff);

WHILE @i < @tot
BEGIN
    SET @i = @i + 1;

    DECLARE 
        @fn NVARCHAR(50), @ln NVARCHAR(50), @bd DATE,
        @em NVARCHAR(100), @ph NVARCHAR(30),
        @gen INT, @role INT, @st NVARCHAR(100), @no NVARCHAR(20);

    SELECT  @fn = FirstName, @ln = LastName, @bd = BirthDate,
            @em = Email,     @ph = Phone,
            @gen = GenderID, @role = RoleID,
            @st = Street,    @no = HouseNo
    FROM (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn, * FROM @Staff) x
    WHERE rn = @i;

    INSERT Address (Street, HouseNumber, PostalCodeID)
    VALUES (@st, @no, @PostalCodeID);
    SET @AdrID = SCOPE_IDENTITY();

    INSERT Employee (FirstName, LastName, BirthDate, Email, PhoneNumber, HireDate, CreatedDate,
                     AddressID, EmployeeRoleID, ManagerID, GenderID, BranchID)
    VALUES (@fn, @ln, @bd, @em, @ph,
            '2021-01-15', SYSDATETIME(),
            @AdrID, @role, @MgrID, @gen, @BranchID);
END

GO

CREATE OR ALTER VIEW dbo.vwCardTransactionDetail AS
SELECT
    t.TransactionID,
    t.TransactionDate,
    t.Amount,
    tt.Name                AS TransactionType,
    t.Description,
    cu.CustomerID,
    CONCAT(cu.FirstName,' ',cu.LastName) AS CustomerName,
    ac.AccountNumber,
    c.CardNumber,
    m.Name                                AS MerchantName
FROM CardTransaction ct
JOIN [Transaction]      t  ON t.TransactionID  = ct.TransactionID
JOIN Card             c  ON c.CardID         = ct.CardID
JOIN Account          ac ON ac.AccountID     = c.AccountID
JOIN Disposition      d  ON d.AccountID      = ac.AccountID AND d.DispositionRoleID = 1  -- Owner
JOIN Customer         cu ON cu.CustomerID    = d.CustomerID
JOIN Merchant         m  ON m.MerchantID     = ct.MerchantID
JOIN TransactionType  tt ON tt.TransactionTypeID = t.TransactionTypeID;
GO

SELECT * FROM dbo.vwCustomerOverview ORDER BY FullName;
SELECT * FROM dbo.vwEmployeeHierarchy;
SELECT * FROM dbo.vwCardTransactionDetail;

print 'Tack för att du installerar mitt bank-schema // Alex Bramstång'
