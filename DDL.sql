CREATE TABLE countries (
    id INT(10) AUTO_INCREMENT,
    name VARCHAR(30),
    CONSTRAINT pk_countries_id PRIMARY KEY (id)
);

CREATE TABLE cities (
    id INT(10) AUTO_INCREMENT,
    name VARCHAR(30),
    country_id INT(10),
    CONSTRAINT pk_cities_id PRIMARY KEY(id),
    CONSTRAINT fk_cities_country FOREIGN KEY (country_id) REFERENCES countries(id)
);

CREATE TABLE phone_types (
    id INT(10) AUTO_INCREMENT,
    type VARCHAR(20),
    CONSTRAINT pk_phone_types_id PRIMARY KEY (id)
);

CREATE TABLE document_types (
    id INT(10) AUTO_INCREMENT,
    type VARCHAR(30),
    CONSTRAINT pk_document_types_id PRIMARY KEY (id)
);

CREATE TABLE customers (
    id INT(10) AUTO_INCREMENT,
    full_name VARCHAR(30),
    email VARCHAR(40),
    phone VARCHAR(15),
    phone_type_id INT(10),
    document_number VARCHAR(20),
    document_type_id INT(10),
    city_id INT(10),
    CONSTRAINT pk_customers_id PRIMARY KEY(id),
    CONSTRAINT fk_customers_city FOREIGN KEY (city_id) REFERENCES cities(id),
    CONSTRAINT fk_customers_phone_type FOREIGN KEY (phone_type_id) REFERENCES phone_types(id),
    CONSTRAINT fk_customers_document_type FOREIGN KEY (document_type_id) REFERENCES document_types(id)
);

CREATE TABLE suppliers (
    id INT(10) AUTO_INCREMENT,
    name VARCHAR(50),
    phone VARCHAR(15),
    phone_type_id INT(10),
    email VARCHAR(40),
    document_number VARCHAR(20),
    document_type_id INT(10),
    city_id INT(10),
    contact_person VARCHAR(15),
    CONSTRAINT pk_suppliers_id PRIMARY KEY(id),
    CONSTRAINT fk_suppliers_city FOREIGN KEY (city_id) REFERENCES cities(id),
    CONSTRAINT fk_suppliers_phone_type FOREIGN KEY (phone_type_id) REFERENCES phone_types(id),
    CONSTRAINT fk_suppliers_document_type FOREIGN KEY (document_type_id) REFERENCES document_types(id)
);

CREATE TABLE bicycles (
    id INT(10) AUTO_INCREMENT,
    model VARCHAR(30),
    brand VARCHAR(15),
    price DECIMAL(10,2),
    stock BIGINT,
    CONSTRAINT pk_bicycles_id PRIMARY KEY (id)
);

