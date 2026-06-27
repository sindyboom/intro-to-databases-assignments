create or replace function calculate_order_total(p_order_id int)
returns numeric(10,2)
language plpgsql
as $$
begin
    return (select coalesce(sum(quantity * price), 0) from order_items where order_id = p_order_id);
end;
$$;
