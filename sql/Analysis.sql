-- =========================================
-- 1) Total Real Customers 
-- Q: How many unique real customers are registered on the platform?
-- ========================================= 
SELECT COUNT(DISTINCT customer_unique_id) AS total_real_customers
FROM customers;
-- Insight:
-- Olist has 96,069 unique real customers, indicating a large and diverse customer base.

-- =========================================
-- 2) Payment Method Distribution
-- Q: Which payment method is used most frequently by customers? 
-- ========================================= 
SELECT payment_type, COUNT(*) AS total_transactions
FROM payments
GROUP BY payment_type
ORDER BY total_transactions DESC; 
-- Insight:
-- Credit card is the most frequently used payment method, indicating strong customer preference for flexible payment options and installment-based purchases.  

-- =========================================
-- 3) Top 10 Customers by Spending 
-- Q: Which customers contribute the highest total spending? 
-- ========================================= 
SELECT TOP 10 o.customer_id, SUM(oi.price + oi.freight_value) AS total_spent
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_spent DESC;
-- Insight:
-- A small number of customers contribute a large portion of total spending, indicating the importance of high-value customers to overall revenue. 

-- =========================================
-- 4) Top 10 Products by Revenue 
-- Q: Which products contribute the highest revenue? 
-- ========================================= 
SELECT TOP 10 p.product_id, 
MAX(p.product_category_name) AS product_category,
SUM(oi.price) AS total_revenue
FROM order_items oi 
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_revenue DESC;
-- Insight:
-- A small number of products generate a significant portion of total revenue, indicating strong sales concentration among top-performing products. 
-- Beauty & Health (beleza_saude) is the highest revenue-generating product category, indicating strong customer demand for health and personal care products. 

-- =========================================
-- 5) Top 10 Sellers by Revenue  
-- Q: Which sellers generate the highest revenue?  
-- ========================================= 
SELECT TOP 10 seller_id, SUM(price + freight_value) AS total_revenue
FROM order_items
GROUP BY seller_id
ORDER BY total_revenue DESC;
-- Insight:
-- Revenue is concentrated among a small number of top-performing sellers.
-- The top seller generated total revenue of 249,640.70, indicating a strong contribution to overall sales. 

-- =========================================
-- 6) Monthly Trend Order 
-- Q: What is the monthly order trend over time? 
-- ========================================= 
SELECT  YEAR(order_purchase_timestamp) AS year, MONTH(order_purchase_timestamp) AS month, COUNT(*) AS total_orders
FROM orders
GROUP BY 
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
ORDER BY year, month;
-- Insight:
-- The data shows a monthly order trend from September 2016 to October 2018. 
-- Order volume peaked in November 2017 with 7,544 total orders, indicating a significant increase in customer purchasing activity during that period. 

-- =========================================
-- 7) Total Revenue and Monthly Revenue Trend 
-- Q: What is the total revenue and how does revenue change over time? 
-- ========================================= 
-- Total Revenue 
SELECT SUM(price + freight_value) AS total_revenue
FROM order_items;
-- Monthly Revenue 
SELECT 
    YEAR(o.order_purchase_timestamp) AS year,
    MONTH(o.order_purchase_timestamp) AS month,
    SUM(oi.price + oi.freight_value) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY 
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY year, month;
-- Insight:
-- Total revenue reached 15,843,553.24. 
-- Monthly revenue peaked in November 2017 with total revenue of 1,179,143.77.

-- =========================================
-- 8) Average Order Value 
-- Q:What is the average order value? 
-- ========================================= 
SELECT DISTINCT AVG(SUM(price + freight_value)) OVER () AS avg_order_value
FROM order_items
GROUP BY order_id;
-- Insight:
-- The average order value is 160.58, indicating the typical amount customers spend per transaction. 

-- =========================================
-- 9) Delivery Delay Analysis 
-- Q:How many delivery delays happened? 
-- ========================================= 
SELECT COUNT(*) AS late_orders
FROM orders
WHERE order_delivered_customer_date > order_estimated_delivery_date;

SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders
        WHERE order_delivered_customer_date IS NOT NULL
    ) AS late_percentage
FROM orders
WHERE order_delivered_customer_date > order_estimated_delivery_date;
-- Insight:
-- Approximately 8.1% of delivered orders arrived later than the estimated delivery date, indicating potential issues in delivery performance and customer experience.

-- =========================================
-- 10) Repeat Customer Rate 
-- Q: What percentage of customers make more than one order? 
-- ========================================= 
WITH customer_orders AS (
    SELECT 
        c.customer_unique_id,
        COUNT(o.order_id) AS total_orders
    FROM orders o
    JOIN customers c 
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT 
    COUNT(CASE WHEN total_orders > 1 THEN 1 END) * 100.0 
    / COUNT(*) AS repeat_customer_rate
FROM customer_orders;
-- Insight:
-- The repeat customer rate is relatively low at 3.12%, indicating that most customers make only one purchase.
-- This suggests an opportunity to improve customer retention and encourage repeat purchases. 


