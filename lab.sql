use sakila;
SHOW FULL TABLES

-- Question 1: How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT COUNT(inventory_id) as Copies
FROM inventory
WHERE film_id in (SELECT film_id FROM film WHERE title = "Hunchback Impossible");

-- Question 2: List all films whose length is longer than the average of all the films

SELECT title, length
FROM film
WHERE length > (SELECT AVG(length)
FROM film);

-- Question 3: Use subqueries to display all actors who appear in the film Alone Trip.
SELECT *
FROM actor
WHERE actor_id in (SELECT actor_id FROM film_actor WHERE film_id in (SELECT film_id FROM film WHERE title = "Alone Trip"));


-- Question 4: Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT title
FROM film
WHERE film_id in (SELECT film_id FROM film_category WHERE category_id in (SELECT category_id FROM category WHERE name = "Family"));

-- Question 5: Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT first_name, last_name, email
FROM customer
WHERE address_id in (SELECT address_id FROM address WHERE city_id in (SELECT city_id FROM city WHERE country_id in (SELECT country_id FROM country WHERE country = "Canada")));


-- Question 6: Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

CREATE TEMPORARY TABLE temp_table_two
SELECT actor_id, COUNT(film_id) as film_counter
FROM film_actor
GROUP BY actor_id
ORDER BY film_counter DESC
LIMIT 1;

SELECT film_id,title
FROM film
WHERE film_id in (SELECT film_id FROM film_actor WHERE actor_id in (SELECT actor_id FROM temp_table_two));


-- Question 7: Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

CREATE TEMPORARY TABLE temp_table_three
SELECT customer_id, payment_id, sum(amount) as amount_paid
FROM payment
GROUP BY customer_id
ORDER BY amount_paid DESC
LIMIT 1;


SELECT film_id,title
FROM film
WHERE film_id in (SELECT inventory_id FROM rental WHERE customer_id in (SELECT customer_id FROM temp_table_three));

-- Question 8 (NOT FINISHED): Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

SELECT customer_id, SUM(amount) as total_amount_spent
FROM payment
WHERE SUM(amount) > 100;

SELECT customer_id, SUM(amount) as sum
FROM payment
WHERE SUM(amount) > 100
GROUP BY customer_id
ORDER BY sum DESC;


GROUP BY customer_id
WHERE SUM(amount) > "100000"
WHERE SUM(amount) > AVG(SUM(amount))
