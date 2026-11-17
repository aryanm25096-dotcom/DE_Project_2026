# TripSketch: Problem Understanding & System Analysis

**Course:** Data Engineering / Database Management Systems (PostgreSQL)  
**Checkpoint:** CP1 — Schema Design & Normalization  
**Application:** TripSketch (Offbeat & Budget-Friendly Travel Planning Platform for India)  

---

## 1. Problem Statement
Travelers seeking offbeat, budget-friendly, and culturally authentic destinations across India face substantial information fragmentation. Mainstream tourism portals over-index on commercialized, overcrowded tourist hubs (e.g., standard circuits like Jaipur or Goa), offering little structured filtering for:
1. **Travel Vibe** (Nature, Adventure, Food, Culture)
2. **Crowd Tolerance** (Low / Quiet, Medium / Moderate, High / Lively)
3. **Daily Budget Caps** (INR per day for local lodging, meals, and transport)

Without a unified relational data layer, travel platforms suffer from slow search responses, inconsistent tag filtering, inability to preserve user-curated favorites, and lack of dynamic multi-day itinerary budget calculations. TripSketch solves this by delivering an interactive discovery engine backed by a normalized PostgreSQL database designed for low-latency queries, strict referential integrity, and reliable multi-table aggregation.

---

## 2. Target Users
- **Solo Explorers & Backpackers:** Young professionals, students, and digital nomads seeking peaceful, low-crowd destinations with transparent daily expenditure estimates.
- **Weekend Adventurers:** Travelers seeking specific activities (e.g., paragliding at Bir Billing, trekking through Zanskar or Chopta) within fixed weekend budgets.
- **Cultural & Culinary Tourists:** Travelers focused on heritage, indigenous crafts, architecture, and hyper-local cuisines (e.g., Chettinad, Bundi stepwells, Sarafa night bazaar).
- **Itinerary Planners:** Users who construct multi-day travel schedules, organize spots by sequential days, and require instant aggregate budget calculations.

---

## 3. Why a Relational Database (RDBMS) is Needed
Prior to introducing a relational database, TripSketch relied on client-side state and ephemeral in-memory JSON objects. This architectural approach introduced severe operational limitations:
- **No Persistence Across Sessions:** Saved favorites and recently viewed items disappeared when users cleared browser cache or switched devices.
- **Data Redundancy & Anomalies:** State names, area locations, and category tags were duplicated across every place record, leading to update anomalies and inconsistent casing (e.g., `"Himachal"`, `"HP"`, `"Himachal Pradesh"`).
- **Lack of Multi-Attribute Filtering & Indexing:** Filtering across three dimensions simultaneously (e.g., Vibe = Nature, Budget <= ₹2,500, Crowd = Low) required $O(N)$ full-array scans in JavaScript. An RDBMS provides composite B-tree indexes for logarithmic lookup times.
- **Dynamic Derived Calculations:** Calculating total itinerary budgets across multiple days requires transactional joins (`SUM(spots.budget_per_day)`). Hardcoding sums in documents causes synchronization drift whenever spot rates update.

---

## 4. Functional Requirements

### 4.1 Discovery & Multi-Faceted Search
- **FR1 (Vibe Filtering):** Filter destinations by standard categories (`nature`, `adventure`, `food`, `culture`).
- **FR2 (Budget Range Filter):** Query places with a daily budget below or equal to a user-specified threshold in INR (`budget_per_day <= target_budget`).
- **FR3 (Crowd Level Filter):** Filter destinations by crowd tolerance (`low`, `medium`, `high`).
- **FR4 (Compound Tag Filtering):** Retrieve spots associated with specific travel tags (e.g., `#trekking`, `#remote`, `#unesco-heritage`) via normalized M:N relationships.

### 4.2 User Management & Personalization
- **FR5 (Account Management):** Register and identify users via unique, validated email addresses.
- **FR6 (Saved Favourites):** Allow users to save or bookmark spots into their personal favorites list, with idempotent toggle support.
- **FR7 (Recently Viewed Tracking):** Track recently viewed spots per user with timestamps for quick revisit carousels.

### 4.3 Multi-Day Itinerary Builder
- **FR8 (Itinerary Creation):** Enable authenticated users to create named itineraries (e.g., "Himalayan High Passes").
- **FR9 (Sequential Scheduling):** Add spots to itineraries organized by `day_number` and `position` with uniqueness constraints preventing schedule collisions.
- **FR10 (Dynamic Cost Aggregation):** Compute estimated itinerary budgets dynamically using SQL `SUM()` across joined spot records.

---

## 5. Main Entities & Relationships in Plain English

| Entity | Description | Relationship |
|---|---|---|
| **states** | Administrative Indian states / union territories. | One state has many locations (1:N). |
| **locations** | Specific areas / cities (e.g., Zanskar, Kullu, Kumta) linked to a state. | One location has many spots (1:N). |
| **vibes** | Master lookup for travel categories (`nature`, `adventure`, `food`, `culture`). | One vibe classifies many spots (1:N). |
| **crowd_levels** | Master lookup for crowd density tiers (`low`, `medium`, `high`). | One crowd level classifies many spots (1:N). |
| **spots** | Individual travel places with rating, daily budget, popularity, and descriptions. | Linked to location, vibe, crowd level, tags, favorites, and itinerary items. |
| **tags** | Descriptive keywords (e.g., `trekking`, `glacier`, `peaceful`). | Many spots have many tags via `spot_tags` (M:N). |
| **spot_tags** | Bridge entity mapping spots to tags. | Resolves M:N relationship. |
| **users** | Registered platform users with validated email addresses. | One user creates many itineraries, favorites, and views. |
| **favourites** | Junction table recording user bookmarks. | Many users bookmark many spots (M:N). |
| **itineraries** | Trip containers created by a user. | One user has many itineraries (1:N). |
| **itinerary_items** | Individual schedule items placed in an itinerary on a specific day and slot. | Belongs to an itinerary and references a spot (M:1). |
| **recently_viewed**| Audit history tracking viewed places per user. | Many users view many spots over time (M:N). |

---

## 6. Assumptions
1. **Currency & Units:** All budgets represent estimated daily expenditure in Indian Rupees (INR) for one traveler.
2. **Rating Range:** Ratings conform strictly to a standard decimal range from $0.00$ to $5.00$.
3. **Popularity Metric:** Popularity scores range from $0$ to $100$, derived from historical engagement metrics.
4. **Hierarchical Geography:** An area belongs to exactly one state; states and locations are pre-validated to avoid redundant free-text typos.
5. **Dynamic Derived Fields:** Total itinerary budget, average rating of itinerary spots, and favorite counts are **derived** and calculated via SQL queries on demand, guaranteeing zero denormalization anomalies.

---

## 7. Scope & Out-of-Scope

### In-Scope (Checkpoint 1 Deliverable)
- Relational schema modeling in 3NF and BCNF for all 12 core tables.
- Primary key, foreign key, unique, check, and not-null constraints enforcing data integrity at the database level.
- Clean execution script (`sql/01_schema.sql`) and deterministic seed script (`sql/02_load_data.sql`).
- Composite and single-column indexes on foreign keys, vibes, budgets, and ratings to support sub-millisecond query execution.
- High-resolution visual ER diagram with explicit cardinalities and key badges.

### Out-of-Scope
- Direct live integration with commercial payment gateways (e.g., Razorpay, Stripe) for booking ticket transactions.
- User password hashing and OAuth JWT session management (handled at application middleware layer).
- Real-time GIS polygon boundary rendering or spatial PostGIS topological geometry mapping.
