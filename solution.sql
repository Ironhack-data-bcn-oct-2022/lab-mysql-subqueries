-- Instructions
-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT * FROM inventory;
SELECT film_id, title FROM film
	WHERE title = 'HUNCHBACK IMPOSSIBLE';

-- NEED TO USE SUBQUERIES 

SELECT count(*) AS Copies_Hunchback_Impossible
FROM inventory 
WHERE inventory.film_id IN (SELECT film_id FROM film WHERE title = "Hunchback Impossible");


-- 2. List all films whose length is longer than the average of all the films.

SELECT * 
FROM Film 
WHERE length > (SELECT AVG (length) FROM film);


-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT * FROM film;

SELECT * 
FROM actor 
WHERE actor_id IN (SELECT actor_id FROM film_actor WHERE film_id = "17");

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT * 
FROM category;
-- Family => category_id 8

SELECT title 
	FROM film 
    WHERE film_id in (SELECT film_id from film_category WHERE category_id = "8"); 


-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT * FROM customer;
SELECT * FROM address;
SELECT * FROM city; 
SELECT * FROM country;

SELECT customer.first_name, customer.last_name, customer.email
	FROM customer
	WHERE address_id in (
		SELECT address_id FROM address WHERE city_id in(
			SELECT city_id FROM city WHERE country_id in (
				SELECT country_id FROM country WHERE country="CANADA")));

SELECT *
FROM (SELECT first_name, last_name, email
FROM Customer
JOIN store
	ON customer.store_id = store.store_id
JOIN address 
	ON store.store_id = address.address_id  
JOIN city 
	ON address.city_id = city.city_id
JOIN country 
	ON city.country_id = country.country_id
WHERE country.country = "Canada") as Country;

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT * FROM actor; 
-- (here we have the actor_di) 
SELECT * FROM film_actor; 

SELECT actor_id, count(actor_id) FROM film_actor
GROUP BY (actor_id)
ORDER BY count(actor_id) desc;

SELECT actor_id, film.film_id, title
FROM film_actor 
JOIN film
ON film.film_id = film_actor.film_id
WHERE actor_id IN ( SELECT actor_id  FROM film_actor WHERE actor_id = "107");



-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT customer.customer_id, sum(amount), customer.first_name, customer.last_name FROM payment
JOIN customer
ON customer.customer_id = payment.customer_id
GROUP BY (customer_id)
ORDER BY sum(amount) desc
LIMIT 10;

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
SELECT customer.customer_id, sum(amount), customer.first_name, customer.last_name FROM payment
JOIN customer
ON customer.customer_id = payment.customer_id
WHERE amount in (SELECT amount FROM payment WHERE sum(amount) > AVG(sum(amount)))
GROUP BY (customer_id)
ORDER BY sum(amount) desc;


SELECT customer.customer_id, sum(amount), customer.first_name, customer.last_name FROM payment
JOIN customer
ON customer.customer_id = payment.customer_id
GROUP BY (customer.customer_id)
HAVING sum(amount) > AVG(sum(amount));