CREATE TABLE purchases (
    id INT(10) AUTO_INCREMENT,
    purchase_date DATE,
    supplier_id INT(10),
    total_amount DECIMAL(10,2),
    CONSTRAINT pk_purchases_id PRIMARY KEY(id),
    CONSTRAINT fk_purchases_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

CREATE TABLE spare_parts (
    id INT(10) AUTO_INCREMENT,
    name VARCHAR(30),
    description VARCHAR(300),
    price DECIMAL(10,2),
    stock BIGINT,
    supplier_id INT(10),
    CONSTRAINT pk_spare_parts_id PRIMARY KEY(id),
    CONSTRAINT fk_spare_parts_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

CREATE TABLE sales (
    id INT(10) AUTO_INCREMENT,
    sale_date DATE,
    customer_id INT(10),
    CONSTRAINT pk_sales_id PRIMARY KEY(id),
    CONSTRAINT fk_sales_customer FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE sales_details (
    id INT(10) AUTO_INCREMENT,
    sale_id INT(10),
    bicycle_id INT(10),
    quantity BIGINT,
    unit_price DECIMAL(10,2),
    CONSTRAINT pk_sales_details_id PRIMARY KEY(id),
    CONSTRAINT fk_sales_details_sale FOREIGN KEY (sale_id) REFERENCES sales(id),
    CONSTRAINT fk_sales_details_bicycle FOREIGN KEY (bicycle_id) REFERENCES bicycles(id)
);

CREATE TABLE purchase_details (
    id INT(10) AUTO_INCREMENT,
    quantity BIGINT,
    unit_price DECIMAL(10,2),
    spare_part_id INT(10),
    purchase_id INT(10),
    CONSTRAINT pk_purchase_details_id PRIMARY KEY (id),
    CONSTRAINT fk_purchase_details_spare_part FOREIGN KEY (spare_part_id) REFERENCES spare_parts(id),
    CONSTRAINT fk_purchase_details_purchase FOREIGN KEY (purchase_id) REFERENCES purchases(id)
);


/* Procedimientos Almacenados */

/* Caso de uso 1 */

DELIMITER $$

CREATE PROCEDURE UpdateBicycleStock(
    IN bicycle_id INT,
    IN quantity_sold INT
)
BEGIN
    UPDATE bicycles
    SET stock = stock - quantity_sold
    WHERE id = bicycle_id;
END $$

DELIMITER ;


/* Caso de uso 2 */

DELIMITER $$

CREATE PROCEDURE RegisterNewSale(
    IN customer_id INT,
    IN sale_date DATE,
    INOUT sale_id INT
)
BEGIN
    INSERT INTO sales (sale_date, customer_id) VALUES (sale_date, customer_id);
    SET sale_id = LAST_INSERT_ID();
END $$


CREATE PROCEDURE RegisterSaleDetails(
    IN sale_id INT,
    IN bicycle_id INT,
    IN quantity BIGINT,
    IN unit_price DECIMAL(10,2)
)
BEGIN
    INSERT INTO sales_details (sale_id, bicycle_id, quantity, unit_price)
    VALUES (sale_id, bicycle_id, quantity, unit_price);
    
    CALL UpdateBicycleStock(bicycle_id, quantity);
END $$

DELIMITER ;

/* Caso de uso 3 */

DELIMITER $$

CREATE PROCEDURE GenerateSalesReportByCustomer(
    IN customer_id INT
)
BEGIN
    SELECT s.id AS sale_id, s.sale_date, sd.bicycle_id, sd.quantity, sd.unit_price
    FROM sales s
    JOIN sales_details sd ON s.id = sd.sale_id
    WHERE s.customer_id = customer_id;
END $$

DELIMITER ;

/* Caso de Uso 4 */

DELIMITER $$

CREATE PROCEDURE RegisterNewPurchase(
    IN supplier_id INT,
    IN purchase_date DATE,
    IN total_amount DECIMAL(10,2),
    INOUT purchase_id INT
)
BEGIN
    INSERT INTO purchases (purchase_date, supplier_id, total_amount) VALUES (purchase_date, supplier_id, total_amount);
    SET purchase_id = LAST_INSERT_ID();
END;

CREATE PROCEDURE RegisterPurchaseDetails(
    IN purchase_id INT,
    IN spare_part_id INT,
    IN quantity BIGINT,
    IN unit_price DECIMAL(10,2)
)
BEGIN
    INSERT INTO purchase_details (purchase_id, spare_part_id, quantity, unit_price)
    VALUES (purchase_id, spare_part_id, quantity, unit_price);
    
    UPDATE spare_parts
    SET stock = stock + quantity
    WHERE id = spare_part_id;
END $$

DELIMITER ;

/* Caso de uso 5 */

DELIMITER $$

CREATE PROCEDURE GenerateInventoryReport()
BEGIN
    SELECT id, model, brand, price, stock FROM bicycles;
    SELECT id, name, description, price, stock FROM spare_parts;
END $$

DELIMITER ;

/* Caso de uso 6 */

DELIMITER $$

CREATE PROCEDURE UpdatePricesByBrand(
    IN brand_name VARCHAR(50),
    IN percentage_increase DECIMAL(5,2)
)
BEGIN
    UPDATE bicycles
    SET price = price * (1 + percentage_increase / 100)
    WHERE brand = brand_name;
END $$

DELIMITER ;


/* Caso de uso 7 */

DELIMITER $$

CREATE PROCEDURE GenerateCustomerReportByCity()
BEGIN
    SELECT ct.name AS city, c.id AS customer_id, c.full_name AS customer_name
    FROM customers c
    JOIN cities ct ON c.city_id = ct.id
    ORDER BY ct.name, c.full_name;
END $$

DELIMITER ;

/* Caso de uso 8 */

DELIMITER $$

CREATE PROCEDURE CheckBicycleStock(
    IN bicycle_id INT,
    IN quantity_required INT,
    OUT stock_status VARCHAR(50)
)
BEGIN
    DECLARE current_stock INT;
    
    SELECT stock INTO current_stock FROM bicycles WHERE id = bicycle_id;
    
    IF current_stock >= quantity_required THEN
        SET stock_status = 'Sufficient stock';
    ELSE
        SET stock_status = 'Insufficient stock';
    END IF;
END $$

DELIMITER ;


/* Caso de uso 9 */

DELIMITER $$

CREATE PROCEDURE RegisterReturn(
    IN customer_id INT,
    IN bicycle_id INT,
    IN quantity_returned INT,
    IN return_date DATE
)
BEGIN
    INSERT INTO returns (customer_id, bicycle_id, quantity_returned, return_date)
    VALUES (customer_id, bicycle_id, quantity_returned, return_date);
    
    UPDATE bicycles
    SET stock = stock + quantity_returned
    WHERE id = bicycle_id;
END $$

DELIMITER ;


/* Caso de Uso 10 */

DELIMITER $$

CREATE PROCEDURE GeneratePurchaseReportBySupplier(
    IN supplier_id INT
)
BEGIN
    SELECT p.id AS purchase_id, p.purchase_date, pd.spare_part_id, pd.quantity, pd.unit_price
    FROM purchases p
    JOIN purchase_details pd ON p.id = pd.purchase_id
    WHERE p.supplier_id = supplier_id;
END $$

DELIMITER ;


/* Caso de uso 11 */

DELIMITER $$

CREATE PROCEDURE CalculateDiscountedSale(
    IN sale_id INT,
    IN discount_percentage DECIMAL(5,2),
    OUT total_with_discount DECIMAL(10,2)
)
BEGIN
    DECLARE total DECIMAL(10,2);
    
    SELECT SUM(quantity * unit_price) INTO total
    FROM sales_details
    WHERE sale_id = sale_id;
    
    SET total_with_discount = total * (1 - discount_percentage / 100);
    
    UPDATE sales
    SET total_amount = total_with_discount
    WHERE id = sale_id;
END $$

DELIMITER ;


/* Funciones de Resumen */

/* Caso de Uso 1 */

DELIMITER $$

CREATE FUNCTION TotalVentasMensuales(
    IN mes INT,
    IN año INT
) RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE total DECIMAL(10, 2);
    
    SELECT SUM(sd.quantity * sd.unit_price) INTO total
    FROM sales s
    JOIN sales_details sd ON s.id = sd.sale_id
    WHERE MONTH(s.sale_date) = mes AND YEAR(s.sale_date) = año;
    
    RETURN total;
END $$

DELIMITER ;

/* Caso de uso 2 */

DELIMITER $$

CREATE FUNCTION PromedioVentasPorCliente(
    IN cliente_id INT
) RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE promedio DECIMAL(10, 2);
    
    SELECT AVG(sd.quantity * sd.unit_price) INTO promedio
    FROM sales s
    JOIN sales_details sd ON s.id = sd.sale_id
    WHERE s.customer_id = cliente_id;
    
    RETURN promedio;
END $$

DELIMITER ;

/* Caso de uso 3 */

DELIMITER $$

CREATE FUNCTION NumeroVentasEnRango(
    IN fecha_inicio DATE,
    IN fecha_fin DATE
) RETURNS INT
BEGIN
    DECLARE total_ventas INT;
    
    SELECT COUNT(*) INTO total_ventas
    FROM sales
    WHERE sale_date BETWEEN fecha_inicio AND fecha_fin;
    
    RETURN total_ventas;
END $$

DELIMITER ;


/* Caso de Uso 4 */

DELIMITER $$

CREATE FUNCTION TotalRepuestosPorProveedor(
    IN proveedor_id INT
) RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE total DECIMAL(10, 2);
    
    SELECT SUM(pd.quantity * pd.unit_price) INTO total
    FROM purchases p
    JOIN purchase_details pd ON p.id = pd.purchase_id
    WHERE p.supplier_id = proveedor_id;
    
    RETURN total;
END $$

DELIMITER ;

/* Caso de uso 5 */

DELIMITER $$

CREATE FUNCTION IngresoTotalPorAño(
    IN año INT
) RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE total DECIMAL(10, 2);
    
    SELECT SUM(sd.quantity * sd.unit_price) INTO total
    FROM sales s
    JOIN sales_details sd ON s.id = sd.sale_id
    WHERE YEAR(s.sale_date) = año;
    
    RETURN total;
END $$

DELIMITER ;


/* Caso de uso 6 */
DELIMITER $$

CREATE FUNCTION ClientesActivosEnMes(
    IN mes INT,
    IN año INT
) RETURNS INT
BEGIN
    DECLARE total_clientes INT;
    
    SELECT COUNT(DISTINCT s.customer_id) INTO total_clientes
    FROM sales s
    WHERE MONTH(s.sale_date) = mes AND YEAR(s.sale_date) = año;
    
    RETURN total_clientes;
END $$

DELIMITER ;

/* Caso de uso 7 */

DELIMITER $$

CREATE FUNCTION PromedioComprasPorProveedor(
    IN proveedor_id INT
) RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE promedio DECIMAL(10, 2);
    
    SELECT AVG(pd.quantity * pd.unit_price) INTO promedio
    FROM purchases p
    JOIN purchase_details pd ON p.id = pd.purchase_id
    WHERE p.supplier_id = proveedor_id;
    
    RETURN promedio;
END $$

DELIMITER ;

/* Caso de uso 8 */

DELIMITER $$

CREATE FUNCTION TotalVentasPorMarca(
    IN marca VARCHAR(50)
) RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE total DECIMAL(10, 2);
    
    SELECT SUM(sd.quantity * sd.unit_price) INTO total
    FROM sales_details sd
    JOIN bicycles b ON sd.bicycle_id = b.id
    WHERE b.brand = marca;
    
    RETURN total;
END $$

DELIMITER ;

/* Caso de uso 9 */

DELIMITER $$

CREATE FUNCTION PromedioPreciosPorMarca(
    IN marca VARCHAR(50)
) RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE promedio DECIMAL(10, 2);
    
    SELECT AVG(b.price) INTO promedio
    FROM bicycles b
    WHERE b.brand = marca;
    
    RETURN promedio;
END $$

DELIMITER ;

/* Caso de uso 10 */

DELIMITER $$

CREATE FUNCTION NumeroRepuestosPorProveedor(
    IN proveedor_id INT
) RETURNS INT
BEGIN
    DECLARE total_repuestos INT;
    
    SELECT COUNT(*) INTO total_repuestos
    FROM spare_parts sp
    WHERE sp.supplier_id = proveedor_id;
    
    RETURN total_repuestos;
END $$

DELIMITER ;

/* Caso de uso 11 */

DELIMITER $$

CREATE FUNCTION TotalIngresosPorCliente(
    IN cliente_id INT
) RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE total DECIMAL(10, 2);
    
    SELECT SUM(sd.quantity * sd.unit_price) INTO total
    FROM sales s
    JOIN sales_details sd ON s.id = sd.sale_id
    WHERE s.customer_id = cliente_id;
    
    RETURN total;
END $$

DELIMITER ;


/* Caso de uso 12 */

DELIMITER $$

CREATE FUNCTION PromedioComprasMensuales() RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE promedio DECIMAL(10, 2);
    
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


/* Caso de Uso 13 */

DELIMITER $$

CREATE FUNCTION TotalVentasPorDiaDeLaSemana(
    IN dia_de_la_semana INT
) RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE total DECIMAL(10, 2);
    
    SELECT SUM(sd.quantity * sd.unit_price) INTO total
    FROM sales s
    JOIN sales_details sd ON s.id = sd.sale_id
    WHERE DAYOFWEEK(s.sale_date) = dia_de_la_semana;
    
    RETURN total;
END $$

DELIMITER ;

/* Caso de uso 14 */

DELIMITER $$

CREATE FUNCTION NumeroVentasPorCategoria(
    IN categoria VARCHAR(50)
) RETURNS INT
BEGIN
    DECLARE total_ventas INT;
    
    SELECT COUNT(*) INTO total_ventas
    FROM sales_details sd
    JOIN bicycles b ON sd.bicycle_id = b.id
    WHERE b.category = categoria;
    
    RETURN total_ventas;
END $$

DELIMITER ;


/* Caso de uso 15 */

DELIMITER $$

CREATE FUNCTION total_ventas_por_año_y_mes() RETURNS TABLE (
    año INT,
    mes INT,
    total_ventas DECIMAL(10, 2)
)
BEGIN
    RETURN (
        SELECT YEAR(s.sale_date) AS año, MONTH(s.sale_date) AS mes, SUM(sd.quantity * sd.unit_price) AS total_ventas
        FROM sales s
        JOIN sales_details sd ON s.id = sd.sale_id
        GROUP BY YEAR(s.sale_date), MONTH(s.sale_date)
    );
END $$

DELIMITER ;