-- 1) Total Customers
SELECT COUNT(*) AS total_customers FROM customers;
-- 2) Total Sellers
SELECT COUNT(*) AS total_sellers FROM sellers;
-- 3) Total Orders
SELECT COUNT(*) AS total_orders FROM orders;
-- 4) Total Products
SELECT COUNT(*) AS total_product FROM products;

-- 5) Order Status Distribution
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;
