/*Section A — SQL fundamentals */
set search_path to retail;

--Q1: Retrieve all customer records.
select * from customers;
--Q2: Display customer names, cities, and segments.
select customer_name, city, customer_segment from customers;
--Q3: Find customers living in Nairobi.
select customer_id, customer_name, city from customers where city ='Nairobi';
--Q4: Find customers registered after January 1, 2025.
select customer_id,customer_name from customers where registration_date > '01-01-2025';
--Q5: Display all unique customer cities.
select distinct city  from customers;
--Q6: Retrieve the 10 most recent orders.
select * from orders;
select * from orders order by order_date desc limit 10;
--Q7: Find orders with unit prices above KSh 10,000.
select * from orders where unit_price>10000;
--Q8: Find customers whose names start with A.
select customer_name from customers where customer_name ilike 'A%';
--Q9: Retrieve orders with quantities between 2 and 5.
select order_id, product_name,product_category, quantity from orders where quantity > 2 and quantity < 5;
--Q10: Find orders paid through M-Pesa.
select * from orders where payment_method ='M-Pesa';
/*Section B — Aggregation and grouping */
--Q11: Count all customers.
select count(*) from customers;
--Q12: Count all orders.
select count(*) from orders;
--Q13: Calculate completed-order revenue.
select ROUND(SUM(quantity * unit_price * (1 - discount / 100)), 2) AS completed_revenue FROM orders WHERE order_status = 'Completed';
--REDO:Q14: Calculate the average completed-order value.
----REDO:select avg(order_status) from orders where order_status ='Completed';
--Q15: Find the highest and lowest product prices.
select * from orders;
select product_name,cost_price from orders group by product_name,cost_price order by cost_price desc limit 1;
select product_name,cost_price from orders group by product_name, cost_price order by cost_price asc limit 1;
--Q16: Calculate revenue by product category.
select product_category, round(sum(quantity * unit_price * (1 - discount / 100)), 2) as revenue from orders group by product_category;

--Q17: Count customers by city.
select city,count(customer_id) from customers group by city;

--Q18: Calculate quantity sold by product.
select product_name, sum(quantity) as quantity_sold from orders group by product_name;
--Q19: Find categories generating more than KSh 100,000 in revenue.
select product_category, ROUND(SUM(quantity * unit_price * (1 - discount / 100)), 2) as revenue 
from orders group by product_category having ROUND(SUM(quantity * unit_price * (1 - discount / 100)), 2) >100000;
--Q20: Calculate the percentage of cancelled orders.
SELECT
    order_status,
    COUNT(*) AS total_cancelled,
    ROUND(COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM orders), 2) AS percentage
FROM orders
WHERE order_status = 'Cancelled'
GROUP BY order_status;
-------REDO AND FIND ANSWERS

---------SECTION C-------Joins and customer analytics----
select * from customers c;
select * from orders o;
--Q21: Display orders with customer names and cities.
select c.customer_name, c.city,
o.order_id, o.customer_id, 
o.order_date,o.product_name, 
o.product_category,o.quantity, o.unit_price, 
o.cost_price,o.discount,o.payment_method,
o.order_status
from customers c
left join orders o 
on c.customer_id=o.customer_id;

--Q22: Calculate total spending by customer.
SELECT
    c.customer_id,
    c.customer_name,
    ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount / 100)), 2) AS total_spending
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC;

--Q23: Identify customers who have never ordered.
select  c.customer_id,c.customer_name
from customers c 
left join orders o
on c.customer_id=o.customer_id
where order_status is null;
--Q24: Find the 10 highest-spending customers.
select  c.customer_id,c.customer_name,  o.unit_price*o.quantity*((1 - o.discount / 100)) as highest_money_spent_by_customer
from customers c
inner join orders o
on c.customer_id= o.customer_id
group by c.customer_id,c.customer_name, o.unit_price*o.quantity*((1 - o.discount / 100)) order by highest_money_spent_by_customer desc limit 10 ;
--Q25: Calculate revenue by customer city.
select city, ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount / 100)), 2) as revenue 
from customers c 
left join orders o
on c.customer_id=o.customer_id
group by city;
--Q26: Identify customers with more than five orders.
select c.customer_id, c.customer_name, o.order_id, o.quantity
from customers c 
left join orders o
on c.customer_id=o.customer_id
where o.quantity>5;
--Q27: Calculate average customer spending by segment.
select c.customer_segment,ROUND(avg(o.quantity * o.unit_price * (1 - o.discount / 100)), 2) as average_customer_spending
from customers c
left join orders o
on c.customer_id=o.customer_id
group by c.customer_segment;

--Q28: Identify the most popular category among VIP customers.
select c.customer_segment, o.product_category,sum(o.quantity) as no_of_quantity_purchased
from customers c
inner join orders o
on o.customer_id=c.customer_id
group by c.customer_segment, o.product_category having customer_segment='VIP' order by no_of_quantity_purchased desc limit 1 ;

