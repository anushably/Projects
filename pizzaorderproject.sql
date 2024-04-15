create database pizzaorder;

use pizzaorder;

create table pizza(
pizza_id int primary key,
pizza_name_id varchar(50)not null,
pizza_size enum('S','M','L','XL'),
pizza_category varchar(50)not null,
pizza_ingredients varchar(100),
pizza_name varchar(100)not null);

CREATE TABLE orderr (
    order_id INT PRIMARY KEY,
    quantity INT,
    order_date DATE,
    order_time TIME,
    unit_price FLOAT,
    total_price FLOAT,
    pizza_id INT,
    FOREIGN KEY (pizza_id) REFERENCES pizza(pizza_id)
);

drop table orderr;

select * from pizza;
select * from orderr;
SELECT COUNT(*) FROM orderr;

SELECT AVG(unit_price) FROM orderr;

SELECT 
    UPPER(pizza_name) AS uppercase_pizza_name
FROM 
    pizza;
    
SELECT CONCAT('Order ID: ', order_id, ', Quantity: ', quantity, ', Total Price: ',
total_price) AS order_details
FROM orderr;

SELECT order_id, quantity, unit_price, ROUND(unit_price, 2) AS rounded_unit_price
FROM orderr;

SELECT pizza_name, ABS(pizza_id) AS absolute_pizza_id
FROM pizza;

SELECT order_id, DATE_FORMAT(order_date, '%m-%Y-%d') AS formatted_order_date,
       TIME_FORMAT(order_time, '%H:%i:%s') AS formatted_order_time
FROM orderr;

SELECT COUNT(order_id) AS total_orders
FROM orderr;
SELECT SUM(quantity) AS total_quantity
FROM orderr;
SELECT MAX(unit_price) AS max_unit_price,
       MIN(unit_price) AS min_unit_price
FROM orderr;

SELECT
    pizza_name_id,
    pizza_id,
    SUM(pizza_id) OVER (ORDER BY pizza_id) AS running_total
FROM
    pizza;
    
SELECT 
    order_id, 
    CASE 
        WHEN total_price > 20 THEN 'High Value'
        WHEN total_price > 10 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS price_category
FROM 
    orderr;

SELECT 
    pizza_id,
    NULLIF(pizza_name, 'The Greek Pizza') AS updated_pizza_name
FROM 
    pizza;
-- 1.	How many pizzas have ingredients starting with the letter 'C'?
SELECT COUNT(*)
FROM pizza
WHERE pizza_ingredients LIKE 'C%';

-- 2.	List all pizzas where the length of the pizza_name is greater than 20 characters.
SELECT *
FROM pizza
WHERE LENGTH(pizza_name) > 20;


SELECT pizza_ingredients
FROM pizza
WHERE pizza_ingredients LIKE '%cheese%';

-- 3.	Display the pizza names with all characters converted to uppercase.
-- Display the pizza names with all characters converted to uppercase.
SELECT UPPER(pizza_name) AS uppercase_pizza_name
FROM pizza;

-- 4.	Calculate the total price of each order based on the unit price and quantity.
SELECT order_id, quantity, unit_price, total_price, unit_price * quantity 
AS calculated_total_price
FROM orderr;

-- 5.	Display the highest and lowest quantity of pizzas ordered.
select * from orderr;
SELECT MAX(quantity) AS highest_quantity, MIN(quantity) AS lowest_quantity
FROM orderr;

-- 6.	Determine the day of the week with the most orders.
SELECT DAYNAME(order_date) AS day_of_week, COUNT(*) AS num_orders
FROM orderr
GROUP BY DAYNAME(order_date)
ORDER BY num_orders DESC
LIMIT 1;

-- 7.	Find the orders made after 6 PM.
SELECT *
FROM orderr
WHERE HOUR(order_time) >= 18;

-- 8.	Count the number of distinct pizza categories.
SELECT COUNT(DISTINCT pizza_category) AS distinct_categories_count
FROM pizza;

SELECT AVG(unit_price) AS average_unit_price
FROM orderr;

-- 9.	Determine the number of orders placed per pizza category.
SELECT p.pizza_category, COUNT(o.order_id) AS num_orders
FROM orderr o
JOIN pizza p ON o.pizza_id = p.pizza_id
GROUP BY p.pizza_category;

-- 10.	Find the cumulative sum of total_price for each order.
SELECT order_id, 
       total_price,
       SUM(total_price) OVER (ORDER BY order_id) AS cumulative_total_price
