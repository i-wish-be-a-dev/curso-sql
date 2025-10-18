create schema trabajo_practico;
use trabajo_practico;

-- Primero elimina la tabla existente si tiene estructura incorrecta
DROP TABLE IF EXISTS staging_raw;

-- Crea la tabla con TODAS las columnas del CSV
CREATE TABLE staging_raw (
    OPcity VARCHAR(100),
    OPcode VARCHAR(10),
    OPsigla VARCHAR(10),
    OPConference VARCHAR(50),
    OPdivision VARCHAR(50),
    OPid INT,
    OPname VARCHAR(100),
    stat_asistencias_id INT,
    stat_asistencias_nombre VARCHAR(50),
    stat_asistencias_valor INT,
    stat_blocks_id INT,
    stat_blocks_nombre VARCHAR(50),
    stat_blocks_valor INT,
    city VARCHAR(100),
    codeJug VARCHAR(20),
    country VARCHAR(50),
    stat_defrebs_id INT,
    stat_defrebs_nombre VARCHAR(50),
    stat_defrebs_valor INT,
    sigla VARCHAR(10),
    Conference VARCHAR(50),
    NamePlayer VARCHAR(100),
    division VARCHAR(50),
    draftYear INT,
    fecha DATE,
    stat_fga_id INT,
    stat_fga_nombre VARCHAR(50),
    stat_fga_valor INT,
    stat_fgm_id INT,
    stat_fgm_nombre VARCHAR(50),
    stat_fgm_valor INT,
    fgpct DECIMAL(5,2),
    firstName VARCHAR(50),
    stat_fouls_id INT,
    stat_fouls_nombre VARCHAR(50),
    stat_fouls_valor INT,
    stat_fta_id INT,
    stat_fta_nombre VARCHAR(50),
    stat_fta_valor INT,
    stat_ftm_id INT,
    stat_ftm_nombre VARCHAR(50),
    stat_ftm_valor INT,
    ftpct DECIMAL(5,2),
    gameId INT,
    height VARCHAR(10),
    isHome VARCHAR(10),
    jerseyNo VARCHAR(10),
    lastName VARCHAR(50),
    stat_mins_id INT,
    stat_mins_nombre VARCHAR(50),
    stat_mins_valor INT,
    name VARCHAR(100),
    stat_offrebs_id INT,
    stat_offrebs_nombre VARCHAR(50),
    stat_offrebs_valor INT,
    oppTeamScore INT,
    playerId INT,
    stat_points_id INT,
    stat_points_nombre VARCHAR(50),
    stat_points_valor INT,
    position VARCHAR(20),
    rebs INT,
    seasonId INT,
    stat_secs_id INT,
    stat_secs_nombre VARCHAR(50),
    stat_secs_valor INT,
    stat_steals_id INT,
    stat_steals_nombre VARCHAR(50),
    stat_steals_valor INT,
    teamCode VARCHAR(10),
    teamScore INT,
    teamid INT,
    stat_tpa_id INT,
    stat_tpa_nombre VARCHAR(50),
    stat_tpa_valor INT,
    stat_tpm_id INT,
    stat_tpm_nombre VARCHAR(50),
    stat_tpm_valor INT,
    tppct DECIMAL(5,2),
    stat_turnovers_id INT,
    stat_turnovers_nombre VARCHAR(50),
    stat_turnovers_valor INT,
    weight VARCHAR(10),
    winOrLoss VARCHAR(10),
    yearDisplay VARCHAR(10),
    idPais INT,
    idCity INT,
    OPidCity INT
);

-- Ahora carga los datos
LOAD DATA LOCAL INFILE 'E:/TP/datos_grupo16.csv' 
INTO TABLE staging_raw 
CHARACTER SET utf8mb4 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

-- SCRIPT COMPLETO OPTIMIZADO CON TABLAS TEMPORALES

-- 1. CONFIGURACIÓN INICIAL
SET SESSION wait_timeout = 600;
SET SESSION interactive_timeout = 600;

