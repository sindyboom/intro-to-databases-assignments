create role music_admin login password 'admin123';
create role music_artist login password 'artist123';
create role music_listener login password 'listener123';

-- адмін: повний доступ
grant all privileges on all tables in schema public to music_admin;

-- артист: може додавати пісні та альбоми, читати все
grant select on all tables in schema public to music_artist;
grant insert, update on songs to music_artist;
grant insert, update on albums to music_artist;

-- слухач: тільки читання + лайки
grant select on all tables in schema public to music_listener;
grant insert, delete on user_liked_songs to music_listener;
grant insert, delete on artist_followers to music_listener;

grant insert on payments to music_listener;
grant insert on subscriptions to music_listener;
grant select on subscription_plans to music_listener;