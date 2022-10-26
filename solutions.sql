USE sakila;

-- Question. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT title AS Title, film.film_id AS `Film ID`, COUNT(inventory.store_id) as `Total films` FROM film
	JOIN inventory
    ON film.film_id = inventory.film_id
    WHERE title = "Hunchback Impossible";

-- Question 2. List all films whose length is longer than the average of all the films.

SELECT title, length FROM film
	WHERE length > (SELECT AVG(length) as `Average Length` FROM film)
	ORDER BY length DESC;

-- Question 3. Use subqueries to display all actors who appear in the film Alone Trip.

-- With joins

SELECT title, actor.first_name, actor.last_name FROM film
	JOIN film_actor
    ON film.film_id = film_actor.film_id
    JOIN actor
    ON film_actor.actor_id = actor.actor_id
    WHERE title = "Alone Trip";

-- With subqueries
SELECT actor_id FROM actor
WHERE actor_id IN 
	(SELECT actor_id FROM film_actor
		WHERE film_actor.film_id IN 
			(SELECT film.film_id FROM film 
				WHERE title = "Alone Trip"));

-- Question 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

-- With joins
SELECT title, category.name as Category FROM film
	JOIN film_category
		ON film.film_id = film_category.film_id
	JOIN category
		ON film_category.category_id = category.category_id
			WHERE category.name = "Family";

-- Question 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

-- With joins
SELECT first_name, last_name, email, country.country FROM customer
	JOIN address
		ON customer.address_id = address.address_id
	JOIN city
		ON address.city_id = city.city_id
	JOIN country
		ON city.country_id = country.country_id
			WHERE country = "Canada";

-- Question 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT actor.first_name, actor.last_name, COUNT(actor.actor_id) as `Total Films` FROM actor
	JOIN film_actor
		ON actor.actor_id = film_actor.actor_id
    JOIN film
		ON film_actor.film_id = film.film_id
	GROUP BY actor.actor_id
    ORDER BY `Total Films` DESC;
	
-- Question 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT customer.customer_ID, first_name, last_name, SUM(payment.amount) as `Total payments` from customer
	JOIN payment
		ON customer.customer_ID = payment.customer_ID
	GROUP BY customer_ID
    ORDER BY `Total payments` DESC
    LIMIT 1;

-- Question 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.



			