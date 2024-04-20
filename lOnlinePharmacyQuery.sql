-- Drop constraints for Medications_in_Prescription
ALTER TABLE Medications_in_Prescription DROP CONSTRAINT Fk_Medications_in_Prescription_Med_ID;
ALTER TABLE Medications_in_Prescription DROP CONSTRAINT Fk_Medications_in_Prescription_Pres_ID;

-- Drop constraints for Order_Detail
ALTER TABLE Order_Detail DROP CONSTRAINT Fk_Order_Detail_Order_ID;
ALTER TABLE Order_Detail DROP CONSTRAINT Fk_Order_Detail_Prod_ID;
ALTER TABLE Order_Detail DROP CONSTRAINT Fk_Order_Detail_Pharmacy_ID;

-- Drop constraints for Delivery_Service
ALTER TABLE Delivery_Service DROP CONSTRAINT Fk_Delivery_Service_Order_ID;
ALTER TABLE Delivery_Service DROP CONSTRAINT Fk_Delivery_Service_Courier_ID;

-- Drop constraints for Order table
ALTER TABLE [Order] DROP CONSTRAINT Fk_Order_Pat_ID;

-- Drop constraints for Prescription table
ALTER TABLE Prescription DROP CONSTRAINT Fk_Prescription_Dr_ID;
ALTER TABLE Prescription DROP CONSTRAINT Fk_Prescription_Pat_ID;

-- Drop constraints for Medication table
ALTER TABLE Medication DROP CONSTRAINT Fk_Medication_Prod_ID;

-- Drop constraints for Product table
ALTER TABLE Product DROP CONSTRAINT Fk_Product_Categoty_ID;


-- Drop the tables

DROP TABLE Medications_in_Prescription;
DROP TABLE Order_Detail;
DROP TABLE Delivery_Service;
DROP TABLE [Order];
DROP TABLE Courier;
DROP TABLE Prescription;
DROP TABLE Medication;
DROP TABLE Product;
DROP TABLE Category;
DROP TABLE Pharmacy;
DROP TABLE Doctor;
DROP TABLE Patient;
DROP TABLE Payment_Transaction;

---------- CREATING TABLE AND CONSTRAINTS ----------

CREATE DATABASE OnlinePharmacyDatabase
USE OnlinePharmacyDatabase

CREATE TABLE Patient
(
Pat_ID INT NOT NULL,
Pat_First_Name VARCHAR(50) NOT NULL,
Pat_Last_Name VARCHAR(50) NOT NULL,
Pat_Email VARCHAR(100) NOT NULL,
Pat_Phone_Num CHAR(10) NOT NULL,
Pat_Shipping_Adress VARCHAR(255) NOT NULL,
Pat_Billing_Adress VARCHAR(255) NOT NULL,
Pat_DoB DATE NOT NULL,

CONSTRAINT Pk_Pat_ID PRIMARY KEY (Pat_ID),
CONSTRAINT UQ_Pat_Email UNIQUE(Pat_Email),
CONSTRAINT UQ_Pat_Phone_Num UNIQUE (Pat_Phone_Num)
)

CREATE TABLE Doctor
(
Dr_ID INT NOT NULL,
Dr_First_Name VARCHAR(50) NOT NULL,
Dr_Last_Name VARCHAR(50) NOT NULL,
Dr_LicenceNumber VARCHAR(20) NOT NULL,
Dr_Specialzation VARCHAR(50) NOT NULL,

CONSTRAINT Pk_Dr_ID PRIMARY KEY (Dr_ID),
CONSTRAINT UQ_Dr_LicenceNumber UNIQUE (Dr_LicenceNumber)
)

CREATE TABLE Pharmacy
(
Pharmacy_ID INT NOT NULL,
Pharmacy_Name VARCHAR(50) NOT NULL,
Pharmacy_Email VARCHAR(100) NOT NULL,
Pharmacy_Phone_Num CHAR(10) NOT NULL,
Pharmacy_Address VARCHAR(255) NOT NULL,

CONSTRAINT Pk_Pharmacy_ID PRIMARY KEY (Pharmacy_ID),
CONSTRAINT UQ_Pharmacy_Email UNIQUE (Pharmacy_Email),
CONSTRAINT UQ_Pharmacy_Phone_Num UNIQUE (Pharmacy_Phone_Num)
)

CREATE TABLE Category
(
Category_ID	SMALLINT NOT NULL,
Category_Name VARCHAR(50) NOT NULL,

CONSTRAINT Pk_Category_ID PRIMARY KEY (Category_ID),
CONSTRAINT UQ_Category_Name UNIQUE (Category_Name)
)

CREATE TABLE Product
(
Prod_ID	INT NOT NULL,
Product_Category_ID SMALLINT NOT NULL,
Prod_Name VARCHAR(50) NOT NULL,
Prod_Description VARCHAR(255) NOT NULL,
Prod_Price DECIMAL(8, 2) NOT NULL,
Prod_StockQuantity INT NOT NULL,
Prod_Manufacturer VARCHAR(100) NOT NULL,

CONSTRAINT Pk_Prod_ID PRIMARY KEY(Prod_ID),
CONSTRAINT Fk_Product_Categoty_ID FOREIGN KEY (Product_Category_ID) REFERENCES Category(Category_ID)
)

CREATE TABLE Medication
(
Med_ID INT NOT NULL,
Medication_Prod_ID INT NOT NULL,
Exp_Date DATE NOT NULL,
Pres_Required BIT NOT NULL,

CONSTRAINT Pk_Med_ID PRIMARY KEY (Med_ID),
CONSTRAINT Fk_Medication_Prod_ID FOREIGN KEY (Medication_Prod_ID) REFERENCES Product(Prod_ID)
)

CREATE TABLE Prescription
(
Pres_ID	INT NOT NULL,
Prescription_Dr_ID INT NOT NULL,
Prescription_Pat_ID INT NOT NULL,
Pres_IssueDate DATE NOT NULL,
Pres_ExpirationDate DATE NOT NULL,

CONSTRAINT Pk_Pres_ID PRIMARY KEY (Pres_ID),
CONSTRAINT Fk_Prescription_Dr_ID FOREIGN KEY (Prescription_Dr_ID) REFERENCES Doctor(Dr_ID),
CONSTRAINT Fk_Prescription_Pat_ID FOREIGN KEY (Prescription_Pat_ID) REFERENCES Patient(Pat_ID)
)

CREATE TABLE Courier
(
Courier_ID INT NOT NULL,
Courier_Name VARCHAR(50) NOT NULL,
Courier_Last_Name VARCHAR(50) NOT NULL,
Courier_Phone CHAR(10) NOT NULL,
Courier_Email VARCHAR(100) NOT NULL,

CONSTRAINT Pk_Courier_ID PRIMARY KEY (Courier_ID),
CONSTRAINT UQ_Courier_Phone UNIQUE (Courier_Phone),
CONSTRAINT UQ_Courier_Email UNIQUE (Courier_Email)
)

