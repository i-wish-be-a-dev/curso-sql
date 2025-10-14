/*Información del zoológico
En un zoológico, las distintas especies de animales están alojados organizados en zonas
dentro del parque. Además de la zona en la que se encuentra cada especie, se conoce un
código, su nombre, nombre científico y una descripción de la especie.
Las zonas son identificadas por un código, nombre y extensión de la misma en m2.
De los empleados se conoce su número de legajo, nombre, dirección, teléfono y fecha de
ingreso. Un empleado puede ser cuidador o guía. Los cuidadores tienen asignados una o
más especies, conociéndose la fecha en que se hace cargo de cada especie.
Por otro lado, los guías son quienes se encargan de acompañar a los visitantes a través de
los distintos itinerarios que hay para recorrer el parque. De estos itinerarios se conoce un
código, duración. longitud y la cantidad máxima de visitantes que permite. También se
conoce cuáles zonas del parque son visitadas por cada itinerario. Un guía puede participar
en más de un itinerario, y un itinerario puede ser recorrido por más de un guía. Para cada
uno de estos casos se sabe la hora en que se realiza.*/
/*Tabla Zonas:
Codigo: INT PK
Nombre: VARCHAR(50)
Extension: INT

Tabla Especies:
Codigo: INT PK
Nombre: VARCHAR(50)
Nombre_Cientifico: VARCHAR(100)
Descripcion: TEXT
Cod_Zona: INT FK

Tabla Empleados:
Legajo: INT PK
Nombre: VARCHAR(100)
Direccion: VARCHAR(150)
Telefono: VARCHAR(15)
Fecha_Ingreso: DATE
Codigo_Rol: INT FK

Tabla Empleado_Rol:
Codigo: INT PK
Tipo: ENUM('Cuidador', 'Guia')

Tabla Cuidador_Especie:
Codigo: INT PK
Legajo_Cuidador: INT FK
Cod_Especie: INT FK
Fecha_Asignacion: DATE

Tabla Itinerarios:
Codigo: INT PK
Duracion: INT
Longitud: INT
Cantidad_Maxima_Visitantes: INT

Tabla Itinerario_Zona:
Codigo: INT PK
Cod_Itinerario: INT FK
Cod_Zona: INT FK


Tabla Itinerario_Guia:
Codigo: INT PK
Legajo_Guia: INT FK
Cod_Itinerario: INT FK
Hora_Realizacion: DATETIME

*/

CREATE TABLE zonas(
	codigo INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    extension INT NOT NULL
);

CREATE TABLE especies(
	codigo INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
	nombre_cientifico VARCHAR(100) NOT NULL,
    descripcion VARCHAR(150) NOT NULL,
    cod_zona INT,
    FOREIGN KEY (cod_zona) REFERENCES zonas(codigo)
);

CREATE TABLE empleado_rol(
	codigo INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    tipo VARCHAR(25) NOT NULL
);

CREATE TABLE empleados(
	legajo INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
	direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(100) NOT NULL,
    fecha_ingreso DATE,
    codigo_rol INT,
    FOREIGN KEY (codigo_rol) REFERENCES empleado_rol(codigo)
);


CREATE TABLE cuidador_especie (
	codigo INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    legajo_cuidador INT NOT NULL,
    cod_especie INT NOT NULL,
    fecha_asignacion INT NOT NULL
);


CREATE TABLE cuidador_especie (
	codigo INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    legajo_cuidador INT NOT NULL,
    cod_especie INT NOT NULL,
    fecha_asignacion INT NOT NULL
);

ALTER TABLE cuidador_especie
ADD FOREIGN KEY (legajo_cuidador) REFERENCES empleados(legajo),
ADD FOREIGN KEY (cod_especie) REFERENCES especies(codigo)


CREATE TABLE itinerarios(
	codigo INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    duracion INT NOT NULL,
	longitud INT NOT NULL,
    max_visitantes INT NOT NULL
);

CREATE TABLE itinerario_zonas(
	codigo INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    cod_itinerario INT NOT NULL,
    cod_zona INT NOT NULL,
    FOREIGN KEY (cod_itinerario) REFERENCES itinerarios(codigo),
    FOREIGN KEY (cod_zona ) REFERENCES zonas(codigo)
);

CREATE TABLE itinerario_guia(
	codigo INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    cod_itinerario INT NOT NULL, 
    legajo_guia INT NOT NULL,
    hora_realizacion DATETIME,
	FOREIGN KEY (cod_itinerario) REFERENCES itinerarios(codigo),
    FOREIGN KEY (legajo_guia) REFERENCES empleados(legajo)
    );

--Insertar registros en todas las tablas.