----------D---------Subqueries and CTEs
select * from customers c;
select * from orders o;
--Q29: Find customers spending above the average total spending per purchasing customer.

select c.customer_id, c.customer_name, SUM(o.quantity * o.unit_price * (1 - o.discount / 100)) AS total_spending
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.quantity * o.unit_price * (1 - o.discount / 100)) >
(SELECT AVG(customer_total) from ( SELECT customer_id,
SUM(quantity * unit_price * (1 - discount / 100)) AS customer_total
FROM orders o
GROUP BY customer_id) AS customer_spending);


--Q30: Find products priced above the overall average unit price.
select product_name,product_category,unit_price from orders where unit_price>(select avg(unit_price) from orders);

--Q31: Use a CTE to identify the three highest-revenue months.
WITH monthly_revenue AS (
    SELECT
        extract(month from order_date) AS sales_year_month,
        ROUND(
            SUM(quantity * unit_price *
                (1 - discount / 100.0)), 2
        ) AS revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY extract(month from order_date)
)
SELECT *
FROM monthly_revenue
ORDER BY revenue desc limit 3 ;

--Q32: Find customers purchasing from at least three categories.
with purchases as(
select c.customer_name, c.customer_id, count(distinct o.product_category) as no_of_product_category_purchased_from
from customers c
inner join orders o
on c.customer_id=o.customer_id
group by c.customer_name, c.customer_id)
select customer_id,customer_name, no_of_product_category_purchased_from 
from purchases 
where no_of_product_category_purchased_from > 3;

--Q33: Use a CTE to calculate category revenue, cost, profit, and profit margin.


WITH calculation AS (

    SELECT 
        o.product_category,

        ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount / 100)), 2) AS category_revenue,

        ROUND(SUM(o.quantity * o.cost_price), 2) AS category_cost,

        ROUND(
            SUM(o.quantity * o.unit_price * (1 - o.discount / 100))
            - SUM(o.quantity * o.cost_price), 2
        ) AS category_profit,
        ROUND(
            (SUM(o.quantity * o.unit_price * (1 - o.discount / 100))
            - SUM(o.quantity * o.cost_price))
            / NULLIF(SUM(o.quantity * o.unit_price * (1 - o.discount / 100)), 0) * 100, 2
        ) AS category_profit_margin
    FROM orders o
    GROUP BY o.product_category
)
SELECT 
    product_category,
    category_revenue,
    category_cost,
    category_profit,
    category_profit_margin
FROM calculation;
--Q34: Find customers whose latest completed order is more than 90 days before the latest order date in the dataset.
WITH latest_order AS (

    SELECT MAX(order_date) AS latest_order_date
    FROM orders
),
latest_completed AS (

    SELECT 
        customer_id,
        MAX(order_date) AS latest_completed_order
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    lc.latest_completed_order,
    lo.latest_order_date
FROM customers c
JOIN latest_completed lc
    ON c.customer_id = lc.customer_id
CROSS JOIN latest_order lo
WHERE lc.latest_completed_order < lo.latest_order_date - INTERVAL '90 days';

-------E----

--Q35. Rank customers by spending using `RANK()`.
SELECT
    c.customer_id,
    c.customer_name,
    ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount / 100)), 2) AS total_spending,
    RANK() OVER (
        ORDER BY SUM(o.quantity * o.unit_price * (1 - o.discount / 100)) DESC
    ) AS spending_rank
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;
--Q36. Number each customer's orders by recency using `ROW_NUMBER()`.
SELECT
    customer_id,
    order_id,
    order_date,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY order_date DESC
    ) AS order_rank
FROM orders;
--Q37. Rank products within categories using `DENSE_RANK()`.
SELECT
    product_name,
    product_category,
    unit_price,
    DENSE_RANK() OVER (
        PARTITION BY product_category
        ORDER BY unit_price DESC
    ) AS product_rank
FROM orders;
--Q38. Calculate cumulative monthly revenue.
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        ROUND(SUM(quantity * unit_price * (1 - discount / 100)), 2) AS revenue
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    month,
    revenue,
    ROUND(
        SUM(revenue) OVER (ORDER BY month), 2
    ) AS cumulative_revenue
FROM monthly_revenue
ORDER BY month;
--Q39. Compare monthly revenue using `LAG()`.
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        ROUND(SUM(quantity * unit_price * (1 - discount / 100)), 2) AS revenue
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
    revenue - LAG(revenue) OVER (ORDER BY month) AS revenue_difference
FROM monthly_revenue
ORDER BY month;
--Q40. Calculate month-over-month revenue growth (%).
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        ROUND(SUM(quantity * unit_price * (1 - discount / 100)), 2) AS revenue
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100,
        2
    ) AS mom_growth_percentage
