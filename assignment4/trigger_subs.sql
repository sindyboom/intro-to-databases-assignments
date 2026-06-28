-- функція
create or replace function log_subscription()
returns trigger language plpgsql as $$
begin
    insert into payments (user_id, subscription_id, amount, payment_date, status)
    values (new.user_id, new.subscription_id, 
            (select price from subscription_plans where plan_id = new.plan_id),
            current_date, 'pending');
    return new;
end;
$$;

-- тригер
create trigger trg_new_subscription
after insert on subscriptions
for each row execute function log_subscription();


insert into subscriptions (user_id, plan_id, start_date, end_date)
values (1, 1, current_date, current_date + 30);

-- дивлюсь які юзери є
select user_id from users limit 1;

-- дивлюсь підписку
select * from subscriptions where user_id = 1;

-- дивлюсь що тригер автоматично створив платіж
select * from payments where user_id = 1;