CREATE TABLE Payment_Transaction
(
Pay_Transaction_ID INT  NOT NULL,
Pay_Method VARCHAR(50) NOT NULL,
Pay_TotalAmount DECIMAL(8, 2) NOT NULL,
Pay_TransactionDate DATE NOT NULL,
Pay_TransactionStatus VARCHAR(50) NOT NULL,

CONSTRAINT Pk_Pay_Transaction_ID PRIMARY KEY( Pay_Transaction_ID ),
-- Drop foreign key constraints on Payment_Transaction table
)

CREATE TABLE [Order]
(
Order_ID INT NOT NULL,
Order_Pat_ID INT NOT NULL,
Order_Pay_Transaction_ID INT NOT NULL,
Total_Order_Amount DECIMAL(8, 2) NOT NULL,
Order_Delivery_Adress VARCHAR(255) NOT NULL,
Order_Status VARCHAR(50) NOT NULL,
Order_Date DATE NOT NULL,
Delivery_Fee DECIMAL(5, 2) NOT NULL,

CONSTRAINT Pk_Order_ID PRIMARY KEY (Order_ID),
CONSTRAINT Fk_Order_Pat_ID FOREIGN KEY (Order_Pat_ID) REFERENCES Patient(Pat_ID),
CONSTRAINT Fk_Order_Pay_Transaction_ID FOREIGN KEY (Order_Pay_Transaction_ID) REFERENCES Payment_Transaction(Pay_Transaction_ID)
)

CREATE TABLE Delivery_Service
(
Delivery_ID INT NOT NULL,
Delivery_Service_Order_ID INT NOT NULL,
Delivery_Service_Courier_ID INT NOT NULL,
Delivery_Status VARCHAR(50) NOT NULL,
Contact_Info VARCHAR(255) NOT NULL,
Tracking_Num VARCHAR(50) NOT NULL,
Delivery_Method VARCHAR(50) NOT NULL,
Est_Delivery_Date DATE NOT NULL,
Act_Delivery_Date DATE NOT NULL,

CONSTRAINT Pk_Delivery_ID PRIMARY KEY (Delivery_ID),
CONSTRAINT Fk_Delivery_Service_Order_ID FOREIGN KEY(Delivery_Service_Order_ID) REFERENCES [Order](Order_ID),
CONSTRAINT Fk_Delivery_Service_Courier_ID FOREIGN KEY(Delivery_Service_Courier_ID) REFERENCES Courier(Courier_ID)
)

CREATE TABLE Order_Detail
(
Order_DetaiL_ID	INT NOT NULL,
Order_Detail_Order_ID INT NOT NULL,
Order_Detail_Prod_ID INT NOT NULL,
Order_Detail_Pharmacy_ID INT NOT NULL,
Quantity SMALLINT NOT NULL,
Sub_Total INT NOT NULL,

CONSTRAINT Pk_Order_Detail_ID PRIMARY KEY(Order_Detail_ID),
CONSTRAINT Fk_Order_Detail_Order_ID FOREIGN KEY (Order_Detail_Order_ID) REFERENCES [Order](Order_ID),
CONSTRAINT Fk_Order_Detail_Prod_ID FOREIGN KEY (Order_Detail_Prod_ID) REFERENCES [Product](Prod_ID),
CONSTRAINT Fk_Order_Detail_Pharmacy_ID FOREIGN KEY (Order_Detail_Pharmacy_ID) REFERENCES [Pharmacy](Pharmacy_ID)
)

CREATE TABLE Medications_in_Prescription
(
Med_in_Pres_ID INT NOT NULL,
Medications_in_Prescription_Med_ID INT NOT NULL,
Medications_in_Prescription_Pres_ID	INT NOT NULL,
Med_Quantity SMALLINT NOT NULL,

CONSTRAINT Pk_Med_in_Pres_ID PRIMARY KEY(Med_in_Pres_ID),
CONSTRAINT Fk_Medications_in_Prescription_Med_ID FOREIGN KEY(Medications_in_Prescription_Med_ID) REFERENCES Medication(Med_ID),
CONSTRAINT Fk_Medications_in_Prescription_Pres_ID FOREIGN KEY(Medications_in_Prescription_Pres_ID) REFERENCES Prescription(Pres_ID)
)

---------- INSERT QUERIES ----------

-- DELETE 
DELETE FROM Patient

-- INSERT INTO Patient
INSERT Patient (Pat_ID, Pat_First_Name, Pat_Last_Name, Pat_Email, Pat_Phone_Num, Pat_Shipping_Adress, Pat_Billing_Adress, Pat_DoB)
VALUES 
(1, 'Alexander','Smith','alexander.smith@example.com', '5551234567', '123 Main St', '456 Billing St', '1980-05-15'),
(2, 'Isabella', 'Johnson','isabella.johnson@example.com','5559876543', '789 Oak St', '321 Billing St', '1992-08-27'),
(3, 'Sebastian', 'Martinez', 'sebastian.martinez@example.com', '5552346127', '456 Pine St', '654 Billing St', '1975-03-10'),
(4, 'Sophia', 'Kim', 'sophia.kim@example.com', '5558765652', '789 Elm St', '987 Billing St', '1988-11-22'),
(5, 'Elijah', 'Davis', 'elijah.davis@example.com', '5553454621', '123 Cedar St', '876 Billing St', '1995-07-01'),
(6, 'Ava', 'Wilson', 'ava.wilson@example.com', '5552344177', '456 Maple St', '765 Billing St', '1983-09-14'),
(7, 'Liam', 'Garcia', 'liam.garcia@example.com', '5559878453', '789 Birch St', '654 Billing St', '1978-02-18'),
(8, 'Olivia', 'Rodriguez', 'olivia.rodriguez@example.com', '5558765432', '123 Walnut St', '543 Billing St', '1990-04-03'),
(9, 'Noah', 'Hernandez', 'noah.hernandez@example.com', '5553456789', '456 Cherry St', '432 Billing St', '1987-06-26'),
(10, 'Emma', 'Lee', 'emma.lee@example.com','5552345678', '789 Pine St', '321 Billing St', '1970-12-09'),
(11, 'Lillian', 'Allen', 'lillian.allen@example.com', '5551112233', '789 Oak St', '456 Billing St', '1991-03-25'),
(12, 'Henry', 'Ward', 'henry.ward@example.com', '5552223344', '456 Pine St', '654 Billing St', '1982-06-18'),
(13, 'Grace', 'Cooper', 'grace.cooper@example.com', '5553334455', '123 Cedar St', '876 Billing St', '1985-09-12'),
(14, 'Jackson', 'Watson', 'jackson.watson@example.com', '5554445566', '789 Elm St', '987 Billing St', '1979-12-05'),
(15, 'Avery', 'Fisher', 'avery.fisher@example.com', '5555556677', '123 Maple St', '321 Billing St', '1993-01-29');

-- DELETE 
DELETE FROM Doctor

