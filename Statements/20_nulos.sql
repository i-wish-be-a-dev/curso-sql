--Manejo de nulos, si age es 0 entonces en los resultados aparecera como 0
SELECT name,surname,IFNULL(age,0) FROM users;

--Si no colocamos un alias en el column name sale la condicion que pusimos
SELECT name,surname ,IFNULL(age,0) AS age FROM curso_sql.users;

