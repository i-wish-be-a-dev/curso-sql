/*NOT todos los registros cuyo mail no sea este*/
SELECT name FROM users WHERE NOT email='sara@mail.com'

SELECT * FROM users WHERE NOT email='sara@mail.com' AND age = 15

SELECT * FROM users WHERE email='sara@mail.com' OR age = 15
