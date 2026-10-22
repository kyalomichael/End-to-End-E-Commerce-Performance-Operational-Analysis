-- E-Commerce Performance Analysis: SQL queries (SQLite)
-- Table: kenya_shop_online_data (created by notebooks/01_cleaning_and_sql_analysis.ipynb)
-- Columns: InvoiceNo, InvoiceDate, Year, Quarter, MonthNum, MonthName,
--          CustomerID, CustomerType, Location, Product, Quantity, UnitPrice, TotalPrice,
--          OrderStatus ('Completed' or 'Cancelled'; cancelled orders have Quantity = 0)
-- Each block starts with "-- name: <query_name>" so the notebook can run them one by one.


-- name: kpis
-- Is the business healthy? Headline numbers.
SELECT
    ROUND(SUM(TotalPrice), 2)                                                          AS total_revenue,
    COUNT(DISTINCT InvoiceNo)                                                          AS total_orders,
    COUNT(DISTINCT CASE WHEN OrderStatus = 'Completed' THEN InvoiceNo END)             AS completed_orders,
    COUNT(DISTINCT CASE WHEN OrderStatus = 'Cancelled' THEN InvoiceNo END)             AS cancelled_orders,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN OrderStatus = 'Cancelled' THEN InvoiceNo END)
          / COUNT(DISTINCT InvoiceNo), 1)                                              AS cancellation_rate_pct,
    COUNT(DISTINCT CustomerID)                                                         AS unique_customers,
    ROUND(SUM(TotalPrice) * 1.0
          / COUNT(DISTINCT CASE WHEN OrderStatus = 'Completed' THEN InvoiceNo END), 2) AS avg_order_value
FROM kenya_shop_online_data;


-- name: monthly_trend
-- Which way is it trending? Revenue and orders by month, in calendar order.
SELECT
    MonthNum,
    MonthName,
    COUNT(DISTINCT InvoiceNo)                                              AS orders,
    ROUND(SUM(TotalPrice), 2)                                              AS revenue,
    ROUND(100.0 * SUM(TotalPrice) / SUM(SUM(TotalPrice)) OVER (), 1)       AS pct_of_year
FROM kenya_shop_online_data
GROUP BY MonthNum, MonthName
ORDER BY MonthNum;


-- name: first_four_months_vs_rest
-- How concentrated is the year? January-April compared with May-December.
SELECT
    CASE WHEN MonthNum <= 4 THEN 'Jan-Apr' ELSE 'May-Dec' END            AS period,
    COUNT(DISTINCT InvoiceNo)                                            AS orders,
    COUNT(DISTINCT CustomerID)                                           AS active_customers,
    ROUND(SUM(TotalPrice), 2)                                            AS revenue,
    ROUND(100.0 * SUM(TotalPrice)
          / (SELECT SUM(TotalPrice) FROM kenya_shop_online_data), 1)     AS pct_of_revenue
FROM kenya_shop_online_data
GROUP BY period
ORDER BY MIN(MonthNum);


-- name: revenue_by_product
-- What drives value? Revenue, orders and share by product.
SELECT
    Product,
    COUNT(DISTINCT InvoiceNo)                                          AS orders,
    SUM(Quantity)                                                      AS units_sold,
    ROUND(SUM(TotalPrice), 2)                                          AS revenue,
    ROUND(100.0 * SUM(TotalPrice) / SUM(SUM(TotalPrice)) OVER (), 1)   AS pct_of_revenue
FROM kenya_shop_online_data
GROUP BY Product
ORDER BY revenue DESC;


-- name: revenue_by_location
-- Which locations matter most?
SELECT
    Location,
    COUNT(DISTINCT CustomerID)                                         AS customers,
    COUNT(DISTINCT InvoiceNo)                                          AS orders,
    ROUND(SUM(TotalPrice), 2)                                          AS revenue,
    ROUND(100.0 * SUM(TotalPrice) / SUM(SUM(TotalPrice)) OVER (), 1)   AS pct_of_revenue
FROM kenya_shop_online_data
GROUP BY Location
ORDER BY revenue DESC;


-- name: segment_summary
-- Which customer segments carry the revenue, and who spends most per head?
WITH seg AS (
    SELECT
        CustomerType,
        COUNT(DISTINCT CustomerID) AS customers,
        SUM(TotalPrice)            AS revenue
    FROM kenya_shop_online_data
    GROUP BY CustomerType
)
SELECT
    CustomerType,
    customers,
    ROUND(100.0 * customers / SUM(customers) OVER (), 1) AS pct_of_customers,
    ROUND(revenue, 2)                                    AS revenue,
    ROUND(100.0 * revenue / SUM(revenue) OVER (), 1)     AS pct_of_revenue,
    ROUND(revenue / customers, 2)                        AS revenue_per_customer
