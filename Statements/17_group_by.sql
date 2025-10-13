--Contara todos las personas que tienen cada edad

SELECT COUNT (age) FROM users GROUP BY age;

SELECT COUNT(age), age FROM users GROUP BY age ORDER BY age ASC;

SELECT COUNT(age), age FROM users WHERE age > 15 GROUP BY age ORDER BY age ASC

