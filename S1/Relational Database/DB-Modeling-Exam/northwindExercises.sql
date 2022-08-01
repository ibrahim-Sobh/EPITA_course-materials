SET search_path = northwind, pg_catalog;

--1 
select * from customers; 

--2
select count(distinct product_name) from products;

--3
select count(employee_id) from employees;

--4  unit_price * quantity - unit_price * quantity * discount
select sum(unit_price * quantity * (1 - discount)) from order_details;

--5 
select sum(unit_price * quantity * (1 - discount)) from order_details
where order_id in (select order_id from orders where  order_date between '1996-01-01' and '1996-12-31');

--6
select distinct ship_country from orders order by ship_country asc;

--7
select company_name from shippers order by company_name asc;

--8
select country ,count(customer_id) as cnt from customers group by country order by cnt desc;

--9
select count(order_id) from orders where shipped_date is null;

--10
select * from orders where lower(ship_country) like 'france' or upper(ship_country) like 'BELGIUM';
--10
select * from orders where ship_country ilike 'france' or ship_country ilike 'BELGIUM';
--10
select * from orders where ship_country in ('France','Belgium');

--11
with product_price_rank as (
    select product_name,quantity_per_unit,unit_price,categories.category_name ,
    rank() over(partition by products.category_id order by unit_price desc) as rnk 
    from products
    join categories on categories.category_id = products.category_id 
)
select product_name,quantity_per_unit,unit_price,category_name,rnk 
from product_price_rank
where rnk <= 5;
--11
select product_name,quantity_per_unit,unit_price,category_name,rnk 
from (
    select product_name,quantity_per_unit,unit_price,categories.category_name ,
    rank() over(partition by products.category_id order by unit_price desc) as rnk 
    from products
    join categories on categories.category_id = products.category_id 
) as product_price_rank
where rnk <= 5;

--12
select * from products where discontinued = 1 order by product_name;

Hello , here is the rest of the questions:
 
--13
select c.category_name, count(p.product_id) from products p 
left join categories c on c.category_id = p.category_id 
group by c.category_id
order by c.category_name;

--14
with sumPerOrder as (
    select order_id, sum((1-discount) * unit_price * quantity) as sumPerOrder
    from order_details od 
    group by order_id
)
select avg(sumPerOrder) from sumPerOrder;

--15
select c.category_name, sum( (1-discount) * od.unit_price * od.quantity)
from products 
left join categories c on products.category_id = c.category_id
left join order_details od on od.product_id = products.product_id
group by c.category_id
order by c.category_name;

--16
select s.company_name, count(o.order_id) as number_of_orders
from orders o 
join shippers s on o.ship_via = s.shipper_id 
group by s.shipper_id;

--17
select concat(e.first_name, ' ', e.last_name) as employee_full_name , count(o.order_id) as number_of_orders 
from orders o 
join employees e on o.employee_id = e.employee_id 
group by e.employee_id 
order by employee_full_name asc;

--18
select s.company_name, cast(sum( (1-discount) * od.unit_price * od.quantity) as integer)
from products p
left join suppliers s on p.supplier_id = s.supplier_id
left join order_details od on od.product_id = p.product_id
group by s.supplier_id
order by s.company_name;

--19
INSERT INTO categories
(category_id, category_name, description, picture)
VALUES(9, 'New Category Name', 'New Category description', categoryImageBytes);

INSERT INTO products
(product_id, product_name, supplier_id, category_id, quantity_per_unit, unit_price, units_in_stock, units_on_order, reorder_level, discontinued)
VALUES(78, 'New Product name', 1, 9, 'Quantity per unit', 8, 100, 0, 10, 0);

--20
INSERT INTO orders
(order_id, customer_id, employee_id, order_date, required_date, shipped_date, ship_via, freight, ship_name, ship_address, ship_city, ship_region, ship_postal_code, ship_country)
VALUES(11078, customer_id, employee_id, 'order_date', 'required_date', '', ship_via, freight, 'ship_name', 'ship_address', 'ship_city', 'ship_region', 'ship_postal_code', 'ship_country');

--Required: customer,shipper and employee ids, then insert into order_details for each product ordered by the customer
INSERT INTO order_details (order_id, product_id, unit_price, quantity, discount) VALUES(11078, 78, 8, 2, 0);
INSERT INTO order_details (order_id, product_id, unit_price, quantity, discount) VALUES(11078, 77, 13, 2, 0);

--21
UPDATE orders
SET shipped_date='2021-11-30'
WHERE order_id=11078;