# Task Worksheet: Ayesha Khan (`ayesha-khan27`)

Welcome to the team! This worksheet contains your 3 assigned tasks for our TripSketch DBMS project. Everything is broken down step-by-step so you can complete each task smoothly in 1–2 hours.

---

## 📌 Ground Rules
1. **Your Workspace:** Work ONLY inside `team_work/ayesha/`. Never edit files in other folders.
2. **Git Branch:** Always work on your own branch: `ayesha/task-a1`, etc. (See `team_work/GIT_GUIDE.md`).
3. **Testing:** Test your SQL queries using `psql` or pgAdmin on our database before committing.

---

## Relevant Schema Reference (Tables You Will Use)

```sql
-- itineraries table
itineraries(itinerary_id, user_id, title, created_at)

-- itinerary_items table
itinerary_items(item_id, itinerary_id, spot_id, day_number, position)

-- spots table
spots(spot_id, name, location_id, vibe_id, crowd_level_id, budget_per_day, rating, popularity, description, image_url, image_keyword)

-- users and vibes
users(user_id, name, email, created_at)
vibes(vibe_id, name)
```

---

## Task A1 (CP2): Itinerary Scheduling & Budget Calculation Queries
- **Goal:** Write 4 queries that power the multi-day trip planner and dynamic budget calculation.
- **Output File:** `team_work/ayesha/01_itinerary_queries.sql` (use the provided starter file!)
- **Due Date:** Wednesday, 18 Nov 2026, 6:00 PM
- **Estimated Time:** 1.5 hours

### What to write:
1. **Query A1.1:** Fetch full itinerary schedule for `itinerary_id = 1`: user name, itinerary title, spot name, day number, and intra-day position, ordered by `day_number ASC, position ASC`.
2. **Query A1.2:** Dynamic total cost calculation: calculate the total estimated budget and total number of spots for every itinerary using SQL `SUM(s.budget_per_day)` and `COUNT(ii.item_id)`.
3. **Query A1.3:** Day-wise summary: for `itinerary_id = 1`, compute the daily subtotal expenditure per `day_number`.
4. **Query A1.4:** Reorder / shift position: write a clean `UPDATE` statement that updates the visit position of a spot inside an itinerary.

### Worked Example for Query A1.2:
```sql
-- Example: Dynamic Itinerary Budget Calculation
SELECT 
    i.itinerary_id,
    i.title,
    u.name AS traveler_name,
    COUNT(ii.item_id) AS total_spots,
    SUM(s.budget_per_day) AS total_budget_inr
FROM itineraries i
JOIN users u ON i.user_id = u.user_id
JOIN itinerary_items ii ON i.itinerary_id = ii.itinerary_id
JOIN spots s ON ii.spot_id = s.spot_id
GROUP BY i.itinerary_id, i.title, u.name;
```

### Acceptance Criteria:
- All 4 queries execute with 0 errors.
- Output file committed with message: `[CP2][ayesha] add itinerary scheduling queries`.

---

## Task A2 (CP3): Travel Insights & Aggregation Analytical Queries
- **Goal:** Write 3 analytical queries providing travel trends and aggregations across our destination database.
- **Output File:** `team_work/ayesha/02_analytics_queries.sql`
- **Due Date:** Thursday, 19 Nov 2026, 4:00 PM
- **Estimated Time:** 1.5 hours

### What to write:
1. **Query A2.1:** Average budget by vibe: calculate the average daily budget (`AVG(budget_per_day)`) rounded to 2 decimal places and spot count for each travel vibe (`nature`, `adventure`, `food`, `culture`).
2. **Query A2.2:** Geographic distribution: find the top 5 states with the highest number of registered spots.
3. **Query A2.3:** High-value recommendations: find all spots with rating $\ge 4.7$ and budget $\le 2000$ INR/day (high rating, low budget gems).

### Acceptance Criteria:
- Queries execute without error and return clean aggregation tables.
- Committed with message: `[CP3][ayesha] add travel analytics queries`.

---

## Task A3 (CP4): Northeast & Himalayan Offbeat Spots Expansion Seed Data
- **Goal:** Write `INSERT` statements to add 6 new offbeat spots in Northeast and Himalayan India to support our scale tests.
- **Output File:** `team_work/ayesha/03_more_spots_seed.sql`
- **Due Date:** Saturday, 21 Nov 2026, 6:00 PM
- **Estimated Time:** 2.0 hours

### Locations to Add:
1. **Yuksom** (Gyalshing, Sikkim) — First Capital of Sikkim & Kanchenjunga Base / Culture (low crowd)
2. **Anini** (Dibang Valley, Arunachal Pradesh) — Untouched Cloud Valleys / Nature (low crowd)
3. **Gurez Valley** (Bandipora, Jammu and Kashmir) — Kishanganga River & Habba Khatoon Peak / Nature (low crowd)
4. **Ziro Valley** (Lower Subansiri, Arunachal Pradesh) — Apatani Pine Groves & Rice Fields / Culture (medium crowd)
5. **Shoja** (Seraj, Himachal Pradesh) — Jalori Pass & Serolsar Lake / Nature (low crowd)
6. **Mokokchung** (Mokokchung, Nagaland) — Ao Naga Cultural Capital & Hills / Culture (low crowd)

### Acceptance Criteria:
- Properly inserts states/locations if they do not exist, and inserts all 6 spots with correct Foreign Keys.
- Committed with message: `[CP4][ayesha] add 6 offbeat expansion spots for Northeast and Himalayan India`.
