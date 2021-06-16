USE bank;

-- 1. +Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
SELECT * FROM client WHERE LENGTH(FirstName) < 6;

-- 2. +Вибрати львівські відділення банку.+
SELECT * FROM department WHERE DepartmentCity LIKE 'Lviv';

-- 3. +Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
SELECT * FROM client WHERE Education LIKE 'high' ORDER BY LastName;

-- 4. +Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
SELECT * FROM application ORDER BY idApplication DESC LIMIT 5;

-- 5. +Вивести усіх клієнтів, чиє прізвище закінчується на IV чи IVA.
SELECT * FROM client WHERE LastName LIKE '%IV' OR LastName LIKE '%IVA';

-- 6. +Вивести клієнтів банку, які обслуговуються київськими відділеннями.
SELECT * FROM client WHERE City LIKE 'Kyiv';

-- 7. +Вивести імена клієнтів та їхні номера телефону, погрупувавши їх за іменами.
SELECT FirstName,Passport FROM client GROUP BY FirstName;

-- 8. +Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
SELECT * FROM client c JOIN application a ON c.idClient=a.Client_idClient WHERE a.Sum > 5000 AND a.Currency LIKE 'Gryvnia';

-- 9. +Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
SELECT COUNT(idClient) allClients FROM client;
SELECT COUNT(idClient) lvivClients FROM client c JOIN department d ON c.Department_idDepartment=d.idDepartment 
WHERE City='Lviv';

-- 10. Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
SELECT MAX(Sum), FirstName, LastName FROM client c
JOIN application a ON a.Client_idClient = c.idClient GROUP BY idClient;

-- 11. Визначити кількість заявок на крдеит для кожного клієнта.
SELECT COUNT(idApplication), FirstName, LastName
FROM client c JOIN application a ON c.idClient = a.Client_idClient 
GROUP BY c.idClient;

-- 12. Визначити найбільший та найменший кредити.
SELECT MIN(Sum)FROM application WHERE Currency='Gryvnia';
SELECT MAX(Sum)FROM application WHERE Currency='Dollar' OR Currency='Euro';

-- 13. Порахувати кількість кредитів для клієнтів, які мають вищу освіту.
SELECT COUNT(idApplication) FROM application a JOIN client c ON a.Client_idClient=c.idClient WHERE c.Education='high';

-- 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
SELECT AVG(Sum) AVG_SUM,c.FirstName FROM client c JOIN application a ON c.idClient=a.Client_idClient
GROUP BY idClient ORDER BY AVG_SUM DESC LIMIT 1;

-- 15. Вивести відділення, яке видало в кредити найбільше грошей
SELECT SUM(Sum),d.idDepartment,d.DepartmentCity FROM application a JOIN client c ON a.Client_idClient=c.idClient
JOIN department d ON d.idDepartment=c.Department_idDepartment GROUP BY DepartmentCity LIMIT 1;

-- 16. Вивести відділення, яке видало найбільший кредит.
SELECT MAX(Sum) Max_Credit,d.idDepartment,d.DepartmentCity FROM application a JOIN client c ON a.Client_idClient=c.idClient
JOIN department d ON d.idDepartment=c.Department_idDepartment;

-- 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
UPDATE application a JOIN client c ON a.Client_idClient = c.idClient SET a.Sum = 6000
WHERE c.Education = 'high';

-- 18. Усіх клієнтів київських відділень пересилити до Києва.
UPDATE client as c JOIN department d ON d.idDepartment = c.Department_idDepartment 
SET c.City = 'Kyiv' WHERE d.DepartmentCity = 'Kyiv';

-- 19. Видалити усі кредити, які є повернені.
DELETE FROM application WHERE CreditState = 'Returned';

-- 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
DELETE FROM application a JOIN client c ON a.Client_idClient = c.idClient 
WHERE c.LastName LIKE '_a%' 
OR c.LastName LIKE '_o%' OR c.LastName LIKE '_u%' OR c.LastName LIKE '_e%' OR c.LastName LIKE '_i%';

-- Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
SELECT * FROM department d JOIN client c ON d.idDepartment = c.Department_idDepartment 
JOIN application a ON c.idClient = a.Client_idClient 
WHERE City='Lviv' AND Sum > 5000 GROUP BY idDepartment;

-- Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
SELECT c.FirstName, c.LastName FROM client c JOIN application a ON a.Client_idClient = c.idClient
WHERE CreditState = 'Returned' AND Sum > 5000 GROUP BY idClient;

--  Знайти максимальний неповернений кредит.
SELECT MAX(Sum) max_sum,idApplication FROM application 
WHERE CreditState='Not returned' 
GROUP BY idApplication ORDER BY max_sum DESC LIMIT 1 ;

-- /*Знайти клієнта, сума кредиту якого найменша*/
SELECT FirstName, LastName, Sum FROM client c JOIN application a ON c.idClient = a.Client_idClient
WHERE Sum = (SELECT MIN(Sum) FROM application);

-- /*Знайти кредити, сума яких більша за середнє значення усіх кредитів*/
SELECT idApplication, Sum FROM application WHERE Sum > (SELECT AVG(Sum) FROM application);

-- /*Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів*/
SELECT  DISTINCT FirstName, LastName, City FROM client c JOIN application a ON c.idClient = a.Client_idClient 
WHERE c.City = (SELECT City FROM client c JOIN application a ON c.idClient = a.Client_idClient
GROUP BY idClient ORDER BY count(idApplication) DESC LIMIT 1);

-- #місто чувака який набрав найбільше кредитів
SELECT c.City, COUNT(idApplication) maxCred FROM client c JOIN application a ON a.Client_idClient=c.idClient 
GROUP BY Client_idClient ORDER BY maxCred DESC LIMIT 1;


