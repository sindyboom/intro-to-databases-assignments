create or replace procedure add_song( p_album_id int,p_artist_id int, p_title varchar,p_duration int)
language plpgsql as $$
begin
    insert into songs (album_id, artist_id, title, duration_sec)
    values (p_album_id, p_artist_id, p_title, p_duration);
end;
$$;

-- виклик
call add_song(1, 1, 'new song', 200);
