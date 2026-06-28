Limit  (cost=17337.95..17337.98 rows=10 width=31) (actual time=187.236..187.242 rows=10.00 loops=1)
  Buffers: shared hit=2130 read=510
  ->  Sort  (cost=17337.95..17542.83 rows=81950 width=31) (actual time=187.234..187.239 rows=10.00 loops=1)
        Sort Key: lc.total_likes DESC
        Sort Method: top-N heapsort  Memory: 26kB
        Buffers: shared hit=2130 read=510
        ->  Hash Join  (cost=13356.02..15567.04 rows=81950 width=31) (actual time=114.673..176.274 rows=66881.00 loops=1)
              Hash Cond: (lc.artist_id = a.artist_id)
              Buffers: shared hit=2130 read=510
              ->  Hash Join  (cost=10406.02..12354.53 rows=100000 width=27) (actual time=93.759..128.535 rows=66881.00 loops=1)
                    Hash Cond: (al.artist_id = lc.artist_id)
                    Buffers: shared hit=1430 read=510
                    ->  Seq Scan on albums al  (cost=0.00..1686.00 rows=100000 width=15) (actual time=0.028..5.319 rows=100000.00 loops=1)
                          Buffers: shared hit=686
                    ->  Hash  (cost=9381.64..9381.64 rows=81950 width=12) (actual time=93.487..93.490 rows=37413.00 loops=1)
                          Buckets: 131072  Batches: 1  Memory Usage: 2632kB
                          Buffers: shared hit=744 read=510
                          ->  Subquery Scan on lc  (cost=7742.64..9381.64 rows=81950 width=12) (actual time=78.211..87.381 rows=37413.00 loops=1)
                                Buffers: shared hit=744 read=510
                                ->  HashAggregate  (cost=7742.64..8562.14 rows=81950 width=12) (actual time=78.209..84.307 rows=37413.00 loops=1)
                                      Group Key: s.artist_id
                                      Batches: 1  Memory Usage: 3609kB
                                      Buffers: shared hit=744 read=510
                                      ->  Merge Join  (cost=0.97..7242.64 rows=100000 width=4) (actual time=0.040..56.468 rows=100000.00 loops=1)
                                            Merge Cond: (ul.song_id = s.song_id)
                                            Buffers: shared hit=744 read=510
                                            ->  Index Only Scan using idx_ul_song_id on user_liked_songs ul  (cost=0.29..2468.29 rows=100000 width=4) (actual time=0.023..15.593 rows=100000.00 loops=1)
                                                  Heap Fetches: 0
                                                  Index Searches: 1
                                                  Buffers: shared hit=4 read=238
                                            ->  Index Scan using idx_songs_song_id on songs s  (cost=0.42..16676.42 rows=500000 width=8) (actual time=0.013..22.674 rows=100000.00 loops=1)
                                                  Index Searches: 1
                                                  Buffers: shared hit=740 read=272
              ->  Hash  (cost=1700.00..1700.00 rows=100000 width=16) (actual time=20.694..20.694 rows=100000.00 loops=1)
                    Buckets: 131072  Batches: 1  Memory Usage: 5938kB
                    Buffers: shared hit=700
                    ->  Seq Scan on artists a  (cost=0.00..1700.00 rows=100000 width=16) (actual time=0.018..6.397 rows=100000.00 loops=1)
                          Buffers: shared hit=700
Planning:
  Buffers: shared hit=22
Planning Time: 0.351 ms
Execution Time: 189.040 ms