CREATE TABLE staging_processed AS
SELECT DISTINCT
    -- Limpieza de textos
    TRIM(OPcity) as OPcity,
    TRIM(OPcode) as OPcode,
    TRIM(OPsigla) as OPsigla,
    TRIM(OPConference) as OPConference,
    TRIM(OPdivision) as OPdivision,
    OPid,
    TRIM(OPname) as OPname,
    
    TRIM(city) as city,
    TRIM(codeJug) as codeJug,
    TRIM(country) as country,
    
    TRIM(sigla) as sigla,
    TRIM(Conference) as Conference,
    TRIM(NamePlayer) as NamePlayer,
    TRIM(division) as division,
    draftYear,
    fecha,
    
    TRIM(firstName) as firstName,
    TRIM(lastName) as lastName,
    
    -- Conversión de altura
    CASE 
        WHEN height LIKE '%-%' THEN 
            ROUND(
                (CAST(SUBSTRING_INDEX(height, '-', 1) AS DECIMAL(4,2)) * 30.48) +
                (CAST(SUBSTRING_INDEX(height, '-', -1) AS DECIMAL(4,2)) * 2.54),
            0
        )
        WHEN height LIKE '%.%' THEN 
            ROUND(CAST(height AS DECIMAL(4,2)) * 100, 0)
        WHEN height REGEXP '^[0-9]+$' THEN 
            CASE 
                WHEN CAST(height AS UNSIGNED) < 300 THEN
                    CAST(height AS UNSIGNED)
                ELSE NULL
            END
        ELSE NULL
    END as altura_cm,
    
    height as altura_original,
    
    -- Conversión de peso
    CASE 
        WHEN weight LIKE '%kg%' OR weight LIKE '%kilogram%' THEN 
            CAST(REPLACE(REPLACE(REPLACE(weight, 'kg', ''), 'kilogram', ''), ' ', '') AS DECIMAL(8,2))
        WHEN weight LIKE '%lb%' OR weight LIKE '%pound%' THEN 
            CAST(REPLACE(REPLACE(REPLACE(weight, 'lb', ''), 'pound', ''), ' ', '') AS DECIMAL(8,2)) * 0.453592
        WHEN weight REGEXP '^[0-9.]+$' THEN 
            CAST(weight AS DECIMAL(8,2))
        ELSE NULL
    END as peso_kg,
    
    weight as peso_original,
    
    TRIM(position) as position,
    rebs,
    seasonId,
    
    TRIM(teamCode) as teamCode,
    teamScore,
    teamid,
    
    playerId,
    gameId,
    oppTeamScore,
    
    -- Estadísticas
    stat_points_valor as puntos_anotados,
    rebs as rebotes,
    stat_asistencias_valor as asistencias,
    
    jerseyNo,
    TRIM(winOrLoss) as winOrLoss,
    TRIM(yearDisplay) as yearDisplay,
    idPais,
    idCity,
    OPidCity

FROM staging_raw;



--- 1. CONFIGURACIÓN
SET SESSION wait_timeout = 600;
SET SESSION interactive_timeout = 600;

-- 2. CREAR TABLAS MAESTRAS SI NO EXISTEN

-- Tabla pais
CREATE TABLE IF NOT EXISTS pais (
    id_pais INT PRIMARY KEY NOT NULL,
    nombre_pais VARCHAR(50)
);

-- Tabla ciudad
CREATE TABLE IF NOT EXISTS ciudad (
    id_ciudad INT PRIMARY KEY NOT NULL,
    nombre_ciudad VARCHAR(50)
);

-- Tabla conferencia
CREATE TABLE IF NOT EXISTS conferencia (
    id_conferencia INT PRIMARY KEY NOT NULL,
    nombre_conferencia VARCHAR(50)
);

-- Tabla division
CREATE TABLE IF NOT EXISTS division (
    id_division INT PRIMARY KEY NOT NULL,
    nombre_division VARCHAR(50),
    id_conferencia INT NOT NULL,
    FOREIGN KEY (id_conferencia) REFERENCES conferencia(id_conferencia)
);

-- Tabla temporada
CREATE TABLE IF NOT EXISTS temporada (
    id_temporada INT NOT NULL PRIMARY KEY,
    descripción VARCHAR(150)
);

-- Tabla equipo
CREATE TABLE IF NOT EXISTS equipo (
    id_equipo INT PRIMARY KEY NOT NULL,
    codigo_alfabetico VARCHAR(10),
    sigla VARCHAR(3),
    nombre_equipo VARCHAR(50),
    id_ciudad INT NOT NULL,
    id_division INT NOT NULL,
    FOREIGN KEY (id_division) REFERENCES division(id_division),
    FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad)
);

