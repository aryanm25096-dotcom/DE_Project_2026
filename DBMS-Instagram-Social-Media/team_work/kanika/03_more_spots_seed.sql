-- =====================================================================
-- TripSketch: Seed Data Expansion for South & West India (6 Places)
-- Assigned to: Kanika Prajapati (kanikaa30)
-- Task: K3 (Checkpoint 4)
-- =====================================================================

-- Step 1: Ensure new States exist (Maharashtra if not present)
INSERT INTO states (name) VALUES ('Maharashtra') ON CONFLICT (name) DO NOTHING;

-- Step 2: Ensure new Locations exist
-- TODO: Insert corresponding area_name with state_id
INSERT INTO locations (area_name, state_id) VALUES
('Shimoga', (SELECT state_id FROM states WHERE name = 'Karnataka')),
('Coimbatore', (SELECT state_id FROM states WHERE name = 'Tamil Nadu')),
('Chikkamagaluru', (SELECT state_id FROM states WHERE name = 'Karnataka')),
('Sindhudurg', (SELECT state_id FROM states WHERE name = 'Maharashtra')),
('Kutch', (SELECT state_id FROM states WHERE name = 'Gujarat')),
('North Goa', (SELECT state_id FROM states WHERE name = 'Goa'))
ON CONFLICT (area_name, state_id) DO NOTHING;

-- Step 3: Insert 6 New Spots
-- TODO: Fill in description, rating, budget, and image fields
INSERT INTO spots (name, location_id, vibe_id, crowd_level_id, budget_per_day, rating, popularity, description, image_keyword) VALUES
(
    'Agumbe Rainforest',
    (SELECT location_id FROM locations WHERE area_name = 'Shimoga' LIMIT 1),
    (SELECT vibe_id FROM vibes WHERE name = 'nature'),
    (SELECT crowd_level_id FROM crowd_levels WHERE name = 'low'),
    1800.00, 4.80, 83,
    'Known as the Cherrapunji of the South, dense tropical Western Ghats rainforest with King Cobra sanctuaries and waterfalls.',
    'agumbe'
),
(
    'Pollachi Countryside',
    (SELECT location_id FROM locations WHERE area_name = 'Coimbatore' LIMIT 1),
    (SELECT vibe_id FROM vibes WHERE name = 'culture'),
    (SELECT crowd_level_id FROM crowd_levels WHERE name = 'low'),
    1600.00, 4.60, 77,
    'Lush agricultural plains dotted with coconut plantations, jaggery mills, and heritage village trails.',
    'pollachi'
),
(
    'Kudremukh Peak',
    (SELECT location_id FROM locations WHERE area_name = 'Chikkamagaluru' LIMIT 1),
    (SELECT vibe_id FROM vibes WHERE name = 'adventure'),
    (SELECT crowd_level_id FROM crowd_levels WHERE name = 'low'),
    2200.00, 4.90, 89,
    'Distinct horse-face shaped mountain peak featuring emerald grasslands and mist-covered trekking trails.',
    'kudremukh'
),
(
    'Tarkarli Scuba Bay',
    (SELECT location_id FROM locations WHERE area_name = 'Sindhudurg' LIMIT 1),
    (SELECT vibe_id FROM vibes WHERE name = 'adventure'),
    (SELECT crowd_level_id FROM crowd_levels WHERE name = 'medium'),
    2800.00, 4.70, 84,
    'Pristine Konkan coastline celebrated for transparent waters, snorkeling reefs, and Malvani seafood shacks.',
    'tarkarli'
),
(
    'Dholavira Harappan Metropolis',
    (SELECT location_id FROM locations WHERE area_name = 'Kutch' LIMIT 1),
    (SELECT vibe_id FROM vibes WHERE name = 'culture'),
    (SELECT crowd_level_id FROM crowd_levels WHERE name = 'low'),
    1900.00, 4.85, 81,
    'UNESCO World Heritage Indus Valley site situated in the Rann of Kutch featuring grand water reservoirs and stone structures.',
    'dholavira'
),
(
    'Fontainhas Latin Quarter',
    (SELECT location_id FROM locations WHERE area_name = 'North Goa' LIMIT 1),
    (SELECT vibe_id FROM vibes WHERE name = 'food'),
    (SELECT crowd_level_id FROM crowd_levels WHERE name = 'medium'),
    2600.00, 4.75, 91,
    'Old heritage neighborhood with pastel Portuguese mansions, traditional bakeries, and quaint street cafes.',
    'fontainhas'
);
