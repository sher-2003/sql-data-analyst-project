/*
==================================================================================================
Create Database and Schemas
==================================================================================================
Script Purpose:
	This script create a new database named 'Superstore' after checking if it already exists.
	If the database exists, it's droped and recreated. Additionaly the script set up three schemas
	within the database: 'bronze', 'silver' and 'gold'.
	
WARNING:
	Running this script will drop up the entire 'Superstore' database if it exists.
	All date in in the datebase will permanently deleted. Proceed with caution
	and ensure you have proper backups before running this script
*/


-- Create Database 'Superstore'

USE MASTER;

-- Drop and recreate the 'Superstore' database

IF EXISTS (SELECT 1 FROM sys.databases WHERE NAME = 'Superstore')
BEGIN
	ALTER DATABASE Superstore SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE Superstore;
END;
GO

CREATE DATABASE Superstore;

USE Superstore

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO