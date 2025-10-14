
--Left Join Se trae siempre los datos de la 
--tabla de la derecha (dni) 

SELECT * FROM users 
RIGHT JOIN dni
ON users.users_id = dni.user_id;



SELECT name, dni_number FROM users 
RIGHT JOIN dni
ON users.users_id = dni.user_id;
