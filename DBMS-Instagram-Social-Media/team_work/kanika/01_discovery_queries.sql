-- =====================================================================
-- TripSketch: Discovery & Search Queries
-- Assigned to: Kanika Prajapati (kanikaa30)
-- Task: K1 (Checkpoint 2)
-- =====================================================================

-- Query K1.1: Fetch spots by vibe (e.g. 'nature') sorted by rating DESC
-- TODO: Complete the SELECT statement below
SELECT 
    s.spot_id,
    s.name AS spot_name,
    l.area_name,
    st.name AS state_name,
    s.budget_per_day,
    s.rating
FROM spots s
JOIN vibes v ON s.vibe_id = v.vibe_id
JOIN locations l ON s.location_id = l.location_id
JOIN states st ON l.state_id = st.state_id
WHERE v.name = 'nature'
ORDER BY s.rating DESC;


-- Query K1.2: Filter spots with budget <= 2500 INR and crowd level = 'low'
-- TODO: Write a query selecting spot_id, name, budget_per_day, and crowd level name
SELECT 
    s.spot_id,
    s.name AS spot_name,
    s.budget_per_day,
    cl.name AS crowd_level,
    v.name AS vibe
FROM spots s
JOIN crowd_levels cl ON s.crowd_level_id = cl.crowd_level_id
JOIN vibes v ON s.vibe_id = v.vibe_id
WHERE s.budget_per_day <= 2500 AND cl.name = 'low'
ORDER BY s.budget_per_day ASC;


-- Query K1.3: Search bar - search for spots containing keyword 'Valley' (case-insensitive)
-- TODO: Fill in the WHERE clause using ILIKE
SELECT 
    s.spot_id,
    s.name AS spot_name,
    l.area_name,
    s.rating,
    s.description
FROM spots s
JOIN locations l ON s.location_id = l.location_id
WHERE s.name ILIKE '%Valley%'
ORDER BY s.popularity DESC;


-- Query K1.4: Get all tags associated with a specific spot (e.g. spot_id = 1)
-- TODO: Complete the JOINs between spots, spot_tags, and tags
SELECT 
    s.name AS spot_name,
    t.name AS tag_name
FROM spots s
JOIN spot_tags st ON s.spot_id = st.spot_id
JOIN tags t ON st.tag_id = t.tag_id
WHERE s.spot_id = 1;
