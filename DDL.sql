CREATE DATABASE CampusBike;

USE CampusBike;

CREATE TABLE paises(
    id INT(10) AUTOINCREMENT,
    nombre VARCHAR(30),
    PRIMARY KEY(id)
);

CREATE TABLE ciudades(
    id INT(10) AUTOINCREMENT,
    nombre VARCHAR(30),
    PRIMARY KEY (id)    
);