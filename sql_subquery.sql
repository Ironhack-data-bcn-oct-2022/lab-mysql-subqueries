USE sakila;

-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT count(*) as Copies_Hunckback_Impossible
FROM inventory
WHERE inventory.film_id in (SELECT film_id FROM film WHERE title = "Hunchback Impossible")
;

-- List all films whose length is longer than the average of all the films.
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);


-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id in 
	(SELECT actor_id 
	FROM film_actor JOIN film ON film_actor.film_id = film.film_id 
	WHERE film.title = "Alone Trip");

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT title
FROM film
WHERE film_id in 
	(SELECT film_id 
	FROM film_category JOIN category ON film_category.category_id = category.category_id
	WHERE category.name = "family");
    
-- Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys 
-- and foreign keys, that will help you get the relevant information.
SELECT first_name, last_name, email
	FROM customer JOIN address
	ON customer.address_id = address.address_id
		JOIN city
        ON address.city_id = city.city_id
			JOIN country
            ON city.country_id = country.country_id
            WHERE country.country = "Canada";

SELECT first_name, last_name, email
FROM customer
WHERE address_id in 
	(SELECT address_id 
    FROM address
    WHERE city_id in
		(SELECT city_id 
        FROM city
        WHERE country_id in
			(SELECT country_id
            FROM country
            WHERE country.country = "Canada")));
            
-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor 
-- that has acted in the most number of films. First you will have to find the most prolific actor 
-- and then use that actor_id to find the different films that he/she starred.
CREATE TEMPORARY TABLE my_table
SELECT actor_id
FROM film_actor
GROUP BY actor_id
ORDER BY COUNT(film_id) DESC
LIMIT 1;

SELECT title
FROM film
WHERE film_id in
	(SELECT film_id
    FROM film_actor
    WHERE actor_id in 
		(SELECT actor_id
        FROM actor
        WHERE actor_id in
			(SELECT actor_id
			FROM my_table)));
            
-- Films rented by most profitable customer. You can use the customer table and payment table 
-- to find the most profitable customer ie the customer that has made the largest sum of payments
CREATE TEMPORARY TABLE my_table2
SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1;

SELECT title
FROM film
WHERE film_id in 
	(SELECT film_id 
    FROM inventory
    WHERE inventory_id in
		(SELECT inventory_id
        FROM rental
        WHERE customer_id in 
			(SELECT customer_id
            FROM my_table2)));

-- Get the client_id and the total_amount_spent of those clients who spent more than the average of 
-- the total_amount spent by each client.
CREATE TEMPORARY TABLE sum_table
SELECT SUM(amount) AS SUM
    FROM payment 
    GROUP BY customer_id;    

CREATE TEMPORARY TABLE average_sum
SELECT AVG(SUM) 
FROM sum_table;

SELECT customer_id, sum(amount)
FROM payment
WHERE sum(amount) > average_sum.AVG(SUM)
GROUP BY customer_id;
