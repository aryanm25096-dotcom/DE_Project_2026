-- =====================================================================
-- TripSketch: Analytical & Trend Aggregation Queries
-- Assigned to: Ayesha Khan (ayesha-khan27)
-- Task: A2 (Checkpoint 3)
-- =====================================================================

-- Query A2.1: Average daily budget per travel vibe category
-- TODO: Group by vibe name and calculate ROUND(AVG(budget_per_day), 2)
SELECT 
    v.name AS vibe_name,
    COUNT(s.spot_id) AS total_spots,
    ROUND(AVG(s.budget_per_day), 2) AS avg_daily_budget_inr,
    MIN(s.budget_per_day) AS min_budget_inr,
    MAX(s.budget_per_day) AS max_budget_inr
FROM vibes v
JOIN spots s ON v.vibe_id = s.vibe_id
GROUP BY v.name
ORDER BY avg_daily_budget_inr ASC;


-- Query A2.2: Geographic distribution (States with highest spot concentration)
-- TODO: Join spots -> locations -> states and group by state name
SELECT 
    st.name AS state_name,
    COUNT(s.spot_id) AS total_spots,
    ROUND(AVG(s.rating), 2) AS avg_state_rating
FROM states st
JOIN locations l ON st.state_id = l.state_id
JOIN spots s ON l.location_id = s.location_id
GROUP BY st.name
ORDER BY total_spots DESC, avg_state_rating DESC
LIMIT 5;


-- Query A2.3: High-value budget gems (Rating >= 4.70 and Budget <= 2000 INR)
-- TODO: Filter spots meeting high rating and low budget criteria
SELECT 
    s.spot_id,
    s.name AS spot_name,
    l.area_name,
    st.name AS state_name,
    s.rating,
    s.budget_per_day,
    v.name AS vibe
FROM spots s
JOIN locations l ON s.location_id = l.location_id
JOIN states st ON l.state_id = st.state_id
JOIN vibes v ON s.vibe_id = v.vibe_id
WHERE s.rating >= 4.70 AND s.budget_per_day <= 2000.00
ORDER BY s.rating DESC, s.budget_per_day ASC;
