/*
===========================================================================================
Stored Procedure: Load Bronze Layer (Sourse -> Bronze)
===========================================================================================
Script Purpose:
	This stored procedure loads date into 'bronze' schema from external CSV files.
	It performs the following actions:
		- Truncstes the the bronze tables before laoding date.
		- Uses the 'BULK INSERT' command to laod data from csv files to bronze tables.

Parameters:
		None.
	This stored ptocedure does not accept any parameters or return any values.

Usage Example:
	EXEC bronze.load_bronze;

===========================================================================================

*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_strart_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_strart_time = GETDATE();
		PRINT '============================================';
		PRINT 'Loading Bronze Layer';
		PRINT '============================================';

		PRINT 'Loading CRM Tables';
		PRINT '--------------------------------------------';
		PRINT '>> Trucating Table: bronze.customer'
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.customer;
		PRINT '>> Inserting into Table: bronze.customer'
		BULK INSERT bronze.customer 
		FROM 'C:\Users\User\Desktop\project\dataset\customer.csv'
		WITH (
		FIELDTERMINATOR = ';',
		FIRSTROW = 2,
		TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '------------------------------------------'
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-----------------------------------------'
		PRINT '>> Trucating Table bronze.[product]'
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.[product];
		PRINT '>> Inserting into Table: [product]'
		BULK INSERT bronze.[product] 
		FROM 'C:\Users\User\Desktop\project\dataset\product.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ';',
			TABLOCk
			);
		SET @end_time = GETDATE();
		PRINT '------------------------------------------'
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-----------------------------------------'
		PRINT '>> Trucating Table: bronze.sales'
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.sales;
		PRINT '>> Inserting into Table: sales'
		BULK INSERT bronze.sales
		FROM 'C:\Users\User\Desktop\project\dataset\sales.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ';',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '------------------------------------------'
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-----------------------------------------'
		SET @batch_end_time = GETDATE();
		PRINT '------------------------------------------'
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '====================================';
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '>> Total Load Duration: ' + CAST(DATEDIFF(second, @batch_strart_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '====================================';
	END TRY
	BEGIN CATCH 
		PRINT '======================================================';
		PRINT 'ERROR OCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '======================================================';
	END CATCH
END