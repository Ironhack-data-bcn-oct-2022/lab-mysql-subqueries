USE sakila;
-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT count(*) as Copies_Hunckback_Impossible
	FROM inventory
	WHERE inventory.film_id in (SELECT film_id FROM film WHERE title = "Hunchback Impossible")
;
-- 2. List all films whose length is longer than the average of all the films.
SELECT film.title
	FROM film
	WHERE length > (SELECT AVG(length) FROM film)
;
-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT actor.first_name, actor.last_name
	FROM actor
    INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
    WHERE film_actor.film_id in (SELECT film_id FROM film WHERE title = "Alone Trip")
    ;
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