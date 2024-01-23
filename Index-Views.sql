/* 
  Student Name: Azin Rezaeian
  Student Number: 41077303
  Course Section: 302
*/
use sales;
show tables;
/* ==== Task A - creating views ==== */
/* 1. Create a view named "view_active_staff" that displays the first name, last name and address of all active staff */

use sales;
CREATE OR REPLACE VIEW view_active_staff
AS
SELECT first_name, last_name,address, is_active
from staff
where is_active = '1';

/* 2. Create a view named "view_incomplete_transactions" that lists rejected and pending orders.
   The view should display all purchase IDs, their status, the first and last names of the Customer and the
   Staff member involved in each transaction. Sort results so rejected orders are listed first. */

-- # DROP VIEW if exists view_products_sold;

CREATE OR REPLACE VIEW view_incomplete_transactions
AS
SELECT purchase.id, staff_id, customer.first_name, customer.last_name, purchase.status
from purchase
inner join customer on purchase.customer_id = customer.id
where purchase.status = 'Rejected'
  or purchase.status = 'Pending'
order by status desc ;


/* 3. Create a view that lists the name and price of the 5 most expensive products in the Office Products category.
Sort results by price in descending order. Name the view "view_expensive_products" */

CREATE OR REPLACE VIEW view_expensive_products
AS
SELECT product.name, product.price, c.id
from product
inner join category c on product.category_id = c.id
where c.id = '5'
order by product.price desc
limit 5;


/* 4. Create a view that calculates the number of products sold, as well as the total income per category, sorted from
highest to lowest total income, and then category name. Consider only Completed transactions. For total income,
don't forget that products can be offered discounts on certain occasions. Name the view "view_products_sold" */

CREATE OR REPLACE VIEW view_products_sold
AS
SELECT sum(pi.quantity), c.name, c.id, round(sum((quantity*product.price) - discount),2) as total_income, p.status
from product
inner join category c on product.category_id = c.id
inner join purchase_item pi on product.id = pi.product_id
inner join purchase p on pi.purchase_id = p.id
where p.status = 'Completed'
group by  c.id, c.name, p.status
order by total_income desc , c.name asc ;



/* 5. Create a view that lists the 5 top selling products (product name, category name, number of sales) of 2019.
Consider only completed transactions. Name the view "view_popular_products" */

CREATE OR REPLACE VIEW view_popular_products
AS
SELECT product.name as 'product name', c.name as 'category name', count(p.id) as number_of_sales, year(p.purchase_date) as year, p.status
from product
inner join category c on product.category_id = c.id
inner join purchase_item pi on product.id = pi.product_id
inner join purchase p on pi.purchase_id = p.id
where p.status =  'Completed' and year(p.purchase_date) = '2019'
group by product.name, c.name, year(p.purchase_date), p.status
order by number_of_sales desc
limit 5;




/* ==== Task B - using subqueries ==== */

/* 1. Display the date, quantity, and status  of the purchase that contains the most items sold in a single purchase.
Consider all status. Your query should have a subquery and display the first and last name of the customer and
staff involved in this purchase. */

select sum(purchase_item.quantity) as total , p.purchase_date, p.status, concat(customer.first_name,customer.last_name) as 'customer name',
       purchase_id, p.staff_id, (select staff.first_name  from staff where staff.id = p.staff_id) staff_first_name,
       (select staff.last_name from staff where staff.id = p.staff_id) staff_last_name
from purchase_item
inner join purchase p on purchase_item.purchase_id = p.id
inner join customer on p.customer_id = customer.id
group by  purchase_id ,p.purchase_date, p.status, concat(customer.first_name,customer.last_name), p.staff_id
having sum(purchase_item.quantity) = (select max(isold)
                                      from (select  purchase_id, sum(purchase_item.quantity) as 'isold'
                                            from purchase_item group by purchase_id) t
                                      );


/* 2. Calculate the number of purchases per customer. Using the results from this calculation, write another
query that calculates the average of purchases per customer. */

/* this is based on the number of purchase of per customer*/
select customer_id, count(purchase.id) as 'the number of purchases',
       (select round(count(purchase.id)/count(distinct(customer_id))) from purchase) as 'the average of purchases'
from purchase
group by customer_id;



/* the question is so confusing I don't know the avg of what per customer, the price avg or the number of purchase per customer,
   the avg of purchase per customer is 47 is same for all of them, while the avg of price is different for per customer */

select customer_id, count(purchase.id) as 'the number of purchases',
       (select round( total_purchases/count(purchase.id),2) from
(select round(sum((quantity*price) - discount),2) as total_purchases from purchase_item
inner join purchase on purchase_item.purchase_id = purchase.id
 group by  purchase.customer_id) t
 group by customer_id) as 'the average of purchases $'
from purchase
group by customer_id;

/* 3. Reuse your query from the previous question to list all the customer ID of customers that purchased more
products than the average. Save the query in a view named "view_vip_customers" */

CREATE OR REPLACE VIEW view_vip_customers
AS
select customer_id, count(purchase.id) as 'the number of purchases', (select round(count(purchase.id)/count(distinct(customer_id))) from purchase) as 'the average of purchases'
from purchase
group by customer_id
having count(purchase.id)  > (select round(count(purchase.id)/count(distinct(customer_id))) from purchase);

/* 4. Using "view_vip_customers", write a query that lists all information on the store's VIP customers.
Your query should also display the number of orders each customer has made listing the customers that
purchased more products at the top. */

select * from view_vip_customers
order by `the number of purchases` desc ;



/* 5. Write a query that displays the id, first name, last name and number of purchases per year in different columns
(As displayed in the image on Assignment "Lab 12" on Brightspace). Limit the results to display the top 8 customers
that bought the most products prioritizing more recent years (2020 then 2019 then 2018) */

select customer.id, customer.first_name, customer.last_name,
       (select count(*) from purchase where customer.id = purchase.customer_id and year(purchase.purchase_date) = '2018') as 'purchases-2018',
      (select count(*) from purchase where customer.id = purchase.customer_id and year(purchase.purchase_date) = '2019') as 'purchases-2019',
      (select count(*) from purchase where customer.id = purchase.customer_id and year(purchase.purchase_date) = '2020') as 'purchases-2020'
from customer
group by customer.id, customer.first_name, customer.last_name
order by `purchases-2020` desc, 'purchases-2019' desc , 'purchases-2018' desc
limit 8;

