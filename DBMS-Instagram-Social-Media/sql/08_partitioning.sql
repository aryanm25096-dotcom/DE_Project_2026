-- =====================================================================
-- Instagram DBMS Project: Checkpoint 4 (Table Partitioning Strategy)
-- File: sql/08_partitioning.sql
-- Description: Declarative partitioning for high-growth tables (likes),
--              enforcing partition pruning, demonstrating PRIMARY KEY rules,
--              and comparing RANGE vs HASH partitioning architectures.
-- =====================================================================

SET search_path TO instagram, public;

-- ---------------------------------------------------------------------
-- 1. Architectural Motivation for Partitioning 'likes'
-- ---------------------------------------------------------------------
-- At 1× seed scale: 419,954 rows (18 MB heap + 25 MB indexes).
-- At 20× large scale: 8,399,000 rows (≈ 360 MB heap + 500 MB indexes).
-- At 100× enterprise scale: 42,000,000+ rows (≈ 1.8 GB heap + 2.5 GB indexes).
--
-- Why Partition?
-- 1. Cache Locality (Working Set): Recent post likes remain in shared_buffers.
-- 2. Partition Pruning: Queries filtering by time or post eliminate 75-90% of data pages.
-- 3. Efficient Archival / Drop: Expired or historical partitions can be detached
--    via `ALTER TABLE ... DETACH PARTITION` in O(1) time without VACUUM overhead.

-- ---------------------------------------------------------------------
-- 2. Range Partitioning: 'likes_partitioned' by created_at (Quarterly)
-- ---------------------------------------------------------------------

-- PostgreSQL Primary Key Rule on Partitioned Tables:
-- "Every unique or primary key constraint on a partitioned table must
--  contain all the partition key columns."
-- Therefore, the composite primary key must include 'created_at'.

DROP TABLE IF EXISTS likes_partitioned CASCADE;

CREATE TABLE likes_partitioned (
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    post_id INT NOT NULL REFERENCES posts(post_id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL,
    PRIMARY KEY (user_id, post_id, created_at)
) PARTITION BY RANGE (created_at);

-- Partition Definitions (Quarterly Ranges for 2025–2026):
CREATE TABLE likes_y2025_q1 PARTITION OF likes_partitioned
    FOR VALUES FROM ('2025-01-01 00:00:00+05:30') TO ('2025-04-01 00:00:00+05:30');

CREATE TABLE likes_y2025_q2 PARTITION OF likes_partitioned
    FOR VALUES FROM ('2025-04-01 00:00:00+05:30') TO ('2025-07-01 00:00:00+05:30');

CREATE TABLE likes_y2025_q3 PARTITION OF likes_partitioned
    FOR VALUES FROM ('2025-07-01 00:00:00+05:30') TO ('2025-10-01 00:00:00+05:30');

CREATE TABLE likes_y2025_q4 PARTITION OF likes_partitioned
    FOR VALUES FROM ('2025-10-01 00:00:00+05:30') TO ('2026-01-01 00:00:00+05:30');

CREATE TABLE likes_y2026_q1 PARTITION OF likes_partitioned
    FOR VALUES FROM ('2026-01-01 00:00:00+05:30') TO ('2026-04-01 00:00:00+05:30');

CREATE TABLE likes_y2026_q2 PARTITION OF likes_partitioned
    FOR VALUES FROM ('2026-04-01 00:00:00+05:30') TO ('2026-07-01 00:00:00+05:30');

CREATE TABLE likes_default PARTITION OF likes_partitioned DEFAULT;

-- Local indexes automatically propagate to each individual partition:
CREATE INDEX idx_likes_part_post ON likes_partitioned (post_id, created_at DESC) INCLUDE (user_id);
CREATE INDEX idx_likes_part_user ON likes_partitioned (user_id, post_id);

-- Migrate existing seed data into partitioned structure:
INSERT INTO likes_partitioned (user_id, post_id, created_at)
SELECT user_id, post_id, created_at FROM likes;

ANALYZE likes_partitioned;

-- ---------------------------------------------------------------------
-- 3. Demonstration of Partition Pruning
-- ---------------------------------------------------------------------
-- When querying likes for a specific timeframe (e.g. June 2026), PostgreSQL
-- skips all non-matching partitions at plan time (Static / Run-time Pruning):

EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*) 
FROM likes_partitioned
WHERE created_at >= '2026-06-01 00:00:00+05:30' 
  AND created_at < '2026-07-01 00:00:00+05:30';

-- Result: Only 'likes_y2026_q2' is scanned; all other partitions are pruned!

-- ---------------------------------------------------------------------
-- 4. Hash Partitioning Alternative: 'likes_hash_partitioned' by post_id
-- ---------------------------------------------------------------------
-- If access patterns are dominated by Post ID lookups (e.g. Post Page R07 & R23),
-- Hash Partitioning on 'post_id' evenly distributes traffic across 4 shards:

DROP TABLE IF EXISTS likes_hash_partitioned CASCADE;

CREATE TABLE likes_hash_partitioned (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    PRIMARY KEY (post_id, user_id)
) PARTITION BY HASH (post_id);

CREATE TABLE likes_hash_0 PARTITION OF likes_hash_partitioned FOR VALUES WITH (MODULUS 4, REMAINDER 0);
CREATE TABLE likes_hash_1 PARTITION OF likes_hash_partitioned FOR VALUES WITH (MODULUS 4, REMAINDER 1);
CREATE TABLE likes_hash_2 PARTITION OF likes_hash_partitioned FOR VALUES WITH (MODULUS 4, REMAINDER 2);
CREATE TABLE likes_hash_3 PARTITION OF likes_hash_partitioned FOR VALUES WITH (MODULUS 4, REMAINDER 3);

CREATE INDEX idx_likes_hash_user ON likes_hash_partitioned (user_id);

INSERT INTO likes_hash_partitioned (user_id, post_id, created_at)
SELECT user_id, post_id, created_at FROM likes;

ANALYZE likes_hash_partitioned;

-- Demonstration of Hash Partition Pruning:
EXPLAIN (ANALYZE, BUFFERS)
SELECT * 
FROM likes_hash_partitioned
WHERE post_id = 59689;

-- Result: Only the single matching remainder partition is queried!
