

# **Campusbike**

![](https://raw.githubusercontent.com/Santiago3336/CampusBike/main/image.png)

## Casos de Uso para la Base de Datos

### Caso de Uso 1

**Descripción:** Este caso de uso describe cómo el sistema gestiona el inventario de bicicletas, permitiendo agregar nuevas bicicletas, actualizar la información existente y eliminar bicicletas que ya no están disponibles.

```SQL
INSERT INTO bicycles (model, brand, price, stock) VALUES ('Schwinn', 'S29', 769.99, 10);

SELECT id, model, brand, price, stock FROM bicycles;

UPDATE bicycles SET price = 823.00, stock = 8 WHERE id = 1;

SELECT id, model, brand, price, stock FROM bicycles;

DELETE FROM bicycles WHERE id = 1;
```

### Caso de Uso 2

**Descripción:** Este caso de uso describe el proceso de registro de una venta de bicicletas, incluyendo la creación de una nueva venta, la selección de las bicicletas vendidas y el cálculo del total de la venta.

```SQL
SELECT id, full_name, email FROM customers;

SELECT id, price FROM bicycles WHERE id IN (2, 3);

INSERT INTO sales (sale_date, customer_id) VALUES (CURDATE(), 1)

SELECT LAST_INSERT_ID() AS sale_id;

INSERT INTO sales_details (sale_id, bicycle_id, quantity, unit_price) VALUES (1, 1, 2, 823.00), (1, 3, 1, 550.00);

UPDATE bicycles SET stock = stock - 2 WHERE id = 1;

UPDATE bicycles SET stock = stock - 1 WHERE id = 3;
```

### Caso de Uso 3

**Descripción:** Este caso de uso describe cómo el sistema gestiona la información de proveedores y repuestos, permitiendo agregar nuevos proveedores y repuestos, actualizar la información existente y eliminar proveedores y repuestos que ya no están activos.

```SQL
INSERT INTO suppliers (name, phone, phone_type_id, email, city_id, contact_person) VALUES ('Global Supplies Inc.', '+1-234-567-8901', 1, 'contact@globalsupplies.com', 101, 'John Doe');

INSERT INTO spare_parts (name, description, price, stock, supplier_id) VALUES ('Headlight Bulb', 'LED headlight bulb', 12.30, 300, 1);

SELECT id, name, phone, email, city_id, contact_person FROM suppliers;

UPDATE suppliers SET name = 'TechParts Co.', phone = '+44-20-7946-0958', email = 'info@techparts.co.uk', city_id = 102, contact_person = 'Jane Smith' WHERE id = 1;

SELECT id, name, description, price, stock, supplier_id FROM spare_parts;

UPDATE spare_parts SET name = 'Brake Pads', description = 'Set of brake pads', price = 45.00, stock = 75 WHERE id = 1;

SELECT id, name FROM suppliers;

DELETE FROM suppliers WHERE id = 1;

SELECT id, name FROM spare_parts;

DELETE FROM spare_parts WHERE id = 1;
```

### Caso de Uso 4

**Descripción:** Este caso de uso describe cómo el sistema permite a un usuario consultar el historial de ventas de un cliente específico, mostrando todas las compras realizadas por el cliente y los detalles de cada venta.

```SQL
SELECT id, full_name, email FROM customers;

SELECT s.id AS sale_id, s.sale_date, s.customer_id, c.full_name FROM sales s JOIN customers c ON s.customer_id = c.id WHERE s.customer_id = 1;

SELECT sd.bicycle_id, b.model, b.brand, sd.quantity, sd.unit_price FROM sales_details sd JOIN bicycles b ON sd.bicycle_id = b.id WHERE sd.sale_id = 1;
```

### Caso de Uso 5

**Descripción:** Este caso de uso describe cómo el sistema gestiona las compras de repuestos a proveedores, permitiendo registrar una nueva compra, especificar los repuestos comprados y actualizar el stock de repuestos.

```SQL
SELECT id, name FROM suppliers;

INSERT INTO purchases (purchase_date, supplier_id, total_amount) VALUES ('2024-07-26', 1, 1000.00);

SELECT LAST_INSERT_ID() AS purchase_id;

SELECT id, name FROM spare_parts;

INSERT INTO purchase_details (quantity, unit_price, spare_part_id, purchase_id) VALUES (10,50.00, 1, 1), (5, 30.00, 2, 2)

UPDATE spare_parts SET stock = stock + 10 WHERE id = 1;

UPDATE spare_parts SET stock = stock + 5 WHERE id = 2;
```

## Casos de Uso con Subconsultas

### Caso de Uso 6

**Descripción:** Este caso de uso describe cómo el sistema permite a un usuario consultar las bicicletas más vendidas por cada marca.

### Caso de Uso 7

**Descripción:** Este caso de uso describe cómo el sistema permite consultar los clientes que han gastado más en un año específico.

```SQL
SELECT c.id AS customer_id, c.full_name, SUM(sd.quantity * sd.unit_price) AS total_spent FROM sales s JOIN sales_details sd ON s.id = sd.sale_id JOIN customers c ON s.customer_id = c.id WHERE YEAR(s.sale_date) = 2023 -- Reemplazar 2023 con el año deseado GROUP BY c.id, c.full_name ORDER BY total_spent DESC;
```

### Caso de Uso 8

**Descripción:** Este caso de uso describe cómo el sistema permite consultar los proveedores que han recibido más compras en el último mes.

```SQL
SELECT s.id AS supplier_id, s.name AS supplier_name, COUNT(p.id) AS purchase_count FROM suppliers s JOIN purchases p ON s.id = p.supplier_id WHERE p.purchase_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH) GROUP BY s.id, s.name ORDER BY purchase_count DESC;
```

### Caso de Uso 9

**Descripción:** Este caso de uso describe cómo el sistema permite consultar los repuestos que han tenido menor rotación en el inventario, es decir, los menos vendidos.

```SQL
SELECT sp.id AS spare_part_id, sp.name AS spare_part_name, COALESCE(SUM(pd.quantity), 0) AS total_sold FROM spare_parts sp LEFT JOIN purchase_details pd ON sp.id = pd.spare_part_id GROUP BY sp.id, sp.name ORDER BY total_sold ASC;
```

### Caso de Uso 10

**Descripción:** Este caso de uso describe cómo el sistema permite consultar las ciudades donde se han realizado más ventas de bicicletas.

```SQL
SELECT ci.id AS city_id, ci.name AS city_name, COUNT(s.id) AS total_sales FROM cities ci JOIN customers cu ON ci.id = cu.city_id JOIN sales s ON cu.id = s.customer_id GROUP BY ci.id, ci.name ORDER BY total_sales DESC;
```

## Casos de Uso con JOINS 

### Caso de Uso 11

**Descripción:** Este caso de uso describe cómo el sistema permite consultar el total de ventas realizadas en cada ciudad.

```SQL
SELECT ci.id AS city_id, ci.name AS city_name, COUNT(s.id) AS total_sales FROM cities ci JOIN customers cu ON ci.id = cu.city_id JOIN sales s ON cu.id = s.customer_id GROUP BY ci.id, ci.name ORDER BY total_sales DESC;
```

### Caso de Uso 12

**Descripción:** Este caso de uso describe cómo el sistema permite consultar los proveedores agrupados por país.

```SQL
SELECT co.id AS country_id, co.name AS country_name, s.id AS supplier_id, s.name AS supplier_name FROM countries co JOIN cities ci ON co.id = ci.country_id JOIN suppliers s ON ci.id = s.city_id ORDER BY co.name, s.name;
```

### Caso de Uso 13

**Descripción:** Este caso de uso describe cómo el sistema permite consultar el total de repuestos comprados a cada proveedor.

```SQL
SELECT s.id AS supplier_id, s.name AS supplier_name, SUM(pd.quantity) AS total_spare_parts_purchased FROM suppliers s JOIN spare_parts sp ON s.id = sp.supplier_id JOIN purchase_details pd ON sp.id = pd.spare_part_id GROUP BY s.id, s.name ORDER BY total_spare_parts_purchased DESC;
```



### Caso de Uso 14

**Descripción:** Este caso de uso describe cómo el sistema permite consultar los clientes que han realizado compras dentro de un rango de fechas específico.

```SQL
SET @start_date = '2023-01-01'; SET @end_date = '2023-12-31';

SELECT c.id AS customer_id, c.full_name AS customer_name, COUNT(s.id) AS total_sales FROM customers c JOIN sales s ON c.id = s.customer_id WHERE s.sale_date BETWEEN @start_date AND @end_date GROUP BY c.id, c.full_name ORDER BY total_sales DESC;
```

## Casos de Uso para Implementar Procedimientos Almacenados

### Caso de Uso 1

**Descripción:** Este caso de uso describe cómo el sistema actualiza el inventario de bicicletas cuando se realiza una venta.

```SQL
DELIMITER $$

CREATE PROCEDURE UpdateBicycleStock( IN bicycle_id INT, IN quantity_sold INT ) BEGIN UPDATE bicycles SET stock = stock - quantity_sold WHERE id = bicycle_id; END $$

DELIMITER ;
```

### Caso de Uso 2

**Descripción:** Este caso de uso describe cómo el sistema registra una nueva venta, incluyendo la creación de la venta y la inserción de los detalles de la venta.

```SQL
DELIMITER $$

CREATE PROCEDURE RegisterNewSale( IN customer_id INT, IN sale_date DATE, INOUT sale_id INT ) BEGIN INSERT INTO sales (sale_date, customer_id) VALUES (sale_date, customer_id); SET sale_id = LAST_INSERT_ID(); END $$

CREATE PROCEDURE RegisterSaleDetails( IN sale_id INT, IN bicycle_id INT, IN quantity BIGINT, IN unit_price DECIMAL(10,2) ) BEGIN INSERT INTO sales_details (sale_id, bicycle_id, quantity, unit_price) VALUES (sale_id, bicycle_id, quantity, unit_price);

CALL UpdateBicycleStock(bicycle_id, quantity);
END $$

DELIMITER ;
```

### Caso de Uso 3

**Descripción:** Este caso de uso describe cómo el sistema genera un reporte de ventas para un cliente específico, mostrando todas las ventas realizadas por el cliente y los detalles de cada venta.

```SQL
DELIMITER $$

CREATE PROCEDURE GenerateSalesReportByCustomer( IN customer_id INT ) BEGIN SELECT s.id AS sale_id, s.sale_date, sd.bicycle_id, sd.quantity, sd.unit_price FROM sales s JOIN sales_details sd ON s.id = sd.sale_id WHERE s.customer_id = customer_id; END $$

DELIMITER ;
```

### Caso de Uso 4

**Descripción:** Este caso de uso describe cómo el sistema registra una nueva compra de repuestos a un proveedor.

```SQL
DELIMITER $$

CREATE PROCEDURE RegisterNewPurchase( IN supplier_id INT, IN purchase_date DATE, IN total_amount DECIMAL(10,2), INOUT purchase_id INT ) BEGIN INSERT INTO purchases (purchase_date, supplier_id, total_amount) VALUES (purchase_date, supplier_id, total_amount); SET purchase_id = LAST_INSERT_ID(); END;

CREATE PROCEDURE RegisterPurchaseDetails( IN purchase_id INT, IN spare_part_id INT, IN quantity BIGINT, IN unit_price DECIMAL(10,2) ) BEGIN INSERT INTO purchase_details (purchase_id, spare_part_id, quantity, unit_price) VALUES (purchase_id, spare_part_id, quantity, unit_price);

UPDATE spare_parts
SET stock = stock + quantity
WHERE id = spare_part_id;
END $$

DELIMITER ;
```

### Caso de Uso 5

**Descripción:** Este caso de uso describe cómo el sistema genera un reporte de inventario de bicicletas y repuestos.

```SQL
DELIMITER $$

CREATE PROCEDURE GenerateInventoryReport() BEGIN SELECT id, model, brand, price, stock FROM bicycles; SELECT id, name, description, price, stock FROM spare_parts; END $$

DELIMITER ;
```

### Caso de Uso 6

**Descripción:** Este caso de uso describe cómo el sistema permite actualizar masivamente los precios de todas las bicicletas de una marca específica.

```SQL
DELIMITER $$

CREATE PROCEDURE UpdatePricesByBrand( IN brand_name VARCHAR(50), IN percentage_increase DECIMAL(5,2) ) BEGIN UPDATE bicycles SET price = price * (1 + percentage_increase / 100) WHERE brand = brand_name; END $$

DELIMITER ;
```

### Caso de Uso 7

**Descripción:** Este caso de uso describe cómo el sistema genera un reporte de clientes agrupados por ciudad.

```SQL
DELIMITER $$

CREATE PROCEDURE GenerateCustomerReportByCity() BEGIN SELECT ct.name AS city, c.id AS customer_id, c.full_name AS customer_name FROM customers c JOIN cities ct ON c.city_id = ct.id ORDER BY ct.name, c.full_name; END $$

DELIMITER ;
```

### Caso de Uso 8

**Descripción:** Este caso de uso describe cómo el sistema verifica el stock de una bicicleta antes de permitir la venta.

```SQL
DELIMITER $$

CREATE PROCEDURE CheckBicycleStock( IN bicycle_id INT, IN quantity_required INT, OUT stock_status VARCHAR(50) ) BEGIN DECLARE current_stock INT;

SELECT stock INTO current_stock FROM bicycles WHERE id = bicycle_id;

IF current_stock >= quantity_required THEN
    SET stock_status = 'Sufficient stock';
ELSE
    SET stock_status = 'Insufficient stock';
END IF;
END $$

DELIMITER ;
```

### Caso de Uso 9

**Descripción:** Este caso de uso describe cómo el sistema registra la devolución de una bicicleta por un cliente.

```SQL
DELIMITER $$

CREATE PROCEDURE RegisterReturn( IN customer_id INT, IN bicycle_id INT, IN quantity_returned INT, IN return_date DATE ) BEGIN INSERT INTO returns (customer_id, bicycle_id, quantity_returned, return_date) VALUES (customer_id, bicycle_id, quantity_returned, return_date);

UPDATE bicycles
SET stock = stock + quantity_returned
WHERE id = bicycle_id;
END $$

DELIMITER ;
```

### Caso de Uso 10

**Descripción:** Este caso de uso describe cómo el sistema genera un reporte de compras realizadas a un proveedor específico, mostrando todos los detalles de las compras.

```SQL
DELIMITER $$

CREATE PROCEDURE GeneratePurchaseReportBySupplier( IN supplier_id INT ) BEGIN SELECT p.id AS purchase_id, p.purchase_date, pd.spare_part_id, pd.quantity, pd.unit_price FROM purchases p JOIN purchase_details pd ON p.id = pd.purchase_id WHERE p.supplier_id = supplier_id; END $$

DELIMITER ;
```

### Caso de Uso 11

**Descripción:** Este caso de uso describe cómo el sistema aplica un descuento a una venta antes de registrar los detalles de la venta.

```SQL
DELIMITER $$

CREATE PROCEDURE CalculateDiscountedSale( IN sale_id INT, IN discount_percentage DECIMAL(5,2), OUT total_with_discount DECIMAL(10,2) ) BEGIN DECLARE total DECIMAL(10,2);

SELECT SUM(quantity * unit_price) INTO total
FROM sales_details
WHERE sale_id = sale_id;

SET total_with_discount = total * (1 - discount_percentage / 100);

UPDATE sales
SET total_amount = total_with_discount
WHERE id = sale_id;
END $$

DELIMITER ;
```

## Casos de Uso para Funciones de Resumen 

### Caso de Uso 1

**Descripción:** Este caso de uso describe cómo el sistema calcula el total de ventas realizadas en un mes específico.

```SQL
DELIMITER $$

CREATE FUNCTION TotalVentasMensuales( IN mes INT, IN año INT ) RETURNS DECIMAL(10, 2) BEGIN DECLARE total DECIMAL(10, 2);

SELECT SUM(sd.quantity * sd.unit_price) INTO total
FROM sales s
JOIN sales_details sd ON s.id = sd.sale_id
WHERE MONTH(s.sale_date) = mes AND YEAR(s.sale_date) = año;

RETURN total;
END $$

DELIMITER ;
```

### Caso de Uso 2

**Descripción:** Este caso de uso describe cómo el sistema calcula el promedio de ventas realizadas por un cliente específico.

```SQL
DELIMITER $$

CREATE FUNCTION PromedioVentasPorCliente( IN cliente_id INT ) RETURNS DECIMAL(10, 2) BEGIN DECLARE promedio DECIMAL(10, 2);

SELECT AVG(sd.quantity * sd.unit_price) INTO promedio
FROM sales s
JOIN sales_details sd ON s.id = sd.sale_id
WHERE s.customer_id = cliente_id;

RETURN promedio;
END $$

DELIMITER ;
```

### Caso de Uso 3

**Descripción:** Este caso de uso describe cómo el sistema cuenta el número de ventas realizadas dentro de un rango de fechas específico.

```SQL
DELIMITER $$

CREATE FUNCTION NumeroVentasEnRango( IN fecha_inicio DATE, IN fecha_fin DATE ) RETURNS INT BEGIN DECLARE total_ventas INT;

SELECT COUNT(*) INTO total_ventas
FROM sales
WHERE sale_date BETWEEN fecha_inicio AND fecha_fin;

RETURN total_ventas;
END $$

DELIMITER ;
```

### Caso de Uso 4

**Descripción:** Este caso de uso describe cómo el sistema calcula el total de repuestos comprados a un proveedor específico.

```SQL
DELIMITER $$

CREATE FUNCTION TotalRepuestosPorProveedor( IN proveedor_id INT ) RETURNS DECIMAL(10, 2) BEGIN DECLARE total DECIMAL(10, 2);

SELECT SUM(pd.quantity * pd.unit_price) INTO total
FROM purchases p
JOIN purchase_details pd ON p.id = pd.purchase_id
WHERE p.supplier_id = proveedor_id;

RETURN total;
END $$

DELIMITER ;
```

### Caso de Uso 5

**Descripción:** Este caso de uso describe cómo el sistema calcula el ingreso total generado en un año específico.

```SQL
DELIMITER $$

CREATE FUNCTION IngresoTotalPorAño( IN año INT ) RETURNS DECIMAL(10, 2) BEGIN DECLARE total DECIMAL(10, 2);

SELECT SUM(sd.quantity * sd.unit_price) INTO total
FROM sales s
JOIN sales_details sd ON s.id = sd.sale_id
WHERE YEAR(s.sale_date) = año;

RETURN total;
END $$

DELIMITER ;
```

### Caso de Uso 6

**Descripción:** Este caso de uso describe cómo el sistema cuenta el número de clientes que han realizado al menos una compra en un mes específico.

```SQL
DELIMITER $$

CREATE FUNCTION ClientesActivosEnMes( IN mes INT, IN año INT ) RETURNS INT BEGIN DECLARE total_clientes INT;

SELECT COUNT(DISTINCT s.customer_id) INTO total_clientes
FROM sales s
WHERE MONTH(s.sale_date) = mes AND YEAR(s.sale_date) = año;

RETURN total_clientes;
END $$

DELIMITER ;
```

### Caso de Uso 7

**Descripción:** Este caso de uso describe cómo el sistema calcula el promedio de compras realizadas a un proveedor específico.

```SQL
DELIMITER $$

CREATE FUNCTION PromedioComprasPorProveedor( IN proveedor_id INT ) RETURNS DECIMAL(10, 2) BEGIN DECLARE promedio DECIMAL(10, 2);

SELECT AVG(pd.quantity * pd.unit_price) INTO promedio
FROM purchases p
JOIN purchase_details pd ON p.id = pd.purchase_id
WHERE p.supplier_id = proveedor_id;

RETURN promedio;
END $$

DELIMITER ;
```

### Caso de Uso 8

**Descripción:** Este caso de uso describe cómo el sistema calcula el total de ventas agrupadas por la marca de las bicicletas vendidas.

```SQL
DELIMITER $$

CREATE FUNCTION TotalVentasPorMarca( IN marca VARCHAR(50) ) RETURNS DECIMAL(10, 2) BEGIN DECLARE total DECIMAL(10, 2);

SELECT SUM(sd.quantity * sd.unit_price) INTO total
FROM sales_details sd
JOIN bicycles b ON sd.bicycle_id = b.id
WHERE b.brand = marca;

RETURN total;
END $$

DELIMITER ;
```

### Caso de Uso 9

**Descripción:** Este caso de uso describe cómo el sistema calcula el promedio de precios de las bicicletas agrupadas por marca.

```SQL
DELIMITER $$

CREATE FUNCTION PromedioPreciosPorMarca( IN marca VARCHAR(50) ) RETURNS DECIMAL(10, 2) BEGIN DECLARE promedio DECIMAL(10, 2);

SELECT AVG(b.price) INTO promedio
FROM bicycles b
WHERE b.brand = marca;

RETURN promedio;
END $$

DELIMITER ;
```

### Caso de Uso 10

**Descripción:** Este caso de uso describe cómo el sistema cuenta el número de repuestos suministrados por cada proveedor.

```SQL
DELIMITER $$

CREATE FUNCTION NumeroRepuestosPorProveedor( IN proveedor_id INT ) RETURNS INT BEGIN DECLARE total_repuestos INT;

SELECT COUNT(*) INTO total_repuestos
FROM spare_parts sp
WHERE sp.supplier_id = proveedor_id;

RETURN total_repuestos;
END $$

DELIMITER ;
```

### Caso de Uso 11

**Descripción:** Este caso de uso describe cómo el sistema calcula el total de ingresos generados por cada cliente.

```SQL
DELIMITER $$

CREATE FUNCTION TotalIngresosPorCliente( IN cliente_id INT ) RETURNS DECIMAL(10, 2) BEGIN DECLARE total DECIMAL(10, 2);

SELECT SUM(sd.quantity * sd.unit_price) INTO total
FROM sales s
JOIN sales_details sd ON s.id = sd.sale_id
WHERE s.customer_id = cliente_id;

RETURN total;
END $$

DELIMITER ;
```

### Caso de Uso 12

**Descripción:** Este caso de uso describe cómo el sistema calcula el promedio de compras realizadas mensualmente por todos los clientes.

```SQL
DELIMITER $$

CREATE FUNCTION PromedioComprasMensuales() RETURNS DECIMAL(10, 2) BEGIN DECLARE promedio DECIMAL(10, 2);

SELECT AVG(monthly_total) INTO promedio
FROM (
    SELECT SUM(sd.quantity * sd.unit_price) AS monthly_total
    FROM sales s
    JOIN sales_details sd ON s.id = sd.sale_id
    GROUP BY YEAR(s.sale_date), MONTH(s.sale_date)
) AS monthly_sales;

RETURN promedio;
END $$

DELIMITER ;
```

### Caso de Uso 13

**Descripción:** Este caso de uso describe cómo el sistema calcula el total de ventas realizadas en cada día de la semana.

```SQL
DELIMITER $$

CREATE FUNCTION TotalVentasPorDiaDeLaSemana( IN dia_de_la_semana INT ) RETURNS DECIMAL(10, 2) BEGIN DECLARE total DECIMAL(10, 2);

SELECT SUM(sd.quantity * sd.unit_price) INTO total
FROM sales s
JOIN sales_details sd ON s.id = sd.sale_id
WHERE DAYOFWEEK(s.sale_date) = dia_de_la_semana;

RETURN total;
END $$

DELIMITER ;
```

### Caso de Uso 14

**Descripción:** Este caso de uso describe cómo el sistema cuenta el número de ventas realizadas para cada categoría de bicicleta (por ejemplo, montaña, carretera, híbrida).

```SQL
DELIMITER $$

CREATE FUNCTION NumeroVentasPorCategoria( IN categoria VARCHAR(50) ) RETURNS INT BEGIN DECLARE total_ventas INT;

SELECT COUNT(*) INTO total_ventas
FROM sales_details sd
JOIN bicycles b ON sd.bicycle_id = b.id
WHERE b.category = categoria;

RETURN total_ventas;
END $$

DELIMITER ;
```

### Caso de Uso 15

**Descripción:** Este caso de uso describe cómo el sistema calcula el total de ventas realizadas cada mes, agrupadas por año.

```SQL
DELIMITER $$

CREATE FUNCTION total_ventas_por_año_y_mes() RETURNS TABLE ( año INT, mes INT, total_ventas DECIMAL(10, 2) ) BEGIN RETURN ( SELECT YEAR(s.sale_date) AS año, MONTH(s.sale_date) AS mes, SUM(sd.quantity * sd.unit_price) AS total_ventas FROM sales s JOIN sales_details sd ON s.id = sd.sale_id GROUP BY YEAR(s.sale_date), MONTH(s.sale_date) ); END $$

DELIMITER ;
```