-- INSERT INTO Doctor
INSERT Doctor (Dr_ID, Dr_First_Name, Dr_Last_Name, Dr_LicenceNumber, Dr_Specialzation)
VALUES 
(1, 'Dr. Emily', 'Jones', '12345', 'Cardiology'),
(2, 'Dr. Michael', 'Williams', '67890', 'Oncology'),
(3, 'Dr. Sarah', 'Clark', '54321', 'Pediatrics'),
(4, 'Dr. Matthew', 'Anderson', '98765', 'Orthopedics'),
(5, 'Dr. Jessica', 'Wilson', '13579', 'Neurology'),
(6, 'Dr. Brian', 'Taylor', '24680', 'Dermatology'),
(7, 'Dr. Lauren', 'Miller', '57916', 'Ophthalmology'),
(8, 'Dr. Christopher', 'White', '87494', 'ENT'),
(9, 'Dr. Olivia', 'Moore', '23456', 'Gastroenterology'),
(10, 'Dr. Ethan', 'Johnson', '87654', 'Psychiatry'),
(11, 'Dr. Sophia', 'Brown', '67891', 'Cardiology'),
(12, 'Dr. Oliver', 'Hill', '23756', 'Dermatology'),
(13, 'Dr. Emma', 'Smith', '98175', 'Pediatrics'),
(14, 'Dr. Ethan', 'Davis', '43210', 'Orthopedics'),
(15, 'Dr. Mia', 'Lopez', '87398', 'Psychiatry');

-- DELETE
DELETE FROM Pharmacy

-- INSERT INTO Pharmacy
INSERT Pharmacy (Pharmacy_ID, Pharmacy_Name, Pharmacy_Email, Pharmacy_Phone_Num, Pharmacy_Address)
VALUES 
(1, 'HealthCare Pharmacy', 'info@healthcarepharmacy.com', '5551112233', '456 Wellness St'),
(2, 'QuickMeds', 'info@quickmeds.com', '5552223344', '789 Fast Lane'),
(3, 'FamilyPharma', 'info@familypharma.com', '5553374105', '123 Harmony St'),
(4, 'CityCure Pharmacy', 'info@citycurepharmacy.com', '5554445446', '789 Metro St'),
(5, 'Sunshine Pharmacy', 'info@sunshinepharmacy.com', '5555559630', '456 Sunny St'),
(6, 'GreenLeaf Pharmacy', 'info@greenleafpharmacy.com', '5556667788', '123 Nature St'),
(7, 'CarePlus Pharmacy', 'info@carepluspharmacy.com', '5557778899', '789 Health St'),
(8, 'UrbanMeds', 'info@urbanmeds.com', '5558889900', '456 City St'),
(9, 'WellBeing Pharmacy', 'info@wellbeingpharmacy.com', '5559990011', '123 Harmony St'),
(10, 'EcoCure Pharmacy', 'info@ecocurepharmacy.com', '5550001122', '789 Green St'),
(11, 'CityHealth Pharmacy', 'info@cityhealthpharmacy.com', '5551146537', '456 City St'),
(12, 'MediFast', 'info@medifast.com', '5552227701', '789 Speedy Lane'),
(13, 'HappyFamily Pharmacy', 'info@happyfamilypharmacy.com', '5553334455', '123 Harmony St'),
(14, 'UrbanCure Pharmacy', 'info@urbancurepharmacy.com', '5554445566', '789 Downtown St'),
(15, 'NatureMeds', 'info@naturemeds.com', '5555556677', '456 Green St');

-- DELETE 
DELETE FROM Category

-- INSERT INTO Category
INSERT Category (Category_ID, Category_Name)
VALUES 
(1, 'Pain Relief'),
(2, 'Antibiotics'),
(3, 'Vitamins'),
(4, 'Digestive Health'),
(5, 'Skin Care'),
(6, 'Allergy'),
(7, 'Diabetes'),
(8, 'Respiratory Health'),
(9, 'Eye Care'),
(10, 'Weight Loss'),
(11, 'Cough and Cold'),
(12, 'Digestive Aids'),
(13, 'Antiseptics'),
(14, 'Blood Pressure'),
(15, 'Diet and Nutrition');

-- DELETE
DELETE FROM Product

-- INSERT INTO Product
INSERT Product (Prod_ID, Product_Category_ID, Prod_Name, Prod_Description, Prod_Price, Prod_StockQuantity, Prod_Manufacturer)
VALUES 
(1, 3, 'Multivitamin Tablets', 'A daily supplement for overall health', 15.99, 200, 'HealthyLife Labs'),
(2, 2, 'Amoxicillin Capsules', 'Antibiotic for bacterial infections', 29.99, 150, 'MedPharm Co.'),
(3, 7, 'Insulin Pen', 'For managing diabetes', 49.99, 100, 'DiabetesCare Inc.'),
(4, 5, 'Moisturizing Cream', 'Hydrates and nourishes the skin', 12.99, 300, 'SkinWell Ltd.'),
(5, 1, 'Ibuprofen Tablets', 'Relieves pain and reduces inflammation', 9.99, 250, 'PainFree Pharmaceuticals'),
(6, 8, 'Inhaler for Asthma', 'For respiratory relief', 19.99, 120, 'BreathEasy Corp.'),
(7, 4, 'Probiotic Capsules', 'Promotes digestive health', 24.99, 180, 'GutGuard Labs'),
(8, 10, 'Allergy Relief Syrup', 'Relieves allergy symptoms', 14.99, 180, 'ClearAir Pharmaceuticals'),
(9, 6, 'Acne Cleanser', 'Clears acne and prevents breakouts', 17.99, 150, 'ClearSkin Inc.'),
(10, 9, 'Eye Drops', 'Relieves dry and irritated eyes', 8.99, 200, 'EyeCare Solutions'),
(11, 4, 'Blood Pressure Monitor', 'Measures and records blood pressure', 49.99, 80, 'HealthGuard Ltd.'),
(12, 1, 'Cold Relief Tablets', 'Provides relief from cold symptoms', 12.99, 120, 'ColdCare Inc.'),
(13, 2, 'Digestive Enzyme Capsules', 'Aids in digestion', 16.99, 150, 'DigestWell Pharmaceuticals'),
(14, 3, 'Antiseptic Solution', 'Cleans and disinfects wounds', 8.99, 200, 'SafeGuard Labs'),
(15, 5, 'Multivitamin Gummies', 'Tasty gummies for essential nutrients', 19.99, 100, 'NutriJoy');

-- DELETE
DELETE FROM Courier

-- INSERT INTO Courier
INSERT Courier (Courier_ID, Courier_Name, Courier_Last_Name, Courier_Phone, Courier_Email)
VALUES 
(1, 'CourierJohn', 'Doe', '5551112233', 'john.doe.courier@example.com'),
(2, 'CourierAlice', 'Smith', '5552223344', 'alice.smith.courier@example.com'),
(3, 'CourierRobert', 'Johnson', '5553334455', 'robert.johnson.courier@example.com'),
(4, 'CourierEmma', 'White', '5554444716', 'emma.white.courier@example.com'),
(5, 'CourierDaniel', 'Brown', '5555556489', 'daniel.brown.courier@example.com'),
(6, 'CourierOlivia', 'Taylor', '5556667788', 'olivia.taylor.courier@example.com'),
(7, 'CourierEthan', 'Miller', '5557778899', 'ethan.miller.courier@example.com'),
(8, 'CourierSophia', 'Jones', '5558889900', 'sophia.jones.courier@example.com'),
(9, 'CourierAiden', 'Davis', '5559990011', 'aiden.davis.courier@example.com'),
(10, 'CourierMia', 'Moore', '5550001122', 'mia.moore.courier@example.com'),
(11, 'CourierSophie', 'Johnson', '5551340928', 'sophie.johnson.courier@example.com'),
(12, 'CourierLogan', 'Wright', '5552221489', 'logan.wright.courier@example.com'),
(13, 'CourierEva', 'Russell', '5553336323', 'eva.russell.courier@example.com'),
(14, 'CourierLucas', 'Baker', '5554445566', 'lucas.baker.courier@example.com'),
(15, 'CourierChloe', 'Lopez', '5555556677', 'chloe.lopez.courier@example.com');

