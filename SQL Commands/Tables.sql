
EXEC sp_msforeachtable 'drop table ?'

CREATE TABLE Address(
	AddressID INT NOT NULL,
	State NVARCHAR(255) NOT NULL,
	Country NVARCHAR(255) NOT NULL,
	Street NVARCHAR(255) NOT NULL,
	CONSTRAINT pk_AddressID PRIMARY KEY (AddressID)
);

CREATE TABLE Cinema (
	CinemaID INT NOT NULL,
	AddressID INT NOT NULL,
	CONSTRAINT pk_CinemaID PRIMARY KEY (CinemaID),
	CONSTRAINT fk_AddressID_Cinema FOREIGN KEY(AddressID) REFERENCES Address(AddressID)
);

CREATE TABLE Customer( 
	CustomerID INT NOT NULL, 
	CustomerName NVARCHAR(255) NOT NULL, 
	CustomerDOB DATE NOT NULL, 
	CustomerGender CHAR NOT NULL, 
	AddressID INT NOT NULL,
	CONSTRAINT pk_CustomerID PRIMARY KEY(CustomerID),
	CONSTRAINT fk_AddressID_Customer FOREIGN KEY(AddressID) REFERENCES Address(AddressID)
);

CREATE TABLE OnlineTransaction(
	OnlineTransactionID INT NOT NULL, 
	System NVARCHAR(255) NOT NULL, 
	Browser NVARCHAR(255) NOT NULL, 
	CONSTRAINT pk_OnlineTransactionID PRIMARY KEY(OnlineTransactionID)
);  

CREATE TABLE SalesTransaction( 
	SalesTransactionID INT NOT NULL, 
	SalesTransactionTotalPrice MONEY NOT NULL, 
	SalesTransactionDate DATE NOT NULL, 
	SalesTransactionTime TIME NOT NULL, 
	CONSTRAINT pk_SalesTransactionID PRIMARY KEY(SalesTransactionID)
); 

CREATE TABLE Promotion( 
	PromotionID INT NOT NULL, 
	PromotionDescription NVARCHAR(255) NOT NULL, 
	PromotionDiscount DECIMAL NOT NULL, 
	PromotionStartDate DATETIME NOT NULL, 
	PromotionEndDate DATETIME NOT NULL, 
	CONSTRAINT pk_PromotionID PRIMARY KEY(PromotionID)
); 

CREATE TABLE Movie( 
	MovieID INT NOT NULL, 
	MovieLanguage NVARCHAR(255) NOT NULL, 
	MovieCost MONEY NOT NULL, 
	MovieCountry NVARCHAR(255) NOT NULL, 
	MovieTitle NVARCHAR(255) NOT NULL, 
	MovieGenre NVARCHAR(255) NOT NULL, 
	CONSTRAINT pk_MovieID PRIMARY KEY(MovieID)
); 

CREATE TABLE Ticket(
	TicketID INT NOT NULL,
	Row NVARCHAR(255) NOT NULL, 
	Seat INT NOT NULL, 
	TicketPrice MONEY NOT NULL, 
	CONSTRAINT pk_TicketID PRIMARY KEY(TicketID)
);

CREATE TABLE Showing(
	ShowingID INT NOT NULL,
	ShowingDate DATE NOT NULL, 
	ShowingTIme TIME NOT NULL, 
	CONSTRAINT pk_ShowingID  PRIMARY KEY(ShowingID)
);

CREATE TABLE Hall(
	HallID INT NOT NULL,
	HallSize INT NOT NULL, 
	CONSTRAINT pk_HallID  PRIMARY KEY(HallID)
);

CREATE TABLE Person(
	PersonID INT NOT NULL,
	Name NVARCHAR(255) NOT NULL, 
	DOB DATE NOT NULL, 
	Gender CHAR NOT NULL,
	CONSTRAINT pk_PersonID PRIMARY KEY(PersonID)
);

CREATE TABLE Director(
	PersonID INT NOT NULL,
	MovieID INT NOT NULL,
	CONSTRAINT fk_PersonID_Director FOREIGN KEY(PersonID) REFERENCES Person(PersonID),
	CONSTRAINT fk_MovieID_Director FOREIGN KEY(MovieID) REFERENCES Movie(MovieID)
);

CREATE TABLE Star(
	PersonID INT NOT NULL,
	MovieID INT NOT NULL,
	CONSTRAINT fk_PersonID_Star FOREIGN KEY(PersonID) REFERENCES Person(PersonID),
	CONSTRAINT fk_MovieID_Star FOREIGN KEY(MovieID) REFERENCES Movie(MovieID)
);

CREATE TABLE SalesFT (
	SalesTransactionID INT NOT NULL,
	OnlineTransactionID INT,
	CustomerID INT NOT NULL,
	MovieID INT NOT NULL,
	CinemaID INT NOT NULL,
	PromotionID INT,
	ShowingID INT NOT NULL,
	HallID INT NOT NULL,
	TicketID INT NOT NULL,
	CONSTRAINT fk_SalesTransactionID FOREIGN KEY(SalesTransactionID) REFERENCES SalesTransaction(SalesTransactionID),
	CONSTRAINT fk_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID),
	CONSTRAINT fk_MovieID FOREIGN KEY(MovieID) REFERENCES Movie(MovieID),
	CONSTRAINT fk_PromotionID FOREIGN KEY(PromotionID) REFERENCES Promotion(PromotionID),
	CONSTRAINT fk_CinemaID FOREIGN KEY(CinemaID) REFERENCES Cinema(CinemaID),
	CONSTRAINT fk_ShowingID FOREIGN KEY(ShowingID) REFERENCES Showing(ShowingID),
	CONSTRAINT fk_HallID FOREIGN KEY(HallID) REFERENCES Hall(HallID),
	CONSTRAINT fk_TicketID FOREIGN KEY(TicketID) REFERENCES Ticket(TicketID),
	CONSTRAINT fk_OnlineTransactionID FOREIGN KEY(OnlineTransactionID) REFERENCES OnlineTransaction(OnlineTransactionID)
);

CREATE INDEX customer_CustomerGender ON Customer(CustomerGender);
CREATE INDEX customer_CustomerDOB ON Customer(CustomerDOB);

CREATE INDEX salestransaction_SalesTransactionDate ON SalesTransaction(SalesTransactionDate);

CREATE INDEX movie_MovieGenre ON Movie(MovieGenre);

CREATE INDEX showing_ShowingDate ON Showing(ShowingDate);
CREATE INDEX showing_ShowingTime ON Showing(ShowingTime);

CREATE INDEX promotion_PromotionDescription ON Promotion(PromotionDescription);

CREATE INDEX address_State ON [Address]([State]);

CREATE INDEX person_Name ON Person(Name);

CREATE INDEX hall_HallSize ON Hall(HallSize);



