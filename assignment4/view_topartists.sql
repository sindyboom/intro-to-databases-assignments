create or replace view top_artists as
select a.name, count(ul.song_id) as total_likes
from artists a
join songs s on s.artist_id = a.artist_id
join user_liked_songs ul on ul.song_id = s.song_id
group by a.name
order by total_likes desc;

select * from top_artists