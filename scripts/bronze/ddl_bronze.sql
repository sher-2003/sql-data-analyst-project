/*
=========================================================================================
DDL Create Bronze Tables
=========================================================================================
Script Purpose:
	This script creates tables in 'bronze' schema, dropping existing 
	tables if they already exist.
	Run this script to re-define the DDL structure of 'bronze' Tables.
*/

USE Superstore;

IF OBJECT_ID ('bronze.customer', 'U') IS NOT NULL
	DROP TABLE bronze.customer;

CREATE TABLE bronze.customer (
	customerID NVARCHAR(50),
	customer_name NVARCHAR(50),
	segment NVARCHAR(50),
);

IF OBJECT_ID ('bronze.[product]', 'U') IS NOT NULL
	DROP TABLE bronze.[product];

CREATE TABLE bronze.[product] (
	productID NVARCHAR(50),
	category NVARCHAR(50),
	subcategory  NVARCHAR(50),
	product_name NVARCHAR(1000),
);

IF OBJECT_ID ('bronze.sales', 'U') IS NOT NULL
	DROP TABLE bronze.sales;

CREATE TABLE bronze.sales (
	orderID NVARCHAR(50),
	order_date NVARCHAR(50),
	ship_date NVARCHAR(50),
	ship_mode NVARCHAR(50),
	customerID NVARCHAR(50),
	country NVARCHAR(50),
	city NVARCHAR(50),
	state_ NVARCHAR(50),
	postal_code INT,
	region NVARCHAR(50),
	productID NVARCHAR(50),
	sales VARCHAR(50),
	quantity INT,
	discount NVARCHAR(50),
	profit NVARCHAR(50)
);