-- =====================================================================
-- Instagram DBMS Project: Checkpoint 3 (Indexing Strategy)
-- File: sql/05_indexes.sql
-- Description: Targeted indexes designed to eliminate sequential scans,
--              support selective filters, covering index-only scans,
--              and optimize the 30 workload queries.
-- =====================================================================

SET search_path TO instagram, public;

-- ---------------------------------------------------------------------
-- 1. Trigram extension for text search
-- ---------------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- ---------------------------------------------------------------------
-- 2. Indexes for Home Feed, Profile Grid & Posts (R01, R02, R05, R11, R12, R16, R17, R18, R19, R20)
-- ---------------------------------------------------------------------

-- Serves R01 & R02: Composite index on (user_id, created_at DESC) for active posts.
-- Eliminates Seq Scan on 60k posts and avoids an explicit sort node.
CREATE INDEX IF NOT EXISTS idx_posts_user_created 
ON posts (user_id, created_at DESC) 
WHERE NOT is_archived;

-- Serves R05, R12, R16, R18, R20: Composite B-tree for time-filtered queries.
-- Allows fast index range scans on post creation time with like_count for sorting.
CREATE INDEX IF NOT EXISTS idx_posts_created_likes 
ON posts (created_at, like_count DESC) 
INCLUDE (post_id, user_id);

-- Serves R16: GIN trigram index on location_name for fast ILIKE '%goa%' lookups.
CREATE INDEX IF NOT EXISTS idx_posts_location_trgm 
ON posts USING gin (location_name gin_trgm_ops) 
WHERE location_name IS NOT NULL;

-- Serves R17: Partial index for 2026 Reels to enable index-only scanning.
CREATE INDEX IF NOT EXISTS idx_posts_reels_2026 
ON posts (created_at, user_id, like_count DESC) 
WHERE post_type = 'REEL';

-- ---------------------------------------------------------------------
-- 3. Indexes for Follows & Social Graph (R01, R07, R08, R09, R10, R14, R15, R21, W04, W06)
-- ---------------------------------------------------------------------

-- Serves R01, R08, R10: Composite covering index for accepted follows by follower.
-- Enables Index Only Scan when fetching a user's followees.
CREATE INDEX IF NOT EXISTS idx_follows_follower_status 
ON follows (follower_id, followee_id) 
WHERE status = 'ACCEPTED';

-- Serves R07, R14, R15, R21, W04: Reverse lookup by followee_id for accepted followers.
-- Crucial for counting followers and checking inbound connections.
CREATE INDEX IF NOT EXISTS idx_follows_followee_accepted 
ON follows (followee_id, follower_id) 
WHERE status = 'ACCEPTED';

-- Serves R09 & W06: Partial index for pending follow requests.
-- Keeps index small and makes pending request retrieval and batch updates sub-millisecond.
CREATE INDEX IF NOT EXISTS idx_follows_pending 
ON follows (followee_id, created_at DESC) 
INCLUDE (follower_id) 
WHERE status = 'PENDING';

-- ---------------------------------------------------------------------
-- 4. Indexes for Likes & Engagement (R07, R19, R21, R23)
-- ---------------------------------------------------------------------

-- Serves R07 & R19: Index on likes by post_id.
-- Resolves likes per post instantly without scanning 420k rows.
CREATE INDEX IF NOT EXISTS idx_likes_post_id 
ON likes (post_id, created_at DESC) 
INCLUDE (user_id);

-- Serves R21: Reverse index on likes by user_id to identify ghost followers.
CREATE INDEX IF NOT EXISTS idx_likes_user_post 
ON likes (user_id, post_id);

-- ---------------------------------------------------------------------
-- 5. Indexes for Comments & Moderation (R04, R13, R20, R22)
-- ---------------------------------------------------------------------

-- Serves R04 & R13: Composite index on post_id and parent_comment_id.
-- Allows fast lookup of top-level comments and child replies per post.
CREATE INDEX IF NOT EXISTS idx_comments_post_parent 
ON comments (post_id, parent_comment_id, created_at) 
WHERE NOT is_hidden;

-- Serves R04 & R13: Index on parent_comment_id to accelerate join and anti-join for replies.
CREATE INDEX IF NOT EXISTS idx_comments_parent 
ON comments (parent_comment_id) 
WHERE parent_comment_id IS NOT NULL;

-- Serves R20: Direct post comment counting.
CREATE INDEX IF NOT EXISTS idx_comments_post_id 
ON comments (post_id);

-- Serves R22: Partial B-tree index on hidden comments sorted by created_at DESC.
-- Makes paginating moderation comments instantaneous.
CREATE INDEX IF NOT EXISTS idx_comments_hidden_created 
ON comments (created_at DESC) 
INCLUDE (comment_id, post_id, user_id, body) 
WHERE is_hidden;

-- ---------------------------------------------------------------------
-- 6. Indexes for Hashtags & Media (R05, R12, R17)
-- ---------------------------------------------------------------------

-- Serves R05 & R12: Reverse composite index on post_hashtags.
CREATE INDEX IF NOT EXISTS idx_post_hashtags_hash_post 
ON post_hashtags (hashtag_id, post_id);

-- Serves R17: Covering index on primary post media duration.
CREATE INDEX IF NOT EXISTS idx_post_media_first_duration 
ON post_media (post_id, duration_sec) 
WHERE position = 1;

-- ---------------------------------------------------------------------
-- 7. Indexes for Users & Search (R06, R11, R15, R19)
-- ---------------------------------------------------------------------

-- Serves R06: GIN trigram indexes for fast prefix and substring search on names.
CREATE INDEX IF NOT EXISTS idx_users_username_trgm 
ON users USING gin (username gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_users_fullname_trgm 
ON users USING gin (full_name gin_trgm_ops);

-- Serves R11 & R15: Partial index on creators and verified accounts.
CREATE INDEX IF NOT EXISTS idx_users_creators 
ON users (user_id, followers_count) 
WHERE account_type = 'CREATOR';

CREATE INDEX IF NOT EXISTS idx_users_verified 
ON users (user_id, username) 
WHERE is_verified;

-- ---------------------------------------------------------------------
-- 8. Indexes for Stories (R10, R24, W05)
-- ---------------------------------------------------------------------

-- Serves R10 & R24: Fast time-range lookups on stories.
CREATE INDEX IF NOT EXISTS idx_stories_user_created 
ON stories (user_id, created_at DESC) 
INCLUDE (story_id, media_type, view_count);

CREATE INDEX IF NOT EXISTS idx_stories_created_views 
ON stories (created_at, user_id, view_count);

-- Serves W05: Fast deletion of expired stories.
CREATE INDEX IF NOT EXISTS idx_stories_expires_at 
ON stories (expires_at);
