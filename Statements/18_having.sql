-- No se puede utilizar en funciones agregadas

-- Solo mostrara el contador si es mayor que 3
SELECT COUNT(age) FROM users HAVING COUNT(age) > 3