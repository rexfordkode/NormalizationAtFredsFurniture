-- Inspect the Data Task 1 - 4
SELECT *
FROM store 
LIMIT(10);

SELECT COUNT (DISTINCT(order_id))
FROM store;

SELECT COUNT (DISTINCT(customer_id))
FROM store;

SELECT customer_id, customer_email, customer_phone
FROM store
WHERE customer_id = 1;

--  Create a Normalized Version of the Database
CREATE TABLE customers AS
SELECT DISTINCT customer_id,customer_phone, customer_email
FROM store;

ALTER TABLE customers 
ADD PRIMARY KEY (customer_id);


CREATE TABLE items AS
SELECT DISTINCT item_1_id as item_id, item_1_name as name, item_1_price as price
FROM store
UNION
SELECT DISTINCT item_2_id as item_id, item_2_name as name, item_2_price as price
FROM store
WHERE item_2_id IS NOT NULL
UNION
SELECT DISTINCT item_3_id as item_id, item_3_name as name, item_3_price as price
FROM store
WHERE item_3_id IS NOT NULL;

CREATE TABLE orders_items AS 
SELECT DISTINCT order_id, item_1_id as item_id
FROM store
UNION  ALL
SELECT order_id, item_2_id as item_id
FROM store
WHERE order_id IS NOT NULL
UNION ALL
SELECT order_id, item_3_id as item_id
FROM store
WHERE order_id IS NOT NULL;

CREATE TABLE orders AS
SELECT order_id, order_date, customer_id
FROM store;

ALTER TABLE orders
ADD PRIMARY KEY (order_id);

ALTER TABLE orders
ADD FOREIGN KEY (customer_id) 
REFERENCES customers(customer_id);

ALTER TABLE orders_items 
ADD FOREIGN KEY (order_id) 
REFERENCES orders(order_id);

ALTER TABLE orders_items
ADD FOREIGN KEY (order_id ) 
REFERENCES orders(order_id);

-- Query your Databases!
SELECT customer_email
FROM store 
WHERE order_date > '2019-08-25';

SELECT customer_email
FROM customers, orders
WHERE customers.customer_id = orders.customer_id;


WITH all_items AS (
SELECT item_1_id as item_id 
FROM store
UNION ALL
SELECT item_2_id as item_id
FROM store
WHERE item_2_id IS NOT NULL
UNION ALL
SELECT item_3_id as item_id
FROM store
WHERE item_3_id IS NOT NULL
)
SELECT item_id, COUNT(*)
FROM all_items
GROUP BY item_id;

SELECT item_id, COUNT(*)
FROM orders_items
GROUP BY item_id;
