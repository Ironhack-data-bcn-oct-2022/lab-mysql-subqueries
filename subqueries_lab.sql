USE sakila; 

-- 1 -- 
SELECT COUNT(inventory.film_id) , film.title
FROM inventory 
JOIN film 
	ON inventory.film_id = film.film_id
WHERE film.title = 'Hunchback Impossible'; 

-- 2 -- 
SELECT  film.rental_duration, film.title 
FROM film 
WHERE film.rental_duration > (SELECT AVG(rental_duration) FROM film);

-- 3 -- 
SELECT  actor.first_name, actor.last_name
FROM actor 
	Join film_actor on actor.actor_id= film_actor.actor_id 
    Join film on film_actor.film_id = film.film_id
WHERE film.title = 'Alone Trip';

-- 4 -- 
-- id  all 'family films'; want category.name  where category = 'FAMILY" and category.category_id = film_category.category_id on film_category.film_id = film.film_id select film.title 
SELECT film.title 
FROM category
JOIN film_category ON film_category.category_id= category.category_id
JOIN film ON film_category.film_id = film.film_id 
WHERE category.name = 'family' ;

-- 5 -- 
-- get customer.first_name, customer.last_name, customer.email WHERE country.country = 'Canada' 
SELECT customer.first_name, customer.last_name, customer.email
FROM customer 
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id 
JOIN country ON city.country_id = country.country_id 
WHERE country.country = "Canada";

-- 6 -- 
-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most 
-- number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films 
-- that he/she starred.

SELECT *
FROM (
SELECT actor.first_name, actor.last_name, COUNT(film_actor.actor_id) AS total_films 
FROM actor 
JOIN film_actor ON actor.actor_id = film_actor.actor_id 
GROUP BY film_actor.actor_id  
ORDER BY total_films DESC
LIMIT 1
) AS ordered ;

-- 7 -- 
-- Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable 
-- customer ie the customer that has made the largest sum of payments
select sum(amount), customer.customer_id,last_name
from payment
join customer
on payment.customer_id=customer.customer_id
group by customer_id
order by sum(amount) desc
limit 1;
-- 8 -- 
--  Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` 
-- spent by each client.

SELECT total_amount_spent >(SELECT AVG(total_amount_spent)from payment.amount))
FROM ( 
SELECT customer.customer_id as client_id, sum(payment.amount) as total_amount_spent
FROM customer 
JOIN payment on customer.customer_id = payment.payment_id
GROUP BY customer.customer_id
ORDER BY total_amount_spent DESC
) AS tot ;
 

SELECT customer.customer_id as client_id, sum(payment.amount) as total_amount_spent
FROM customer 
JOIN payment on customer.customer_id = payment.payment_id
GROUP BY customer.customer_id
ORDER BY total_amount_spent;


