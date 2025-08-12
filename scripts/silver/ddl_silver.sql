/*
=========================================================================================
DDL Create Silver Tables
=========================================================================================
Script Purpose:
	This script creates tables in 'silver' schema, dropping existing 
	tables if they already exist.
	Run this script to re-define the DDL structure of 'silver' Tables.
*/

USE Superstore;

IF OBJECT_ID ('silver.customer', 'U') IS NOT NULL
	DROP TABLE silver.customer;

CREATE TABLE silver.customer (
	customerID NVARCHAR(50),
	customer_name NVARCHAR(50),
	segment NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.product', 'U') IS NOT NULL
	DROP TABLE silver.[product];

CREATE TABLE silver.[product] (
	productID NVARCHAR(50),
	category NVARCHAR(50), 
	subcategory NVARCHAR(50),
	product_name  NVARCHAR(200),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.sales', 'U') IS NOT NULL
	DROP TABLE silver.sales;

CREATE TABLE silver.sales (
	orderID NVARCHAR(50),
	order_date DATE,
	ship_date DATE,
	ship_mode NVARCHAR(50),
	customerID NVARCHAR(50),
	country NVARCHAR(50),
	city NVARCHAR(50),
	state_ NVARCHAR(50),
	postal_code INT,
	region NVARCHAR(50),
	productID NVARCHAR(50),
	sales FLOAT,
	quantity INT,
	discount FLOAT,
	profit FLOAT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);