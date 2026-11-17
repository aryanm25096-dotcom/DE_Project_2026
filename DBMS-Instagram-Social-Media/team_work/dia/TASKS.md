# Task Worksheet: Dia Chowdhary (`diachowdhary`)

Welcome to the team! This worksheet contains your 3 assigned tasks for our TripSketch DBMS project. Everything is broken down step-by-step so you can complete each task smoothly in 1–2 hours.

---

## 📌 Ground Rules
1. **Your Workspace:** Work ONLY inside `team_work/dia/`. Never edit files in other folders.
2. **Git Branch:** Always work on your own branch: `dia/task-d1`, etc. (See `team_work/GIT_GUIDE.md`).
3. **Testing:** Test your SQL queries using `psql` or pgAdmin on our database before committing.

---

## Relevant Schema Reference (Tables You Will Use)

```sql
-- users table
users(user_id, name, email, created_at)

-- spots table
spots(spot_id, name, location_id, vibe_id, crowd_level_id, budget_per_day, rating, popularity, description, image_url, image_keyword)

-- favourites table (bookmarks)
favourites(user_id, spot_id, saved_at)

-- recently_viewed table
recently_viewed(user_id, spot_id, viewed_at)
```

---

## Task D1 (CP2): User Activity & Saved Favorites Queries
- **Goal:** Write 4 queries powering user profiles, bookmarked favorites, and browsing history.
- **Output File:** `team_work/dia/01_user_activity_queries.sql` (use the provided starter file!)
- **Due Date:** Wednesday, 18 Nov 2026, 6:00 PM
- **Estimated Time:** 1.5 hours

### What to write:
1. **Query D1.1:** Fetch all saved favorites for user `user_id = 1`, displaying spot name, area, budget per day, and the date it was saved (`saved_at`).
2. **Query D1.2:** Calculate how many times each spot has been saved into favorites, sorted by most saved descending (Spot popularity ranking).
3. **Query D1.3:** Boolean toggle check: check if a specific user (e.g. `user_id = 2`) has saved a given spot (e.g. `spot_id = 3`).
4. **Query D1.4:** Retrieve the 5 most recently viewed spots for `user_id = 1` ordered by `viewed_at DESC` (to power the "Recently Viewed" carousel).

### Worked Example for Query D1.1:
```sql
-- Example: Fetching user 1's favourites
SELECT u.name AS user_name, s.name AS spot_name, f.saved_at
FROM favourites f
JOIN users u ON f.user_id = u.user_id
JOIN spots s ON f.spot_id = s.spot_id
WHERE f.user_id = 1
ORDER BY f.saved_at DESC;
```

### Acceptance Criteria:
- All 4 queries execute with 0 errors.
- Output file committed with message: `[CP2][dia] add user activity and favorites queries`.

---

## Task D2 (CP3): Query Documentation & Use-Case Mapping Report
- **Goal:** Fill out the markdown table describing all core platform queries, their purpose in the UI, read vs write type, and target response time.
- **Output File:** `team_work/dia/02_query_descriptions.md`
- **Due Date:** Thursday, 19 Nov 2026, 4:00 PM
- **Estimated Time:** 1.5 hours

### What to write:
- Fill in the table in `02_query_descriptions.md` mapping our 12 application queries (Discovery, Favorites, Itineraries, Analytics) to their UI components in the React app (TripCard, Navbar, Dashboard, Itinerary Drawer).

### Acceptance Criteria:
- All query rows completed with descriptions and UI component mappings.
- Committed with message: `[CP3][dia] add query descriptions documentation`.

---

## Task D3 (CP4): North & Central India Offbeat Spots Expansion Seed Data
- **Goal:** Write `INSERT` statements to add 6 new offbeat spots in North and Central India to support our scale tests.
- **Output File:** `team_work/dia/03_more_spots_seed.sql`
- **Due Date:** Saturday, 21 Nov 2026, 6:00 PM
- **Estimated Time:** 2.0 hours

### Locations to Add:
1. **Kalpa** (Kinnaur, Himachal Pradesh) — Apple Orchards & Kinner Kailash / Nature (low crowd)
2. **Pangong Tso** (Leh, Ladakh) — High Altitude Blue Lake / Adventure (medium crowd)
3. **Orchha** (Niwari, Madhya Pradesh) — Cenotaphs & Betwa River / Culture (low crowd)
4. **Munsiyari** (Pithoragarh, Uttarakhand) — Panchachuli Peaks & Treks / Adventure (low crowd)
5. **Chanderi** (Ashoknagar, Madhya Pradesh) — Handloom Weavers & Forts / Culture (low crowd)
6. **Bhimbetka** (Raisen, Madhya Pradesh) — Paleolithic Rock Shelters / Culture (low crowd)

### Acceptance Criteria:
- Properly inserts states/locations if they do not exist, and inserts all 6 spots with correct Foreign Keys.
- Committed with message: `[CP4][dia] add 6 offbeat expansion spots for North and Central India`.
