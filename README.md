# product-analytics-sql
SQL view to analyze product performance by aggregating key sales metrics, customer behaviour, and revenue KPIs.


# Product Performance Report

This repository contains a SQL view that generates a comprehensive product performance report. It consolidates sales data from multiple tables and computes key product-level metrics and KPIs for business insights.

## Purpose

To create a reusable and scalable SQL-based reporting view that helps:

- Understand product-level sales performance
- Segment products by revenue contribution
- Calculate key business KPIs (e.g., average monthly revenue, recency, lifespan)
- Support data-driven product strategy decisions

## View: `gold.report_products`

This SQL view is built in layered CTEs to enhance readability and modularity:

### Base Query
Joins fact and dimension tables to pull:
- Order info
- Product metadata (name, category, cost)
- Customer identifiers

### Product Aggregation
Aggregates metrics per product:
- Total orders
- Total sales
- Total quantity sold
- Total unique customers
- Product lifespan (months active)
- Average selling price

### Final Selection & KPIs
Calculates:
- Product performance tiers (`High`, `Mid-Range`, `Low`)
- Recency (months since last sale)
- Average Monthly Revenue
- AOR (Average Order Revenue)

## Tables Used
- `gold.fact_sales`
- `gold.dim_products`
- `gold.dim_customers`

## Technology Used
- SQL (T-SQL / compatible dialect)

-- Use Cases
- Business Intelligence dashboards
- Quarterly product reviews
- Executive sales reporting
- Data modelling for analytics
