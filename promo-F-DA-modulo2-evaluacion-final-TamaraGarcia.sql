################################
###EVALUACIÓN FINAL MÓDULO 2 ###
################################

/* 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados. */

SELECT DISTINCT title FROM film;



/* 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13". */

SELECT title, rating FROM film WHERE rating LIKE 'PG-13';



/* 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción. */

SELECT title, `description` FROM film_text WHERE `description` LIKE '%Amazing%';



/* 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos. */

SELECT title, `length` AS 'Duración' FROM film WHERE `length` >= 120;



/* 5. Recupera los nombres de todos los actores. */

SELECT CONCAT(first_name, ' ', last_name) AS 'NombreActor' FROM actor;



/* 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido. */

SELECT CONCAT(first_name, ' ', last_name) AS 'NombreActor' FROM actor WHERE last_name LIKE '%Gibson%';



/* 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20. */

SELECT CONCAT(first_name, ' ', last_name) AS 'NombreActor', actor_id FROM actor WHERE actor_id BETWEEN 10 AND 20;



/* 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación. */

SELECT title, rating FROM film WHERE rating NOT LIKE 'R' AND rating NOT LIKE 'PG-13';



/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento. */

SELECT COUNT(film_id) AS 'TotalPeliculas', rating FROM film GROUP BY rating;



/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas. */

SELECT cus.customer_id, CONCAT(cus.first_name, ' ', cus.last_name) AS 'NombreCliente', COUNT(r.customer_id) AS 'PeliculasAlquiladas'
FROM customer cus, rental ren WHERE cus.customer_id = ren.customer_id
GROUP BY ren.customer_id;


/* 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres. */

SELECT cat.`name` AS 'Categoría', COUNT(ren.inventory_id) AS 'Recuento' FROM category cat
INNER JOIN film_category fc ON cat.category_id = fc.category_id
INNER JOIN inventory inv ON fc.film_id = inv.film_id
INNER JOIN rental ren ON inv.inventory_id = ren.inventory_id
GROUP BY cat.`name`;


/* 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración. */

SELECT rating AS 'Clasificación', AVG(length) AS 'Promedio' FROM film GROUP BY rating;


/* 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love". */

SELECT CONCAT(first_name, ' ', last_name) AS 'NombreActor' FROM actor act
INNER JOIN film_actor fa ON act.actor_id = fa.actor_id
INNER JOIN film ON film.film_id = fa.film_id
WHERE film.title = 'Indian Love';


/* 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción. */

SELECT title, `description` FROM film_text WHERE `description` LIKE '%dog%' OR `description` LIKE '%cat%';


/* 15. Hay algún actor que no aparece en ninguna película en la tabla film_actor. */

SELECT CONCAT(act.first_name, ' ', act.last_name) AS 'NombreActor' FROM actor act
INNER JOIN film_actor fa ON act.actor_id = fa.actor_id
WHERE fa.actor_id NOT IN (SELECT actor_id FROM film_actor);
              

/* 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010. */

SELECT title, release_year FROM film WHERE release_year BETWEEN 2005 AND 2010;


/* 17. Encuentra el título de todas las películas que son de la misma categoría que "Family". */

SELECT title, cat.`name` FROM film 
INNER JOIN film_category fcat ON film.film_id = fcat.film_id INNER JOIN category cat ON fcat.category_id = cat.category_id
WHERE cat.category_id = 8;


/* 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas. */

SELECT CONCAT(act.first_name, ' ', act.last_name) AS 'NombreActor' FROM actor act 
WHERE act.actor_id IN (
	SELECT fa.actor_id FROM film_actor fa GROUP BY fa.actor_id
	HAVING COUNT(fa.film_id) >= 10);
    
#También se puede así:

SELECT CONCAT(act.first_name, ' ', act.last_name) AS 'NombreActor' FROM actor act
INNER JOIN film_actor fa ON act.actor_id = fa.actor_id GROUP BY fa.actor_id HAVING COUNT(fa.film_id) >= 10;


/* 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film. */

SELECT title, rating, `length` AS 'Duración' FROM film WHERE rating = 'R' AND `length` >= 120;


/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración. */

SELECT cat.`name` AS 'Categoría', film.`length` AS 'Duración'  FROM category cat INNER JOIN film ON `length` >= 120;


/* 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado. */
       
SELECT CONCAT(act.first_name, ' ', act.last_name) AS 'NombreActor', COUNT(fac.film_id) 'Películas'
FROM actor act INNER JOIN film_actor fac ON act.actor_id = fac.actor_id
GROUP BY act.actor_id HAVING COUNT(fac.film_id) >= 5;


/* 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días.
Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes. */

SELECT film.title AS 'Título', ren.rental_date AS 'FechaPréstamo', ren.return_date AS 'FechaDevolución' FROM film
INNER JOIN inventory inv ON film.film_id = inv.film_id
INNER JOIN rental ren ON inv.inventory_id = ren.inventory_id
WHERE ren.rental_id IN (
						SELECT ren.rental_id FROM rental ren WHERE DATEDIFF(ren.return_date, ren.rental_date)>5);
                        
                        

/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores. */

SELECT CONCAT(act.first_name, ' ', act.last_name) AS 'NombreActor' FROM actor act
WHERE act.actor_id NOT IN (
							SELECT fact.actor_id FROM film_actor fact INNER JOIN film ON fact.film_id = film.film_id
                            INNER JOIN film_category fcat ON film.film_id = fcat.film_id INNER JOIN category cat ON fcat.category_id = cat.category_id
                            WHERE cat.`name` LIKE 'Horror')
ORDER BY 'NombreActor';



/* 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film. */

WITH categorias AS (SELECT film.title AS 'Titulo', film.`length` AS 'Duración', cat.`name` AS 'Categoría' FROM film
					INNER JOIN film_category fcat ON film.film_id = fcat.film_id
					INNER JOIN category cat ON fcat.category_id = cat.category_id
					WHERE cat.`name`= 'Comedy' AND film.`length` >=180)
                    
SELECT * FROM categorias;
         
