--Left Join Se trae siempre los datos de la 
--tabla de la izquierda (users) 



/*TRAEMOS TODA LA TABLA DE LA IZQUIERDA (LA PRIMERA QUE INVOCAMOS)
AUNQUE EL REGISTRO NO TENGA DNI  COMO EN EL EJEMPLO, RELLENA CON NULOS
*/
SELECT * FROM users 
LEFT JOIN dni
ON users.users_id = dni.user_id;


SELECT name, dni_number FROM users 
LEFT JOIN dni
ON users.users_id = dni.user_id;
