use sakila;


-- Challenge 1 --
SELECT f.title AS Title, COUNT(i.film_id) AS Copies
	FROM inventory AS i
    JOIN film AS f
		ON f.film_id = i.film_id
	WHERE f.title = 'Hunchback Impossible';


-- Challenge 2 --
SELECT f.title AS Title, f.length AS Duration
	FROM film as f
    WHERE f.length > (SELECT AVG(length) FROM film)
    ORDER BY Duration DESC;

    
-- Challenge 3 --
SELECT first_name, last_name
	FROM actor AS a
    LEFT JOIN film_actor AS fa
		ON fa.actor_id = a.actor_id
	WHERE fa.film_id = (SELECT film_id FROM film WHERE film.title='Alone Trip');
    

-- Challenge 4 --
SELECT f.title AS Title
	FROM film AS f
	LEFT JOIN film_category AS fc
		ON fc.film_id = f.film_id
	WHERE fc.category_id = (SELECT category_id FROM category WHERE category.name='Family');
    
    
-- Challenge 5 -- Using Subquery
SELECT first_name, last_name, email FROM customer
	WHERE address_id IN	(SELECT address_id FROM address
							WHERE city_id IN (SELECT city_id FROM city
												WHERE country_id = (SELECT country_id FROM country WHERE country='Canada')));
-- Challenge 5 -- Using Joins
SELECT first_name, last_name, email 
	FROM customer AS cu
    JOIN address AS ad
		ON cu.address_id = ad.address_id
	JOIN city AS ci
		ON ci.city_id = ad.city_id
	JOIN country AS co
		ON co.country_id = ci.country_id
	WHERE co.country = 'Canada';

    
-- Challenge 6 --
SELECT title FROM film
	WHERE film_id IN (SELECT film_id FROM film_actor
						WHERE actor_id = (SELECT actor_id FROM film_actor 
											GROUP BY actor_id ORDER BY COUNT(film_id) DESC LIMIT 1));


-- Challenge 7 --
SELECT title
	FROM film
	WHERE film_id IN (SELECT film_id FROM inventory
						WHERE inventory_id IN (SELECT inventory_id FROM rental
													WHERE customer_id = (SELECT customer_id FROM payment
																		GROUP BY customer_id ORDER BY SUM(amount) DESC LIMIT 1)))
	ORDER BY film_id;


-- Challenge 8 --
SELECT customer_id, SUM(amount) AS Total
	FROM payment
    GROUP BY customer_id
    HAVING SUM(amount) > (SELECT AVG(accumulated) FROM(SELECT sum(amount) AS accumulated FROM payment GROUP BY customer_id) as inner_query)
	ORDER BY Total DESC;