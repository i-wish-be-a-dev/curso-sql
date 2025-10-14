--CREACION DE LAS TABLAS DEL EJERCICIO GUIA PRACTICA 8
--2)
CREATE TABLE Clientes(
	Cli_Codigo INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    Cli_RazonSocial varchar (100),
    Cli_TipoDocumento int,
    Cli_NumDocumento varchar(20),
    Cli_FechaNacimiento date,
    Cli_Estado varchar(1),
    FOREIGN KEY(Cli_TipoDocumento) REFERENCES Tipo_Documento(TDC_Codigo)
);

--3)
CREATE TABLE Domicilio_Cliente (
	Dom_CodCliente INT,
    Dom_Codigo INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Dom_Domicilio VARCHAR(150),
    Dom_CodLocalidad INT,
    Dom_Principal Boolean,
    FOREIGN KEY(Dom_CodCliente) REFERENCES Clientes(Cli_Codigo)
);

--1)
CREATE TABLE Tipo_Documento(
	 TDC_Codigo INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
     TDC_Descripcion VARCHAR(150) 
);
--4)
CREATE TABLE Factura_Cabecera (
	Fac_Codigo INT PRIMARY KEY NOT NULL,
    Fac_Sucursal INT,
    Fac_Numero INT,
    Fac_Fecha DATE,
    Fac_CodCliente INT,
    FOREIGN KEY (Fac_CodCliente) REFERENCES Clientes(Cli_Codigo)
); 

--6)
CREATE TABLE Factura_Item (
	Item_CodFactura  INT,
    Item_Codigo INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	Item_CodArticulo INT, 
    Item_Cantidad INT,
    Item_PrecioUnitario DECIMAL(10,2), --10 digitos, 2 decimales
    FOREIGN KEY(Item_CodFactura) REFERENCES Factura_Cabecera(Fac_Codigo),
    FOREIGN KEY(Item_CodArticulo) REFERENCES Articulo(Art_Codigo)
);

--5)
CREATE TABLE Articulo(
	Art_Codigo INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    Art_Descripcion VARCHAR(150),
    Art_TipoArticulo VARCHAR(50),
    Art_Estado VARCHAR(1)

);
--Insertar registros en todas las tablas.
INSERT INTO Tipo_Documento (TDC_Codigo, TDC_Descripcion) VALUES
('DNI'),
('CUIT'),
('CUIL'),
('PASAPORTE');


INSERT INTO Clientes (Cli_RazonSocial, Cli_TipoDocumento, Cli_NumDocumento, Cli_FechaNacimiento, Cli_Estado) VALUES
('Juan Perez', 1, '12345678', '1980-05-15', 'A'),
('Maria Gomez', 2, '20304050', '1975-10-20', 'A'),
('Carlos Lopez', 3, '27384950', '1990-03-25', 'I'),
('Ana Martinez', 1, '87654321', '1985-07-30', 'A'),
('Luis Rodriguez', 2, '30405060', '1970-12-10', 'A');

INSERT INTO clientes 
VALUES (8,"Lucia Gomez", 1, "12341213", '1980-05-15', 'A');


INSERT INTO Domicilio_Cliente (Dom_CodCliente, Dom_Domicilio, Dom_CodLocalidad, Dom_Principal) VALUES
(1, 'Calle Falsa 123', 1, TRUE),
(1, 'Avenida Siempre Viva 456', 2, FALSE),
(2, 'Boulevard Central 789', 3, TRUE),
(3, 'Calle Secundaria 101', 4, TRUE),
(4, 'Avenida Principal 202', 5, TRUE),
(5, 'Calle Terciaria 303', 6, TRUE),
(5, 'Avenida Cuarta 404', 7, FALSE);


INSERT INTO Articulo (Art_Descripcion, Art_TipoArticulo, Art_Estado) VALUES
('Laptop Dell', 'Electrónica', 'A'),
('Smartphone Samsung', 'Electrónica', 'A'),
('Tablet Apple', 'Electrónica', 'I'),
('Monitor LG', 'Electrónica', 'A'),
('Impresora HP', 'Electrónica', 'A');

INSERT INTO Factura_Cabecera (Fac_Codigo, Fac_Sucursal, Fac_Numero, Fac_Fecha, Fac_CodCliente) VALUES
(1, 1, 1001, '2023-01-15', 1),
(2, 1, 1002, '2023-01-16', 2),
(3, 2, 2001, '2023-01-17', 3),
(4, 2, 2002, '2023-01-18', 4),
(5, 3, 3001, '2023-01-19', 5);

INSERT INTO Factura_Item (Item_CodFactura, Item_CodArticulo, Item_Cantidad, Item_PrecioUnitario) VALUES
(1, 1, 2, 1500.00),
(1, 2, 1, 800.00),
(2, 3, 3, 600.00),
(3, 4, 1, 300.00),
(4, 5, 2, 200.00),
(5, 1, 1, 1500.00),
(5, 2, 2, 800.00);
--FIN DEL SCRIPT