-- DELETE 
DELETE FROM Medication

-- INSERT INTO Medication
INSERT Medication (Med_ID ,Medication_Prod_ID, Exp_Date, Pres_Required)
VALUES 
(1,1, '2024-12-31',0),
(2,2, '2023-08-15',1),
(3,3, '2025-05-20',0),
(4,4, '2023-11-30',0),
(5,5, '2024-06-25',1),
(6,6, '2024-09-10',0),
(7,7, '2025-03-18',1),
(8,8, '2024-12-05',1),
(9,9, '2023-10-15',1),
(10,10, '2024-05-02',0),
(11, 11, '2025-02-28', 0),
(12, 12, '2024-10-15', 1),
(13, 13, '2025-07-20', 0),
(14, 14, '2024-05-30', 1),
(15, 15, '2024-12-10', 0);

-- DELETE
DELETE FROM Prescription

-- INSERT INTO Prescription
INSERT Prescription (Pres_ID, Prescription_Dr_ID, Prescription_Pat_ID, Pres_IssueDate, Pres_ExpirationDate)
VALUES 
(1, 1, 1, '2024-01-15', '2024-02-15'),
(2, 2, 2, '2024-02-01', '2024-03-01'),
(3, 3, 3, '2024-02-10', '2024-03-10'),
(4, 4, 4, '2023-12-20', '2024-01-20'),
(5, 5, 5, '2024-01-05', '2024-02-05'),
(6, 6, 6, '2024-03-02', '2024-04-02'),
(7, 7, 7, '2023-11-25', '2023-12-25'),
(8, 8, 8, '2024-02-15', '2024-03-15'),
(9, 9, 9, '2023-12-10', '2024-01-10'),
(10, 10, 10, '2024-01-20', '2024-02-20'),
(11, 11, 11, '2024-03-15', '2024-04-15'),
(12, 12, 12, '2024-04-01', '2024-05-01'),
(13, 13, 13, '2024-04-10', '2024-05-10'),
(14, 14, 14, '2024-02-20', '2024-03-20'),
(15, 15, 15, '2024-03-05', '2024-04-05');

-- DELETE FROM
DELETE FROM Payment_Transaction

-- INSERT INTO Payment_Transaction
INSERT INTO Payment_Transaction (Pay_Transaction_ID, Pay_Method, Pay_TotalAmount, Pay_TransactionDate, Pay_TransactionStatus)
VALUES 
(1, 'Credit Card', 31.98, '2024-02-01', 'Success'),
(2, 'PayPal', 89.97, '2024-02-02', 'Success'),
(3, 'Debit Card', 72.25, '2024-02-03', 'Success'),
(4, 'Bank Transfer', 115.96, '2024-02-04', 'Success'),
(5, 'Credit Card', 19.98, '2024-02-05', 'Success'),
(6, 'PayPal', 39.99, '2024-02-06', 'Success'),
(7, 'Debit Card', 64.50, '2024-02-07', 'Success'),
(8, 'Bank Transfer', 138.50, '2024-02-08', 'Success'),
(9, 'Credit Card', 424.00, '2024-02-09', 'Success'),
(10, 'PayPal', 29.95, '2024-02-10', 'Success'),
(11, 'Credit Card', 35.00, '2024-04-01', 'Success'),
(12, 'PayPal', 92.50, '2024-04-02', 'Success'),
(13, 'Debit Card', 68.75, '2024-04-03', 'Success'),
(14, 'Credit Card', 24.99, '2024-04-04', 'Failed'),
(15, 'PayPal', 19.99, '2024-04-05', 'Success');

-- DELETE 
DELETE FROM [Order]

-- INSERT INTO [Order]
INSERT INTO [Order] (Order_ID,Order_Pat_ID, Order_Pay_Transaction_ID, Total_Order_Amount, Order_Delivery_Adress, Order_Status, Order_Date, Delivery_Fee)
VALUES 
(1, 1, 1, 31.98, '123 Main St', 'Preapering', '2024-02-01', 5.00),
(2, 2, 2, 89.97, '789 Oak St', 'Cancelled', '2024-02-02', 5.00),
(3, 3, 3, 72.25, '456 Pine St', 'Delivered', '2024-02-03', 5.00),
(4, 4, 4, 115.96, '789 Elm St', '', '2024-02-04', 5.00),
(5, 5, 5, 19.98, '123 Cedar St', 'Order is on the way', '2024-02-05', 5.00),
(6, 6, 6, 39.99, '456 Maple St', 'Not Delivered Yet', '2024-02-06', 5.00),
(7, 7, 7, 64.50, '789 Birch St', 'Delivered', '2024-02-07', 5.00),
(8, 8, 8, 138.50, '123 Walnut St', 'Not Delivered Yet', '2024-02-08', 5.00),
(9, 9, 9, 424.00, '456 Cherry St', 'Delivered', '2024-02-09', 5.00),
(10, 10, 10, 29.95, '789 Pine St', 'Not Delivered Yet', '2024-02-10', 5.00),
(11, 11, 11, 75.00, '123 Main St', 'Preparing', '2024-04-01', 5.00),
(12, 12, 12, 105.50, '789 Oak St', 'Cancelled', '2024-04-02', 5.00),
(13, 13, 13, 45.75, '456 Pine St', 'Delivered', '2024-04-03', 5.00),
(14, 14, 14, 32.99, '789 Elm St', '', '2024-04-04', 5.00),
(15, 15, 15, 39.99, '123 Cedar St', 'Order is on the way', '2024-04-05', 5.00);

-- DELETE 
DELETE FROM Delivery_Service

