USE School_Cafeteria;
GO

DROP TABLE IF EXISTS Order_Details;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Cafe_Employees_Phone;
DROP TABLE IF EXISTS Students_Phone;
DROP TABLE IF EXISTS Menu_Items;
DROP TABLE IF EXISTS Cafe_Employees;
DROP TABLE IF EXISTS Students;
GO

CREATE TABLE Students(
    Student_ID   INT           IDENTITY(1,1) NOT NULL,
    Name         VARCHAR(100)  NOT NULL,
    Class        VARCHAR(10)   NULL,
    Grade_Level  VARCHAR(20)   NOT NULL,
    CONSTRAINT PK_Students PRIMARY KEY (Student_ID)
) ON [PRIMARY];
GO

CREATE TABLE Cafe_Employees(
    Emp_ID     INT           IDENTITY(1,1) NOT NULL,
    Name       VARCHAR(100)  NOT NULL,
    Hire_Date  DATE          NOT NULL CONSTRAINT DF_Cafe_Employees_Hire_Date DEFAULT (GETDATE()),
    Job_Title  VARCHAR(30)   NOT NULL,
    CONSTRAINT PK_Cafe_Employees PRIMARY KEY (Emp_ID),
    CONSTRAINT CK_Cafe_Employees_Job_Title
        CHECK (Job_Title IN ('Cashier', 'Cook', 'Manager'))
) ON [PRIMARY];
GO

CREATE TABLE Menu_Items(
    Item_ID   INT           IDENTITY(1,1) NOT NULL,
    Name      VARCHAR(80)   NOT NULL,
    Category  VARCHAR(20)   NOT NULL,
    Price     DECIMAL(6,2)  NOT NULL,
    Quantity  INT           NOT NULL CONSTRAINT DF_Menu_Items_Quantity DEFAULT (0),
    CONSTRAINT PK_Menu_Items PRIMARY KEY (Item_ID),
    CONSTRAINT UQ_Menu_Items_Name UNIQUE (Name),
    CONSTRAINT CK_Menu_Items_Category
        CHECK (Category IN ('Meal', 'Snack', 'Drink', 'Dessert')),
    CONSTRAINT CK_Menu_Items_Price    CHECK (Price > 0),
    CONSTRAINT CK_Menu_Items_Quantity CHECK (Quantity >= 0)
) ON [PRIMARY];
GO

CREATE TABLE Students_Phone(
    Student_ID    INT          NOT NULL,
    Phone_Number  VARCHAR(15)  NOT NULL,
    CONSTRAINT PK_Students_Phone PRIMARY KEY (Student_ID, Phone_Number),
    CONSTRAINT FK_Students_Phone_Students FOREIGN KEY (Student_ID)
        REFERENCES Students (Student_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ON [fg2];
GO

CREATE TABLE Cafe_Employees_Phone(
    Emp_ID        INT          NOT NULL,
    Phone_Number  VARCHAR(15)  NOT NULL,
    CONSTRAINT PK_Cafe_Employees_Phone PRIMARY KEY (Emp_ID, Phone_Number),
    CONSTRAINT UQ_Cafe_Employees_Phone_Number UNIQUE (Phone_Number),
    CONSTRAINT FK_Cafe_Employees_Phone_Cafe_Employees FOREIGN KEY (Emp_ID)
        REFERENCES Cafe_Employees (Emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ON [fg2];
GO

CREATE TABLE Orders(
    Order_ID        INT          IDENTITY(1,1) NOT NULL,
    Payment_Method  VARCHAR(10)  NOT NULL CONSTRAINT DF_Orders_Payment_Method DEFAULT ('Cash'),
    Date_Time       DATETIME     NOT NULL CONSTRAINT DF_Orders_Date_Time DEFAULT (GETDATE()),
    Student_ID      INT          NOT NULL,
    Emp_ID          INT          NOT NULL,
    CONSTRAINT PK_Orders PRIMARY KEY (Order_ID),
    CONSTRAINT CK_Orders_Payment_Method
        CHECK (Payment_Method IN ('Cash', 'Wallet')),
    CONSTRAINT FK_Orders_Students FOREIGN KEY (Student_ID)
        REFERENCES Students (Student_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_Orders_Cafe_Employees FOREIGN KEY (Emp_ID)
        REFERENCES Cafe_Employees (Emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ON [fg3];
GO

CREATE TABLE Order_Details(
    Order_ID         INT           NOT NULL,
    Item_ID          INT           NOT NULL,
    Current_Price    DECIMAL(6,2)  NOT NULL,
    Quantity_Needed  INT           NOT NULL,
    CONSTRAINT PK_Order_Details PRIMARY KEY (Order_ID, Item_ID),
    CONSTRAINT CK_Order_Details_Current_Price   CHECK (Current_Price > 0),
    CONSTRAINT CK_Order_Details_Quantity_Needed CHECK (Quantity_Needed >= 1),
    CONSTRAINT FK_Order_Details_Orders FOREIGN KEY (Order_ID)
        REFERENCES Orders (Order_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_Order_Details_Menu_Items FOREIGN KEY (Item_ID)
        REFERENCES Menu_Items (Item_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ON [fg3];
GO