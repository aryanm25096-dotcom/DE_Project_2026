# Checkpoint 2: Baseline Timings Report

**Course:** Data Engineering / Database Management Systems (PostgreSQL)  
**Checkpoint:** CP2 — Baseline Timings  
**Target Date:** Tuesday 17 Nov 2026, 11:59 PM  
**Database Name:** `instagram_db`  
**Dataset Scale:** 30,000 users · 60,000 posts · 419,954 likes · 150,000 comments · 258,588 follows · 89,854 media items  
**Environment:** Apple Silicon Mac (macOS), PostgreSQL 18.4  
**Benchmark Script:** `./benchmarks/run_benchmark.sh instagram_db baseline` (3 runs per query, EXPLAIN ANALYZE BUFFERS)  

---

## 1. Executive Summary

This report documents the baseline performance of the 30 workload queries (`R01`–`R24` reads, `W01`–`W06` writes) running on an unindexed PostgreSQL schema (primary keys and unique constraints only).

Across all 30 queries:
- **Fastest Query:** `R03` (Open profile by username) at **0.021 ms** and `R23` (Like button state) at **0.025 ms**, both leveraging unique B-tree indexes.
- **Slowest Query:** `R19` (Verified accounts like aggregation) at **5,440.593 ms (~5.44 seconds)** due to full sequential scans on `users`, `posts`, and `likes` (419,954 rows).
- **Primary Bottleneck:** Repeated `Seq Scan` operations on large relational tables (`posts` 60k rows, `likes` 420k rows, `comments` 150k rows, `follows` 258k rows) where foreign key indexes and selective filter indexes are currently absent.

---

## 2. 30-Query Baseline Timing Table

| SQL Query | Type | Run 1 (ms) | Run 2 (ms) | Run 3 (ms) | Average (ms) | Dominant Scan Nodes |
|:---|:---:|---:|---:|---:|---:|:---|
| **R01**: Home feed: latest 30 posts from followed accounts | READ | 4.677 | 4.386 | 4.109 | **4.391** | `Seq Scan on posts` \| `Index Scan on follows` |
| **R02**: Profile grid: user 217's latest 12 posts | READ | 2.270 | 2.216 | 2.242 | **2.243** | `Seq Scan on posts` |
| **R03**: Open a profile by username | READ | 0.022 | 0.020 | 0.022 | **0.021** | `Index Scan on users (username_key)` |
| **R04**: Post page: top-level comments on post 59689 with reply counts | READ | 7.154 | 7.476 | 6.778 | **7.136** | `Seq Scan on comments` |
| **R05**: Explore: top posts tagged #travel in June 2026 | READ | 9.300 | 9.263 | 9.300 | **9.288** | `Seq Scan on post_hashtags` \| `Seq Scan on hashtags` |
| **R06**: Search bar: accounts matching "karan" prefix / full name | READ | 9.056 | 9.231 | 8.911 | **9.066** | `Seq Scan on users` |
| **R07**: "Liked by": users liking post 59689, showing follow status | READ | 6.644 | 6.197 | 6.352 | **6.398** | `Seq Scan on likes` \| `Index Scan on users` |
| **R08**: "Suggested for you": friends-of-friends not yet followed | READ | 0.143 | 0.128 | 0.139 | **0.137** | `Index Scan on follows` \| `Index Only Scan on follows` |
| **R09**: Follow requests screen: pending requests for private user 338 | READ | 2.376 | 2.547 | 2.748 | **2.557** | `Index Scan on follows` \| `Index Scan on users` |
| **R10**: Story highlights: stories in June 2026 from followed users | READ | 2.071 | 1.978 | 2.106 | **2.052** | `Seq Scan on stories` \| `Index Scan on follows` |
| **R11**: Creator insights: engagement rate on 2026 posts (top 20) | READ | 5.366 | 5.208 | 5.454 | **5.343** | `Seq Scan on posts` \| `Seq Scan on users` |
| **R12**: Trending: hashtags used most in last 7 days of June 2026 | READ | 3.199 | 3.159 | 2.967 | **3.108** | `Seq Scan on posts` \| `Index Only Scan on post_hashtags` |
| **R13**: Creator tools: comments on post 59689 with no replies yet | READ | 21.735 | 21.875 | 21.666 | **21.759** | `Seq Scan on comments` |
| **R14**: "Not following back": accounts following user 217 | READ | 2.306 | 2.469 | 2.342 | **2.372** | `Index Scan on follows` \| `Index Only Scan on follows` |
| **R15**: Data quality: creator accounts whose stored follower count is wrong | READ | 29.355 | 29.214 | 29.656 | **29.408** | `Seq Scan on follows` \| `Seq Scan on users` |
| **R16**: Places: posts tagged with location "goa" in June 2026 | READ | 4.674 | 4.629 | 4.564 | **4.622** | `Seq Scan on posts` |
| **R17**: Reels team: creators' reels longer than 60s in 2026 | READ | 8.911 | 8.588 | 8.757 | **8.752** | `Seq Scan on posts` \| `Index Scan on users, post_media` |
| **R18**: Content analytics: new posts per day and type in June 2026 | READ | 4.345 | 4.250 | 4.391 | **4.329** | `Seq Scan on posts` |
| **R19**: Verified-account report: last post time and total likes | READ | 5405.925 | 5434.809 | 5481.046 | **5440.593** | `Seq Scan on users` \| `Seq Scan on posts` \| `Seq Scan on likes` |
| **R20**: Content analytics: 10 most-commented posts of June 2026 | READ | 12.999 | 13.062 | 12.844 | **12.968** | `Seq Scan on comments` \| `Seq Scan on posts` |
| **R21**: Creator tools: ghost followers of user 217 | READ | 4.040 | 3.858 | 3.889 | **3.929** | `Index Scan on follows` \| `Index Only Scan on likes` |
| **R22**: Moderation console: hidden comments, page 61 | READ | 5.087 | 5.116 | 5.074 | **5.092** | `Seq Scan on comments` |
| **R23**: Like button state: has user 1042 liked post 59689? | READ | 0.026 | 0.022 | 0.027 | **0.025** | `Index Only Scan on likes (likes_pkey)` |
| **R24**: Story insights: total story views in last 30 days (top 20) | READ | 1.429 | 1.390 | 1.400 | **1.406** | `Seq Scan on stories` |
| **W01**: Publish a new photo post | WRITE | 0.381 | 0.416 | 0.338 | **0.378** | *(no scan, single INSERT)* |
| **W02**: Double-tap: user 1042 likes post 59689 | WRITE | 0.452 | 0.439 | 0.429 | **0.440** | *(no scan, single INSERT)* |
| **W03**: Keep counter in sync after like | WRITE | 0.109 | 0.089 | 0.085 | **0.094** | `Index Scan on posts (posts_pkey)` |
| **W04**: Nightly job: recompute every user's follower count | WRITE | 61.287 | 62.201 | 65.733 | **63.074** | `Seq Scan on users` \| `Seq Scan on follows` |
| **W05**: Housekeeping: delete stories expired before June 2026 | WRITE | 6.420 | 6.755 | 6.984 | **6.720** | `Seq Scan on stories` |
| **W06**: Private user accepts all pending follow requests | WRITE | 2.572 | 2.641 | 2.523 | **2.579** | `Index Scan on follows` |

