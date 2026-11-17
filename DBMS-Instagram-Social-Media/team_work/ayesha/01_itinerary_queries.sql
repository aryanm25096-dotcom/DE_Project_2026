-- =====================================================================
-- TripSketch: Itinerary Scheduling & Cost Calculation Queries
-- Assigned to: Ayesha Khan (ayesha-khan27)
-- Task: A1 (Checkpoint 2)
-- =====================================================================

-- Query A1.1: Fetch full day-by-day itinerary schedule for itinerary 1
-- TODO: Join itineraries, users, itinerary_items, and spots, ordering by day and position
SELECT 
    i.itinerary_id,
    i.title AS itinerary_title,
    u.name AS traveler_name,
    ii.day_number,
    ii.position,
    s.name AS spot_name,
    s.budget_per_day
FROM itineraries i
JOIN users u ON i.user_id = u.user_id
JOIN itinerary_items ii ON i.itinerary_id = ii.itinerary_id
JOIN spots s ON ii.spot_id = s.spot_id
WHERE i.itinerary_id = 1
ORDER BY ii.day_number ASC, ii.position ASC;


-- Query A1.2: Dynamic total budget and spot count calculation per itinerary
-- TODO: Use SUM(s.budget_per_day) and COUNT(ii.item_id) grouped by itinerary_id
SELECT 
    i.itinerary_id,
    i.title,
    u.name AS traveler_name,
    COUNT(ii.item_id) AS total_spots,
    SUM(s.budget_per_day) AS total_estimated_budget
FROM itineraries i
JOIN users u ON i.user_id = u.user_id
JOIN itinerary_items ii ON i.itinerary_id = ii.itinerary_id
JOIN spots s ON ii.spot_id = s.spot_id
GROUP BY i.itinerary_id, i.title, u.name
ORDER BY total_estimated_budget DESC;


-- Query A1.3: Day-wise subtotal calculation for itinerary 1
-- TODO: Group by day_number and SUM(s.budget_per_day)
SELECT 
    ii.day_number,
    COUNT(ii.item_id) AS spots_on_day,
    SUM(s.budget_per_day) AS daily_subtotal_inr
FROM itinerary_items ii
JOIN spots s ON ii.spot_id = s.spot_id
WHERE ii.itinerary_id = 1
GROUP BY ii.day_number
ORDER BY ii.day_number ASC;


-- Query A1.4: Update visit position of a spot inside an itinerary
-- TODO: Shift item position safely
UPDATE itinerary_items
SET position = 2
WHERE itinerary_id = 1 AND day_number = 1 AND spot_id = 17;
