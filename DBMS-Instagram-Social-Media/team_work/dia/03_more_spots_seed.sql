-- =====================================================================
-- TripSketch: Seed Data Expansion for North & Central India (6 Places)
-- Assigned to: Dia Chowdhary (diachowdhary)
-- Task: D3 (Checkpoint 4)
-- =====================================================================

-- Step 1: Ensure Locations exist
INSERT INTO locations (area_name, state_id) VALUES
('Kinnaur', (SELECT state_id FROM states WHERE name = 'Himachal Pradesh')),
('Leh', (SELECT state_id FROM states WHERE name = 'Ladakh')),
('Niwari', (SELECT state_id FROM states WHERE name = 'Madhya Pradesh')),
('Pithoragarh', (SELECT state_id FROM states WHERE name = 'Uttarakhand')),
('Ashoknagar', (SELECT state_id FROM states WHERE name = 'Madhya Pradesh')),
('Raisen', (SELECT state_id FROM states WHERE name = 'Madhya Pradesh'))
ON CONFLICT (area_name, state_id) DO NOTHING;

-- Step 2: Insert 6 New Spots
INSERT INTO spots (name, location_id, vibe_id, crowd_level_id, budget_per_day, rating, popularity, description, image_keyword) VALUES
(
    'Kalpa Apple Orchards',
    (SELECT location_id FROM locations WHERE area_name = 'Kinnaur' LIMIT 1),
    (SELECT vibe_id FROM vibes WHERE name = 'nature'),
    (SELECT crowd_level_id FROM crowd_levels WHERE name = 'low'),
    2100.00, 4.80, 80,
    'Serene Himalayan hamlet in Kinnaur overlooking the sacred Kinner Kailash peak, famous for apple groves and traditional wooden temples.',
    'kalpa'
),
(
    'Pangong Tso Wilderness',
    (SELECT location_id FROM locations WHERE area_name = 'Leh' LIMIT 1),
    (SELECT vibe_id FROM vibes WHERE name = 'adventure'),
    (SELECT crowd_level_id FROM crowd_levels WHERE name = 'medium'),
    3600.00, 4.90, 93,
    'Endorheic saltwater lake at 14,270 feet extending into Tibet, renowned for shifting colors from azure to cobalt blue.',
    'pangong_tso'
),
(
    'Orchha Royal Cenotaphs',
    (SELECT location_id FROM locations WHERE area_name = 'Niwari' LIMIT 1),
    (SELECT vibe_id FROM vibes WHERE name = 'culture'),
    (SELECT crowd_level_id FROM crowd_levels WHERE name = 'low'),
    1700.00, 4.70, 78,
    'Medieval Bundela dynasty chhatris and fort palaces standing gracefully along the boulders of the Betwa river.',
    'orchha'
),
(
    'Munsiyari Himalayan Gateway',
    (SELECT location_id FROM locations WHERE area_name = 'Pithoragarh' LIMIT 1),
    (SELECT vibe_id FROM vibes WHERE name = 'adventure'),
    (SELECT crowd_level_id FROM crowd_levels WHERE name = 'low'),
    2300.00, 4.85, 82,
    'Basecamp for high-altitude Milam and Ralam glacier treks, framed directly by the dramatic Panchachuli mountain range.',
    'munsiyari'
),
(
    'Chanderi Weaver Town',
    (SELECT location_id FROM locations WHERE area_name = 'Ashoknagar' LIMIT 1),
    (SELECT vibe_id FROM vibes WHERE name = 'culture'),
    (SELECT crowd_level_id FROM crowd_levels WHERE name = 'low'),
    1500.00, 4.60, 75,
    'Historic fortress city internationally known for traditional gossamer silk and zari weaving, Jain temples, and medieval mosques.',
    'chanderi'
),
(
    'Bhimbetka Cave Shelters',
    (SELECT location_id FROM locations WHERE area_name = 'Raisen' LIMIT 1),
    (SELECT vibe_id FROM vibes WHERE name = 'culture'),
    (SELECT crowd_level_id FROM crowd_levels WHERE name = 'low'),
    1400.00, 4.75, 79,
    'UNESCO World Heritage site preserving 30,000-year-old prehistoric rock art depictions of human and animal life.',
    'bhimbetka'
);