FROM seg
ORDER BY revenue DESC;


-- name: top_customers
-- Who are the best customers? Top 10 by revenue.
SELECT
    CustomerID,
    MAX(CustomerType)             AS CustomerType,
    MAX(Location)                 AS Location,
    COUNT(DISTINCT CASE WHEN OrderStatus = 'Completed' THEN InvoiceNo END) AS completed_orders,
    ROUND(SUM(TotalPrice), 2)     AS revenue,
    MAX(CASE WHEN OrderStatus = 'Completed' THEN InvoiceDate END)          AS last_order
FROM kenya_shop_online_data
GROUP BY CustomerID
ORDER BY revenue DESC
LIMIT 10;


-- name: at_risk_customers
-- Who is at risk? Above-average spenders with no order in the last 90 days of the data.
WITH cust AS (
    SELECT
        CustomerID,
        MAX(CustomerType)         AS CustomerType,
        COUNT(DISTINCT InvoiceNo) AS orders,
        ROUND(SUM(TotalPrice), 2) AS revenue,
        MAX(InvoiceDate)          AS last_order
    FROM kenya_shop_online_data
    WHERE OrderStatus = 'Completed'
    GROUP BY CustomerID
),
ref AS (
    SELECT MAX(InvoiceDate) AS dataset_end FROM kenya_shop_online_data
)
SELECT
    c.CustomerID,
    c.CustomerType,
    c.orders,
    c.revenue,
    c.last_order,
    CAST(julianday(r.dataset_end) - julianday(c.last_order) AS INTEGER) AS days_since_last_order
FROM cust c
CROSS JOIN ref r
WHERE julianday(r.dataset_end) - julianday(c.last_order) > 90
  AND c.revenue >= (SELECT AVG(revenue) FROM cust)
ORDER BY c.revenue DESC
LIMIT 20;


-- name: cancellation_by_product
-- Where are orders being lost? Cancellation rate by product.
SELECT
    Product,
    COUNT(DISTINCT InvoiceNo)                                                  AS orders,
    COUNT(DISTINCT CASE WHEN OrderStatus = 'Cancelled' THEN InvoiceNo END)     AS cancelled,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN OrderStatus = 'Cancelled' THEN InvoiceNo END)
          / COUNT(DISTINCT InvoiceNo), 1)                                      AS cancellation_rate_pct
FROM kenya_shop_online_data
GROUP BY Product
ORDER BY cancellation_rate_pct DESC;


-- name: cancellation_by_location
-- Cancellation rate by location.
SELECT
    Location,
    COUNT(DISTINCT InvoiceNo)                                                  AS orders,
    COUNT(DISTINCT CASE WHEN OrderStatus = 'Cancelled' THEN InvoiceNo END)     AS cancelled,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN OrderStatus = 'Cancelled' THEN InvoiceNo END)
          / COUNT(DISTINCT InvoiceNo), 1)                                      AS cancellation_rate_pct
FROM kenya_shop_online_data
GROUP BY Location
ORDER BY cancellation_rate_pct DESC;


-- name: cancellation_by_customer_type
-- Cancellation rate by customer type.
SELECT
    CustomerType,
    COUNT(DISTINCT InvoiceNo)                                                  AS orders,
    COUNT(DISTINCT CASE WHEN OrderStatus = 'Cancelled' THEN InvoiceNo END)     AS cancelled,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN OrderStatus = 'Cancelled' THEN InvoiceNo END)
          / COUNT(DISTINCT InvoiceNo), 1)                                      AS cancellation_rate_pct
FROM kenya_shop_online_data
GROUP BY CustomerType
ORDER BY cancellation_rate_pct DESC;


-- name: cancellation_by_month
-- Cancellation rate by month, in calendar order.
SELECT
    MonthNum, MonthName,
    COUNT(DISTINCT InvoiceNo)                                                  AS orders,
    COUNT(DISTINCT CASE WHEN OrderStatus = 'Cancelled' THEN InvoiceNo END)     AS cancelled,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN OrderStatus = 'Cancelled' THEN InvoiceNo END)
          / COUNT(DISTINCT InvoiceNo), 1)                                      AS cancellation_rate_pct
FROM kenya_shop_online_data
GROUP BY MonthNum, MonthName
ORDER BY MonthNum;
