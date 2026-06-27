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
