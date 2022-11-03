/**
 * Commands used to create 5 tables in the database: vivero, zona. empleado, producto, cliente, cliente afiliado, cliente no afiliado, tiene y pedido.
 * 
 * usage:
 *  sudo su postgres
 *  psql
 *  \i vivero.sql
 */

/* Remove all the tables in 'public' schema and create the schema 'public' */ 
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

/* --DROP TABLES-- */
DROP TABLE IF EXISTS vivero;
DROP TABLE IF EXISTS zona;
DROP TABLE IF EXISTS empleado;
DROP TABLE IF EXISTS producto;
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS cliente_afiliado;
DROP TABLE IF EXISTS cliente_no_afiliado
DROP TABLE IF EXISTS tiene;
DROP TABLE IF EXISTS pedido;


/* -- CREATE TABLES -- */
/* Create the table 'vivero' */
CREATE TABLE vivero (
  id_vivero INT GENERATED ALWAYS AS IDENTIFY,
  ubicacion VARCHAR(100) NOT NULL,
  PRIMARY KEY(id_vivero)
);

/* Create the table 'zona' */
CREATE TABLE zona (
  id_zona INT GENERATED ALWAYS AS IDENTIFY,
  id_vivero INT,
  nombre_zona VARCHAR(20) NOT NULL,
  numero_ventas INT, --- atributo derivado
  PRIMARY KEY(id_zona)
  CONSTRAINT fk_id_vivero 
    FOREIGN KEY(id_vivero) 
      REFERENCES vivero(id_vivero) 
        ON DELETE CASCADE
);

/* Create the table 'empleado' */
CREATE TABLE empleado (
  dni_empleado INT GENERATED ALWAYS AS IDENTIFY,
  id_zona INT,
  nombre_empleado VARCHAR(255) NOT NULL,
  historico VARCHAR(255) NOT NULL, --- atributo derivado 
  puesto VARCHAR(255) NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE,
  PRIMARY KEY(dni_empleado)
  CONSTRAINT fk_id_zona 
    FOREIGN KEY(id_zona) 
      REFERENCES zona(id_zona) 
        ON DELETE CASCADE
);

/* Create the table 'producto' */
CREATE TABLE producto (
  id_producto INT GENERATED ALWAYS AS IDENTIFY,
  nombre_producto VARCHAR(255) NOT NULL,
  precio FLOAT,
  numero_stock INT, --- atributo derivado
  PRIMARY KEY(id_producto)
);

/* Create the table 'cliente' */
CREATE TABLE cliente (
  dni_cliente VARCHAR(9) NOT NULL,
  nombre_cliente VALUES(255) NOT NULL,
  tipo_cliente VARCHAR(10) NOT NULL,
  PRIMARY KEY(dni_cliente)
);

/* Create the table 'cliente afiliado' */
CREATE TABLE cliente_afiliado (
  dni_cliente VARCHAR(9) NOT NULL,
  bonificacion FLOAT,
  fecha_ingreso VARCHAR(6) NOT NULL,
  total_mensual FLOAT,
  PRIMARY KEY ( dni_cliente )
    CONSTRAINT fk_dni_cliente
      FOREIGN KEY(dni_cliente) 
        REFERENCES cliente(dni_cliente) 
          ON DELETE CASCADE
);

/* Create the table 'cliente no afiliado */
CREATE TABLE cliente_no_afiliado ( 
  dni_cliente VARCHAR(9) NOT NULL, 
  numero_compras INT,
  PRIMARY KEY ( dni_cliente )
    CONSTRAINT fk_dni_cliente
      FOREIGN KEY(dni_cliente) 
        REFERENCES cliente(dni_cliente) 
          ON DELETE CASCADE
);

/* Create the table 'tiene' */
CREATE TABLE tiene (
  id_zona INT NOT NULL,
  id_producto INT NOT NULL,
  stock INT,
  PRIMARY KEY(id_zona, id_producto)
  CONSTRAINT fk_id_zona 
    FOREIGN KEY(id_zona) 
      REFERENCES zona(id_zona) 
        ON DELETE CASCADE
  CONSTRAINT fk_id_producto 
    FOREIGN KEY(id_producto) 
      REFERENCES producto(id_producto) 
        ON DELETE CASCADE
);

/* Create the table 'pedido */
CREATE TABLE pedido (
  dni_empleado VARCHAR(9) NOT NULL,
  id_producto INT NOT NULL,
  dni_cliente VARCHAR(9) NOT NULL,
  fecha_compra DATE NOT NULL,
  precio_pedido FLOAT NOT NULL,
  PRIMARY KEY ( dni_empleado, id_producto, dni_cliente )
    CONSTRAINT fk_dni_empleado 
      FOREIGN KEY(dni_empleado) 
        REFERENCES empleado(dni_empleado) 
          ON DELETE CASCADE
    CONSTRAINT fk_id_producto
      FOREIGN KEY(id_producto) 
        REFERENCES producto(id_producto) 
          ON DELETE CASCADE
    CONSTRAINT fk_dni_cliente
      FOREIGN KEY(dni_cliente) 
        REFERENCES cliente(dni_cliente) 
          ON DELETE CASCADE
);

