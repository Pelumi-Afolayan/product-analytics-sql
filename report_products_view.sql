/* Product Report

Purpose:
- This consolidates key product metrics and behaviours.

Highlights:
1. Gathers essential fields such as product name, category, subcategory and cost.
2. Segments products by revenue to identify High-Performers, Mid-Range or Low-Performance.
3. Aggregates product-level metrics:
	- total orders
	- total sales
	- total quantity sold
	- total customers (unique)
	- lifespan in months
4. Calculate valuable KPIs:
	- recency (months since last sale)
	- Average order revenue (AOR)
	- average monthly revenue

*/

CREATE VIEW gold.report_products AS
WITH base_query AS (
-- Base query: retrieves core columns from tables

SELECT
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
f.price,
p.product_number,
p.product_name,
p.category,
p.subcategory,
p.cost,
c.customer_key
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
WHERE order_number IS NOT NULL
) 
, product_aggregation AS (
-- Product aggregations: summarizes key metrics at the product level

SELECT
product_number,
product_name,
category,
subcategory,
cost,
COUNT(DISTINCT order_number) AS total_orders,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT customer_key) AS total_customers,
DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
MAX(order_date) AS last_order_date,
ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM base_query
GROUP BY
	product_number,
	product_name,
	category,
	subcategory,
	cost )


SELECT
product_number,
product_name,
category,
subcategory,
total_sales,

CASE WHEN total_sales >= 50000 THEN 'High Performing Product'
	WHEN total_sales >= 10000 THEN 'Mid-Range'
	ELSE 'Low Performing Product'
END AS performance_range,
DATEDIFF(month, last_order_date, GETDATE()) AS recency_in_months,
lifespan,
total_orders,
total_quantity,
total_customers,
avg_selling_price,

CASE WHEN lifespan = 0 THEN 0
	ELSE total_sales / lifespan
END AS avg_monthly_revenue
FROM product_aggregation;


SELECT *
FROM gold.report_products;