-- Tabla jugador
CREATE TABLE IF NOT EXISTS jugador (
    id_jugador INT PRIMARY KEY NOT NULL,
    codigo_alfabetico VARCHAR(10),
    id_pais INT NOT NULL,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    altura_cm INT,
    peso_kg INT,
    anio_reclutamiento INT,
    fecha_nacimiento DATE,
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);

-- Tabla Jugador_Equipo_Temporada
CREATE TABLE IF NOT EXISTS Jugador_Equipo_Temporada (
    id_jugador INT NOT NULL,
    id_equipo INT NOT NULL,
    id_temporada INT NOT NULL,
    numero_camiseta INT,
    PRIMARY KEY (id_jugador, id_equipo, id_temporada),
    FOREIGN KEY (id_jugador) REFERENCES jugador(id_jugador),
    FOREIGN KEY (id_equipo) REFERENCES equipo(id_equipo),
    FOREIGN KEY (id_temporada) REFERENCES temporada(id_temporada)
);

-- Tabla partido
CREATE TABLE IF NOT EXISTS partido (
    id_partido INT PRIMARY KEY NOT NULL,
    id_equipo_local INT NOT NULL,
    id_equipo_visitante INT NOT NULL,
    id_temporada INT NOT NULL,
    fecha DATE,
    puntos_local INT,
    puntos_visitante INT,
    id_equipo_ganador INT NOT NULL,
    FOREIGN KEY (id_temporada) REFERENCES temporada(id_temporada),
    FOREIGN KEY (id_equipo_local) REFERENCES equipo(id_equipo),
    FOREIGN KEY (id_equipo_visitante) REFERENCES equipo(id_equipo),
    FOREIGN KEY (id_equipo_ganador) REFERENCES equipo(id_equipo)
);

-- Tabla Jugador_Partido_Estadistica
CREATE TABLE IF NOT EXISTS Jugador_Partido_Estadistica (
    id_jugador INT NOT NULL,
    id_partido INT NOT NULL,
    puntos_anotados INT,
    rebotes INT,
    asistencias INT,
    PRIMARY KEY (id_jugador, id_partido),
    FOREIGN KEY (id_jugador) REFERENCES jugador(id_jugador),
    FOREIGN KEY (id_partido) REFERENCES partido(id_partido)
);

-- 3. INSERCIONES OPTIMIZADAS

-- PAÍSES
DROP TEMPORARY TABLE IF EXISTS temp_paises;
CREATE TEMPORARY TABLE temp_paises AS
SELECT DISTINCT 
    idPais,
    TRIM(country) as nombre_pais
FROM staging_processed 
WHERE idPais IS NOT NULL AND country IS NOT NULL AND TRIM(country) != '';

INSERT IGNORE INTO pais (id_pais, nombre_pais)
SELECT idPais, nombre_pais FROM temp_paises;

DROP TEMPORARY TABLE IF EXISTS temp_paises;

-- CIUDADES
DROP TEMPORARY TABLE IF EXISTS temp_ciudades;
CREATE TEMPORARY TABLE temp_ciudades AS
SELECT DISTINCT 
    idCity,
    TRIM(city) as nombre_ciudad
FROM staging_processed 
WHERE idCity IS NOT NULL AND city IS NOT NULL AND TRIM(city) != '';

INSERT IGNORE INTO ciudad (id_ciudad, nombre_ciudad)
SELECT idCity, nombre_ciudad FROM temp_ciudades;

DROP TEMPORARY TABLE IF EXISTS temp_ciudades;

-- CONFERENCIAS
DROP TEMPORARY TABLE IF EXISTS temp_conferencias;
CREATE TEMPORARY TABLE temp_conferencias AS
SELECT DISTINCT TRIM(Conference) as nombre_conferencia
FROM staging_processed 
WHERE Conference IS NOT NULL AND TRIM(Conference) != '';

INSERT IGNORE INTO conferencia (id_conferencia, nombre_conferencia)
SELECT 
    ROW_NUMBER() OVER (ORDER BY nombre_conferencia) as id_conferencia,
    nombre_conferencia
