/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value for sales
		- average monthly spend
		- average order value for profit
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================

WITH base_query AS (
	SELECT
	fs.order_number,
	dc.customer_key,
	fs.product_key,
	dc.customer_name,
	fs.order_date,
	fs.sales_amount,
	fs.quantity,
	fs.profit,
	dc.segment
	FROM gold.fact_sales AS fs
	LEFT JOIN gold.dim_customer AS dc
	ON dc.customer_key = fs.customer_key
	), customer_aggregation AS (
	SELECT
	customer_key,
	customer_name,
	segment,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT product_key) AS total_products,
	SUM(quantity) AS total_quantity,
	SUM(sales_amount) AS total_sales,
	SUM(profit) AS total_profit,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
	MAX(order_date) AS last_order_date
	FROM base_query
	GROUP BY 
		customer_name,
		customer_key,
		segment)
SELECT
	customer_key,
	customer_name,
	segment,
	CASE 
		WHEN lifespan >= 20 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan >= 20 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END customer_type,
	lifespan,
	last_order_date,
	DATEDIFF(month, last_order_date, GETDATE()) recency_months,
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE ROUND(total_sales/lifespan, 2)
	END avg_monthly_spend,
	CASE
		WHEN total_sales = 0 THEN 0
		ELSE ROUND(total_sales/total_orders, 2)
	END avg_order_value,
	CASE
		WHEN total_profit <= 0 THEN 0
		ELSE ROUND(total_profit/total_orders, 2)
	END avg_order_profit_value

FROM customer_aggregation