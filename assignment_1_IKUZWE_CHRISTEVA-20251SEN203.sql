PL/SQL ASSIGNMENT ONE - SUNRISE SUPERMARKET
Student Name: IKUZWE Christeva
Student ID:20251SEN203
Group:B 
DBMS: MySQL
Platform:OneCompiler
============================================

============================================
1. CREATE TABLES
============================================
CREATE TABLE customers (
customer_id INT PRIMARY KEY,
customer_name VARCHAR(100),
email VARCHAR(100),
city VARCHAR(50)
);
CREATE TABLE products (
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
category VARCHAR(50),
price DECIMAL(10,2)
);
CREATE TABLE orders (
order_id INT PRIMARY KEY,
customer_id INT,
order_date DATE,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE order_items (
order_item_id INT PRIMARY KEY,
order_id INT,
product_id INT,
quantity INT,
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
);

=============================================
INSERT INTO CUSTOMER
=============================================
INSERT INTO customers (customer_id, customer_name, email, city) VALUES
(1, 'Alice Uwase', 'alice@gmail.com', 'Kigali'), 
(2, 'Brian Niyonzima', 'brian@gmail.com', 'Huye'), 
(3, 'Claudine Mukamana', 'claudine@gmail.com', 'Musanze'), 
(4, 'David Habimana', 'david@gmail.com', 'Kigali'), 
(5, 'Eric Ishimwe', 'eric@gmail.com', 'Rubavu'), 
(6, 'Grace Ingabire', 'grace@gmail.com', 'Kigali');

=============================================
3.INSERT PRODUCTS
=============================================
INSERT INTO products (product_id,product_name,category,price)VALUES
(1,'Milk','Dairy',1200.00),
(2,'cheese','Dairy',4500.00),
(3,'Bread','Bakery',1500.00),
(4,'Croissant','Bakery',2000.00),
(5,'Rice','Grains',3000.00),
(6,'Wheat Flour','Grains',2500.00),
(7,'Apple Juice','Beverages',2500.00),
(8,'Orange Juice','Beverages',2800.00),
(9,'Coffee','Beverages',3500.00),
(10,'Butter','Dairy',3200.00);

=============================================
4.INSERT ORDERS
=============================================
INSERT INTO orders (order_id,customer_id,order_date)VALUES
(1,1,'2026-09-01'),
(2,2,'2026-09-02'),
(3,3,'2026-09-03'),
(4,1,'2026-09-05'),
(5,4,'2026-09-06'),
(6,5,'2026-09-08'),
(7,2,'2026-09-10'),
(8,6,'2026-09-11'),
(9,3,'2026-09-13'),
(10,1,'2026-09-15'),
(11,4,'2026-09-16'),
(12,5,'2026-09-18'),
(13,6,'2026-09-19'),
(14,2,'2026-09-20'),
(15,1,'2026-09-21');

=============================================
5.INSERT ORDER ITEMS
=============================================
INSERT INTO order_items (order_item_id,order_id,product_id,quantity)VALUES
(1,1,1,2),
(2,1,3,1),
(3,2,5,2),
(4,2,7,1),
(5,3,2,1),
(6,3,4,2),
(7,4,8,2),
(8,4,10,1),
(9,5,6,3),
(10,5,3,2),
(11,6,9,2),
(12,6,1,3),
(13,7,5,3),
(14,7,2,1),
(15,8,7,2),
(16,8,4,1),
(17,9,10,2),
(18,9,6,1),
(19,10,9,3),
(20,10,8,2),
(21,11,3,4),
(22,11,1,2),
(23,12,5,2),
(24,12,7,2),
(25,13,2,2),
(26,13,10,1),
(27,14,6,2),
(28,14,9,1),
(29,15,8,3),
(30,15,4,2);

=====================================================
6.JOIN QUERY 1
List every order customer name, city, and order date.
=====================================================
SELECT
    orders.order_id,
    customers.customer_name,
    customers.city,
    orders.order_date
FROM orders
INNER JOIN customers
    ON orders.customer_id = customers.customer_id
ORDER BY orders.order_date;

===============================================
7.JOIN QUERY 2
List every order item with product information
===============================================
SELECT 
    order_items.order_item_id,
    products.product_name,
    products.category,
    products.price,
    order_items.quantity
FROM order_items
INNER JOIN products
    ON order_items.product_id = products.product_id
ORDER BY order_items.order_item_id;

=======================================================
8.JOIN QUERY 3
List all customers and their orders, including customer
who have no order
=======================================================
SELECT
    customers.customer_id,
    customers.customer_name,
    customers.city,
    orders.order_id,
    orders.order_date
FROM customers
LEFT JOIN orders
    ON customers.customer_id = orders.customer_id
ORDER BY customers.customer_id, orders.order_date;

===================================================
9.CTE QUERY
Calculate each customer's total spending and return
customers whose spending is above the average
===================================================
WITH customer_totals AS(
     SELECT
     c.customer_id,
     c.customer_name,
     SUM(oi.quantity*p.price)AS total_spend
FROM customers c
JOIN orders o
     ON c.customer_id = o.customer_id
JOIN order_items oi
     ON o.order_id =oi.order_id
JOIN productS p
     ON oi.product_id = p.product_id
GROUP BY
     c.customer_id,
     c.customer_name
)
SELECT 
     customer_id,
     customer_name,
     total_spend
FROM customer_totals
WHERE total_spend > (
    SELECT AVG(total_spend)
    FROM customer_totals
)
ORDER BY total_spend DESC;

==============================================
10.WINDOW QUERY 1
Rank customers by total amount spent
==============================================
WITH customer_totals AS (
     SELECT
        c.customer_id, 
        c.customer_name, 
        SUM(oi.quantity * p.price) AS total_spend
 FROM customers c
 JOIN orders o 
        ON c.customer_id = o.customer_id 
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id 
GROUP BY
     c.customer_id,
     c.customer_name 
) 
SELECT
    customer_id, 
    customer_name, 
    total_spend, 
    RANK() OVER (ORDER BY total_spend DESC) AS spending_rank 
FROM customer_totals 
ORDER BY spending_rank;

============================================================ 
11. WINDOW QUERY 2 -- Number each customer's orders in the 
order they were placed. 
============================================================
 SELECT
     c.customer_id, 
     c.customer_name,
     o.order_id,
     o.order_date, 
ROW_NUMBER() OVER ( 
     PARTITION BY c.customer_id 
     ORDER BY o.order_date 
) AS order_number 
FROM customers c 
JOIN orders o 
     ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;
=======================================================
12. WINDOW QUERY 3
Show the running total of revenue over time.
=======================================================
WITH order_revenue AS (
    SELECT 
        o.order_id, 
        o.order_date, 
        SUM(oi.quantity * p.price) AS order_revenue 
FROM orders o 
JOIN order_items oi 
   ON o.order_id = oi.order_id 
JOIN products p 
   ON oi.product_id = p.product_id 
GROUP BY
    o.order_id,
    o.order_date
 )
SELECT
   order_id, 
   order_date, 
   order_revenue, 
   SUM(order_revenue) OVER ( 
       ORDER BY order_date, order_id 
   ) AS running_total_revenue 
FROM order_revenue
ORDER BY order_date, order_id;

========================================================
13.WINDOWS QUERY 4
Show the number of days between each customer's orders.
========================================================
WITH customer_orders AS (
   SELECT 
       c.customer_id, 
       c.customer_name, 
       o.order_id, 
       o.order_date, 
       LAG(o.order_date) OVER (
          PARTITION BY c.customer_id
          ORDER BY o.order_date 
      ) AS previous_order_date
 FROM customers c 
JOIN orders o
   ON c.customer_id = o.customer_id 
) 
SELECT 
    customer_id, 
    customer_name, 
    order_id, 
    order_date, 
    previous_order_date, 
    DATEDIFF(order_date, previous_order_date) AS days_between_orders 
FROM customer_orders
WHERE previous_order_date IS NOT NULL 
ORDER BY customer_id, order_date;
