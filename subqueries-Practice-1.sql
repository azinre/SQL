
/*
Q1: (world.country) Write a query that:
- Calculates the total GNP, average GNP, total population of all government forms
- Calculates the GNP per capital (total GNP divided by total population)
- Filters out countries with no GNP and whose population is less than 1000 people
- Only displays the results of government forms that contain the word monarchy or the word republic
*/
use world;
select sum(GNP) as "Total GNP", avg(GNP) as "Average GNP", sum(population) as "Total Population", GovernmentForm, (sum(GNP)/sum(Population)) as "GNP per Capital"
from country
where GNP = 0.00 and population < 1000 and (GovernmentForm like '%monarchy%' or '%republic%')
group by GovernmentForm;



/*
Q2: (world.countrylanguage) Write a query that:
- Displays the code of a country along with the number of unofficial languages spoken and the maximum percentage of speakers
- Returns only countries with an even number of unofficial languages
- Returns only countries where the maximum percentage is greater than 25%
- Sorts the result by number of languages and maximum percentage both in descending order
- Displays only the first 10 results
*/
select CountryCode, COUNT(IsOfficial), MAX(Percentage)
from countrylanguage
where IsOfficial = 'F'
group by CountryCode
HAVING COUNT(IsOfficial)%2=0 AND MAX(Percentage) >'25%'
ORDER BY count(IsOfficial),MAX(Percentage) DESC
limit 10;


/*
Q3: (world.city) Display the code, number of cities and the total population of countries
- which code starts with the letter B,C, or D
- the code ends with a vowel (A, E, I, O, U)
- with an average of the population is more than 10000 people
- filter out countries that contain less than two cities
*/
select CountryCode, count(*), sum(Population), AVG(Population)
from city
where (CountryCode like 'B%' or CountryCode like 'C%' or CountryCode like 'D%') and
      (CountryCode like  '%A'  or CountryCode like '%E' or CountryCode like  '%I' or CountryCode like '%O' or CountryCode like '%U')
group by CountryCode
having AVG(Population) > 10000 AND count(*)<2;
/*
Q4: (inventory.products) Incoming purchases increase the inventory while outgoing orders decrease it. Each product also has a starting inventory level and a resultant current inventory amount.
- That said, create a report that displays all products which the current inventory is inconsistent.
- Display the product id, product name, the current inventory level, and the correct inventory level, and the difference between these last two values.
- Name as 'expected_inventory_on_hand' the correct inventory, and "gap" the field containing the difference in inventory.
- Order the result set in a way that the biggest inconsistency amount appears at the top.
*/
use inventory;

select id, product_name, inventory_on_hand, (starting_inventory + inventory_received - inventory_shipped) as expected_inventory_on_hand,
        (starting_inventory + inventory_received - inventory_shipped - inventory_on_hand) as gap
from products
where (starting_inventory + inventory_received - inventory_shipped - inventory_on_hand) != 0
order by gap desc;

/*
Q5: (inventory.purchases) Create a query that displays the total products supplied by each supplier.
- Name your total column as "Total_Products_Received" and sort your results by it in descending order.
- Filter the results to only show total products received greater than 500.
*/

select supplier_id, sum(number_received) as "Total_Products_Received"
from purchases
group by supplier_id
having Total_Products_Received> 500
order by Total_Products_Received desc;


/*
Q6: (inventory.orders) Create a query that totals shipped products by customer.
- Concatenate first and last name to create your customer identifier.
- Disregard all orders which first name were not stored.
- Consider only customers who ordered more than 100 items.
- Name your total column as total_ordered and use it to sort the results in descending order
*/

select concat(first,last) as customer, sum(number_shipped) as total_ordered
from orders
where first != ''
group by customer
having  total_ordered > 100
order by total_ordered desc;

/*
Q7: (inventory.purchases) Create a query that calculate purchases age in days.
- Include the number of days since the purchase happened, the product Id and the supplier Id
- This query must show only product ids between 1 and 12 and disregard all purchases older than 2015-01-01.
- Sort the result set by the days in descending order.
*/

select purchase_date ,datediff(date (now()),date (purchase_date)) as `purchases age` , product_id, supplier_id
from purchases
where product_id between '1' and '12'and purchase_date > '2015-01-01'
order by 'purchases age' desc;


/*
Q8: (inventory.purchases) Write a report that gives us some insight on suppliers.
The report should list:
- The number of purchases per supplier. Name this calculation as "number_purchases"
- The number of different types of products ordered. Name this calculation as "different_products"
- The average of numbers received (display it as an integer value). Name this calculation as "avg_number_received"
*/

select count(*) as "number_purchases", supplier_id, count(distinct (product_id)) as "different_products",
       round(avg(number_received)) as "avg_number_received"
from purchases
group by supplier_id;

/*
Q9: (inventory.products) Consider a linear demand of 5 items per month for each product.
- Prepare a report to list all products whose current inventory is enough for the next 12 months.
- Consider only the products with inventory lower than 10,000 and disregard the products with test in their names.
- Include the field that uniquely identifies the product, its name, the current inventory.
- Using the reported demand, calculate a field that shows the number of months the current inventory is able to supply.
Name this last field as months_until_next_purchase displaying only its integer part.
 */

select id, product_name ,product_label, inventory_on_hand ,round(inventory_on_hand/5) as months_until_next_purchase
from products
where product_name not like '%test%' and inventory_on_hand between 60 and 10000
group by id;

/*
Q10: (inventory.purchases) Create a query that calculate purchases age in days.
- Include the number of days since the purchase happened, the product ID and the supplier ID
- This query must show only product ids between 1 and 12
- Disregard all purchases older than 2015-01-01.
- Sort the result set by age in descending order.
*/

select datediff(date (now()),date (purchase_date)) as `Purchase Age`,product_id,supplier_id, purchase_date
from purchases
where product_id between 1 and 12 and purchase_date > '2015-01-01'
order by 'Purchase Age' desc;

/*
Q10: (world.countrylanguage) Create a report that:
- Calculates the number of countries in which each language is considered an official language
- Sorts results by the number of countries in descending order
- Displays only the first 9 records
*/
use world;
select IsOfficial, count(CountryCode) as 'the number of countries', Language
from countrylanguage
where IsOfficial = 'T'
group by Language
order by count(CountryCode) desc
limit 9;

