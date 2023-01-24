-- Exploring dataset
SELECT *
FROM nycrestaurant.food_order;

-- Looking at the different kinds of rating
SELECT DISTINCT(rating)
FROM nycrestaurant.food_order;

-- Looking at average rating of each restaurant
SELECT restaurant_name, AVG(rating) As `Average Rating`
FROM nycrestaurant.food_order
WHERE NOT rating ='Not given'
GROUP BY 1
ORDER BY 2 DESC;

-- Looking at total amount of orders
SELECT COUNT(*)
FROM nycrestaurant.food_order;

-- Looking at number of orders on weekday VS weekend
SELECT day_of_the_week, COUNT(*) As `Number of Orders`
FROM nycrestaurant.food_order
GROUP BY day_of_the_week;

-- Looking at number of orders from each restaurant
SELECT restaurant_name, COUNT(*) As `Number of orders`
FROM nycrestaurant.food_order
GROUP BY 1
ORDER BY 2 DESC;

-- Looking at number of orders of each cuisine type
SELECT cuisine_type, COUNT(*) As `Number of orders`
FROM nycrestaurant.food_order
GROUP BY 1
ORDER BY 2 DESC;

-- Looking at average food preparation time and delivery time of each restaurant
SELECT restaurant_name, cuisine_type, AVG(food_preparation_time) AS  `Average food preparation time`, AVG(delivery_time) AS `Average delivery time`
FROM nycrestaurant.food_order
GROUP BY 1,2
ORDER BY 3,4 ASC;

-- Looking at average waiting time of each restaurant
SELECT restaurant_name, cuisine_type, AVG(food_preparation_time + delivery_time) AS `Average Waiting Time`
FROM nycrestaurant.food_order
GROUP BY 1,2
ORDER BY 3 ASC;

-- Looking at average waiting time of each cuisine type
SELECT cuisine_type, AVG(food_preparation_time + delivery_time) AS `Average Waiting Time`
FROM nycrestaurant.food_order
GROUP BY 1
ORDER BY 2 ASC;

-- Looking at returning customer of each restaurant
WITH returningcustomer AS (SELECT *, ROW_NUMBER() OVER (
							PARTITION BY customer_id,restaurant_name,cuisine_type 
                            ORDER BY customer_id) AS row_num
FROM nycrestaurant.food_order),

returningcustomer2 AS (SELECT restaurant_name, COUNT(DISTINCT(customer_id)) AS `Returning Customers` 
FROM returningcustomer
WHERE row_num > 1
GROUP BY restaurant_name
ORDER BY 2 DESC)

SELECT n.restaurant_name, CASE
WHEN r.`Returning Customers` IS NOT NULL THEN r.`Returning Customers`
ELSE 0
END As `Returning Customers 0`
FROM returningcustomer2 r
RIGHT JOIN (SELECT restaurant_name
FROM nycrestaurant.food_order 
GROUP BY restaurant_name) n
ON n.restaurant_name = r.restaurant_name
ORDER BY 2 DESC;