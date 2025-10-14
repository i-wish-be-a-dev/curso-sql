--Obtener los datos comunes de ambas tablas


SELECT * FROM users
INNER JOIN dni

--Es una interseccion de ambas tablas
SELECT * FROM users
INNER JOIN dni
ON users.users_id = dni.user_id;


SELECT name, dni_number FROM users
INNER JOIN dni
ON users.users_id = dni.user_id
ORDER BY age DESC;


SELECT *  FROM users 
JOIN companies 
ON users.company_id = companies.company_id


SELECT companies.name, users.name FROM companies 
JOIN users 
ON users.company_id = companies.company_id


--INNER JOIN DE TABLAS RELACIONADAS N:N


SELECT * FROM users_languages
JOIN users ON users_languages.user_id = users.users_id
JOIN languages ON users_languages.language_id = languages.language_id;

--ACOTAMIENTO DE DATOS

SELECT users.name, languages.name FROM users_languages
JOIN users ON users_languages.user_id = users.users_id
JOIN languages ON users_languages.language_id = languages.language_id;



