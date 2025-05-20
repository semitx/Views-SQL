

use sakila;

CREATE VIEW film_category_view AS
SELECT f.film_id, f.title, fc.category_id, c.name
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON c.category_id = fc.category_id;

CREATE VIEW film_language_view AS
SELECT f.film_id, f.title, l.name AS language_name
FROM film f
LEFT JOIN language l ON f.language_id = l.language_id;

CREATE VIEW categoria_con_cantidad_peliculas AS
SELECT c.name, COUNT(fc.film_id) AS cantidad_peliculas
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY cantidad_peliculas DESC;

CREATE VIEW vista_pagos_clientes AS
SELECT c.customer_id,CONCAT(c.first_name, " ", c.last_name) AS nombre_completo, SUM(p.amount) AS total_pagos
FROM customer c
LEFT JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id;
SELECT * FROM vista_pagos_clientes
ORDER BY customer_id;

CREATE VIEW StoreAddresses AS
SELECT a.address, s.store_id
FROM address a
LEFT JOIN store s ON a.address_id = s.address_id;
SELECT * FROM StoreAddresses;

CREATE VIEW RentalFilms AS
SELECT r.rental_date, f.title
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id;
SELECT * FROM RentalFilms;

CREATE VIEW StaffStore AS
SELECT s.staff_id, s.first_name, s.last_name, s.store_id
FROM staff s
LEFT JOIN store st ON s.store_id = st.store_id;
SELECT * FROM StaffStore;

CREATE VIEW city_customer_count AS
SELECT ci.city, COUNT(c.customer_id) AS customer_count
FROM city ci
LEFT JOIN address a ON ci.city_id = a.city_id
LEFT JOIN customer c ON a.address_id = c.address_id
GROUP BY ci.city_id;
SELECT * FROM city_customer_count;

CREATE VIEW customer_rentals AS
SELECT c.first_name, c.last_name, f.title
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id;
SELECT * FROM customer_rentals;

CREATE VIEW film_rental_summary AS
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id;
SELECT * FROM film_rental_summary;

CREATE VIEW actor_film_count AS
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id;
SELECT * FROM actor_film_count;

CREATE VIEW store_employee_count AS
SELECT s.store_id, COUNT(st.staff_id) AS employee_count
FROM store s
LEFT JOIN staff st ON s.store_id = st.store_id
GROUP BY s.store_id;
SELECT * FROM store_employee_count;



create view film_length as
select title, length
from film;
select title
from film
where length = (
    select length
    from film_length
    where title = "ALIEN CENTER"
);

create view customer_amount as
SELECT first_name,last_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM payment
    WHERE amount > 5
);
SELECT * FROM customer_amount;

create view rentalrate_zoolander as
select title
from film
where rental_rate=(
    select rental_rate
    from film
    where title="ZOOLANDER FICTION"
);
SELECT * FROM rentalrate_zoolander;


create view ghostbusters as
select actor_id, concat(first_name, " ", last_name) as nombre
from actor
where actor_id IN (
    select actor_id
    from film_actor
    join film on film_actor.film_id = film.film_id
    where film.title = "GHOSTBUSTERS ELF"
);
SELECT * FROM ghostbusters;


create view prom as
select film_id, title, length
from film
where length > (
    select avg(length)
    from film
);
SELECT * FROM prom;


create view customer_with_payments as
select customer_id, concat(first_name, " ", last_name) as nombre
from customer
where customer_id IN(
    select distinct customer_id
    from payment
);
select * from customer_with_payments;

CREATE VIEW unavailable_films AS
SELECT film_id, title
FROM film
WHERE film_id NOT IN (
    SELECT DISTINCT film_id
    FROM inventory
    JOIN rental ON inventory.inventory_id = rental.inventory_id
);
select * from unavailable_films;

CREATE VIEW popular_categories AS
SELECT name
FROM category
WHERE category_id IN (
    SELECT category_id
    FROM film_category
    GROUP BY category_id
    HAVING COUNT(film_id) > 50
);
select * from popular_categories;

CREATE VIEW staff_from_largest_store AS
SELECT first_name, last_name
FROM staff
WHERE store_id = (
    SELECT store_id
    FROM inventory
    GROUP BY store_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
);
select * from staff_from_largest_store;


CREATE VIEW film_rating_view AS
SELECT title
FROM film
WHERE rating IN (
    SELECT rating
    FROM film
    WHERE film.title = "ACADEMY DINOSAUR"
);
SELECT * FROM film_rating_view;


CREATE VIEW actores_mas_de_20_peliculas AS
SELECT CONCAT(first_name, " ", last_name) AS nombre
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    HAVING COUNT(film_id) > 20
);
SELECT * FROM actores_mas_de_20_peliculas;

CREATE VIEW title_crusadehoney AS
select title
from film
where replacement_cost IN (
    select replacement_cost
    from film
    where film.title = "CRUSADE HONEY"
);
SELECT * FROM title_crusadehoney;


use videojuego;

CREATE VIEW edad_jugadores AS
SELECT Nombre, Edad
FROM jugadores
WHERE Edad > (SELECT AVG(Edad) FROM jugadores);
select * from edad_jugadores;

