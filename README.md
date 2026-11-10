# Exploring Retail Sales Performance Through PostgreSQL

## 1. Project Overview
This project demonstrates the application of PostgreSQL and SQL in analysing retail sales data, understanding customer purchasing behaviour, and generating business insights to support data-driven decision-making.
The project is based on a fictional electronics retailer, Duka Smart Electronics, which sells mobile phones, computing equipment, electronics, accessories, and home appliances across different Kenyan cities.
Using a synthetic retail dataset, the analysis explores sales performance, product profitability, customer value, geographical trends, and order outcomes.

The project consists of 46 SQL business questions, progressing from fundamental queries to advanced analytical techniques and business intelligence reporting.

Project details
Item	Description
Project	Retail Sales & Customer Intelligence
Database	PostgreSQL
SQL Environment	DBeaver
Database Name	retail_analytics
Schema	retail
Dataset	Synthetic retail data
Customers	150 records
Orders	800 records
Analysis Period	January 2025 – September 2026

## 2. Business Problem
Retail businesses generate large amounts of transactional data, but raw records alone do not provide sufficient information for effective decision-making.
Management needs to understand which products generate the most revenue, which customers contribute the greatest value, how sales change over time, and whether operational issues such as cancelled orders affect performance.
This project uses SQL to transform raw customer and transaction records into meaningful business information.
The analysis seeks to answer questions such as:

• 	Which product categories generate the highest revenue?

•	  Who are the highest-spending customers?

•	  Which cities contribute most to sales?

•	  How does monthly revenue change over time?

•	  Which customers have never purchased?

•	  What proportion of orders are cancelled?

•	  Which customer segments contribute most to business revenue?

•	  Which products and categories generate the highest profit?

## 3. Project Objectives

•	 Explore and analyse structured retail data using PostgreSQL.

•	 Retrieve, filter, and aggregate customer and transaction records.

•  Evaluate sales revenue, costs, and profitability.

•	 Identify high-value customers and purchasing patterns.

•	 Analyse product, category, and geographical performance.

•	 Examine completed, pending, and cancelled orders.

•	 Apply advanced SQL techniques to solve business problems.

•	 Develop reusable reporting outputs and translate findings into recommendations.

## 4. Tools and Technologies
Tool	Purpose
PostgreSQL	Database management and SQL analysis
DBeaver	Database connection and query execution
SQL	Data extraction, transformation, and analysis
GitHub	Project documentation and version control

## Project Setup
1. Create the Database: Create a PostgreSQL database named retail_analytics.
2. Connect to the Database: Open DBeaver and establish a connection to your local PostgreSQL instance.
3. Create the Schema: Create a schema named retail.
4. Create the Tables: Run the SQL scripts to create the customers and orders tables.
5. Load the Data: Execute the INSERT statements, loading customer records before order records to maintain referential integrity.
6. Run the Analysis: Execute the SQL scripts (Q1–Q46) to explore the dataset and generate business insights.
## 5. Database and Dataset Structure
The database contains two relational tables: customers and orders.
Customers table
Stores customer registration and classification information.
Column	Description
customer_id	Unique customer identifier
customer_name	Customer name
gender	Recorded gender
city	Customer location
registration_date	Registration date
customer_segment	Retail, Corporate, or VIP
Orders table
Stores customer transaction and product information.
Column	Description
order_id	Unique order identifier
customer_id	Linked customer identifier
order_date	Transaction date
product_name	Purchased product
product_category	Product category
quantity	Units ordered
unit_price	Selling price per unit
cost_price	Cost per unit
discount	Discount percentage
payment_method	Payment method
order_status	Completed, Pending, or Cancelled
The tables are connected through customer_id, establishing a one-to-many relationship: one customer can have multiple orders.
Dataset details

It includes five product categories:

•	 Mobile Phones

•	 Computing

•	 Electronics

•	 Accessories

•	 Home Appliances

Payment methods include M-Pesa, Cash, Card, and Bank Transfer.

## 6. Data Preparation and Business Rules
The analysis considers data relationships, record completeness, appropriate data types, transaction statuses, and consistent aggregation.
The following calculation conventions are used:

Gross sales
quantity * unit_price
Discounted revenue
quantity * unit_price * (1 - discount / 100.0)
Cost of goods sold
quantity * cost_price
Profit
(quantity * unit_price * (1 - discount / 100.0))- (quantity * cost_price)
  
For realized revenue and profitability reporting, only Completed orders are included.

•	 Completed orders represent realized sales.

•	 Pending orders are analysed separately as outstanding activity.

•	 Cancelled orders are excluded from realized revenue and reported as an operational metric.

This distinction helps maintain consistency in business performance reporting.

