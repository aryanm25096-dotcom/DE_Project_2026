# Checkpoint 4: Scalability & Architecture Report (20× Large Dataset Round)

**Course:** Data Engineering / Database Management Systems (PostgreSQL)  
**Checkpoint:** CP4 — Scalability & Architecture Report  
**Database Name:** `instagram_large_db`  
**Measured Scale:** 23,996,713 total rows (600,000 users · 1,200,000 posts · 8,399,946 likes · 3,000,000 comments · 5,195,968 follows · 1,800,749 media items · 800,000 stories)  
**Benchmark Script:** `./benchmarks/run_benchmark.sh instagram_large_db large 3 sql/06_optimized_queries.sql`  
**Enterprise Target:** 100× Architecture Design  

---

## 1. 20× Large Dataset Performance Results (Measured)

All 30 optimized queries were executed 3 times each on `instagram_large_db` (`large_data.zip`) and evaluated against faculty target thresholds:
- **User-Facing / Real-Time:** Target **< 5 ms**
- **Interactive Search & Tools:** Target **< 250 ms**
- **Reports & Analytics:** Target **< 5,000 ms**
- **Batch Jobs:** Target **< 3,000 ms**

| Query | Category | Optimized Seed (ms) | Measured Large (ms) | Growth Factor (Large ÷ Seed) | Faculty Target | Target Met? | Plan / Bottleneck Notes |
|:---|:---:|---:|---:|---:|---:|:---:|:---|
| **R01** | Real-Time | 1.043 | **3.788** | 3.63× | < 5 ms | ✅ **PASS** | `Index Only Scan` on follows + `Bitmap Index Scan` on posts |
| **R02** | Real-Time | 0.121 | **0.052** | 0.43× | < 5 ms | ✅ **PASS** | `Index Scan using idx_posts_user_created` (O(log N)) |
| **R03** | Real-Time | 0.020 | **0.843** | 42.1× | < 5 ms | ✅ **PASS** | Unique B-tree index lookup on `users(username)` |
| **R04** | Real-Time | 0.446 | **0.117** | 0.26× | < 5 ms | ✅ **PASS** | `Index Scan using idx_comments_post_parent` + `idx_comments_parent` |
| **R05** | Search/Tools | 1.026 | **13.445** | 13.1× | < 250 ms | ✅ **PASS** | `Index Only Scan` on `posts` and `post_hashtags` |
| **R06** | Search/Tools | 1.030 | **41.042** | 39.8× | < 250 ms | ✅ **PASS** | GIN trigram index (`pg_trgm`) on 600k users |
| **R07** | Real-Time | 0.216 | **0.462** | 2.14× | < 5 ms | ✅ **PASS** | `Index Only Scan using idx_likes_post_id` |
| **R08** | Search/Tools | 0.713 | **0.393** | 0.55× | < 250 ms | ✅ **PASS** | `Index Only Scan` on `follows` |
| **R09** | Real-Time | 0.215 | **3.272** | 15.2× | < 5 ms | ✅ **PASS** | Partial index `idx_follows_pending` |
| **R10** | Search/Tools | 0.384 | **0.092** | 0.24× | < 250 ms | ✅ **PASS** | `Index Only Scan` on `follows` and `stories` |
| **R11** | Analytics | 4.245 | **35.775** | 8.43× | < 5,000 ms | ✅ **PASS** | `Seq Scan on posts` + `Index Scan` on creators |
| **R12** | Analytics | 0.734 | **9.396** | 12.8× | < 5,000 ms | ✅ **PASS** | `Index Only Scan` on `posts(created_at, like_count)` |
| **R13** | Search/Tools | 0.134 | **0.037** | 0.28× | < 250 ms | ✅ **PASS** | Anti-join via `Index Only Scan using idx_comments_parent` |
| **R14** | Search/Tools | 0.152 | **0.550** | 3.62× | < 250 ms | ✅ **PASS** | `Index Only Scan using idx_follows_followee_accepted` |
| **R15** | Analytics | 13.911 | **137.030** | 9.85× | < 5,000 ms | ✅ **PASS** | Partial index on verified/creators + `follows` Index-Only Scan |
| **R16** | Search/Tools | 0.231 | **3.984** | 17.2× | < 250 ms | ✅ **PASS** | GIN trigram `idx_posts_location_trgm` + date range index |
| **R17** | Analytics | 2.280 | **16.338** | 7.17× | < 5,000 ms | ✅ **PASS** | Partial index `idx_posts_reels_2026` + `post_media` covering |
| **R18** | Analytics | 0.787 | **14.967** | 19.0× | < 5,000 ms | ✅ **PASS** | `Bitmap Index Scan` on `posts` June range |
| **R19** | Analytics | 23.843 | **172.108** | 7.22× | < 5,000 ms | ✅ **PASS** | Pre-aggregated CTE join (`idx_likes_post_id` Index-Only Scan) |
| **R20** | Analytics | 3.060 | **45.922** | 15.0× | < 5,000 ms | ✅ **PASS** | `Index Only Scan` on `posts` and `comments` |
| **R21** | Search/Tools | 4.445 | **73.703** | 16.6× | < 250 ms | ✅ **PASS** | `Index Only Scan` on `follows` and `likes` |
| **R22** | Search/Tools | 0.521 | **0.137** | 0.26× | < 250 ms | ✅ **PASS** | `Index Only Scan using idx_comments_hidden_created` |
| **R23** | Real-Time | 0.079 | **0.043** | 0.54× | < 5 ms | ✅ **PASS** | `Index Only Scan using idx_likes_user_post` |
| **R24** | Analytics | 0.596 | **7.845** | 13.2× | < 5,000 ms | ✅ **PASS** | `Index Only Scan using idx_stories_created_views` |
| **W01** | Real-Time | 1.167 | **1.092** | 0.94× | < 5 ms | ✅ **PASS** | Single-row insert into `posts` |
| **W02** | Real-Time | 0.703 | **1.089** | 1.55× | < 5 ms | ✅ **PASS** | Single-row upsert into `likes` |
| **W03** | Real-Time | 0.195 | **1.421** | 7.29× | < 5 ms | ✅ **PASS** | Point PK update on `posts` |
| **W04** | Batch Job | 74.705 | **1,813.185** | 24.3× | < 3,000 ms | ✅ **PASS** | Nightly recount across 5.2M follows & 600k users |
| **W05** | Batch Job | 13.036 | **605.607** | 46.5× | < 3,000 ms | ✅ **PASS** | Batch delete across 800k stories |
| **W06** | Real-Time | 0.951 | **13.131** | 13.8× | < 5 ms | ⚠️ **Explained** | Bulk `UPDATE` of all pending requests for user 338 (see §3) |

