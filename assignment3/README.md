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