--INSERT INTO Delivery_Service
INSERT INTO Delivery_Service (Delivery_ID, Delivery_Service_Order_ID, Delivery_Service_Courier_ID, Delivery_Status, Contact_Info, Tracking_Num, Delivery_Method, Est_Delivery_Date, Act_Delivery_Date)
VALUES 
(1, 1, 1, 'Delivered', '5551112233', 'ABC123', 'Express', '2024-02-05', '2024-02-05'),
(2, 2, 2, 'Delivered', '5552223344', 'XYZ456', 'Standard', '2024-02-06', '2024-02-06'),
(3, 3, 3, 'Delivered', '5553334455', 'LMN789', 'Express', '2024-02-07', '2024-02-07'),
(4, 4, 4, 'Delivered', '5554445566', 'PQR123', 'Standard', '2024-02-08', '2024-02-08'),
(5, 5, 5, 'Delivered', '5555556677', 'JKL456', 'Express', '2024-02-09', '2024-02-09'),
(6, 6, 6, 'Delivered', '5556667788', 'DEF789', 'Standard', '2024-02-10', '2024-02-10'),
(7, 7, 7, 'Delivered', '5557778899', 'UVW123', 'Express', '2024-02-11', '2024-02-11'),
(8, 8, 8, 'Delivered', '5558889900', 'GHI456', 'Standard', '2024-02-12', '2024-02-12'),
(9, 9, 9, 'Delivered', '5559990011', 'MNO789', 'Express', '2024-02-13', '2024-02-13'),
(10, 10, 10, 'Delivered', '5550001122', 'QRS123', 'Standard', '2024-04-14', '2024-02-14'),
(11, 11, 11, 'Delivered', '5551112233', 'ABC123', 'Express', '2024-04-05', '2024-04-05'),
(12, 12, 12, 'Delivered', '5552223344', 'XYZ456', 'Standard', '2024-04-06', '2024-04-06'),
(13, 13, 13, 'Delivered', '5553334455', 'LMN789', 'Express', '2024-04-07', '2024-04-07'),
(14, 14, 14, 'Delivered', '5554445566', 'PQR123', 'Standard', '2024-04-08', '2024-04-08'),
(15, 15, 15, 'Delivered', '5555556677', 'JKL456', 'Express', '2024-04-09', '2024-04-09');

-- DELETE 
DELETE FROM Order_Detail

-- INSERT INTO Order_Detail
INSERT INTO Order_Detail (Order_Detail_ID, Order_Detail_Order_ID, Order_Detail_Prod_ID, Order_Detail_Pharmacy_ID, Quantity, Sub_Total)
VALUES 
(1, 1, 1, 1, 2, 31.98),
(2, 2, 2, 2, 3, 89.97),
(3, 3, 3, 3, 1, 72.25),
(4, 4, 4, 4, 4, 115.96),
(5, 5, 5, 5, 1, 19.98),
(6, 6, 6, 6, 2, 39.99),
(7, 7, 7, 7, 3, 64.50),
(8, 8, 8, 8, 2, 138.50),
(9, 9, 9, 9, 5, 424.00),
(10, 10, 10, 10, 1, 29.95),
(11, 11, 11, 11, 2, 75.00),
(12, 12, 12, 12, 3, 105.50),
(13, 13, 13, 13, 1, 45.75),
(14, 14, 14, 14, 4, 32.99),
(15, 15, 15, 15, 1, 39.99);

-- DELETE
DELETE FROM Medications_in_Prescription

-- INSERT INTO Medications_in_Prescription
INSERT INTO Medications_in_Prescription (Med_in_Pres_ID, Medications_in_Prescription_Med_ID, Medications_in_Prescription_Pres_ID, Med_Quantity)
VALUES 
(1, 1, 1, 2),
(2, 2, 2, 3),
(3, 3, 3, 1),
(4, 4, 4, 4),
(5, 5, 5, 1),
(6, 6, 6, 2),
(7, 7, 7, 3),
(8, 8, 8, 2),
(9, 9, 9, 5),
(10, 10, 10, 1),
(11, 11, 11, 2),
(12, 12, 12, 3),
(13, 13, 13, 1),
(14, 14, 14, 4),
(15, 15, 15, 1);

---------- QUERIES ----------
--1) Specialties and numbers of doctors in the Doctor table:

SELECT 
    Dr_Specialzation AS Specialization, 
	COUNT(Dr_ID) AS [Number of Doctor] 
FROM 
    Doctor 
GROUP BY Dr_Specialzation

--2) Average price of the products in the product table:
SELECT 
    AVG(Prod_Price) [Average of All Product's Price] 
FROM 
    Product

--3) Numbers of Delivered Orders in the order table:

SELECT 
    Order_Status AS [Order Status], 
	COUNT(*) AS [Numbers of Delivered Orders] 
FROM 
    [Order] 
WHERE 
    Order_Status ='Delivered' 
GROUP BY Order_Status 

--4) Numbers of Cancelled Orders in the order table:

SELECT 
    Order_Status AS [Order Status], 
	COUNT(*) AS [Numbers of Cancelled Orders]  
FROM 
    [Order] 
WHERE 
    Order_Status ='Cancelled' 
GROUP BY Order_Status 

--5) Numbers of Not Delivered Yet Orders in the order table:

SELECT 
    Order_Status AS [Order Status], 
	COUNT(*) AS [Numbers of Not Delivered Yet Orders] 
FROM 
    [Order] 
WHERE 
    Order_Status ='Not Delivered Yet' 
GROUP BY Order_Status 

--6) Checking a specific courier's delivery information:
SELECT *
FROM Delivery_Service
WHERE Delivery_Service_Courier_ID = 1;

--7) List delivered and has higher than 50 dollar of total order amount:

SELECT *
FROM [Order]
WHERE Order_Status <> 'Delivered' AND Total_Order_Amount > 50;

--8) Finding the total amount of top 10 orders:
SELECT TOP(10) Order_Pat_ID, SUM(Total_Order_Amount) AS TotalAmount
FROM [Order]
GROUP BY Order_Pat_ID;

--9) Filter the total payment amount by a specific date range:
SELECT SUM(Pay_TotalAmount) AS TotalPayment
FROM Payment_Transaction
WHERE Pay_TransactionDate BETWEEN '2024-02-01' AND '2024-02-10';

--10) Price ranking of products belonging to a category:
SELECT Prod_Name, Prod_Price
FROM Product
WHERE Product_Category_ID = 3
ORDER BY Prod_Price DESC;

--11) 5 Latest Added Products:
SELECT TOP 5 *
FROM Product
ORDER BY Prod_ID DESC;

--12) Total expenses incurred by each patient:
SELECT Order_Pat_ID, SUM(Total_Order_Amount) AS TotalSpent
FROM [Order]
GROUP BY Order_Pat_ID;

---------- INNER JOIN QUERIES ----------

--13) Number of products in the Product table by category:
SELECT 
    Category_Name AS Category, 
	COUNT(Prod_ID) AS [Number of Product] 
FROM 
    Product p INNER JOIN Category c on p.Product_Category_ID = c.Category_ID 
GROUP BY Category_Name

--14) Number of medications taken by patients with birth dates greater than 1980 in the Patient table:
SELECT 
    Pat_First_Name AS [First Name], 
	Pat_Last_Name AS [Last Name], 
	COUNT(Med_ID) AS [Number of Taking Medicine] 
FROM 
    Patient p INNER JOIN [Order] o on p.Pat_ID = o.Order_Pat_ID  
INNER JOIN 
    Order_Detail od on o.Order_ID = od.Order_Detail_Order_ID 
INNER JOIN 
    Product as prod ON od.Order_Detail_Prod_ID = prod.Prod_ID 
INNER JOIN 
    Medication med ON prod.Prod_ID = med.Medication_Prod_ID 
WHERE 
    YEAR(Pat_DoB) > '1980' 
GROUP BY Pat_First_Name,Pat_Last_Name

--15) Most ordered product:
SELECT 
    TOP 1 Prod_Name AS [Prodcut Name], 
	COUNT(*) AS [Order Count] 
FROM 
    Product p 