/* -- INSERT DATA -- */
/* Insert data into the table 'vivero' */
INSERT INTO vivero VALUES (id_vivero, ubicacion)
VALUES
  (1, 'Calle Los Sueños, 19'),
  (2, 'Calle Ramón y Cajal, 2'),
  (3, 'Calle La Trinidad, 3'),
  (4, 'Calle España, 27'),
  (5, 'Calle El Hidalgo, 8');

/* Insert data into the table 'zona' */
INSERT INTO zona VALUES (id_zona, id_vivero, nombre_zona, numero_ventas)
VALUES
  (1, 1, 'Zona exterior', 39),
  (2, 1, 'Almacén', 23),
  (3, 2, 'Cajas', 17),
  (4, 3, 'Zona exterior', 29),
  (5, 3, 'Cajas', 40);
  
/* Insert data into the table 'producto' */
INSERT INTO producto VALUES (id_producto, nombre_producto, precio, numero_stock)
VALUES
  (1, 'Helecho asplenium', 61.65, 300),
  (2, 'Helecho Dicksonia', 10.3, 250),
  (3, 'Lentejas de agua', 19.15, 150),
  (4, 'Petunia', 11.21, 100),
  (5, 'Croton', 26.88, 90);

/* Insert data into the table 'tiene' */
INSERT INTO tiene VALUES (id_zona, id_producto, stock)
VALUES
  (1, 1, 10),
  (1, 2, 20),
  (1, 3, 30),
  (1, 4, 40),
  (1, 5, 50),
  (2, 1, 10),
  (2, 2, 20),

/* Insert data into the table 'empleado' */
INSERT INTO empleado VALUES (dni_empleado, nombre_empleado, historico)
VALUES
  ('14769497W', 'Salma Blasco', 'Ha realizado 20 ventas'),
  ('30094494Y', 'Ismail Salvador', 'Ha realizado 30 venta'),
  ('41603427S', 'Jose Antonio Megias', 'Ha reliado 40 ventas'),
  ('86537048P', 'Angeles Cabello', 'Ha realizado 5 ventas'),
  ('20891673Z', 'Jess Duque', 'Ha realizado 55 ventas');
  
/* Insert data into the table 'cliente' */
INSERT INTO cliente VALUES (dni_cliente, tipo_cliente, bonificacion, fecha_ingreso, total_mensual)
VALUES
  ('45714294T', 'Salah Figueras', 49.30, '01/01/2000', 9094.68),
  ('53059518J', 'Ramiro Navarrete', 73.15, '02/02/2000', 6022.42),
  ('56490217D', 'Ezequiel Cabeza', 40.8, '03/03/2000', 6380.35),
  ('51673145B', 'Aquilino Criado', 20.62, '04/04/2000', 6544.13),
  ('82367086S', 'Jan Puerta', 54.36, '05/05/2000',  5246.95);

/* Insert data into the table 'cliente_afiliado' */
INSERT INTO cliente_afiliado VALUES(dni_cliente, bonificacion, fecha_ingreso, total_mensual)
VALUES
  ('45714294T', 49.30, '01/01/2000', 9094.68),
  ('56490217D', 40.8,  '03/03/2000', 6380.35),
  ('82367086S', 34.36, '05/05/2000',  5246.95);

/* Insert data into the table 'cliente no afiliado' */
INSERT INTO cliente_no_afiliado VALUES(dni_cliente, numero_compras)
  ('53059518J', 12),
  ('51673145B', 20);
  
/* Insert data into the table 'pedido' */  
INSERT INTO pedido VALUES (dni_empleado, id_producto, dni_cliente, fecha_compra, precio_pedido)
  ('14769497W', 1, '53059518J', '01/04/2022', 1213.46),
  ('30094494Y', 2, '56490217D', '16/07/2022', 5242.05),
  ('41603427S', 3, '82367086S', '10/10/2022', 10010.15),
  ('86537048P', 4, '45714294T', '23/02/2022', 9240.78),
  ('14769497W', 5, '45714294T', '02/11/2022', 7728.99);

/* -- SELECT DATA FROM TABLES -- */ 
/* select all the data from the table 'vivero' */
SELECT * FROM vivero;

/* select all the data from the table 'zona' */
SELECT * FROM zona;

/* select all the data from the table 'producto' */
SELECT * FROM producto;

/* select all the data from the table 'empleado' */
SELECT * FROM empleado;

/* select all the data from the table 'cliente' */
SELECT * FROM cliente;

/* select all the data from the table 'cliente afiliado' */
SELECT * FROM cliente_afiliado;

/* select all the data from the table 'cliente no afiliado' */
SELECT * FROM cliente_no_afiliado;

/* select all the data from the table 'tiene' */
SELECT * FROM tiene;

/* select all the data from the table 'pedido' */
SELECT * FROM pedido;