FROM temp_conferencias;

DROP TEMPORARY TABLE IF EXISTS temp_conferencias;

-- DIVISIONES
DROP TEMPORARY TABLE IF EXISTS temp_divisiones;
CREATE TEMPORARY TABLE temp_divisiones AS
SELECT DISTINCT 
    TRIM(division) as nombre_division,
    TRIM(Conference) as nombre_conferencia
FROM staging_processed 
WHERE division IS NOT NULL AND TRIM(division) != '';

INSERT IGNORE INTO division (id_division, nombre_division, id_conferencia)
SELECT 
    ROW_NUMBER() OVER (ORDER BY td.nombre_division) as id_division,
    td.nombre_division,
    c.id_conferencia
FROM temp_divisiones td
JOIN conferencia c ON td.nombre_conferencia = c.nombre_conferencia;

DROP TEMPORARY TABLE IF EXISTS temp_divisiones;

-- TEMPORADAS
DROP TEMPORARY TABLE IF EXISTS temp_temporadas;
CREATE TEMPORARY TABLE temp_temporadas AS
SELECT DISTINCT 
    seasonId,
    TRIM(yearDisplay) as descripcion
FROM staging_processed 
WHERE seasonId IS NOT NULL;

INSERT IGNORE INTO temporada (id_temporada, descripción)
SELECT seasonId, descripcion FROM temp_temporadas;

DROP TEMPORARY TABLE IF EXISTS temp_temporadas;

-- EQUIPOS
DROP TEMPORARY TABLE IF EXISTS temp_equipos;
CREATE TEMPORARY TABLE temp_equipos AS
SELECT DISTINCT 
    sp.teamid,
    TRIM(sp.teamCode) as codigo_alfabetico,
    TRIM(sp.sigla) as sigla,
    TRIM(sp.OPname) as nombre_equipo,
    sp.OPidCity as id_ciudad,
    d.id_division
FROM staging_processed sp
LEFT JOIN division d ON TRIM(sp.division) = d.nombre_division 
    AND TRIM(sp.Conference) = (SELECT nombre_conferencia FROM conferencia c WHERE c.id_conferencia = d.id_conferencia)
WHERE sp.teamid IS NOT NULL;

INSERT IGNORE INTO equipo (id_equipo, codigo_alfabetico, sigla, nombre_equipo, id_ciudad, id_division)
SELECT teamid, codigo_alfabetico, sigla, nombre_equipo, id_ciudad, id_division 
FROM temp_equipos;

DROP TEMPORARY TABLE IF EXISTS temp_equipos;

-- JUGADORES - CORREGIDO
DROP TEMPORARY TABLE IF EXISTS temp_jugadores;
CREATE TEMPORARY TABLE temp_jugadores AS
SELECT DISTINCT 
    sp.playerId,
    TRIM(sp.codeJug) as codigo_alfabetico,
    sp.idPais,
    TRIM(sp.firstName) as nombre,
    TRIM(sp.lastName) as apellido,
    -- Convertir altura_cm de decimal a INT
    CAST(sp.altura_cm AS UNSIGNED) as altura_cm,
    -- Convertir peso_kg de decimal a INT
    CAST(sp.peso_kg AS UNSIGNED) as peso_kg,
    sp.draftYear
FROM staging_processed sp
WHERE sp.playerId IS NOT NULL;

INSERT IGNORE INTO jugador (id_jugador, codigo_alfabetico, id_pais, nombre, apellido, altura_cm, peso_kg, anio_reclutamiento)
SELECT playerId, codigo_alfabetico, idPais, nombre, apellido, altura_cm, peso_kg, draftYear 
FROM temp_jugadores;

DROP TEMPORARY TABLE IF EXISTS temp_jugadores;

--- JUGADOR_EQUIPO_TEMPORADA - VERSIÓN SIMPLIFICADA
DROP TEMPORARY TABLE IF EXISTS temp_jugador_equipo;
CREATE TEMPORARY TABLE temp_jugador_equipo AS
SELECT DISTINCT 
    sp.playerId,
    sp.teamid,
    sp.seasonId,
    -- VERSIÓN SIMPLE: Solo tomar la parte antes del punto decimal
    CASE 
        WHEN sp.jerseyNo IS NOT NULL AND sp.jerseyNo != '' AND sp.jerseyNo != '0' THEN
            CAST(SUBSTRING_INDEX(sp.jerseyNo, '.', 1) AS UNSIGNED)
        ELSE NULL
    END as numero_camiseta
