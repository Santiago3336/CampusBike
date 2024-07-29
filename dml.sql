/*Caso de uso 1*/
/* Agregar*/
INSERT INTO bicycles (model, brand, price, stock)
VALUES ('Schwinn', 'S29', 769.99, 10);
/*Mostrar las bicicletas para despues Actualizar*/
SELECT id, model, brand, price, stock
FROM bicycles;

UPDATE bicycles
SET price = 823.00, stock = 8
WHERE id = 1;
/*Mostrar las bicicletas para despues Eliminar*/
SELECT id, model, brand, price, stock
FROM bicycles;

DELETE FROM bicycles
WHERE id = 1;

/* CASO DE USO 2 */


/*Se selecciona el usuario*/
SELECT id, full_name, email
FROM customers;

SELECT id, price
FROM bicycles
WHERE id IN (2, 3);

/*Confirmacion de la venta*/


INSERT INTO sales (sale_date, customer_id)
VALUES (CURDATE(), 1)

/*Obtener el ID de la venta reciente*/
SELECT LAST_INSERT_ID() AS sale_id;

/*Crear detalles de la venta*/
INSERT INTO sales_details (sale_id, bicycle_id, quantity, unit_price)
VALUES (1, 1, 2, 823.00),
       (1, 3, 1, 550.00);

/* Actualizar inventario de bicicletas */
UPDATE bicycles
SET stock = stock - 2
WHERE id = 1;

UPDATE bicycles
SET stock = stock - 1
WHERE id = 3;

/* CASO DE USO 3 */

INSERT INTO suppliers (name, phone, phone_type_id, email, city_id, contact_person)
VALUES ('Global Supplies Inc.', '+1-234-567-8901', 1, 'contact@globalsupplies.com', 101, 'John Doe');

INSERT INTO spare_parts (name, description, price, stock, supplier_id)
VALUES ('Headlight Bulb', 'LED headlight bulb', 12.30, 300, 1);

/*Actualizar Proveedor*/
SELECT id, name, phone, email, city_id, contact_person
FROM suppliers;

UPDATE suppliers
SET name = 'TechParts Co.', phone = '+44-20-7946-0958', email = 'info@techparts.co.uk', city_id = 102, contact_person = 'Jane Smith'
WHERE id = 1;


/*Actualizar repuestos*/
SELECT id, name, description, price, stock, supplier_id
FROM spare_parts;

UPDATE spare_parts
SET name = 'Brake Pads', description = 'Set of brake pads', price = 45.00, stock = 75
WHERE id = 1;

/*Eliminar proveedor*/
SELECT id, name
FROM suppliers;

DELETE FROM suppliers
WHERE id = 1;

/*Eliminar repuesto*/
SELECT id, name
FROM spare_parts;

DELETE FROM spare_parts
WHERE id = 1;

/* Caso de uso 4 */


SELECT id, full_name, email
FROM customers;

SELECT s.id AS sale_id, s.sale_date, s.customer_id, c.full_name
FROM sales s
JOIN customers c ON s.customer_id = c.id
WHERE s.customer_id = 1;

SELECT sd.bicycle_id, b.model, b.brand, sd.quantity, sd.unit_price
FROM sales_details sd
JOIN bicycles b ON sd.bicycle_id = b.id
WHERE sd.sale_id = 1;

/* Caso de uso 5 */

SELECT id, name
FROM suppliers;

INSERT INTO purchases (purchase_date, supplier_id, total_amount)
VALUES ('2024-07-26', 1, 1000.00);

SELECT LAST_INSERT_ID() AS purchase_id;

SELECT id, name
FROM spare_parts;

INSERT INTO purchase_details (quantity, unit_price, spare_part_id, purchase_id)
VALUES (10,50.00, 1, 1),
       (5, 30.00, 2, 2)

UPDATE spare_parts
SET stock = stock + 10
WHERE id = 1;

