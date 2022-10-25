USE sakila;

-- #1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film.title, count(inventory_id) as copies
FROM film
JOIN inventory
ON film.film_id = inventory.film_id
WHERE film.title = 'Hunchback Impossible';

-- with subquery
SELECT count(inventory_id) as copies
FROM inventory
WHERE film_id in (SELECT film_id FROM film WHERE title = 'Hunchback Impossible');

-- #2. List all films whose length is longer than the average of all the films.
SELECT film_id, title
FROM film
WHERE length > (SELECT avg(length) as average FROM film);

-- #3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id in 
	(SELECT actor_id FROM film_actor
		WHERE film_actor.film_id in 
			(SELECT film.film_id FROM film 
				WHERE title = "Alone Trip"));
                
-- #4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT film_id, title
FROM film
WHERE film_id in
	(SELECT film_id FROM film_category
		WHERE category_id in
			(SELECT category_id FROM category 
				WHERE name = "Family"));
                
-- #5. Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information.
SELECT first_name, last_name, email 
FROM customer
WHERE address_id in
	(SELECT address_id FROM address 
		WHERE city_id in
			(SELECT city_id FROM city
				WHERE country_id in
					(SELECT country_id FROM country
						WHERE country = "Canada")));

SELECT first_name, last_name, email 
FROM customer
JOIN address
ON customer.address_id = address.address_id
JOIN city
ON address.city_id = city.city_id
JOIN country
ON city.country_id = country.country_id
WHERE country = "Canada";

-- #6. Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT film_id, title
FROM film
WHERE film_id in
	(SELECT film_id FROM film_actor
		WHERE actor_id in 
			(SELECT actor_id FROM my_table));

-- Most prolific actor:
SELECT actor_id, count(actor_id) my_count FROM film_actor
				GROUP BY actor_id
				ORDER BY my_count DESC
				LIMIT 1;

-- Created a temporary table to store the most prolific actor, then Selected from this table:
CREATE TEMPORARY TABLE my_table
SELECT actor_id, count(actor_id) my_count FROM film_actor
				GROUP BY actor_id
				ORDER BY my_count DESC
				LIMIT 1;

-- #7. Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie 
-- the customer that has made the largest sum of payments
SELECT film_id, title
FROM film
WHERE film_id in
	(SELECT film_id FROM inventory
		WHERE inventory_id in
			(SELECT inventory_id FROM rental
				WHERE customer_id in
					(SELECT customer_id FROM my_customer)));

-- Most profitable customer:
SELECT customer_id, sum(amount) suma FROM payment
	GROUP BY customer_id
    ORDER BY suma DESC
    LIMIT 1;

CREATE TEMPORARY TABLE my_customer
SELECT customer_id, sum(amount) suma FROM payment
	GROUP BY customer_id
    ORDER BY suma DESC
    LIMIT 1;

-- #8. Get the client_id and the total_amount_spent of those clients who spent more than the average of 
-- the total_amount spent by each client.

SELECT customer_id, sum(amount)
FROM payment
GROUP BY customer_id
HAVING sum(amount) > (SELECT average FROM average_table);

-- Total_amount by customer
-- CREATE TEMPORARY TABLE total_amount
SELECT customer_id, sum(amount) suma FROM payment
GROUP by customer_id;

-- Avg of total_amounts
-- CREATE TEMPORARY TABLE average_table
SELECT avg(suma) average FROM total_amount;