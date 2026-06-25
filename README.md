1 ASSIGNMENT з бонусами: Hospital database. SQL SELECT queries with JOIN, GROUP BY, CTE, UNION ALL
Головний запит :
1. Об'єднує через UNION ALL прийоми за 2025 і 2026 рік за допомогою CTE (all_appointments)
2. Робить JOIN 5 таблиць (appointments, doctors, departments, patients, diagnoses) для повної інформації про лікарів, відділення, пацієнтів та діагнозів
3. Фільтрує дані за статусом Completed
4. Групує дані за лікарем, відділенням, пацієнтом та діагнозом і підраховує кількість прийомів.
5. Сортує результат за іменем лікаря


## 2 ASSIGNMENT з бонусами: 
## Задача
Знайти активних клієнтів які зробили більше 3 замовлень і мали замовлення товарів категорії `Category1` у 2023 році.
Виводимо: id клієнта, повне ім'я, статус, id замовлення, дату замовлення, назву і категорію товару. Відсортовано по імені, перші 1000 результатів.

## Non-optimized Query
- JOIN 3 таблиць
- 1 вкладений підзапит в `WHERE` для підрахунку кількості замовлень клієнта (`having count > 3`)
- підзапити повторно джойнять ті самі таблиці і це зайве навантаження на БД
| Metric | Value |
|--------|-------|
| Execution time | 1129 ms |
| Planning time | 2.178 ms |
| Type of Scan | Seq Scan |
| Buffers hit | 64 405 |

## Optimized Query
- створено індекс `index_opt_orders_by_client` на `client_id` в таблиці `opt_orders`
- використано CTE, кожна таблиця фільтрується лише один раз
- підзапити змінені на JOIN
- `active_clients` винесено в окремий CTE
### З індексом
| Metric | Value |
|--------|-------|
| Execution time | 675 ms |
| Planning time | 2.682 ms |
| Type of Scan | Index Scan (index_opt_orders_by_client) |
| Buffers hit | 57 563 |
### Без Index Scan (`set enable_indexscan = off`)
| Metric | Value |
|--------|-------|
| Execution time | 685 ms |
| Planning time | 1.072 ms |
| Type of Scan | Seq Scan, Bitmap Index Scan |
| Buffers hit | 52 837 |
## Summary
Неоптимізований запит мав вкладені підзапити які повторно джойнили ті самі таблиці. Через відсутність індексів виконувалось повне сканування таблиць, що сповільнювало виконання до **1129 ms**. Вирішила це створенням індексу на `client_id` та переписала запит з використанням CTE. В результаті час виконання скоротився з **1129 ms** до **675 ms** - приблизно **2.5** рази.

