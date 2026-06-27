# Practice Assignment 3 — Online Store Database

## Functions

**`calculate_order_total(p_order_id int)`** — повертає загальну суму замовлення як `sum(quantity * price)` з `order_items`. Якщо замовлення порожнє — повертає `0`.

---

## Procedures

**`create_order(p_customer_id int)`** — створює нове замовлення для клієнта. Якщо клієнт не існує — кидає exception.

**`add_product_to_order(p_order_id, p_product_id, p_quantity)`** — додає товар до замовлення. Бере поточну ціну з `products`, зменшує залишок на складі. Кидає exception якщо кількість <= 0 або недостатньо товару.

---

## Triggers

**`trigger_update_total`** - спрацьовує після `insert`, `update`, `delete` на `order_items`, перераховує `total_amount` в `orders` через `calculate_order_total()`.

**`trigger_log`** - спрацьовує після `insert` на `orders`. Записує в `order_log` id замовлення, id клієнта, тип дії і час створення.
## Testing
---
```sql
-- створюю клієнтів
insert into customers (full_name, email, balance)
values
    ('Izolda Kassandrovna', 'izolda@example.com', 500),
    ('Victor Dudka', 'victor@example.com', 300);

-- створюю продукти
insert into products (product_name, price, stock_quantity)
values
    ('laptop67', 25000, 10),
    ('mouse67', 350, 50);

-- створюю замовлення через процедуру
call create_order(1);
call create_order(2);

-- додаю товари через процедуру
call add_product_to_order(1, 1, 1);
call add_product_to_order(1, 2, 2);
call add_product_to_order(2, 2, 3);

-- перевіряю total_amount (має оновитись автоматично)
select order_id, total_amount from orders;

-- перевіряю stock_quantity (має зменшитись)
select product_id, product_name, stock_quantity from products;

-- перевіряю лог
select * from order_log;
```
---
## Explain Analyze
---
```sql
explain analyze
select
    p.product_name,
    oi.quantity,
    oi.price,
    oi.quantity * oi.price as item_total
from order_items oi
join products p on p.product_id = oi.product_id
where oi.order_id = 1
    and oi.quantity * oi.price > 100
order by item_total desc;

```
---
## Execution Plan 
---
Sort (cost=51.39..51.40 rows=2 width=270) (actual time=0.263..0.264 rows=4 loops=1)

Sort Key: (oi.quantity * oi.price) DESC

-> Hash Join (cost=37.23..51.38 rows=2 width=270) (actual time=0.207..0.210 rows=4 loops=1)

Hash Cond: (p.product_id = oi.product_id)

-> Seq Scan on products p (actual time=0.096..0.097 rows=12 loops=1)

-> Seq Scan on order_items oi (actual time=0.031..0.035 rows=4 loops=1)

Filter: (order_id = 1) AND (quantity * price > 100)

Rows Removed by Filter: 17

Planning Time: 1.462 ms

Execution Time: 0.377 ms

