/*
===============================================================
DDL Script: Create Gold Views
===============================================================
Script Purpose:
	This script creaates views for the Gold layer in the data warehouse.
	The gold layer respresents the final demensial and fact tables (Star schema).

	Each view performs transformations and combines data  from the Silver layer
	to produse a clean, enreached and business-ready dateset.
	
Usage:
	- These views can be quired directly for analytics and reporting.
===============================================================
*/
--============================================================
--Create Dimension: gold.dim_customer
--==========================================================
IF OBJECT_ID ('gold.dim_customer', 'V') IS NOT NULL
	DROP VIEW gold.dim_customer
GO

CREATE VIEW gold.dim_customer AS
SELECT
	ROW_NUMBER() OVER (ORDER BY customerID) AS customer_key,
	customerID AS customer_id,
	customer_name AS customer_name,
	segment AS segment
FROM silver.customer

GO
--============================================================
--Create Dimension: gold.dim_customer
--==========================================================
IF OBJECT_ID ('gold.dim_product', 'V') IS NOT NULL
	DROP VIEW gold.dim_product
GO

CREATE VIEW gold.dim_product AS
SELECT
	ROW_NUMBER() OVER (ORDER BY productID) AS product_key,
	productID AS product_id,
	category,
	subcategory,
	product_name
FROM silver.[product]
GO

--============================================================
--Create Fact Table: gold.fact_sales
--==========================================================
IF OBJECT_ID ('gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales
GO

CREATE VIEW gold.fact_sales AS
SELECT
	sl.orderID AS order_number,
	dp.product_key,
	dc.customer_key,
	sl.order_date,
	sl.ship_date AS shipping_date,
	sl.ship_mode,
	sl.sales AS sales_amount,
	sl.quantity,
	sl.discount,
	sl.profit,
	sl.country,
	sl.region,
	sl.state_ AS state,
	sl.city,
	sl.postal_code
FROM silver.sales AS sl
LEFT JOIN gold.dim_customer AS dc
ON dc.customer_id = sl.customerID
LEFT JOIN gold.dim_product AS dp
ON dp.product_id = sl.productID
GO