UPDATE spare_parts
SET stock = stock + 5
WHERE id = 2;

/* Subconsultas */
/*Caso de uso 6*/

SELECT
    b.brand,
    b.model,
    MAX(b.sold_quantity) AS max_sold_quantity
FROM (
    SELECT
        b.brand,
        b.model,
        SUM(sd.quantity) AS sold_quantity
    FROM
        bicycles b
    JOIN
        sales_details sd ON b.id = ds.bicycle_id
    GROUP BY
        b.brand, b.model
) b
GROUP BY
    b.brand
ORDER BY
    b.brand, b.sold_quantity DESC;


/* Caso de uso 7 */

SELECT
    c.id AS customer_id,
    c.full_name,
    SUM(sd.quantity * sd.unit_price) AS total_spent
FROM
    sales s
JOIN
    sales_details sd ON s.id = sd.sale_id
JOIN
    customers c ON s.customer_id = c.id
WHERE
    YEAR(s.sale_date) = 2023  -- Reemplazar 2023 con el año deseado
GROUP BY
    c.id, c.full_name
ORDER BY
    total_spent DESC;


/* Caso de uso 8 */

SELECT
    s.id AS supplier_id,
    s.name AS supplier_name,
    COUNT(p.id) AS purchase_count
FROM
    suppliers s
JOIN
    purchases p ON s.id = p.supplier_id
WHERE
    p.purchase_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY
    s.id, s.name
ORDER BY
    purchase_count DESC;


/* Caso de uso 9 */

SELECT
    sp.id AS spare_part_id,
    sp.name AS spare_part_name,
    COALESCE(SUM(pd.quantity), 0) AS total_sold
FROM
    spare_parts sp
LEFT JOIN
    purchase_details pd ON sp.id = pd.spare_part_id
GROUP BY
    sp.id, sp.name
ORDER BY
    total_sold ASC;


/* Caso de uso 10 */

SELECT
    ci.id AS city_id,
    ci.name AS city_name,
    COUNT(s.id) AS total_sales
FROM
    cities ci
JOIN
    customers cu ON ci.id = cu.city_id
JOIN
    sales s ON cu.id = s.customer_id
GROUP BY
    ci.id, ci.name
ORDER BY
    total_sales DESC;


/* Caso de uso 11 */

SELECT
    ci.id AS city_id,
    ci.name AS city_name,
    COUNT(s.id) AS total_sales
FROM
    cities ci
JOIN
    customers cu ON ci.id = cu.city_id
JOIN
    sales s ON cu.id = s.customer_id
GROUP BY
    ci.id, ci.name
ORDER BY
    total_sales DESC;


/* Caso de uso 12 */

SELECT
    co.id AS country_id,
    co.name AS country_name,
    s.id AS supplier_id,
    s.name AS supplier_name
FROM
    countries co
JOIN
    cities ci ON co.id = ci.country_id
JOIN
    suppliers s ON ci.id = s.city_id
ORDER BY
    co.name, s.name;


/* Caso de uso 13 */

SELECT
    s.id AS supplier_id,
    s.name AS supplier_name,
    SUM(pd.quantity) AS total_spare_parts_purchased
FROM
    suppliers s
JOIN
    spare_parts sp ON s.id = sp.supplier_id
JOIN
    purchase_details pd ON sp.id = pd.spare_part_id
GROUP BY
    s.id, s.name
ORDER BY
    total_spare_parts_purchased DESC;


/* Caso de uso 14 */


SET @start_date = '2023-01-01';
SET @end_date = '2023-12-31';

SELECT
    c.id AS customer_id,
    c.full_name AS customer_name,
    COUNT(s.id) AS total_sales
FROM
    customers c
JOIN
    sales s ON c.id = s.customer_id
WHERE
    s.sale_date BETWEEN @start_date AND @end_date
GROUP BY
    c.id, c.full_name
ORDER BY
    total_sales DESC;