INSERT INTO zonas (nombre, extension) VALUES
('Sabana Africana',5000), 
('Selva Amazonica',4000), 
('Pantano Tropical',5), 
('Montaña Rocosa',2800),
('Bosque Patagonico', 2000);

INSERT INTO especies (nombre, nombre_cientifico, descripcion, cod_zona) VALUES
('León', 'Panthera leo', 'El león es un mamífero carnívoro de la familia de los félidos.', 1),
('Tigre', 'Panthera tigris', 'El tigre es una especie de mamífero carnívoro de la familia de los félidos.', 2),
('Cocodrilo', 'Crocodylus porosus', 'El cocodrilo es un reptil grande y semiacuático que se encuentra en regiones tropicales.', 3),
('Águila Real', 'Aquila chrysaetos', 'El águila real es una especie de ave rapaz de gran tamaño.', 4),
('Pingüino Emperador', 'Aptenodytes forsteri', 'El pingüino emperador es la especie de pingüino más grande y pesada.', 5),
('Elefante', 'Loxodonta africana', 'Mamífero herbívoro con trompa.', 1);

--Prueba
SELECT * FROM  especies
LEFT JOIN
zonas
ON especies.cod_zona = zonas.codigo


INSERT INTO empleado_rol (tipo) VALUES
('Cuidador'), 
('Guia');

INSERT INTO empleados (nombre, direccion, telefono, fecha_ingreso, codigo_rol) VALUES
('Juan Pérez', 'Calle Falsa 123', '555-1234', '2020-01-15', 1),
('María Gómez', 'Avenida Siempre Viva 742', '555-5678', '2019-03-22', 2),
('Carlos López', 'Boulevard Central 456', '555-8765', '2021-07-30', 1),
('Ana Martínez', 'Calle del Sol 789', '555-4321', '2018-11-05', 2),
('Luis Fernández', 'Avenida de la Luna 321', '555-6789', '2022-05-12', 1);

--bad formated date

ALTER TABLE cuidador_especie 
MODIFY COLUMN fecha_asignacion DATE NOT NULL


INSERT INTO cuidador_especie (legajo_cuidador, cod_especie, fecha_asignacion) VALUES
(1, 1, '2020-02-01'), 
(3, 2, '2021-08-15'), 
(5, 3, '2022-06-20'),
(1, 6, '2020-03-10');

INSERT INTO itinerarios (duracion,longitud,max_visitantes)
VALUES(60,1200,25),(90,2000,30),(45,800,15),(120,2500,40);

INSERT INTO itinerario_zonas(cod_itinerario, cod_zona)
VALUES (1,1),(1,2),(2,2),(2,3),(3,4),(4,1),(4,3),(4,4);



INSERT INTO itinerario_guia(cod_itinerario, legajo_guia, hora_realizacion)
VALUES (1,2,'2023-10-01 10:00:00'),
(2,4,'2023-10-01 14:00:00'),
(3,2,'2023-10-02 09:30:00'),
(4,4,'2023-10-02 13:00:00'),
(1,4,'2023-10-03 11:00:00');
(1,2,'2023-10-03 15:00:00');
--FIN DEL SCRIPT



--1. Listado completo de especies.
SELECT * FROM especies;


--2. Listado de especies ubicadas en una zona dada.
SELECT * FROM especies
WHERE cod_zona = 1; 

--3. Nombre y teléfono de los cuidadores a cargo de una especie dada.

SELECT empleados.nombre, empleados.telefono FROM empleados
JOIN cuidador_especie ON empleados.legajo = cuidador_especie.legajo_cuidador
WHERE cuidador_especie.cod_especie = 1;

--mi version
SELECT e.nombre, e.telefono ,c.cod_especie FROM  cuidador_especie c
JOIN empleados e ON e.legajo = c.legajo_cuidador
WHERE c.cod_especie = 1 



--4)Listado de todos los empleados del parque indicando quienes son guías y quienes
--cuidadores.

SELECT e.nombre, e.direccion, e.telefono, e.fecha_ingreso, er.tipo as rol FROM empleados e
JOIN empleado_rol er 
ON e.codigo_rol = er.codigo


--5. Listado de guías definidos para un itinerario ordenados por hora. 
SELECT e.legajo as Legajo, e.nombre as Guia, itng.hora_realizacion as 'Hora del itinerario' FROM itinerario_guia itng
JOIN empleados e
ON itng.legajo_guia = e.legajo
ORDER BY itng.hora_realizacion ASC;



--6. Detalle de cada zona, extensión y cantidad de especies que aloja.

SELECT z.codigo,z.nombre,z.extension, COUNT(*) AS cant_especimenes 
FROM especies e
JOIN zonas z 
ON e.cod_zona = z.codigo
GROUP BY z.codigo

