-- =====================================================================
-- TripSketch: User Activity & Favorites Queries
-- Assigned to: Dia Chowdhary (diachowdhary)
-- Task: D1 (Checkpoint 2)
-- =====================================================================

-- Query D1.1: Fetch user 1's saved favorites with spot name, area, and budget
-- TODO: Complete the JOINs between favourites, spots, locations, and users
SELECT 
    u.name AS user_name,
    s.spot_id,
    s.name AS spot_name,
    l.area_name,
    s.budget_per_day,
    f.saved_at
FROM favourites f
JOIN users u ON f.user_id = u.user_id
JOIN spots s ON f.spot_id = s.spot_id
JOIN locations l ON s.location_id = l.location_id
WHERE f.user_id = 1
ORDER BY f.saved_at DESC;


-- Query D1.2: Top saved spots ranking across all users
-- TODO: Group by spot_id and name, and COUNT(*) the saves
SELECT 
    s.spot_id,
    s.name AS spot_name,
    COUNT(f.user_id) AS total_saves
FROM spots s
JOIN favourites f ON s.spot_id = f.spot_id
GROUP BY s.spot_id, s.name
ORDER BY total_saves DESC, s.name ASC;


-- Query D1.3: Check if a user has already favorited a spot (e.g. user 2, spot 3)
-- TODO: Return a boolean or 1/0 indicating if row exists
SELECT 
    CASE WHEN COUNT(*) > 0 THEN TRUE ELSE FALSE END AS is_saved
FROM favourites
WHERE user_id = 2 AND spot_id = 3;


-- Query D1.4: Recently viewed spots carousel (Top 5 most recent for user 1)
-- TODO: Query recently_viewed joined with spots, ordered by viewed_at DESC LIMIT 5
SELECT 
    s.spot_id,
    s.name AS spot_name,
    s.rating,
    s.budget_per_day,
    rv.viewed_at
FROM recently_viewed rv
JOIN spots s ON rv.spot_id = s.spot_id
WHERE rv.user_id = 1
ORDER BY rv.viewed_at DESC
LIMIT 5;
