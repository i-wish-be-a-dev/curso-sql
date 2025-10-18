--Los países a los que pertenecen los jugadores tienen un id y nombre.
CREATE TABLE pais (
    id_pais INT PRIMARY KEY NOT NULL,
    nombre_pais VARCHAR (50)
);

--Cada temporada que se juega se identifica con un ID único y una descripción.

CREATE TABLE temporada (
    id_temporada INT NOT NULL PRIMARY KEY,
    descripción varchar (150)
);


--De los equipos se conoce el ID, un codigo alfabetico, un nombre, una sigla de 3 letras y la ciudad de origen.

CREATE TABLE equipo (
    id_equipo INT PRIMARY KEY NOT NULL,
    codigo_alfabetico VARCHAR (10),
    sigla VARCHAR (3),
    nombre_equipo VARCHAR (50),
    id_ciudad INT NOT NULL,
    id_division INT NOT NULL,
    FOREIGN KEY (id_division) REFERENCES division(id_division),
    FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad)
);

--En una temporada se juegan muchos partidos. 




--Cada partido tiene un ID único, 
--un equipo que juega de local 
--y otro como visitante, 
--la fecha en que se jugó, 
--puntos convertidos por el equipo local, 
--puntos equipos visitante, 
--y que equipo ganó el partido.

CREATE TABLE partido (
    id_partido INT PRIMARY KEY NOT NULL,
    id_equipo_local INT NOT NULL,
    id_equipo_visitante INT NOT NULL,
    id_temporada INT NOT NULL,
    fecha DATE,
    puntos_local INT,
    puntos_visitante INT,
    id_equipo_ganador  INT NOT NULL,
    FOREIGN KEY (id_temporada) REFERENCES temporada(id_temporada),
    FOREIGN KEY (id_equipo_local) REFERENCES equipo(id_equipo),
    FOREIGN KEY (id_equipo_visitante) REFERENCES equipo(id_equipo),
    FOREIGN KEY (id_equipo_ganador) REFERENCES equipo(id_equipo)
);


--Las ciudades tienen su id y nombre.

CREATE TABLE ciudad (
    id_ciudad INT PRIMARY KEY NOT NULL,
    nombre_ciudad VARCHAR (50)
);


--Además, los equipos se agrupan en conferencias y divisiones. Un equipo pertenece a una única división, y a su vez dicha división pertenece a una única conferencia. 
--De las conferencias y divisiones se conoce solo su nombre, pero se recomienda agregarle también un id para poder referenciarlo más fácilmente.

CREATE TABLE conferencia (
    id_conferencia INT PRIMARY KEY NOT NULL,
    nombre_conferencia VARCHAR (50)
);
CREATE TABLE division (
    id_division INT PRIMARY KEY NOT NULL,
    nombre_division VARCHAR (50),
    id_conferencia INT NOT NULL,
    FOREIGN KEY (id_conferencia) REFERENCES conferencia(id_conferencia)
);

/*Los jugadores tienen un ID, un código alfabético, nombre, apellido, altura, peso, país de origen, posición en la que juega y año en que fue reclutado (draftYear). 
Este dato es importante para determinar los años de carrera que tiene. 
Un jugador puede jugar para distintos equipos a lo largo de la temporada, pudiendo utilizar un número de camiseta diferente en cada caso. 

*/
CREATE TABLE jugador (
    id_jugador INT PRIMARY KEY NOT NULL,
    codigo_alfabetico VARCHAR (10),
    id_pais INT NOT NULL,
    nombre VARCHAR (50),
    apellido VARCHAR (50),
    altura_cm INT,
    peso_kg INT,
    anio_reclutamiento INT,
    fecha_nacimiento DATE,
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);



CREATE TABLE Jugador_Equipo_Temporada (
    id_jugador INT NOT NULL,
    id_equipo INT NOT NULL,
    id_temporada INT NOT NULL,
    numero_camiseta INT,
    PRIMARY KEY (id_jugador, id_equipo, id_temporada),
    FOREIGN KEY (id_jugador) REFERENCES jugador(id_jugador),
    FOREIGN KEY (id_equipo) REFERENCES equipo(id_equipo),
    FOREIGN KEY (id_temporada) REFERENCES temporada(id_temporada)
);






--Cada jugador puede tener muchas estadísticas en diferentes partidos.
--Cada estadística tiene un ID único, el ID del jugador, el ID del partido,
--cantidad de puntos anotados, cantidad de rebotes, cantidad de asistencias.

CREATE TABLE Jugador_Partido_Estadistica(
    id_jugador INT NOT NULL,
    id_partido INT NOT NULL,
    puntos_anotados INT,
    rebotes INT,
    asistencias INT,
    PRIMARY KEY (id_jugador, id_partido),
    FOREIGN KEY (id_jugador) REFERENCES jugador(id_jugador),
    FOREIGN KEY (id_partido) REFERENCES partido(id_partido)
);






--- IGNORE ---
--Estas tablas son para que no de error el script