---

## 3. Bottleneck Identification & Analysis

### 3.1 The Slowest Queries

1. **`R19` (~5,440.59 ms — 5.44 seconds):**
   - **Root Cause:** Performs an aggregation across all verified users joined against `posts` (60,000 rows) and `likes` (419,954 rows).
   - Because `likes(post_id)` and `posts(user_id)` lack secondary indexes, PostgreSQL executes full sequential table scans and builds immense in-memory Hash tables, checking over 420,000 tuples per run.
2. **`W04` (~63.07 ms):**
   - **Root Cause:** Nightly recount job updating the follower counts of all users by aggregating the entire `follows` table (258,588 rows). Sequential scan on `follows` without grouping index.
3. **`R15` (~29.41 ms):**
   - **Root Cause:** Data quality audit comparing stored `followers_count` against a live `COUNT(*)` from `follows`. Performs a full table scan across 30,000 users and 258,588 follow rows.
4. **`R13` (~21.76 ms):**
   - **Root Cause:** Unanswered comments tool using a `NOT EXISTS` anti-join over `comments` (150,000 rows). Lacking an index on `parent_comment_id`, every check scans the entire comment relation.

### 3.2 Tables with Excessive Sequential Scans

| Table Name | Row Count | Queries Performing `Seq Scan` | Problem Impact |
|:---|---:|---|---|
| **`posts`** | 60,000 | R01, R02, R05, R11, R12, R16, R17, R18, R19, R20 | Scanned on nearly every feed, profile, and analytics read query. |
| **`likes`** | 419,954 | R07, R19 | Largest table in database; unindexed lookups scan ~420k rows per query. |
| **`comments`** | 150,000 | R04, R13, R20, R22 | Nested comments and reply count calculations scan all 150k comments. |
| **`follows`** | 258,588 | R15, W04 | Reverse lookup (`followee_id`) forces full table scan because composite PK is `(follower_id, followee_id)`. |
| **`users`** | 30,000 | R06, R11, R15, R19, W04 | Filter on `account_type`, `is_verified`, and prefix text search scans 30k rows. |

---

## 4. Phase 4 Optimization Strategy (Index Targets)

Based on these baseline execution plans, the following indexes are targeted for Phase 4 to eliminate table scans and bring execution times under 1–5 ms:

1. **`CREATE INDEX idx_posts_user_created ON posts(user_id, created_at DESC) WHERE NOT is_archived;`**
   - *Target Queries:* R01, R02. Converts R01 and R02 from `Seq Scan` to blazing fast `Index Scan`.
2. **`CREATE INDEX idx_likes_post_id ON likes(post_id);`**
   - *Target Queries:* R07, R19. Allows instant lookup of likes per post instead of scanning 420k rows.
3. **`CREATE INDEX idx_comments_post_parent ON comments(post_id, parent_comment_id) WHERE NOT is_hidden;`**
   - *Target Queries:* R04, R13, R20. Provides direct access to top-level comments and replies.
4. **`CREATE INDEX idx_follows_followee ON follows(followee_id, status);`**
   - *Target Queries:* R01, R14, R15, W04. Solves the reverse followee lookup bottleneck.
5. **`CREATE INDEX idx_users_search ON users USING gin (username gin_trgm_ops, full_name gin_trgm_ops);`**
   - *Target Queries:* R06. Replaces the full 30,000 row regex search with trigram index scan.
