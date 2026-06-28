explain analyze
with liked_counts as (
    select s.artist_id, count(*) as total_likes
    from user_liked_songs ul
    join songs s on s.song_id = ul.song_id
    group by s.artist_id
)
select a.name, al.title, lc.total_likes
from liked_counts lc
join artists a on a.artist_id = lc.artist_id
join albums al on al.artist_id = a.artist_id
order by lc.total_likes desc
limit 10;

create index idx_songs_artist_id on songs(artist_id);
create index idx_songs_song_id on songs(song_id);
create index idx_ul_song_id on user_liked_songs(song_id);
create index idx_albums_artist_id on albums(artist_id);

set enable_indexscan = off;
set enable_bitmapscan = off;

set enable_indexscan = on;
set enable_bitmapscan = on;