INNER JOIN 
    Order_Detail od ON p.Prod_ID = od.Order_Detail_Prod_ID 
GROUP BY Prod_Name 
ORDER BY([Order Count]) DESC

--16) Total amount of expenses incurred by each patient ,high to low order:
SELECT
    Pat_First_Name AS [First Name], 
	Pat_Last_Name AS [Last Name], 
	Total_Order_Amount AS [Total amount of expenses] 
FROM 
    Patient p INNER JOIN [Order] o on p.Pat_ID = o.Order_Pat_ID 
ORDER BY [Total amount of expenses] DESC

--17) The stock quantity of each product in the Product table and the number of times it was ordered, low to high order.
SELECT 
    Prod_Name AS [Product Name], 
	Prod_StockQuantity AS [Stock Quantity] , 
	COUNT(Order_Detail_ID) AS [Number of Ordered] 
FROM 
    Product p 
INNER JOIN 
    Order_Detail od on p.Prod_ID = od.Order_Detail_Prod_ID 
GROUP BY Prod_Name,Prod_StockQuantity 
ORDER BY [Stock Quantity] 

--18) Bringing a Specific Patient's Prescription Medications and Quantity:
SELECT 
    Pat_ID AS [Patient ID], 
	Pat_First_Name +' '+ Pat_Last_Name AS [Patient Name], 
	pres.Pres_IssueDate,
	pres.Pres_ExpirationDate,
	med.Med_ID AS [Medication ID],
	mp.Med_Quantity AS [Medication Quantity],
	prod.Prod_Name AS [Medication Name]
FROM 
    Patient p 
INNER JOIN 
    Prescription pres ON p.Pat_ID = pres.Prescription_Pat_ID 
INNER JOIN 
    Medications_in_Prescription mp ON pres.Pres_ID = mp.Med_in_Pres_ID 
INNER JOIN 
    Medication med ON mp.Medications_in_Prescription_Med_ID = med.Med_ID 
INNER JOIN 
    Product prod ON mp.Medications_in_Prescription_Med_ID = prod.Prod_ID 
WHERE 
    p.Pat_First_Name = 'Alexander' AND p.Pat_Last_Name ='Smith'

--19) Listing Prescriptions Written by a Doctor:
SELECT 
    dr.Dr_ID AS [Doctor ID], 
    dr.Dr_First_Name + ' ' + dr.Dr_Last_Name AS [Doctor Name], 
    pres.Pres_ID AS [Prescription ID], 
	pres.Pres_IssueDate AS [Prescription Issue Date],
    pres.Pres_ExpirationDate AS [Prescreption Expiration Date],
    p.Pat_First_Name + ' ' + p.Pat_Last_Name AS [Patient Name]
FROM 
    Doctor dr 
INNER JOIN 
    Prescription pres ON dr.Dr_ID = pres.Prescription_Dr_ID 
INNER JOIN
    Patient p ON pres.Prescription_Pat_ID = p.Pat_ID
WHERE 
    dr.Dr_First_Name = 'Dr. Emily' AND dr.Dr_Last_Name = 'Jones'

   
--20) Listing Products Belonging to a Category:
SELECT
    Category_Name AS [Category Name],
    Prod_Name AS [Product Name],
    Prod_Description AS [Product Description] ,
    Prod_Price AS [Product Price]
FROM
    Category c
INNER JOIN
    Product p ON c.Category_ID = p.Product_Category_ID
WHERE
    c.Category_Name = 'Pain Relief';

--21) Listing a Patient's Past Orders and Delivery Status:
SELECT
    Pat_First_Name + ' ' + Pat_Last_Name AS [Patient Name],
	Order_ID AS [Order ID],
    Order_Date AS [Order Date],
    Order_Status AS [Order Status] ,
    Delivery_Status AS [Delivery Status],
    Est_Delivery_Date AS [Estimation Delivery Date],
    Act_Delivery_Date AS [Actual Delivery Date]
FROM
    [Order] o
INNER JOIN
    Delivery_Service d ON o.Order_ID = d.Delivery_Service_Order_ID
INNER JOIN
    Patient p ON o.Order_Pat_ID = p.Pat_ID
WHERE
    p.Pat_First_Name = 'Henry' AND p.Pat_Last_Name = 'Ward';

--22)  Shows categories with more than three products and an average price greater than 15.
SELECT
    Category_Name AS [Category Name],
    COUNT(Prod_ID) AS [Product Count],
    AVG(Prod_Price) AS [Avg Price]
FROM
    Category c
INNER JOIN
    Product p ON c.Category_ID = p.Product_Category_ID
GROUP BY
    c.Category_Name
HAVING
    COUNT(Prod_ID) > 1 
	AND
	AVG(Prod_Price) > 15  
ORDER BY
    [Avg Price] DESC;

--23) Listing the orders placed by a customer, the order details and the patient information in these details:
SELECT Pat_ID, Pat_First_Name + ' '+ Pat_Last_Name , Order_Delivery_Adress , Total_Order_Amount , Order_Status
FROM Patient P
INNER JOIN [Order] O ON P.Pat_ID = O.Order_Pat_ID
INNER JOIN Order_Detail OD ON O.Order_ID = OD.Order_Detail_Order_ID
INNER JOIN Product PR ON OD.Order_Detail_Prod_ID = PR.Prod_ID
WHERE P.Pat_ID = 2; 

--24) Finding the number and name of prescriptions written by a doctor:
SELECT Doctor.Dr_First_Name, Doctor.Dr_Last_Name, COUNT(Prescription.Pres_ID) AS Prescription_Count
FROM Doctor
INNER JOIN Prescription ON Doctor.Dr_ID = Prescription.Prescription_Dr_ID
WHERE Doctor.Dr_ID = 1
GROUP BY Doctor.Dr_First_Name, Doctor.Dr_Last_Name

--25) Delivery dates of orders placed by a patient:
SELECT Order_ID, Order_Date, Act_Delivery_Date
FROM [Order]
INNER JOIN Delivery_Service ON [Order].Order_ID = Delivery_Service.Delivery_Service_Order_ID
WHERE Order_Pat_ID = 4

--26) Number of orders delivered by each courier:
SELECT Courier_ID, Courier_Name, COUNT(Delivery_ID) AS DeliveryCount
FROM Courier
LEFT JOIN Delivery_Service ON Courier.Courier_ID = Delivery_Service.Delivery_Service_Courier_ID
GROUP BY Courier_ID, Courier_Name;

--27) Customers to whom couriers deliver packages
SELECT Pat_First_Name, Pat_Last_Name, Courier_ID  from Patient 
INNER JOIN Courier ON Pat_ID = Courier_ID

--28) How Many Patients Does a Doctor Prescribe Medicine:
SELECT d.Dr_First_Name + ' ' + d.Dr_Last_Name AS DoctorName, COUNT(pres.Pres_ID) AS PrescriptionCount
FROM Prescription pres
INNER JOIN Doctor d ON pres.Prescription_Dr_ID = d.Dr_ID
GROUP BY d.Dr_First_Name, d.Dr_Last_Name;