FROM staging_processed sp
WHERE sp.playerId IS NOT NULL AND sp.teamid IS NOT NULL AND sp.seasonId IS NOT NULL;

INSERT IGNORE INTO Jugador_Equipo_Temporada (id_jugador, id_equipo, id_temporada, numero_camiseta)
SELECT playerId, teamid, seasonId, numero_camiseta 
FROM temp_jugador_equipo;

DROP TEMPORARY TABLE IF EXISTS temp_jugador_equipo;

-- PARTIDOS - CORREGIDO (cumple con only_full_group_by)
DROP TEMPORARY TABLE IF EXISTS temp_partidos;

CREATE TEMPORARY TABLE temp_partidos AS
SELECT 
    sp1.gameId,
    sp1.teamid as id_equipo_local,
    sp2.teamid as id_equipo_visitante,
    sp1.seasonId,
    sp1.fecha,
    sp1.teamScore as puntos_local,
    sp1.oppTeamScore as puntos_visitante,
    CASE 
        WHEN sp1.teamScore > sp1.oppTeamScore THEN sp1.teamid
        ELSE sp2.teamid
    END as id_equipo_ganador
FROM staging_processed sp1
JOIN staging_processed sp2 ON sp1.gameId = sp2.gameId AND sp1.teamid < sp2.teamid
WHERE sp1.gameId IS NOT NULL
GROUP BY sp1.gameId, sp1.teamid, sp2.teamid, sp1.seasonId, sp1.fecha, sp1.teamScore, sp1.oppTeamScore;

INSERT IGNORE INTO partido (id_partido, id_equipo_local, id_equipo_visitante, id_temporada, fecha, puntos_local, puntos_visitante, id_equipo_ganador)
SELECT gameId, id_equipo_local, id_equipo_visitante, seasonId, fecha, puntos_local, puntos_visitante, id_equipo_ganador
FROM temp_partidos;

DROP TEMPORARY TABLE IF EXISTS temp_partidos;

-- JUGADOR_PARTIDO_ESTADISTICA
DROP TEMPORARY TABLE IF EXISTS temp_estadisticas;
CREATE TEMPORARY TABLE temp_estadisticas AS
SELECT DISTINCT 
    sp.playerId,
    sp.gameId,
    COALESCE(sp.puntos_anotados, 0) as puntos_anotados,
    COALESCE(sp.rebotes, 0) as rebotes,
    COALESCE(sp.asistencias, 0) as asistencias
FROM staging_processed sp
WHERE sp.playerId IS NOT NULL 
  AND sp.gameId IS NOT NULL
  AND EXISTS (SELECT 1 FROM jugador j WHERE j.id_jugador = sp.playerId)
  AND EXISTS (SELECT 1 FROM partido p WHERE p.id_partido = sp.gameId);

INSERT IGNORE INTO Jugador_Partido_Estadistica (id_jugador, id_partido, puntos_anotados, rebotes, asistencias)
SELECT playerId, gameId, puntos_anotados, rebotes, asistencias 
FROM temp_estadisticas;

DROP TEMPORARY TABLE IF EXISTS temp_estadisticas;

-- 4. VERIFICACIÓN FINAL
SELECT 
    (SELECT COUNT(*) FROM pais) as total_paises,
    (SELECT COUNT(*) FROM ciudad) as total_ciudades,
    (SELECT COUNT(*) FROM conferencia) as total_conferencias,
    (SELECT COUNT(*) FROM division) as total_divisiones,
    (SELECT COUNT(*) FROM temporada) as total_temporadas,
    (SELECT COUNT(*) FROM equipo) as total_equipos,
    (SELECT COUNT(*) FROM jugador) as total_jugadores,
    (SELECT COUNT(*) FROM Jugador_Equipo_Temporada) as total_relaciones_jugador_equipo,
    (SELECT COUNT(*) FROM partido) as total_partidos,
    (SELECT COUNT(*) FROM Jugador_Partido_Estadistica) as total_estadisticas;