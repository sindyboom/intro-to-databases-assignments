Limit  (cost=31417.81..31417.83 rows=10 width=31) (actual time=600.784..600.793 rows=10.00 loops=1)
  Buffers: shared hit=5506, temp read=1504 written=1504
  ->  Sort  (cost=31417.81..31622.68 rows=81950 width=31) (actual time=600.782..600.789 rows=10.00 loops=1)
        Sort Key: lc.total_likes DESC
        Sort Method: top-N heapsort  Memory: 26kB
        Buffers: shared hit=5506, temp read=1504 written=1504
        ->  Hash Join  (cost=27435.88..29646.90 rows=81950 width=31) (actual time=523.548..590.472 rows=66881.00 loops=1)
              Hash Cond: (lc.artist_id = a.artist_id)
              Buffers: shared hit=5506, temp read=1504 written=1504
              ->  Hash Join  (cost=24485.88..26434.39 rows=100000 width=27) (actual time=499.833..537.645 rows=66881.00 loops=1)
                    Hash Cond: (al.artist_id = lc.artist_id)
                    Buffers: shared hit=4806, temp read=1504 written=1504
                    ->  Seq Scan on albums al  (cost=0.00..1686.00 rows=100000 width=15) (actual time=0.033..5.295 rows=100000.00 loops=1)
                          Buffers: shared hit=686
                    ->  Hash  (cost=23461.50..23461.50 rows=81950 width=12) (actual time=499.534..499.538 rows=37413.00 loops=1)
                          Buckets: 131072  Batches: 1  Memory Usage: 2632kB
                          Buffers: shared hit=4120, temp read=1504 written=1504
                          ->  Subquery Scan on lc  (cost=21822.50..23461.50 rows=81950 width=12) (actual time=480.535..491.993 rows=37413.00 loops=1)
                                Buffers: shared hit=4120, temp read=1504 written=1504
                                ->  HashAggregate  (cost=21822.50..22642.00 rows=81950 width=12) (actual time=480.532..488.774 rows=37413.00 loops=1)
                                      Group Key: s.artist_id
                                      Batches: 1  Memory Usage: 3609kB
                                      Buffers: shared hit=4120, temp read=1504 written=1504
                                      ->  Hash Join  (cost=16881.00..21322.50 rows=100000 width=4) (actual time=140.123..452.944 rows=100000.00 loops=1)
                                            Hash Cond: (ul.song_id = s.song_id)
                                            Buffers: shared hit=4120, temp read=1504 written=1504
                                            ->  Seq Scan on user_liked_songs ul  (cost=0.00..1443.00 rows=100000 width=4) (actual time=0.014..7.924 rows=100000.00 loops=1)
                                                  Buffers: shared hit=443
                                            ->  Hash  (cost=8677.00..8677.00 rows=500000 width=8) (actual time=137.676..137.677 rows=500000.00 loops=1)
                                                  Buckets: 262144  Batches: 4  Memory Usage: 6928kB
                                                  Buffers: shared hit=3677, temp written=1280
                                                  ->  Seq Scan on songs s  (cost=0.00..8677.00 rows=500000 width=8) (actual time=0.013..45.818 rows=500000.00 loops=1)
                                                        Buffers: shared hit=3677
              ->  Hash  (cost=1700.00..1700.00 rows=100000 width=16) (actual time=23.445..23.446 rows=100000.00 loops=1)
                    Buckets: 131072  Batches: 1  Memory Usage: 5938kB
                    Buffers: shared hit=700
                    ->  Seq Scan on artists a  (cost=0.00..1700.00 rows=100000 width=16) (actual time=0.028..7.191 rows=100000.00 loops=1)
                          Buffers: shared hit=700
Planning:
  Buffers: shared hit=52 read=7
Planning Time: 3.082 ms
Execution Time: 603.663 ms
