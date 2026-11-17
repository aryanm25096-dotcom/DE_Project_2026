-- =====================================================================
-- TripSketch: Schema Integrity & Constraint Validation Queries
-- Assigned to: Kanika Prajapati (kanikaa30)
-- Task: K2 (Checkpoint 3)
-- =====================================================================

-- Query K2.1: Check for any invalid ratings or negative budgets (Expected: 0 rows)
-- TODO: Verify rating boundaries and budget constraints
SELECT spot_id, name, rating, budget_per_day
FROM spots
WHERE rating < 0.0 OR rating > 5.0 OR budget_per_day < 0;


-- Query K2.2: Find spots that have ZERO tags assigned (Orphan spots)
-- TODO: Use LEFT JOIN with spot_tags and find WHERE st.tag_id IS NULL
SELECT s.spot_id, s.name AS spot_name
FROM spots s
LEFT JOIN spot_tags st ON s.spot_id = st.spot_id
WHERE st.tag_id IS NULL;


-- Query K2.3: Verification of geographic hierarchy (Locations count per State)
-- TODO: Group by state name and count how many registered locations exist
SELECT 
    st.name AS state_name,
    COUNT(l.location_id) AS total_locations
FROM states st
LEFT JOIN locations l ON st.state_id = l.state_id
GROUP BY st.name
ORDER BY total_locations DESC;
