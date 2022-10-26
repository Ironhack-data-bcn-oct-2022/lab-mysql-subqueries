-- How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT COUNT(*)
FROM inventory i

JOIN film f
ON f.film_id = i.film_id
AND title = 'Hunchback Impossible';
-------------------------------------------------------------------------

-- List all films whose length is longer than the average of all the films.

SELECT title
FROM film f
WHERE f.length > (SELECT AVG (f.length)
				  FROM film f);
-------------------------------------------------------------------------

-- Use subqueries to display all actors who appear in the film Alone Trip.

SELECT CONCAT(first_name, " ", last_name) as actorname
FROM film f

JOIN film_actor fa
ON fa.film_id = f.film_id

JOIN actor a
ON a.actor_id = fa.actor_id
WHERE f.title = 'Alone Trip';
-------------------------------------------------------------------------

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

