--Cada temporada que se juega se identifica con un ID único y una descripción.

CREATE TABLE temporada (
    id_temporada INT NOT NULL PRIMARY KEY,
    descripción varchar (150)
);


--En una temporada se juegan muchos partidos. 
--Cada partido tiene un ID único, un equipo que juega de local 
--y otro como visitante, la fecha en que se jugó, puntos convertidos 
--por el equipo local, puntos equipos visitante, y que equipo ganó el partido.

CREATE TABLE partido (
    id_partido INT PRIMARY KEY NOT NULL,
    id_equipo_local INT NOT NULL,
    id_equipo_visitante INT NOT NULL,
    fecha DATE,
    puntos_local INT,
    puntos_visitante INT,
    equipo_ganador VARCHAR (50)
);

--Cada equipo tiene un ID único, nombre del equipo y ciudad de origen.
CREATE TABLE equipo (
    id_equipo INT PRIMARY KEY NOT NULL,
    nombre_equipo VARCHAR (50),
    ciudad_origen VARCHAR (50)
);
--Cada jugador tiene un ID único, nombre, apellido, fecha de nacimiento,
--posición en la que juega, y el ID del equipo al que pertenece.
CREATE TABLE jugador (
    id_jugador INT PRIMARY KEY NOT NULL,
    nombre VARCHAR (50),
    apellido VARCHAR (50),
    fecha_nacimiento DATE,
    posicion VARCHAR (50),
    id_equipo INT NOT NULL
);
--Cada jugador puede tener muchas estadísticas en diferentes partidos.
--Cada estadística tiene un ID único, el ID del jugador, el ID del partido,
--cantidad de puntos anotados, cantidad de rebotes, cantidad de asistencias.
CREATE TABLE estadistica (
    id_estadistica INT PRIMARY KEY NOT NULL,
    id_jugador INT NOT NULL,
    id_partido INT NOT NULL,
    puntos_anotados INT,
    rebotes INT,
    asistencias INT
);
--Cada temporada puede tener muchos equipos participando.
--Cada equipo puede participar en muchas temporadas.
--La tabla intermedia tiene el ID de la temporada y el ID del equipo.
CREATE TABLE temporada_equipo (
    id_temporada INT NOT NULL,
    id_equipo INT NOT NULL,
    PRIMARY KEY (id_temporada, id_equipo)
);
--Cada partido pertenece a una temporada.
ALTER TABLE partido
ADD CONSTRAINT fk_partido_temporada
FOREIGN KEY (id_temporada) REFERENCES temporada(id_temporada);
--Cada equipo local y visitante en un partido es un equipo.
ALTER TABLE partido
ADD CONSTRAINT fk_partido_equipo_local
FOREIGN KEY (id_equipo_local) REFERENCES equipo(id_equipo);