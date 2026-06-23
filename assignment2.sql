--пояснення в readme
--неоптимізований запит
explain analyze
select c.id, concat(c.name, ' ', c.surname) as fullname, c.status, o.order_id, o.order_date,p.product_name, p.product_category
from opt_clients c
join opt_orders o on c.id = o.client_id
join opt_products p on p.product_id = o.product_id
where c.status = 'active'and p.product_category = 'Category1'and o.order_date >= '2023-01-01' and o.order_date < '2024-01-01'and c.id in 
(     select opt_clients.id
      from opt_clients
      join opt_orders on opt_clients.id = opt_orders.client_id
      group by opt_clients.id
      having count(*) > 3)
order by concat(c.name, ' ', c.surname)
limit 1000;

--індекс
create index if not exists index_opt_orders_by_client
    on opt_orders(client_id);

-- оптимізований запит з бонусним

set enable_indexscan = off;

explain analyze
with filtered_clients as (select * from opt_clients where status = 'active'),
filtered_products as (select * from opt_products where product_category = 'Category1'),
filtered_orders as ( select * from opt_orders where order_date >= '2023-01-01' and order_date < '2024-01-01'),
client_order_product as (select c.id, concat(c.name, ' ', c.surname) as fullname,c.status, o.order_id, o.order_date,p.product_name, p.product_category
    from filtered_clients c
    join filtered_orders o on c.id = o.client_id
    join filtered_products p on o.product_id = p.product_id),
active_clients as (select client_id as id from opt_orders group by client_id having count(*) > 3)
select cop.*
from client_order_product cop
join active_clients ac on cop.id = ac.id
order by fullname
limit 1000;


set enable_indexscan = on;