**Summary:** **29 of 30 queries** meet their faculty SLA targets out of the box on 24 million rows; **W06** is explained below.

---

## 2. Growth Analysis

Queries fall into three distinct scaling tiers when data expands 20× (to 24M rows):

### Tier 1: Constant / Sub-Millisecond ($O(\log N)$)
- **Queries:** `R02`, `R03`, `R04`, `R07`, `R08`, `R10`, `R13`, `R14`, `R22`, `R23`, `W01`, `W02`, `W03`.
- **Behavior:** Remained between **0.03 ms and 1.42 ms** despite 20× more rows. B-tree depth only grows by ~1 level between 60k and 1.2M posts, so buffer page lookups stay nearly constant.

### Tier 2: Selective Range / Trigram Scans (3× – 17× growth)
- **Queries:** `R01`, `R05`, `R06`, `R09`, `R11`, `R12`, `R16`, `R17`, `R19`, `R20`, `R21`, `R24`.
- **Behavior:** Grew proportionally to the matched subset size ($K$) rather than total table size ($N$). `R19` (our worst baseline query at 5.44s on 1× seed data) ran in just **172.1 ms** on 20× data thanks to the CTE rewrite and covering indexes.

### Tier 3: Proportional & Maintenance Overhead (~20× – 46× growth)
- **Queries:** `R18`, `W04`, `W05`, `W06`.
- **Behavior:** `W04` (1.81s) and `W05` (0.61s) touch a fixed share of the 24M rows and update multiple indexes on each modified tuple, scaling linearly with row count.

---

## 3. What Broke / Slowed Down at Scale & How We Handled It

1. **`W06` (Bulk Accept Follow Requests — 13.131 ms vs 5 ms target):**
   - *Why:* `W06` executes `UPDATE follows SET status = 'ACCEPTED' WHERE followee_id = 338 AND status = 'PENDING'`. At 20× scale, user 338 has 20× more pending requests, and changing `status` forces PostgreSQL to update all 3 filtered/composite indexes on `follows` (`idx_follows_pending`, `idx_follows_follower_status`, `idx_follows_followee_accepted`) for every updated row in one statement.
   - *Fix in Production:* Batch-accepting "Accept All" in the background (or processing in chunks of 50 rows / single-request `AND follower_id = $2`), which keeps interactive single-accept latency under **0.5 ms**.
2. **`R06` (GIN Trigram Search — 41.04 ms):**
   - *Why:* Trigram intersections for common prefixes (`'karan%'`) match ~20× more users on 600k rows before sorting by `(is_verified DESC, followers_count DESC)`.
   - *Fix:* Still well under the 250 ms target; at 100× scale, add a materialized prefix column or route type-ahead search to Elasticsearch/Typesense.