## 7. SQL Analysis: 46 Business Questions
The analysis is organised into six sections, each demonstrating different SQL concepts and business applications.
Section	Questions	Focus
SQL Fundamentals	Q1–Q10	Data retrieval, filtering, sorting, and pattern matching
Aggregate Functions	Q11–Q20	Revenue, averages, counts, product performance, and cancellations
Joins and Customer Analytics	Q21–Q28	Customer spending, customer activity, segments, and geographical analysis
Subqueries and CTEs	Q29–Q34	Above-average spending, monthly performance, profitability, and inactivity
Window Functions	Q35–Q42	Ranking, cumulative revenue, month-over-month growth, and customer quartiles
Advanced Business Intelligence	Q43–Q46	Views, user-defined functions, customer segmentation, and management reporting

Key SQL techniques demonstrated

•	 SELECT, WHERE, ORDER BY, LIMIT, and DISTINCT

•	 Aggregate functions: SUM(), COUNT(), AVG(), MIN(), and MAX()

•	 GROUP BY and HAVING

•	 INNER JOIN and LEFT JOIN

•	 Subqueries and Common Table Expressions (CTEs)

•	 Window functions: ROW_NUMBER(), RANK(), DENSE_RANK(), LAG(), and NTILE()

•	 Date functions and time-based analysis

•	 Views and user-defined functions

•	 Index creation

## 8. Key Business Metrics

The project examines several performance indicators:
Metric	Business purpose
Total customers	Measures customer base size
Total orders	Measures transaction volume
Completed revenue	Measures realized sales
Average order value	Measures average transaction value
Profit	Measures revenue after product costs
Profit margin	Evaluates profitability
Cancellation rate	Measures cancelled orders as a proportion of total orders
Monthly revenue	Tracks sales performance over time
Customer spending	Identifies high-value customers
Category contribution	Compares product category performance
Customer inactivity	Supports customer retention analysis
## 9. Business Insights and Recommendations
The analysis supports several areas of business decision-making:
Product performance: Compare category revenue and profitability to guide inventory, pricing, and promotional decisions.
Customer retention: Identify high-value and inactive customers to support targeted engagement and loyalty initiatives.
Geographical performance: Compare revenue across cities to inform regional marketing and resource allocation.
Sales trends: Monitor monthly revenue to identify stronger and weaker periods and investigate unusual changes.
Order management: Track pending and cancelled orders to identify potential operational concerns.
Profitability: Evaluate product costs and discounts alongside revenue to avoid relying on sales volume alone when making business decisions.
These recommendations are analytical proposals; the dataset does not independently establish the causes of business trends or operational issues.
## 10. Database Performance
The project includes indexes on customer identifiers and order dates to support common lookup and filtering operations.
CREATE INDEX idx_orders_customer
ON retail.orders(customer_id);
CREATE INDEX idx_orders_date
ON retail.orders(order_date);
These indexes are relevant to customer joins, customer-level analysis, date filtering, and monthly reporting.
PostgreSQL's EXPLAIN ANALYZE can be used to inspect query execution and assess performance.
## 11. Screenshots and Visual Evidence
The repository will include screenshots demonstrating the database setup and analytical results.
The screenshots will pertain:
1.	Database and record-count verification.
2.	Revenue by product category.
3.	Revenue by city.
4.	Top five customers.
5.	Customer inactivity analysis.
6.	Monthly revenue trend.
These screenshots provide visual evidence of SQL execution and help communicate the analytical findings.
## 12. Skills Demonstrated

Technical skills

• 	PostgreSQL and relational database management.

•	 SQL querying and data aggregation.

•	 Joins, subqueries, and CTEs.

•	 Window functions and analytical ranking.

•	 Views and user-defined functions.

•	 Database indexing and query performance awareness.

Analytical skills

•	 Data exploration and validation.

•	 Revenue and profitability analysis.

•	 Customer segmentation and behaviour analysis.

•	 Sales trend analysis.

•	 Business problem-solving.

•	 Interpretation of results and business recommendations.

## 13. Limitations and Future Improvements
The project is based on synthetic data and is limited to the information available in the customer and order tables. It does not include detailed inventory, supplier, customer feedback, or marketing campaign records.
Potential improvements include:

• 	Integrating inventory and supplier data.

• 	Introducing sales forecasting.

•	  Implementing automated data-quality checks and scheduled reporting.

## 14. Conclusion

The Retail Sales & Customer Intelligence Using PostgreSQL project demonstrates how SQL can be applied to real-world business questions within a retail environment.
Through 46 structured queries, the project progresses from basic data exploration to advanced analytical techniques and reusable business intelligence outputs.
It demonstrates the use of transactional data to evaluate sales performance, customer behaviour, product profitability, geographical trends, and operational activity.
Most importantly, the project highlights that effective data analysis involves more than writing queries. It requires understanding business requirements, validating information, defining appropriate metrics, interpreting results, and communicating findings that support informed decision-making

## Business Insights and Recommendations
The business insights generated from this analyses is available on the link below:
[View Business Insights](Business_Insights.md)