--Crear una nueva tabla "Tipo_Producto", que contenga código y descripción.

CREATE TABLE Tipo_Producto(
	TP_Codigo INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    TP_Descripcion VARCHAR(150)
    );

--Modificar la tabla Artículo, agregando la clave foránea a la tabla Tipo_Producto
ALTER TABLE Articulo
ADD COLUMN Cod_TPRod INT,
ADD FOREIGN KEY(Cod_TPRod) REFERENCES tipo_producto(TP_Codigo)


--Crear una nueva tabla “Estado_Civil” que contenga código y descripción.
CREATE TABLE Estado_Civil(
	codigo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(150)
);

--Modificar la tabla clientes, agregando una columna para indicar el estado civil de la
--persona, la cual debe hacer referencia a la tabla previamente creada. Puede admitir
--valores nulos


ALTER TABLE clientes 
ADD COLUMN Cli_CodEstadoCivil INT,
ADD FOREIGN KEY (Cli_CodEstadoCivil) REFERENCES estado_civil(codigo);



--Vuelva a ejecutar las sentencias para insertar clientes cambiando solo el código.
--Modifique la sentencia anterior para indicar el estado civil.


--Observaciones, si no hay registros en la tabla Estado_Civil, no se podrá insertar registros en
--Clientes, ya que la clave foránea no tendrá referencia.

--CASADO = 2 SOLTERO = 1
INSERT INTO estado_civil (descripcion)
VALUES ('soltero'), ('casado');


INSERT INTO Clientes (Cli_RazonSocial, Cli_TipoDocumento, Cli_NumDocumento, Cli_FechaNacimiento, Cli_Estado, Cli_CodEstadoCivil) VALUES
('Juan Perez', 1, '12345678', '1980-05-15', 'A', 2),
('Maria Gomez', 2, '20304050', '1975-10-20', 'A', 1),
('Carlos Lopez', 3, '27384950', '1990-03-25', 'I', 1),
('Ana Martinez', 1, '87654321', '1985-07-30', 'A', 1),
('Luis Rodriguez', 2, '30405060', '1970-12-10', 'A', 2);


--Actualizar los datos de la tabla clientes, indicando estado civil a las clientes cuyo código
--sea menor a 3.
UPDATE clientes SET Cli_CodEstadoCivil = 1 WHERE clientes.Cli_Codigo <= 3;



--Modificar la tabla clientes, agregando una nueva columna para indicar el límite de crédito
--permitido. Es necesario que este campo siempre tenga valor. En caso de no indicarse
--alguno, debe ser 0.
ALTER TABLE clientes
ADD COLUMN Cli_LimiteCredito DECIMAL(10,2) DEFAULT 0


--Insertar un nuevo cliente sin indicar el límite de crédito.

INSERT INTO clientes (Cli_RazonSocial, Cli_TipoDocumento,Cli_NumDocumento,Cli_FechaNacimiento,Cli_Estado, Cli_CodEstadoCivil)
VALUES("ROBERTO CULO ABIERTO", 1, "22232332", "1980-12-25",'A', 1)

--Borrar los clientes cuyo límite de crédito sea mayor a 0.
--INSERTANDO DATOS CON LIMITE DE CREDITO
INSERT INTO clientes (Cli_RazonSocial, Cli_TipoDocumento,Cli_NumDocumento,Cli_FechaNacimiento,Cli_Estado, Cli_CodEstadoCivil, Cli_CreditoLimite)
VALUES("ROBERTO CULO CERRADO", 1, "22232332", "1980-12-25",'A', 1, 800.00),
	("MARCELO AGACHATE Y", 2, "111332", "1925-01-30",'B', 2, 900.00),
    ("JUAN ", 3, "001332", "1945-10-31",'C', 1, 10.00)



--BORRANDOLOS

DELETE FROM clientes WHERE Cli_CreditoLimite > 0;
SELECT * FROM clientes;


--Seleccionar el código, razón social y fecha de nacimiento de los clientes cuyo tipo de
--documento sea 1 y el estado sea activo (A).

SELECT Cli_Codigo, Cli_RazonSocial, Cli_FechaNacimiento FROM clientes
WHERE  Cli_TipoDocumento = 1 AND  Cli_Estado = 'A';


--Seleccionar los items facturados, mostrando código de artículo, cantidad y precio, cuando
--el precio sea mayor a 100 o la cantidad sea mayor a 5, ordenados por código de artículo
--de mayor a menor.

SELECT Item_Codigo, Item_PrecioUnitario, Item_Cantidad FROM factura_item
WHERE (Item_PrecioUnitario > 1000) OR (Item_Cantidad > 5) 
ORDER BY Item_Codigo DESC;