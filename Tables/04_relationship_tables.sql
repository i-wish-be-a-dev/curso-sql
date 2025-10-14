1:1
CREATE TABLE dni(
	dni_id INT AUTO_INCREMENT PRIMARY KEY,
    dni_number INT NOT NULL,
    user_id INT,
    FOREIGN KEY(user_id) REFERENCES users(users_id),
    UNIQUE(dni_id)
);


1:N 


CREATE TABLE companies(
	company_id INT AUTO_INCREMENT PRIMARY KEY,
    name varchar(100) NOT NULL
);

ALTER TABLE users
ADD COLUMN company_id INT,
ADD FOREIGN KEY (company_id) REFERENCES companies(company_id);


ALTER TABLE users
ADD FOREIGN KEY (company_id) REFERENCES companies(company_id);


N:N 

CREATE TABLE languages(
	language_od int AUTO_INCREMENT PRIMARY KEY,
    name varchar(100)
);

CREATE TABLE users_languages(
	users_language_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    language_id INT NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(users_id),
    FOREIGN KEY(language_id) REFERENCES languages(language_id)
);


ALTER TABLE users_languages
ADD CONSTRAINT user_id UNIQUE (user_id),
ADD CONSTRAINT language_id UNIQUE (language_id);
--ESTE ALTER TABLE ES UNA LOCURA, NO TIENE SENTIDO 
--YA QUE SI ES UNICO UN USUARIO NO PUEDE CONOCER A MAS DE UN LENGUAJE

CREATE TABLE users_languages(
user_language_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
user_id INT,
language_id INT,
FOREIGN KEY(user_id) REFERENCES users(users_id),
FOREIGN KEY (language_id) REFERENCES languages(language_id)
);



INSERT INTO users_languages (user_id, language_id) VALUES (1,1);
INSERT INTO users_languages (user_id, language_id) VALUES (1,3);
INSERT INTO users_languages (user_id, language_id) VALUES (1,5);
INSERT INTO users_languages (user_id, language_id) VALUES (2,3);
INSERT INTO users_languages (user_id, language_id) VALUES (2,4);
INSERT INTO users_languages (user_id, language_id) VALUES (5,7);
INSERT INTO users_languages (user_id, language_id) VALUES (5,2);

SELECT * FROM users_languages;


ALTER TABLE users_languages
MODIFY COLUMN user_id INT NOT NULL,
MODIFY COLUMN language_id INT NOT NULL;