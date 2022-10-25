/*
Lab | SQL Subqueries
In this lab, you will be using the Sakila database of movie rentals. Create appropriate joins wherever necessary.
Instructions
1.How many copies of the film Hunchback Impossible exist in the inventory system?
2. List all films whose length is longer than the average of all the films.
3. Use subqueries to display all actors who appear in the film Alone Trip.
4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
8. Customers who spent more than the average payments.
*/

-- 1 How many copies of the film Hunchback Impossible exist in the inventory system?
Use sakila;
SELECT count(*) as Copies_Hunckback_Impossible
	FROM inventory
	WHERE inventory.film_id in (SELECT film_id FROM film WHERE title = "Hunchback Impossible")
    ;

-- 2. List all films whose length is longer than the average of all the films.   
SELECT film.title
	FROM film
	WHERE length > (SELECT AVG(length) FROM film);
    
-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT actor.first_name, actor.last_name
	FROM actor
    INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
    WHERE film_actor.film_id in (SELECT film_id FROM film WHERE title = "Alone Trip");    
    
-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.
SELECT film.title
FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
WHERE film_category.category_id in(SELECT category_id FROM category WHERE name = "Family");
    
-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins.
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT customer.first_name, customer.last_name, customer.email
	FROM customer
	WHERE address_id in (
		SELECT address_id FROM address WHERE city_id in(
			SELECT city_id FROM city WHERE country_id in (
				SELECT country_id FROM country WHERE country="CANADA")));
SELECT customer.first_name, customer.last_name, customer.email
	FROM customer
    INNER JOIN address ON customer.address_id = address.address_id
    INNER JOIN city ON address.city_id = city.city_id
    INNER JOIN country ON city.country_id = country.country_id
    WHERE country.country="CANADA";

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT title FROM film WHERE film_id IN (
SELECT film_id FROM inventory WHERE inventory_id IN 
(SELECT inventory_id FROM rental WHERE customer_id = 
(SELECT customer_id FROM (SELECT COUNT(rental_id) total_movies_rented, customer_id
FROM payment
GROUP BY customer_id
ORDER BY 1 DESC
LIMIT 1) AS rentals_cust
)));
    
-- 8. Customers who spent more than the average payments.
SELECT SUM(amount) as total_amount, customer_id
FROM payment
GROUP BY 2
HAVING SUM(amount) > (SELECT AVG(amount) FROM payment);