--29) How Many Different Medications a Patient Takes in a Given Prescription:
SELECT p.Pat_First_Name + ' ' + p.Pat_Last_Name AS PatientName, pres.Pres_ID, COUNT(DISTINCT mip.Medications_in_Prescription_Med_ID) AS UniqueMedicationCount
FROM Patient p
INNER JOIN Prescription pres ON p.Pat_ID = pres.Prescription_Pat_ID
INNER JOIN Medications_in_Prescription mip ON pres.Pres_ID = mip.Medications_in_Prescription_Pres_ID
GROUP BY p.Pat_First_Name, p.Pat_Last_Name, pres.Pres_ID;

--30) Find orders delivered on a specific date: 
SELECT O.Order_ID, O.Order_Date, O.Order_Status, P.Pat_First_Name, P.Pat_Last_Name
FROM [Order] O
INNER JOIN Patient P ON O.Order_Pat_ID = P.Pat_ID
WHERE O.Order_Status = 'Delivered' AND O.Order_Date = '2024-02-07'; 

---------- 5 INSERT ----------

--1) To add a new product:
INSERT INTO Product (Prod_ID, Product_Category_ID, Prod_Name, Prod_Description, Prod_Price, Prod_StockQuantity, Prod_Manufacturer)
VALUES (16, 3, 'Omega-3 Fish Oil Capsules', 'Supports heart and brain health', 21.99, 120, 'NutriHealth Labs');

--2) To add a new courier:
INSERT INTO Courier (Courier_ID, Courier_Name, Courier_Last_Name, Courier_Phone, Courier_Email)
VALUES (16, 'CourierEmma', 'Miller', '5559876543', 'emma.miller.courier@example.com');

--3) To add a new recipe:
INSERT INTO Prescription (Pres_ID, Prescription_Dr_ID, Prescription_Pat_ID, Pres_IssueDate, Pres_ExpirationDate)
VALUES (16, 10, 11, '2024-04-15', '2024-05-15');

--4) To add a new order:
INSERT INTO [Order] (Order_ID, Order_Pat_ID, Order_Pay_Transaction_ID, Total_Order_Amount, Order_Delivery_Adress, Order_Status, Order_Date, Delivery_Fee)
VALUES (16, 8, 9, 55.00, '456 Walnut St', 'Preparing', '2024-04-10', 7.00);

--5) To add a new delivery service:
INSERT INTO Delivery_Service (Delivery_ID, Delivery_Service_Order_ID, Delivery_Service_Courier_ID, Delivery_Status, Contact_Info, Tracking_Num, Delivery_Method, Est_Delivery_Date, Act_Delivery_Date)
VALUES (16, 16, 16, 'Preparing', '5556645688', 'LMN456', 'Standard', '2024-04-12', '2024-04-12');

---------- 5 UPDATE ----------

--1) To update the stock quantity of a product:
UPDATE Product SET Prod_StockQuantity = 180 WHERE Prod_ID = 3;

--2) To update a patient's contact information:
UPDATE Patient SET Pat_Phone_Num = '5553337890', Pat_Shipping_Adress = '789 New St' WHERE Pat_ID = 2;

--3) To extend the validity period of a prescription:
UPDATE Prescription SET Pres_ExpirationDate = '2024-06-15' WHERE Pres_ID = 5;

--4) To change the name of a category:
UPDATE Category SET Category_Name = 'Pain Management' WHERE Category_ID = 1;

--5) To update the status of an order:
UPDATE [Order] SET Order_Status = 'Shipped' WHERE Order_ID = 3;

---------- 5 DELETE ----------

--1) To delete delivery method which has letter a in name:
DELETE FROM Delivery_Service 
WHERE Delivery_Method LIKE '%A%';

--2) Delete all prescriptions and related order details for a medication:
DELETE FROM Medications_in_Prescription
WHERE Medications_in_Prescription_Med_ID = 2;

--3) Deleting order details for specific pharmacy:
DELETE FROM Order_Detail
WHERE Order_Detail_Pharmacy_ID = 7;

--4) To delete a Sub_Totals which are the bigger than 10: 
DELETE FROM Order_Detail 
WHERE Sub_Total >10;

--5) To delete a delivery service:
DELETE FROM Delivery_Service WHERE Delivery_ID = 1;

---------- 5 ALTER TABLE ----------

--1) Alter Patient Table and Add New Column Birthplace
ALTER TABLE Patient
ADD Birthplace VARCHAR(50);

--2) Alter Payment_Transaction Table and Alter the Pay_Method Column VARCHAR(50) TO VARCHAR(100)
ALTER TABLE Payment_Transaction
ALTER COLUMN Pay_Method VARCHAR(100);

--3) Alter Courier Table and add Column Courier_Rank
ALTER TABLE Courier
ADD Courier_Rank INT;

--4) Alter Pharmacy Table and Add Unique Constraint to Pharmacy_Name
ALTER TABLE Pharmacy
ADD CONSTRAINT UQ_CONSTRAINT_Pharmacy_Name UNIQUE(Pharmacy_Name);

--5) Alter Delivery_Service Table and Drop Tracking_Num
ALTER TABLE Delivery_Service
DROP COLUMN Tracking_Num ; 

---------- VIEWS AND SELECT VIEWS ----------
-- 1)VIEW --  Gives information about Prescription.
DROP VIEW Prescription_Info

CREATE VIEW Prescription_Info 
AS
SELECT Dr_ID AS [Doctor ID] , 
dr.Dr_First_Name AS [Doctor First Name], 
Dr.Dr_Last_Name AS [Doctor Last Name],
Pat_ID AS [Patient ID] ,
pt.Pat_First_Name AS [Patient First Name] , 
pt.Pat_Last_Name AS [Patient Last Name],
Pres_ID AS [Prescription ID] ,
Pres_IssueDate AS [Prescription Issue Date] , 
Pres_ExpirationDate AS [Prescription Expiration Date] 
FROM Prescription as p
INNER JOIN Doctor dr on p.Prescription_Dr_ID = dr.Dr_ID 
INNER JOIN Patient pt on p.Prescription_Pat_ID = pt.Pat_ID
-- 1)SELECT --
SELECT * FROM Prescription_Info

-- 2)VIEW --   This view contains basic information of orders and total quantities.
DROP VIEW Order_Summary

CREATE VIEW Order_Summary 
AS
SELECT
Order_ID,
Order_Date,
Pat_First_Name + ' ' + p.Pat_Last_Name AS Patient_Name,
SUM(od.Quantity) AS Total_Items,
Total_Order_Amount,
Delivery_Status
FROM
[Order] o
JOIN Order_Detail od ON o.Order_ID = od.Order_Detail_Order_ID
JOIN Patient p ON o.Order_Pat_ID = p.Pat_ID
JOIN Delivery_Service os ON o.Order_ID = os.Delivery_Service_Order_ID
GROUP BY
o.Order_ID, o.Order_Date, p.Pat_First_Name, p.Pat_Last_Name, o.Total_Order_Amount, os.Delivery_Status;
-- 2)SELECT --
SELECT * FROM Order_Summary

-- 3)VIEW --  This view shows the pharmacy inventory.
DROP VIEW PharmacyInventory

