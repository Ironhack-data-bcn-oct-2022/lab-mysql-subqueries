use sakila;


-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

Select f.title as Title, count(inventory.film_id) as Copies from inventory
join film as f
	on f.film_id = inventory.film_id 
where title = "Hunchback Impossible" 
;

-- 2. List all films whose length is longer than the average of all the films.

select title, length from film as f
where length > (SELECT AVG(length)
FROM film as f);


-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

select act.first_name, act.last_name from actor as act
join film_actor as f_a
	on f_a.actor_id = act.actor_id
    where f_a.film_id = (select film.film_id from film where title = "Alone Trip")
;

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

select f.title from film as f
join film_category as fcat
	on fcat.film_id = f.film_id
where fcat.category_id = (select cat.category_id from category as cat where cat.name = "Family")
;

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to 
-- create a join, you will have to identify the correct tables with their primary keys and foreign keys, that
-- will help you get the relevant information.

select first_name, last_name, email from customer
    where address_id in (select address_id from address
	where city_id in (select city_id from city 
	where country_id =(select country_id from country
	where country= "Canada")));
;

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films.
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.


;
CREATE VIEW actor_count AS
select f_a.actor_id as actor_id, count(film.film_id) as counter from film
join film_actor as f_a
		on f_a.actor_id = film.actor_id 
group by f_a.actor_id;

select title from film
join film_actor as f_a
		on f_a.film_id = film.film_id
where f_a.actor_id =
(select actor_id from actor_count 
where counter = (select max(counter)from actor_count));

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer
-- ie the customer that has made the largest sum of payments

-- I have a view with customers and sum of amount
Create view amount_cust as
select customer_id, sum(amount) as total_amount from payment
group by customer_id
;

-- tinc el ID del client que te l'amount màxima
select customer_id from amount_cust
where total_amount = (select max(total_amount) from amount_cust);

select film.title from film
	Join inventory as i
		on i.film_id = film.film_id
	join rental
		on rental.inventory_id = i.inventory_id
	where rental.customer_id = (select customer_id from amount_cust
where total_amount = (select max(total_amount) from amount_cust));


-- 8. Get the client_id and the total_amount_spent of those clients who spent more 
-- than the average of the total_amount spent by each client. --> I will use the previously create VIEW

select customer_id, total_amount from amount_cust
where total_amount> (select avg(total_amount) from amount_cust)
order by total_amount asc;


