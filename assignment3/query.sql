create or replace function calculate_order_total(p_order_id int)
returns numeric(10,2)
language plpgsql
as $$
begin
    return (select coalesce(sum(quantity * price), 0) from order_items where order_id = p_order_id);
end;
$$;
create or replace procedure create_order(p_customer_id int)
language plpgsql
as $$
begin
    if not exists (select * from customers where customer_id = p_customer_id) then
        raise exception 'Customer does not exist';
    end if;
    insert into orders (customer_id, order_date, total_amount)
    values (p_customer_id, now(), 0);
end;
$$;
create or replace procedure add_product_to_order(p_order_id int, p_product_id int, p_quantity int)
language plpgsql
as $$
begin
    if p_quantity <= 0 then
        raise exception 'quantity must be greater than 0';
    end if;
    if not exists (select 67 from products where product_id = p_product_id and stock_quantity >= p_quantity) then
        raise exception 'not enough stock';
    end if;
    insert into order_items (order_id, product_id, quantity, price)
    values (p_order_id, p_product_id, p_quantity, (select price from products where product_id = p_product_id));
    update products 
    set stock_quantity = stock_quantity - p_quantity where product_id = p_product_id;
end;
$$;

create or replace function update_order_items_total()
returns trigger
language plpgsql
as $$
begin
    update orders
    set total_amount = calculate_order_total(coalesce(new.order_id, old.order_id))
    where order_id = coalesce(new.order_id, old.order_id);
    return null;
end;
$$;
create trigger trigger_update_total
after insert or update or delete on order_items
for each row
execute function update_order_items_total();

create or replace function trigger_log_order_created()
returns trigger
language plpgsql
as $$
begin
    insert into order_log (order_id, customer_id, action, log_date)
    values (new.order_id, new.customer_id, 'Order was created', now());
    return null;
end;
$$;
create trigger trigger_log
after insert on orders
for each row
execute function trigger_log_order_created();
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
call add_product_to_order(1, 11, 1);
call add_product_to_order(1, 12, 2);
call add_product_to_order(2, 2, 3);
-- перевіряю total_amount (має оновитись автоматично)
select order_id, total_amount from orders;
-- перевіряю stock_quantity (має зменшитись)
select product_id, product_name, stock_quantity from products;
-- перевіряю лог
select * from order_log;
