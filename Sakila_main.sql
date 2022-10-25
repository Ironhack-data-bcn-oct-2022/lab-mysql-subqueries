USE SAKILA;

-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?

SELECT title, COUNT(store_id)
FROM film_text
JOIN inventory
ON film_text.film_id= inventory.film_id
WHERE title = "Hunchback Impossible";

-- 2. List all films whose length is longer than the average of all the films.

SELECT title, length 
FROM film 
WHERE length>
(SELECT AVG(length) AS average
FROM film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name,last_name FROM actor
    WHERE actor_id IN (SELECT actor_id FROM film_actor 
        WHERE film_id IN (SELECT film_id FROM film 
                WHERE title = "Alone Trip"));
                
-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT title FROM film
    WHERE film_id IN (SELECT film_id FROM film_category 
        WHERE category_id IN (SELECT category_id FROM category
                WHERE name = "family"));
                
-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.¶

-- Subqueries
SELECT first_name, last_name, email FROM customer
    WHERE address_id IN (SELECT address_id FROM address
        WHERE city_id IN (SELECT city_id FROM city 
            WHERE country_id IN (SELECT country_id FROM country
                WHERE country = "Canada")));
                
-- Join
SELECT first_name, last_name, email 
	FROM customer
		JOIN address
			ON customer.address_id = address.address_id
		JOIN city
			ON address.city_id = city.city_id
		JOIN country
			ON city.country_id = country.country_id
			WHERE country = "Canada";
            
-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

CREATE TEMPORARY TABLE temp_table
(SELECT actor_id, COUNT(film_id) AS total_amount FROM film_actor
                        GROUP BY actor_id
                        ORDER BY total_amount DESC
                        LIMIT 1);
SELECT * FROM temp_table;
                        
SELECT title FROM film
        WHERE film_id IN
            (SELECT film_id FROM film_actor
                    WHERE actor_id = 107);
                    
-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments¶

CREATE TEMPORARY TABLE temp_table2
        SELECT customer_id, SUM(amount) AS Total_amount
            FROM payment
                GROUP BY customer_id;
                
SELECT customer_id, AVG(Total_amount) AS average
    FROM temp_table2
            GROUP BY customer_id
                ORDER BY average DESC;
SELECT title
    FROM film
        WHERE film_id IN (SELECT film_id
            FROM inventory
                WHERE store_id IN (SELECT store_id
                    FROM customer
                        WHERE customer_id = 526));
                        
-- 8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` spent by each client.

CREATE TEMPORARY TABLE temp_table3
SELECT customer_id, amount, SUM(amount) AS Total_amount
FROM payment
GROUP BY customer_id;

SELECT * 
FROM temp_table3
ORDER BY Total_amount DESC;

SELECT customer_id, Total_amount, AVG(Total_amount) AS average
FROM temp_table3;

SELECT customer_id, Total_amount
    FROM temp_table3
        WHERE Total_amount > 112.53182