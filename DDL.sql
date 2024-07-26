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
