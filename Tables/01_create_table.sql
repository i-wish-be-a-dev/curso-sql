CREATE TABLE persons (
	id int,
    name varchar(100),
    age int,
    email varchar(100),
    created date
);

--Ahora aplicaremos restricciones 'CONSTRAINSTS'

CREATE TABLE persons2 (
	id int NOT NULL,
    name varchar(100) NOT NULL,
    age int,
    email varchar(100),
    created date
);

--UNIQUE
CREATE TABLE persons3 (
	id int NOT NULL,
    name varchar(100) NOT NULL,
    age int,
    email varchar(100),
    created datetime,
    UNIQUE(id)
);

--PRIMARY KEY

CREATE TABLE persons4 (
	id int NOT NULL,
    name varchar(100) NOT NULL,
    age int,
    email varchar(100),
    created datetime,
    PRIMARY KEY(id)
);

--CHECK criterio al guardar en la bd

CREATE TABLE persons5 (
	id int NOT NULL,
    name varchar(100) NOT NULL,
    age int,
    email varchar(100),
    created datetime,
    UNIQUE(id),
    PRIMARY KEY(id),
    CHECK (age >= 18)
);


--DEFAULT

CREATE TABLE persons6 (
	id int NOT NULL,
    name varchar(100) NOT NULL,
    age int,
    email varchar(100) DEFAULT '',
    created datetime DEFAULT CURRENT_TIMESTAMP,,
    UNIQUE(id),
    PRIMARY KEY(id),
    CHECK (age >= 18)
);


--AUTO INCREMENT
CREATE TABLE persons7 (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    age INT,
    email varchar(100) DEFAULT '',
    created datetime DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(id),
    PRIMARY KEY(id),
    CHECK (age >= 18)
);

CREATE TABLE persons8 (
    name VARCHAR(100) NOT NULL,
);





