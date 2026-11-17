# TripSketch: Application Queries Specification & Use-Case Mapping

**Author:** Dia Chowdhary (`diachowdhary`)  
**Task:** D2 (Checkpoint 3 Deliverable Section)  

---

## 1. Overview
This document maps our core SQL queries to their corresponding frontend UI components in the TripSketch React application, defining their operational type (READ/WRITE) and performance latency SLA.

---

## 2. Core Query Mapping Table

| Query ID | Component | Operation | Description | Target Latency |
|---|---|---|---|---:|
| **Q01** | `Dashboard.jsx` (Grid) | READ | Fetch spots filtered by selected Vibe (e.g. Nature, Culture) | < 10 ms |
| **Q02** | `Dashboard.jsx` (Filter Bar) | READ | Filter spots under daily budget threshold and crowd level | < 10 ms |
| **Q03** | `Dashboard.jsx` (Search) | READ | Search spots by keyword in name/description using `ILIKE` | < 15 ms |
| **Q04** | `TripCard.jsx` (Tags) | READ | Load all tag pills associated with a destination card | < 5 ms |
| **Q05** | `TripCard.jsx` (Heart Button) | READ | Check if currently logged-in user has bookmarked this spot | < 5 ms |
| **Q06** | `TripCard.jsx` (Save Click) | WRITE | Toggle / Insert spot into `favourites` table | < 10 ms |
| **Q07** | `Dashboard.jsx` (Favorites Tab) | READ | List all saved destinations for the active user | < 10 ms |
| **Q08** | `Dashboard.jsx` (Recently Viewed) | READ | Retrieve top 5 most recently inspected spots (MRU order) | < 5 ms |
| **Q09** | `ItineraryModal.jsx` | READ | Fetch day-by-day scheduled spots for a user's trip | < 10 ms |
| **Q10** | `ItineraryModal.jsx` (Summary) | READ | Dynamically calculate total trip estimated cost with `SUM()` | < 10 ms |
| **Q11** | `Analytics.jsx` | READ | Calculate average daily travel budget per vibe category | < 15 ms |
| **Q12** | `Analytics.jsx` | READ | Rank top 5 most saved destinations platform-wide | < 15 ms |

---

## 3. UI Integration Notes
- **Dynamic Costing:** Notice that **Q10** computes the trip budget on the fly using `SUM(spots.budget_per_day)` across joined itinerary items, ensuring that if any destination cost is updated in the database, itineraries automatically reflect the updated total without stale caches.
- **Deduplicated History:** **Q08** utilizes the `PRIMARY KEY (user_id, spot_id)` in `recently_viewed` with `ON CONFLICT (user_id, spot_id) DO UPDATE SET viewed_at = NOW()` to maintain a clean top-5 history without duplicated spot entries.
