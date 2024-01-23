/* 1. Using a UNION query, create a report that lists the name and the district of the cities 
   in Canada (code CAN) and the Netherlands (code NLD). Note that this query can be written
   without using a UNION. The purpose of this question is to use UNION. (city table) */
use world;
SELECT Name,District FROM City
WHERE CountryCode='CAN'
UNION
SELECT Name,District FROM City
WHERE CountryCode='NLD';

/* 2. Using an INNER JOIN..ON, create a report that list the name of cities, the country and 
   the indepyear of all countries whose indepYear field is not null. (city and countrytables). */

SELECT City.Name, Country.name, Country.Indepyear
FROM City
INNER JOIN Country ON City.CountryCode = Country.code
WHERE country.Indepyear is not null;



/* 3. Rewrite the previous query using WHERE/FROM. */

select City.Name, Country.name, Country.Indepyear
FROM city, country
WHERE city.countrycode = country.code and country.Indepyear is not null;

/* 4. Using a subquery, list the name of the city, the countrycode, the population and the 
   average city population of all cities with a population less than the average population.
   (city table) */

SELECT Name, CountryCode, Population,(SELECT round(AVG(population)) from city) as "avarage population"
FROM city
WHERE city.Population <  (SELECT avg(city.Population) FROM city);



/* 5. Using INNER JOIN ..ON, write a query that displays, for the city of Toronto, the name 
   of the city and the head of state of its country. (city and country tables) */

SELECT City.Name, Country.HeadOfState
FROM City
INNER JOIN Country ON City.CountryCode = Country.code
WHERE city.Name = 'Toronto';

/* 6. Using INNER JOIN ..ON the three tables, write a query that displays the name of the 
   city, the city continent, the city head of state, the year of independence and the 
   percentage of people who speaks English in the city of Toronto. 
   (city, countrylanguage and country tables) */

SELECT City.Name, Country.continent, Country.HeadOfState, Country.Indepyear, CountryLanguage.Percentage, countrylanguage.Language
FROM City
INNER JOIN Country ON City.CountryCode = Country.code
INNER JOIN CountryLanguage ON Country.code = CountryLanguage.Countrycode
WHERE countrylanguage.language = 'English' and city.Name = 'Toronto';

/* 7. Rewrite the previous query using WHERE/FROM. */

SELECT City.Name, Country.continent, Country.HeadOfState, Country.Indepyear, CountryLanguage.Percentage, countrylanguage.Language
FROM City,country,countrylanguage
where city.CountryCode=country.code and city.CountryCode = countrylanguage.CountryCode
and countrylanguage.language = 'English' and city.Name = 'Toronto';

/* 8. Using a subquery, list the name of the city, the countrycode and the population of 
   the city with the largest population. (city table) */
select city.name, city.countrycode, city.population
from city
where city.population = (select max(city.Population ) from city);


/* 9. Using a subquery, list the name of the city, the countrycode and the population of all
   the cities whose population is larger than the average population. (city table) */

select city.name, city.countrycode, city.population
from city
where city.Population > (SELECT round(AVG(population))  from city);


/* 10. What is wrong with the following subquery?
   SELECT name, countrycode, population, avg(population)
   FROM city
   WHERE population > (SELECT avg(population) FROM city);
*/
/* we can not use the "avg(population)" when we want to show the list of all cities,
 it only shows one record randomly. when we use aggregate functions than using group by and
 having for the filtering, in this example we use a subquery means a query that is
 nested inside another query, and using 'where' for filtering. so if we want to show
 avg of the population in all rows so we need another subquery inside select,
 otherwise we can not show the list by using "avg(population)" and where filtering.
Subqueries are correlated when their values depend on the outer SELECT statements
they are contained in. The rest of the subqueries are considered uncorrelated.*/

SELECT name, countrycode, population, avg(population)
   FROM city
   WHERE population > (SELECT avg(population) FROM city);

/* 11. Replace the first avg(population) with (SELECT AVG(population) from city)
   What happens? Why? */

/* Due to the fact that correlated subqueries depend on the outer SELECT for their values,
 they must be executed repeatedly, once for each value returned by the outer SELECT.
 Only one subquery is executed in an uncorrelated subquery. A comparison is made between
 an expression and the result of another SELECT statement.
/*The population average is repeated for each row. The problem of the previous question
  is solved and the list of cities is displayed correctly. The average is shown in each row.*/

SELECT name, countrycode, population, (SELECT AVG(population) from city)
   FROM city
   WHERE population > (SELECT avg(population) FROM city);

/* 12. Using a subquery, list the name of the country, the continent and the life 
   expectancy of all countries whose life expectancy is less than the average life 
   expectancy. (country table) */

select country.name, country.continent, country.LifeExpectancy,(select round(avg(LifeExpectancy),2) from country)
from country
where country.LifeExpectancy < (select avg(LifeExpectancy) from country);