CREATE VIEW lobo_blanco AS
SELECT Nombre, Nivel
FROM misiones
WHERE Nivel > (
    SELECT Nivel
    FROM misiones
    WHERE Nombre = 'Caza del Lobo Blanco'
);
select * from lobo_blanco;


CREATE VIEW jugadores_partida AS
SELECT Nombre
FROM jugadores
WHERE ClaveJugador IN (
    SELECT ClaveJugador
    FROM partidas
    GROUP BY ClaveJugador
    HAVING COUNT(*) > 1
);
select * from jugadores_partida;

CREATE VIEW tipo_arma AS
SELECT Nombre
FROM items
WHERE Tipo IN (
    SELECT Tipo
    FROM items
    WHERE items.Tipo = 'Arma'
);
select * from tipo_arma;

CREATE VIEW item_defensa AS
SELECT Nombre
FROM items
WHERE Estadisticas LIKE (
    SELECT Estadisticas
    FROM items
    WHERE Estadisticas LIKE 'Defensa%'
    LIMIT 1
);
select * from item_defensa;

use ligafutbol;

CREATE VIEW total_partidos AS
SELECT e.Nombre AS Equipo,
       (SELECT COUNT(*) FROM partidos p WHERE p.Equipos LIKE CONCAT('%', e.Nombre, '%')) AS TotalPartidos
FROM equipos e;
select * from total_partidos;


CREATE VIEW jugador_equipo AS
SELECT Nombre,
       (SELECT Nombre FROM equipos WHERE ClaveEquipo = j.ClaveEquipo) AS Equipo
FROM jugadores j;
select * from jugador_equipo;

CREATE VIEW arbitros_goles AS
SELECT DISTINCT a.Nombre
FROM arbitros a
WHERE a.ClaveArbitro IN
    (SELECT p.Arbitraje
    FROM partidos p
    WHERE SUBSTRING_INDEX(p.Goles, '-', -1) + SUBSTRING_INDEX(p.Goles, '-', 1) > 3);
select * from arbitros_goles;

CREATE VIEW jugador_sueldo AS
SELECT j.Nombre AS Jugador,
       j.Sueldo,
       (SELECT e.Nombre FROM equipos e WHERE e.ClaveEquipo = j.ClaveEquipo) AS Equipo
FROM jugadores j;
select * from jugador_sueldo;


use tienda;

CREATE VIEW marca_descrip AS
SELECT a.Descripcion,
(SELECT m.Descripcion FROM marca m WHERE m.ClaveMarca = a.ClaveMarca) AS Marca
FROM articulo a;
select * from marca_descrip;

CREATE VIEW cliente_compras AS
SELECT c.Nombre AS Cliente,
       (SELECT COUNT(*) FROM ventas v WHERE v.ClaveCliente = c.ClaveCliente) AS TotalVentas
FROM clientes c;
select * from cliente_compras;

CREATE VIEW precio_mayor AS
SELECT a.Descripcion,
       a.Precio
FROM articulo a
WHERE a.Precio > (SELECT AVG(Precio) FROM articulo);
select * from precio_mayor;

CREATE VIEW ventas_mayor3 AS
SELECT v.ClaveVendedor,
       (SELECT COUNT(*) FROM ventas ve WHERE ve.ClaveVendedor = v.ClaveVendedor) AS TotalVentas
FROM vendedor v
HAVING TotalVentas > 3;
select * from ventas_mayor3;

CREATE VIEW clientes_menorsaldo AS
SELECT c.Nombre AS Cliente,
       c.Saldo,
       (SELECT SUM(v.Total) FROM ventas v WHERE v.ClaveCliente = c.ClaveCliente) AS TotalCompras
FROM clientes c
WHERE c.Saldo < (SELECT SUM(v.Total) FROM ventas v WHERE v.ClaveCliente = c.ClaveCliente);
select * from clientes_menorsaldo;

use escuela;

CREATE VIEW estudiante_grupo AS
SELECT e.Nombre,
       (SELECT g.ClaveGrupo FROM grupos g WHERE g.ClaveGrupo = e.Grupo) AS Grupo
FROM estudiante e;
select * from estudiante_grupo;


CREATE VIEW grupo_estudiantes AS
SELECT g.ClaveGrupo,
       (SELECT COUNT(*) FROM estudiante e WHERE e.Grupo = g.ClaveGrupo) AS TotalEstudiantes
FROM grupos g;
select * from grupo_estudiantes;

CREATE VIEW maestro_materias AS
SELECT m.Nombre AS Materia,
    (SELECT GROUP_CONCAT(ma.Nombre SEPARATOR ', ' ) FROM maestros ma WHERE ma.Grupos) AS maestro
	 FROM materias m;
select * from maestro_materias;

CREATE VIEW horario AS
SELECT h.Materias,
       h.Hora,
       (SELECT g.AñoEscolar FROM grupos g WHERE g.ClaveGrupo = h.Grupo) AS AñoEscolar
FROM horarios h
WHERE h.Grupo = 101;
select * from horario;


CREATE VIEW estudiantesmas AS
SELECT g.ClaveGrupo
FROM grupos g 
WHERE g.ClaveGrupo IN (SELECT e.Grupo
                  FROM estudiante e 
                  WHERE g.CantidadEstudiantes > 20);
select * from estudiantesmas;