FROM orderr;

-- 11.	If the unit price 
-- of a pizza is greater than 10, label it as 'Expensive', otherwise 'Affordable'.
SELECT p.pizza_id,
       p.pizza_name,
       CASE 
           WHEN o.unit_price > 10 THEN 'Expensive'
           ELSE 'Affordable'
       END AS price_category
FROM pizza p
JOIN orderr o ON p.pizza_id = o.pizza_id;

-- 12.	Assign a discount of 10% to orders with a total_price above 50.
SELECT order_id, 
       total_price, 
       CASE 
           WHEN total_price > 50 THEN total_price * 0.9  -- Apply 10% discount
           ELSE total_price 
       END AS discounted_price
FROM orderr;

-- 13.	Retrieve the pizza_name, order_date, and total_price of all orders.
SELECT pizza.pizza_name, orderr.order_date, orderr.total_price
FROM orderr
JOIN pizza ON orderr.pizza_id = pizza.pizza_id;

-- 14.	Retrieve the order_id, quantity, and unit price along with the pizza_name 
-- and pizza_category.
SELECT orderr.order_id, orderr.quantity, orderr.unit_price, pizza.pizza_name, pizza.pizza_category
FROM orderr
INNER JOIN pizza ON orderr.pizza_id = pizza.pizza_id;

-- 15.	Find the pizzas with the highest total_price among orders.
SELECT pizza.pizza_name, SUM(orderr.total_price) AS total_price
FROM orderr
INNER JOIN pizza ON orderr.pizza_id = pizza.pizza_id
GROUP BY pizza.pizza_name
ORDER BY total_price DESC
LIMIT 1;

-- 16.	List pizzas ordered at least once but never with 'mushrooms' as an ingredient.
SELECT DISTINCT pizza.pizza_name
FROM pizza
INNER JOIN orderr ON pizza.pizza_id = orderr.pizza_id
WHERE pizza.pizza_id NOT IN (
    SELECT DISTINCT pizza_id
    FROM pizza
    WHERE pizza_ingredients LIKE '%mushrooms%'
);

-- 17.	Calculate the total number of orders for each pizza category using a CTE.
WITH OrderCounts AS (
    SELECT p.pizza_category, COUNT(*) AS num_orders
    FROM pizza p
    INNER JOIN orderr o ON p.pizza_id = o.pizza_id
    GROUP BY p.pizza_category
)
SELECT * FROM OrderCounts;


CREATE VIEW PizzaView AS
SELECT pizza_id, pizza_name, pizza_category
FROM pizza;

CREATE VIEW PizzaSizeView AS
SELECT pizza_id, pizza_name, pizza_size
FROM pizza;
CREATE VIEW XLOrdersView AS
SELECT o.order_id, o.quantity, o.unit_price
FROM orderr o
JOIN pizza p ON o.pizza_id = p.pizza_id
WHERE p.pizza_size = 'XL';


-- 18.	Implement a procedure to calculate the total price of an order.
DELIMITER //

CREATE PROCEDURE CalculateTotalPrice (
    IN order_id INT
)
BEGIN
    DECLARE total_price DECIMAL(10, 2);

    SELECT SUM(unit_price * quantity) INTO total_price
    FROM orderr
    WHERE order_id = order_id;

    SELECT total_price;
END //

DELIMITER ;
CALL CalculateTotalPrice(123);

-- 19.	Implement a trigger to 
-- automatically update the total_price when the unit price or quantity of an order changes.
DELIMITER //

CREATE TRIGGER UpdateTotalPrice
AFTER UPDATE ON orderr
FOR EACH ROW
BEGIN
    DECLARE newTotalPrice FLOAT;
    SET newTotalPrice = NEW.unit_price * NEW.quantity;
    UPDATE orderr SET total_price = newTotalPrice WHERE order_id = NEW.order_id;
END //

DELIMITER ;
-- Update the unit price of an order
UPDATE orderr
SET unit_price = 15
WHERE order_id = 1;

-- Update the quantity of an order
UPDATE orderr
SET quantity = 2
WHERE order_id = 1;

select * from orderr;
SELECT * FROM orderr WHERE order_id = 1;

DROP TRIGGER IF EXISTS updatetotalprice;

CREATE INDEX idx_pizza_category ON pizza(pizza_category);
-- Before creating the index
EXPLAIN SELECT * FROM pizza WHERE pizza_category = 'Vegetarian';