CREATE VIEW PharmacyInventory 
AS
SELECT
Pharmacy_ID,
Pharmacy_Name,
Pharmacy_Email,
Pharmacy_Phone_Num,
Pharmacy_Address,
Prod_ID,
Prod_Name,
Prod_Description,
Prod_Price,
Prod_StockQuantity,
Quantity AS [Order Quantity]
FROM
Pharmacy Ph
INNER JOIN Order_Detail od ON Ph.Pharmacy_ID = od.Order_Detail_Pharmacy_ID
INNER JOIN Product Pr ON od.Order_Detail_Prod_ID = Pr.Prod_ID;

-- 3)SELECT --  
SELECT * FROM PharmacyInventory

-- 4)VIEW -- Give information about patient and their prescription with doctor information.
DROP VIEW PatientDetails

CREATE VIEW PatientDetails 
AS
SELECT
Pat_ID,
Pat_First_Name,
Pat_Last_Name,
Pat_Email,
Pat_Phone_Num,
Pat_Shipping_Adress,
Pat_Billing_Adress,
Pat_DoB,
Pres_ID,
Pres_IssueDate,
Pres_ExpirationDate,
Dr_ID,
Dr_First_Name,
Dr_Last_Name
FROM
Patient P
LEFT JOIN Prescription Pr ON P.Pat_ID = Pr.Prescription_Pat_ID
LEFT JOIN Doctor D ON Pr.Prescription_Dr_ID = D.Dr_ID;

-- 4)SELECT --
SELECT * FROM PatientDetails

-- 5)VIEW --  Give information about top selling products.
DROP VIEW TopSellingProducts

CREATE VIEW TopSellingProducts 
AS
SELECT
Prod_Name,
Prod_Description,
SUM(od.Quantity) AS Total_Sold
FROM
Order_Detail od
JOIN Product p ON od.Order_Detail_Prod_ID = p.Prod_ID
GROUP BY
p.Prod_Name, p.Prod_Description

-- 5)SELECT --
SELECT * FROM TopSellingProducts

-- 6)VIEW -- Shows Top Customer according to purchasing amounts.

DROP VIEW TopCustomers 

CREATE VIEW TopCustomers 
AS
SELECT
Pat_ID,
Pat_First_Name + ' ' + p.Pat_Last_Name AS Patient_Name,
COUNT(o.Order_ID) AS Total_Orders
FROM
[Order] o
JOIN Patient p ON o.Order_Pat_ID = p.Pat_ID
GROUP BY
p.Pat_ID, p.Pat_First_Name, p.Pat_Last_Name

-- 6)SELECT --
SELECT * FROM TopCustomers

-- 7)VIEW --   Give information about Courier's deliveries' quantity.
DROP VIEW CourierDeliveryInfo

CREATE VIEW CourierDeliveryInfo 
AS
SELECT
Courier_ID,
Courier_Name,
Courier_Last_Name,
Courier_Phone,
Courier_Email,
COUNT(Delivery_ID) AS TotalDeliveries
FROM
Courier C
JOIN
Delivery_Service DS ON C.Courier_ID = DS.Delivery_Service_Courier_ID
GROUP BY
Courier_ID, Courier_Name, Courier_Last_Name, Courier_Phone, Courier_Email;

-- 7)SELECT --
SELECT * FROM CourierDeliveryInfo

-- 8)VIEW -- View of Patient-specific Order Details.
DROP VIEW PatientOrdersView

CREATE VIEW PatientOrdersView 
AS
SELECT
    O.Order_ID,
    O.Order_Pat_ID,
    P.Pat_First_Name,
    P.Pat_Last_Name,
    O.Total_Order_Amount,
    O.Order_Status,
    O.Order_Date,
    O.Delivery_Fee
FROM [Order] O
JOIN Patient P ON O.Order_Pat_ID = P.Pat_ID;

-- 8)SELECT -- 
SELECT * FROM PatientOrdersView

-- 9)VIEW -- View of Orders with Total_Order_Amount Greater Than 100.
DROP VIEW HighValueOrdersView

CREATE VIEW HighValueOrdersView 
AS
SELECT
    O.Order_ID,
    O.Order_Pat_ID,
    P.Pat_First_Name,
    P.Pat_Last_Name,
    O.Total_Order_Amount
FROM [Order] O
JOIN Patient P ON O.Order_Pat_ID = P.Pat_ID
WHERE O.Total_Order_Amount > 100;

-- 9)SELECT --
SELECT * FROM HighValueOrdersView

-- 10)VIEW -- View of Orders Associated with Patient ID = 4.
DROP VIEW OrderDeliveryDate

CREATE VIEW OrderDeliveryDate 
AS
SELECT Order_ID, Order_Date, Act_Delivery_Date
FROM [Order]
INNER JOIN Delivery_Service ON [Order].Order_ID = Delivery_Service.Delivery_Service_Order_ID
WHERE Order_Pat_ID = 4

-- 10)SELECT --
SELECT * FROM OrderDeliveryDate

---------- INDEX ----------

--1)This index prevents patients registered with the same email address by adding unique values ​​to the Pat_Email column in the Patient table.
CREATE UNIQUE INDEX Pat_Email ON Patient(Pat_Email)

--2)This index prevents doctors with the same license number from being recorded by adding unique values ​​to the Dr_LicenceNumber column in the Doctor table.
CREATE UNIQUE INDEX Dr_LicenceNumber ON Doctor(Dr_LicenceNumber)

--3)This index adds unique values ​​to the Pharmacy_Email column in the Pharmacy table, preventing pharmacies registered with the same email address.
CREATE UNIQUE INDEX Pharmacy_Email ON Pharmacy(Pharmacy_Email)

--4)This index adds unique values ​​to the Category_Name column in the Category table, preventing categories with the same category name from being saved.
CREATE UNIQUE INDEX Category_Name ON Category(Category_Name)

--5)This index adds a regular index to the Product_Category_ID column in the Product table, allowing quick access to that column but not forcing the values ​​to be unique.
CREATE INDEX Product_Categoty_ID ON Product(Product_Category_ID)

--6)This index adds a regular index to the Medication_Prod_ID column in the Medication table, allowing quick access to that column but not forcing the values ​​to be unique.
CREATE INDEX Medication_Prod_ID ON Medication(Medication_Prod_ID)

--7)This index adds a regular index to the Prescription_Dr_ID column in the Prescription table, allowing quick access to that column but not forcing the values ​​to be unique.
CREATE INDEX Prescription_Dr_ID ON Prescription(Prescription_Dr_ID)

--8)This index adds a regular index to the Order_Pat_ID column in the [Order] table, allowing quick access to that column but not forcing the values to be unique.
CREATE INDEX Order_Pat_ID ON [Order](Order_Pat_ID)

--9)This index adds a regular index to the Delivery_Service_Order_ID column in the Delivery_Service table, allowing quick access to that column but not forcing the values ​​to be unique.
CREATE INDEX Delivery_Service_Order_ID ON Delivery_Service(Delivery_Service_Order_ID)

--10)This index adds a regular index to the Order_Detail_Order_ID column in the Order_Detail table, allowing quick access to that column but not forcing the values ​​to be unique.
CREATE INDEX Order_Detail_Order_ID ON Order_Detail(Order_Detail_Order_ID)