-- =====================================================================
-- TripSketch: Seed Data Expansion for Northeast & Himalayas (6 Places)
-- Assigned to: Ayesha Khan (ayesha-khan27)
-- Task: A3 (Checkpoint 4)
-- =====================================================================

-- Step 1: Ensure new States exist (Sikkim and Jammu and Kashmir)
INSERT INTO states (name) VALUES 
('Sikkim'),
('Jammu and Kashmir')
ON CONFLICT (name) DO NOTHING;

-- Step 2: Ensure Locations exist
INSERT INTO locations (area_name, state_id) VALUES
('Gyalshing', (SELECT state_id FROM states WHERE name = 'Sikkim')),
('Dibang Valley', (SELECT state_id FROM states WHERE name = 'Arunachal Pradesh')),
('Bandipora', (SELECT state_id FROM states WHERE name = 'Jammu and Kashmir')),
('Lower Subansiri', (SELECT state_id FROM states WHERE name = 'Arunachal Pradesh')),
('Seraj', (SELECT state_id FROM states WHERE name = 'Himachal Pradesh')),
('Mokokchung Area', (SELECT state_id FROM states WHERE name = 'Nagaland'))
ON CONFLICT (area_name, state_id) DO NOTHING;

-- Step 3: Insert 6 New Spots
INSERT INTO spots (name, location_id, vibe_id, crowd_level_id, budget_per_day, rating, popularity, description, image_keyword) VALUES
(
    'Yuksom Historic Hamlet',
    (SELECT location_id FROM locations WHERE area_name = 'Gyalshing' LIMIT 1),
    (SELECT vibe_id FROM vibes WHERE name = 'culture'),
    (SELECT crowd_level_id FROM crowd_levels WHERE name = 'low'),
    2000.00, 4.80, 81,
    'Coronation site of the first Chogyal monarch in 1642, surrounded by sacred mountain lakes and serving as the trailhead for Dzongri.',
    'yuksom'
),
(
    'Anini Cloud Plateau',
    (SELECT location_id FROM locations WHERE area_name = 'Dibang Valley' LIMIT 1),
    (SELECT vibe_id FROM vibes WHERE name = 'nature'),
    (SELECT crowd_level_id FROM crowd_levels WHERE name = 'low'),
    2700.00, 4.90, 72,
    'Remote frontier town where clouds descend directly into the Dibang river basin, bordered by Idu Mishmi tribal settlements.',
    'anini'
),
(
    'Gurez Border Valley',
    (SELECT location_id FROM locations WHERE area_name = 'Bandipora' LIMIT 1),
    (SELECT vibe_id FROM vibes WHERE name = 'nature'),
    (SELECT crowd_level_id FROM crowd_levels WHERE name = 'low'),
    2500.00, 4.85, 78,
    'Pristine valley along the ancient Silk Route framed by the pyramidal Habba Khatoon peak and the sparkling Kishanganga river.',
    'gurez_valley'
),
(
    'Ziro Valley Pine Groves',
    (SELECT location_id FROM locations WHERE area_name = 'Lower Subansiri' LIMIT 1),
    (SELECT vibe_id FROM vibes WHERE name = 'culture'),
    (SELECT crowd_level_id FROM crowd_levels WHERE name = 'medium'),
    2200.00, 4.80, 90,
    'UNESCO tentative heritage plateau renowned for unique Apatani wet-rice cultivation, fish farming, and bamboo groves.',
    'ziro_valley'
),
(
    'Shoja Mountain Retreat',
    (SELECT location_id FROM locations WHERE area_name = 'Seraj' LIMIT 1),
    (SELECT vibe_id FROM vibes WHERE name = 'nature'),
    (SELECT crowd_level_id FROM crowd_levels WHERE name = 'low'),
    2100.00, 4.75, 80,
    'Quiet deodar-clad hamlet in the Seraj valley below Jalori Pass, offering birdwatching trails to pristine Serolsar Lake.',
    'shoja'
),
(
    'Mokokchung Cultural Hills',
    (SELECT location_id FROM locations WHERE area_name = 'Mokokchung Area' LIMIT 1),
    (SELECT vibe_id FROM vibes WHERE name = 'culture'),
    (SELECT crowd_level_id FROM crowd_levels WHERE name = 'low'),
    1800.00, 4.70, 74,
    'Cultural nerve-center of the Ao Naga tribe famous for traditional festivals, step agriculture, and scenic hill panoramas.',
    'mokokchung'
);
