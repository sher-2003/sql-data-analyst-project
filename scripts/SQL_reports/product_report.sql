/*
================================================================================================================
Product Report
================================================================================================================
Purpose:
	This report consolidates key product metrics and behavior.

Highlights:
	1. Gathers assentional fields such as category, subcategory and cost.
	2. Segments products by revenue to inditify High-Performers, Mid-Range or Low-Performers
	and by profit to inditify Profitable and Not Profitble products.
	3. Aggregetes product-level metrics:
		- total orders;
		- total sales;
		- total profit
		- total quantity sold;
		- total customers (unique);
		- lifespan (in month).
	4. Calculates valueble KPIs:
		- recency (months since last sales)
		- average order sales
		- average monthly sales
================================================================================================================
*/

CREATE VIEW product_report AS
WITH base_query AS (
SELECT
fs.order_number,
fs.order_date,
dc.customer_key,
dp.product_key,
fs.shipping_date,
fs.ship_mode,
fs.sales_amount,
fs.quantity,
fs.discount,
fs.profit,
fs.region,
fs.state,
fs.city,
dc.segment,
dp.category,
dp.subcategory
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customer AS dc
ON fs.customer_key = dc.customer_key
LEFT JOIN gold.dim_product AS dp
ON dp.product_key = fs.product_key),
product_aggregetion AS (
SELECT
	product_key,
	category,
	subcategory,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(profit) AS total_profit,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT customer_key) AS total_customers,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
	MAX(order_date) AS last_sale_date,
	ROUND(AVG(sales_amount / NULLIF(quantity, 0)), 1) avg_selling_price
FROM base_query
GROUP BY 
	product_key,
	category,
	subcategory
	)
SELECT
	product_key,
	category,
	subcategory,
	total_orders,
	total_sales,
	total_profit,
	total_quantity,
	total_customers,
	lifespan,
	CASE
			WHEN total_profit > 0 THEN 'Profitable'
			WHEN total_profit <= 0 THEN 'Not Profitable'
		END product_profit,
	CASE
			WHEN total_sales > 2500 THEN 'High-Performers'
			WHEN total_sales >= 600 THEN 'Mid-Performers'
			ELSE 'Low-Performers'
		END product_segment,
	DATEDIFF(month, last_sale_date, GETDATE()) AS recensy_month,
	avg_selling_price,
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE ROUND(total_sales/total_orders, 2)
	END avg_orders_sales,
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE ROUND(total_sales/lifespan, 2)
	END avg_monthly_sales
FROM product_aggregetion