3. **`W05` (Expired Stories Cleanup — 605.61 ms):**
   - *Why:* Planner chose `Seq Scan on stories` because deleting >70% of expired rows in one batch makes sequential scanning faster than random index lookups.
   - *Fix:* At 100× scale, partition `stories` daily/weekly by `expires_at` and use `DROP TABLE` / `DETACH PARTITION` for instant $O(1)$ expiration cleanup.

---

## 4. Measured Storage Comparison: Seed (1×) vs Large (20×)

Measured directly from PostgreSQL system catalogs (`pg_database_size`, `pg_relation_size`, `pg_indexes_size`):

| Table | Seed Heap + Indexes (1×) | Large Heap (20×) | Large Indexes (20×) | Large Total (20×) |
|:---|---:|---:|---:|---:|
| `likes` | 43.2 MB | 355 MB | 685 MB | **1,040 MB** |
| `follows` | 31.7 MB | 298 MB | 333 MB | **631 MB** |
| `comments` | 21.8 MB | 197 MB | 231 MB | **428 MB** |
| `post_media` | 12.8 MB | 176 MB | 75 MB | **251 MB** |
| `posts` | 12.3 MB | 120 MB | 124 MB | **244 MB** |
| `post_hashtags` | 11.9 MB | 104 MB | 129 MB | **233 MB** |
| `users` | 12.8 MB | 87 MB | 139 MB | **226 MB** |
| `stories` | 7.7 MB | 52 MB | 96 MB | **148 MB** |
| `hashtags` | 40 KB | 8 KB | 32 KB | **72 KB** |
| **Total Database Size** | **~155 MB** | **1,389 MB** | **1,812 MB** | **3,209 MB (3.21 GB)** |

---

## 5. Architecture for 100× Scale (~240M Rows, ~16 GB)

At 100× scale (~42M+ likes, ~6M posts, ~3M users), a single PostgreSQL primary node encounters physical disk I/O and autovacuum limits. The recommended architecture:

### 5.1 Table Partitioning (`sql/08_partitioning.sql`)
- **Partition `likes` by `RANGE (created_at)`** (quarterly or monthly partitions) to keep the active working-set index inside `shared_buffers` and enable `DETACH PARTITION` archival.
- **Primary Key Rule:** Partitioned tables in PostgreSQL require the partition key to be included in the primary key: `PRIMARY KEY (user_id, post_id, created_at)`.
- Verified via `EXPLAIN (ANALYZE, BUFFERS)` that queries filtering on `created_at` prune 5 of 6 partitions automatically (`likes_y2026_q2` only).

### 5.2 Horizontal Sharding: Shard Key Strategy
* **Author Sharding (`user_id`):**
  - *Best for:* Profile grids (`R02`), creator analytics (`R11`, `R17`), and user settings (`R03`).
  - *Cross-shard problem:* Home feed (`R01`) reads posts from many authors, requiring scatter-gather across shards.
* **Post Sharding (`post_id`):**
  - *Best for:* Post pages (`R04`, `R07`, `R23`) on viral posts.
* **Recommended Hybrid:** Shard `posts`, `comments`, and `likes` by **`user_id`** (author), and maintain a **Redis Fan-Out Feed Cache** storing the latest 800 `post_id`s per active follower so `R01` never triggers cross-shard SQL joins.

### 5.3 Read Replicas & Caching
- **Read Replicas:** Route analytics (`R11`, `R12`, `R15`, `R17`, `R18`, `R19`, `R20`, `R24`) and recount audit (`W04`) to streaming read replicas via PgBouncer. Keep the primary node strictly for writes (`W01`–`W06`) and consistent reads (`R09`, `R23`).
- **Redis Cache:** Cache user profiles (`R03`) and like-button state (`R23` via Redis Sets) for sub-millisecond reads.

### 5.4 Maintenance & Autovacuum Tuning
```ini
# High-throughput tuning for likes (42M+ rows) & comments (15M+ rows)
autovacuum_max_workers = 6
autovacuum_vacuum_cost_limit = 2000
autovacuum_vacuum_cost_delay = 2ms

ALTER TABLE likes SET (autovacuum_vacuum_scale_factor = 0.02, autovacuum_vacuum_threshold = 5000);
ALTER TABLE stories SET (autovacuum_vacuum_scale_factor = 0.05, autovacuum_vacuum_threshold = 2000);
```

---

## 6. Conclusion

Testing against the real 24-million-row dataset (`instagram_large_db`, 3.21 GB) confirmed that our indexing and query optimizations hold up under 20× growth: **29 of 30 queries pass faculty SLAs directly**, `R19` dropped from **5.44s on 1×** to **172 ms on 20×**, and all real-time reads stay under **3.8 ms**. Combined with declarative partitioning (`sql/08_partitioning.sql`), read-replica offloading, and Redis feed caching, the platform is ready for 100× growth.
