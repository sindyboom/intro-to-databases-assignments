## Bonus Task 3 — Query Analysis

### Query
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

### Execution Plan
Sort  (cost=51.39..51.40 rows=2 width=270) (actual time=0.263..0.264 rows=4 loops=1)

Sort Key: (oi.quantity * oi.price) DESC

->  Hash Join  (cost=37.23..51.38 rows=2 width=270) (actual time=0.207..0.210 rows=4 loops=1)

Hash Cond: (p.product_id = oi.product_id)

->  Seq Scan on products p  (actual time=0.096..0.097 rows=12 loops=1)

->  Seq Scan on order_items oi  (actual time=0.031..0.035 rows=4 loops=1)

Filter: (order_id = 1) AND (quantity * price > 100)

Rows Removed by Filter: 17

Planning Time: 1.462 ms

Execution Time: 0.377 ms

### Explanation
Спочатку виконується Seq Scan на обох таблицях, перебирає всі рядки послідовно, бо таблиці малі і індексів немає. Потім з'єднуються через Hash Join по product_id - будується хеш-таблиця з order_items і шукає збіги в products. В кінці сортується результат по item_total desc через **quicksort** в пам'яті (25kB). Загальний час виконання склав 0.377 ms.
