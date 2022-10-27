/*Q1 ) Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.*/


SELECT 
       c.name AS category_name,
       COUNT(*) AS rental_count
FROM film_category fc
		JOIN film f
		ON fc.film_id = f.film_id
		JOIN category c
		ON c.category_id = fc.category_id
		JOIN inventory i
		ON i.film_id = f.film_id
		JOIN rental r
		ON r.inventory_id = i.inventory_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY 1ORDER BY 2,1;

/*Q2 ) Can you write a query to capture the customer name, month and year of payment, and total payment amount for each month by these top 10 paying customers?*/

SELECT DATE_TRUNC('month', p.payment_date) pay_month, CONCAT(c.first_name, ' ', c.last_name) AS fullname, COUNT(p.amount) AS pay_countpermon, SUM(p.amount) AS pay_amount
  FROM customer c
  JOIN payment p
  ON p.customer_id = c.customer_id
  WHERE CONCAT(c.first_name, ' ', c.last_name) IN
    (SELECT t1.fullname
        FROM
        (SELECT CONCAT(c.first_name, ' ', c.last_name) AS fullname, SUM(p.amount) as amount_total
          FROM customer c
          JOIN payment p
          ON p.customer_id = c.customer_id
          GROUP BY 1
          ORDER BY 2 DESC
          LIMIT 10) t1) AND (p.payment_date BETWEEN '2007-01-01' AND '2008-01-01')
GROUP BY 2, 1
ORDER BY 2, 1, 3;

/*Q3) provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category for each corresponding rental duration category*/

SELECT category_name,
       standard_quartile,
       count(*)
FROM (SELECT c.name AS category_name,
             f.rental_duration AS rental_duration,
             NTILE(4) OVER (ORDER BY f.rental_duration  ) standard_quartile
      FROM film_category fc
      JOIN film f
      ON fc.film_id = f.film_id
      JOIN category c
      ON c.category_id = fc.category_id
      WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music'))sub
GROUP BY 1,2
ORDER BY 1,2;

/*Q4 ) Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.*/

SELECT DATE_PART('month', r.rental_date) AS rental_month,
       DATE_PART('year', r.rental_date) AS rental_year,
       s.store_id ,
       COUNT(*) AS Count_rentals
  FROM store s
        JOIN staff st
        ON s.store_id = st.store_id
        JOIN rental r
        ON st.staff_id = r.staff_id
 GROUP BY 1, 2, 3
 ORDER BY 4 desc ; 
