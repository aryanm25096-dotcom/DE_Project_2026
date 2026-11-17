# Task Worksheet: Kanika Prajapati (`kanikaa30`)

Welcome to the team! This worksheet contains your 3 assigned tasks for our TripSketch DBMS project. Everything is broken down step-by-step so you can complete each task smoothly in 1–2 hours.

---

## 📌 Ground Rules
1. **Your Workspace:** Work ONLY inside `team_work/kanika/`. Never edit files in other folders.
2. **Git Branch:** Always work on your own branch: `kanika/task-k1`, etc. (See `team_work/GIT_GUIDE.md`).
3. **Testing:** Test your SQL scripts using `psql` or pgAdmin on our database before committing.

---

## Relevant Schema Reference (Tables You Will Use)

```sql
-- spots table
spots(spot_id, name, location_id, vibe_id, crowd_level_id, budget_per_day, rating, popularity, description, image_url, image_keyword)

-- locations and states
locations(location_id, area_name, state_id)
states(state_id, name)

-- vibes and crowd_levels
vibes(vibe_id, name)  -- names: 'nature', 'adventure', 'food', 'culture'
crowd_levels(crowd_level_id, name) -- names: 'low', 'medium', 'high'

-- tags and spot_tags
tags(tag_id, name)
spot_tags(spot_id, tag_id)
```

---

## Task K1 (CP2): Spot Discovery & Faceted Filter Queries
- **Goal:** Write 4 standard read queries that power TripSketch's spot discovery and search bar.
- **Output File:** `team_work/kanika/01_discovery_queries.sql` (use the provided starter file!)
- **Due Date:** Wednesday, 18 Nov 2026, 6:00 PM
- **Estimated Time:** 1.5 hours

### What to write:
1. **Query K1.1:** Fetch all spots belonging to a specific vibe (e.g. `'nature'`), showing `spot_id`, `name`, `area_name`, `budget_per_day`, and `rating`, ordered by rating descending.
2. **Query K1.2:** Fetch all budget-friendly spots with `budget_per_day <= 2500` and crowd level `'low'`, showing `spot_id`, `name`, `budget_per_day`, and `vibe`.
3. **Query K1.3:** Search bar query: Find spots whose name contains a search keyword (e.g. `'Valley'`) using case-insensitive `ILIKE`, showing spot name and state.
4. **Query K1.4:** Retrieve all tags associated with a specific spot (e.g. `spot_id = 1`) by joining `spots`, `spot_tags`, and `tags`.

### Worked Example for Query K1.1:
```sql
-- Example: Fetching spots with vibe 'adventure'
SELECT s.spot_id, s.name AS spot_name, l.area_name, s.budget_per_day, s.rating
FROM spots s
JOIN vibes v ON s.vibe_id = v.vibe_id
JOIN locations l ON s.location_id = l.location_id
WHERE v.name = 'adventure'
ORDER BY s.rating DESC;
```

### Acceptance Criteria:
- All 4 queries run cleanly without syntax errors.
- Every query uses standard `JOIN` syntax (no comma-separated joins).
- Output file is committed with message: `[CP2][kanika] add discovery queries`.

---

## Task K2 (CP3): Schema Integrity & Constraint Validation Queries
- **Goal:** Write 3 verification queries to ensure the database data adheres to our integrity rules.
- **Output File:** `team_work/kanika/02_data_validation.sql`
- **Due Date:** Thursday, 19 Nov 2026, 4:00 PM
- **Estimated Time:** 1.5 hours

### What to write:
1. **Query K2.1:** Check for any invalid ratings outside the range $[0.0, 5.0]$ or negative budgets (`budget_per_day < 0`). (Expected output: 0 rows).
2. **Query K2.2:** Verify that all `spots` have at least one tag assigned in `spot_tags` (find any orphan spots with zero tags).
3. **Query K2.3:** Verify geographic consistency: confirm every location references a valid state and return a count of locations per state.

### Acceptance Criteria:
- Queries execute without error and return clean validation results.
- Committed with message: `[CP3][kanika] add data validation queries`.

---

## Task K3 (CP4): West & South India Offbeat Spots Expansion Seed Data
- **Goal:** Write `INSERT` statements to add 6 new offbeat spots in South and Western India to support our scale tests.
- **Output File:** `team_work/kanika/03_more_spots_seed.sql`
- **Due Date:** Saturday, 21 Nov 2026, 6:00 PM
- **Estimated Time:** 2.0 hours

### Locations to Add:
1. **Agumbe** (Shimoga, Karnataka) — Rainforest / Nature (low crowd)
2. **Pollachi** (Coimbatore, Tamil Nadu) — Coconut Groves / Culture (low crowd)
3. **Kudremukh** (Chikkamagaluru, Karnataka) — Peak Trek / Adventure (low crowd)
4. **Tarkarli** (Sindhudurg, Maharashtra) — Coral Beach / Adventure (medium crowd)
5. **Dholavira** (Kutch, Gujarat) — Harappan Ruins / Culture (low crowd)
6. **Velha Goa Heritage** (North Goa, Goa) — Bakeries & Latin Quarter / Food (medium crowd)

### Acceptance Criteria:
- Ensures parent `locations` and `states` exist before inserting into `spots`.
- Each spot has valid `vibe_id`, `crowd_level_id`, budget in INR, rating between $0.0\text{--}5.0$, popularity $0\text{--}100$, and at least 2 tag associations in `spot_tags`.
- Committed with message: `[CP4][kanika] add 6 offbeat expansion spots for South and West India`.
