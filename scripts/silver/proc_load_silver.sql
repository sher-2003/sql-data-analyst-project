/*
===========================================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===========================================================================================
Script Purpose:
	This stored procedure loads cleaned date into 'silver' schema from bronze layer.
	It performs the following actions:
		- Truncstes the the silver tables before laoding date.
		- Transform date of the bronze layer
Parameters:
		None.
	This stored ptocedure does not accept any parameters or return any values.

Usage Example:
	EXEC silver.load_silver;
===========================================================================================

*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN 
    PRINT '>> Truncating Table: silver.customer'
    TRUNCATE TABLE silver.customer;
    PRINT '>> Inserting into Table: silver.customer'
    INSERT INTO silver.customer (
    customerID,
    customer_name,
    segment
    )

    SELECT 
    customerID,
    customer_name,
    segment
    FROM bronze.customer

    PRINT '>> Truncating Table: silver.product'
    TRUNCATE TABLE silver.[product];
    PRINT '>> Inserting into Table: silver.product'
    INSERT INTO silver.[product] (
    productID,
    category,
    subcategory,
    product_name
    )
    SELECT
    productID,
    category,
    subcategory,
    product_name
    FROM bronze.[product]

    PRINT '>> Truncating Table: silver.sales'
    TRUNCATE TABLE silver.sales;
    PRINT '>> Inserting into Table: silver.sales'
    INSERT INTO silver.sales (
    orderID,
    order_date,
    ship_date,
    ship_mode,
    customerID,
    country,
    city,
    state_,
    postal_code,
    region,
    productID,
    sales,
    quantity,
    discount,
    profit
    )
    SELECT 
        orderID,
    CAST(order_date AS DATE) AS order_date,
    CAST(ship_date AS DATE) AS ship_date,
        ship_mode,
        customerID,
        country,
        city,
        state_,
        postal_code,
        region,
        productID,
        CAST(REPLACE(sales, ',', '.') AS FLOAT) AS sales,
        quantity,
        CAST(REPLACE(discount, ',', '.') AS FLOAT) AS discount,
        CAST(REPLACE(profit, ',', '.') AS FLOAT) AS profit
    FROM bronze.sales 
END