FROM monthly_revenue
ORDER BY month;
--Q41. Divide customers into four spending groups using `NTILE(4)`.
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount / 100)), 2) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_spending,
    NTILE(4) OVER (ORDER BY total_spending DESC) AS spending_group
FROM customer_spending
ORDER BY total_spending DESC;

--------------F-------
--Q42. Calculate each category's share of total revenue using window functions.
WITH category_revenue AS (
    SELECT
        product_category,
        ROUND(SUM(quantity * unit_price * (1 - discount / 100)), 2) AS revenue
    FROM orders
    GROUP BY product_category
)
SELECT
    product_category,
    revenue,
    ROUND(
        revenue / SUM(revenue) OVER () * 100,
        2
    ) AS revenue_share_percentage
FROM category_revenue
ORDER BY revenue DESC;
--Q43. Create a `monthly_sales_summary` view (month, orders, revenue, cost, profit). Then `SELECT` from it.
CREATE VIEW The_monthly_sales_summary AS
SELECT
    DATE_TRUNC('month', order_date) AS month,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(quantity * unit_price * (1 - discount / 100)), 2) AS revenue,
    ROUND(SUM(quantity * cost_price), 2) AS cost,
    ROUND(
        SUM(quantity * unit_price * (1 - discount / 100))
        - SUM(quantity * cost_price),
        2
    ) AS profit

FROM orders
GROUP BY DATE_TRUNC('month', order_date);

SELECT *
FROM monthly_sales_summary
ORDER BY month;
--Q44. Create a PostgreSQL function that returns completed-order revenue for a supplied customer ID. Show
    --it working for one customer **and** for an ID that does not exist (it should return 0, not NULL).

CREATE OR REPLACE FUNCTION customer_completed_revenue(p_customer_id INT)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    total_revenue NUMERIC;
BEGIN
    SELECT
        COALESCE(
            SUM(quantity * unit_price * (1 - discount / 100)),
            0
        )
    INTO total_revenue
    FROM orders
    WHERE customer_id = p_customer_id
      AND order_status = 'Completed';

    RETURN total_revenue;
END;
$$;

SELECT customer_completed_revenue(15);

--Q45. Segment customers into High, Medium and Low Value. **Explain why you chose your thresholds** — for
    --example percentiles, or round KSh amounts based on what the data looks like.

WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COALESCE(
            SUM(o.quantity * o.unit_price * (1 - o.discount / 100)),
            0
        ) AS total_spending
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
),
customer_segments AS (
    SELECT
        customer_id,
        customer_name,
        total_spending,
        NTILE(3) OVER (ORDER BY total_spending DESC) AS spending_group
    FROM customer_spending
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_spending, 2) AS total_spending,
    CASE
        WHEN spending_group = 1 THEN 'High Value'
        WHEN spending_group = 2 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment,
    COUNT(*) OVER (PARTITION BY spending_group) AS customers_in_segment
FROM customer_segments
ORDER BY total_spending DESC;

/*I chose percentile-based thresholds using NTILE(3) because they are based on the actual customer spending distribution rather than arbitrary KSh amounts.
- High Value: Top 33.3% of customers with the highest total spending.
- Medium Value: Middle 33.3% of customers with moderate spending.
- Low Value: Bottom 33.3% of customers with the lowest spending.
Justification: This approach divides customers into approximately equal-sized groups, making it easier for management to identify the most valuable customers, compare spending patterns, and develop targeted customer retention strategies.*/

--Q46. Produce a management report: the top five customers, top five products, the most profitable
   -- category, and the lowest-revenue month.

-- MANAGEMENT REPORT

-- 1. TOP FIVE CUSTOMERS BY REVENUE

SELECT
    c.customer_id,
    c.customer_name,c.customer_segment,
    ROUND(
        SUM(o.quantity * o.unit_price * (1 - o.discount / 100)),
        2
    ) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name,c.customer_segment
ORDER BY total_revenue DESC
LIMIT 5;


-- 2. TOP FIVE PRODUCTS BY REVENUE

SELECT
    product_name,
    ROUND(
        SUM(quantity * unit_price * (1 - discount / 100)),
        2
    ) AS total_revenue
FROM orders
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 5;


-- 3. MOST PROFITABLE CATEGORY

SELECT
    product_category,
    ROUND(
        SUM(quantity * unit_price * (1 - discount / 100))
        - SUM(quantity * cost_price),
        2
    ) AS total_profit
FROM orders
GROUP BY product_category
ORDER BY total_profit desc
limit 1;


-- 4. LOWEST-REVENUE MONTH

SELECT
    month,
    revenue
FROM monthly_sales_summary
ORDER BY revenue ASC
LIMIT 1;




