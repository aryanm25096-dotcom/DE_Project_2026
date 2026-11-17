# Team T0125 Work Split & Task Allocation Matrix

**Project:** TripSketch (DBMS / PostgreSQL Course Project)  
**Team Number:** T0125  
**Group Lead:** Aryan Mudgal (`aryanm25096-dotcom`)  
**Team Members:** Kanika Prajapati (`kanikaa30`), Dia Chowdhary (`diachowdhary`), Ayesha Khan (`ayesha-khan27`)  
**Generated On:** Tuesday, 17 November 2026  

---

## 1. Master Task Allocation Matrix

| Task ID | Checkpoint | Title | Difficulty | Owner | Output File Path | Due Date | Est. Hours | Status |
|---|---|---|---|---|---|---|---|---|
| **K1** | CP2 | Spot Discovery & Faceted Filter Queries | BASIC | Kanika | `team_work/kanika/01_discovery_queries.sql` | 18 Nov 2026, 6 PM | 1.5h | Not started |
| **D1** | CP2 | User Activity & Saved Favorites Queries | BASIC | Dia | `team_work/dia/01_user_activity_queries.sql` | 18 Nov 2026, 6 PM | 1.5h | Not started |
| **A1** | CP2 | Itinerary Construction & Budget Aggregation Queries | BASIC | Ayesha | `team_work/ayesha/01_itinerary_queries.sql` | 18 Nov 2026, 6 PM | 1.5h | Not started |
| **H1** | CP2 | Benchmark Execution, EXPLAIN ANALYZE & Baseline Report | HARD | Aryan | `docs/03_baseline_timings.md`<br>`benchmarks/results/baseline/summary.csv` | 18 Nov 2026, 11:59 PM | 4.0h | Not started |
| **K2** | CP3 | Schema Integrity & Constraint Validation Queries | BASIC | Kanika | `team_work/kanika/02_data_validation.sql` | 19 Nov 2026, 4 PM | 1.5h | Not started |
| **D2** | CP3 | Query Documentation & Use-Case Mapping Report | BASIC | Dia | `team_work/dia/02_query_descriptions.md` | 19 Nov 2026, 4 PM | 1.5h | Not started |
| **A2** | CP3 | Travel Insights & Aggregation Analytical Queries | BASIC | Ayesha | `team_work/ayesha/02_analytics_queries.sql` | 19 Nov 2026, 4 PM | 1.5h | Not started |
| **H2** | CP3 | Indexing Architecture, Query Rewrites & Optimization Report | HARD | Aryan | `sql/05_indexes.sql`<br>`sql/06_optimized_queries.sql`<br>`docs/04_optimization_report.md` | 19 Nov 2026, 11:59 PM | 5.0h | Not started |
| **K3** | CP4 | West & South India Offbeat Spots Expansion Seed Data | BASIC | Kanika | `team_work/kanika/03_more_spots_seed.sql` | 21 Nov 2026, 6 PM | 2.0h | Not started |
| **D3** | CP4 | North & Central India Offbeat Spots Expansion Seed Data | BASIC | Dia | `team_work/dia/03_more_spots_seed.sql` | 21 Nov 2026, 6 PM | 2.0h | Not started |
| **A3** | CP4 | Northeast & Himalayan Offbeat Spots Expansion Seed Data | BASIC | Ayesha | `team_work/ayesha/03_more_spots_seed.sql` | 21 Nov 2026, 6 PM | 2.0h | Not started |
| **H3** | CP4 | Table Partitioning DDL, Scalability Benchmark & Report | HARD | Aryan | `sql/08_partitioning.sql`<br>`docs/05_scalability_report.md` | 23 Nov 2026, 11:59 PM | 6.0h | Not started |
| **H4** | CP0-CP5 | Branch Integration, Peer Code Review & Conflict Resolution | HARD | Aryan | Git commit integration across repository | Ongoing | 3.0h | In progress |

---

## 2. Summary of Work Distribution

| Member | Role | Total Tasks | Basic Tasks | Hard Tasks | Estimated Hours | First Commit Deadline |
|---|---|---:|---:|---:|---:|---|
| **Aryan Mudgal** | Group Lead | 4 | 0 | 4 | ~18.0h | Completed (CP0/CP1) |
| **Kanika Prajapati** | Database Engineer | 3 | 3 | 0 | ~5.0h | Wed 18 Nov (Task K1) |
| **Dia Chowdhary** | Database Engineer | 3 | 3 | 0 | ~5.0h | Wed 18 Nov (Task D1) |
| **Ayesha Khan** | Database Engineer | 3 | 3 | 0 | ~5.0h | Wed 18 Nov (Task A1) |

### Key Design Principles:
1. **Zero Conflict Architecture:** Every teammate works solely inside their dedicated folder (`team_work/<member_name>/`). No two people ever edit the same file, eliminating Git merge conflicts.
2. **Equitable Effort:** Kanika, Dia, and Ayesha each receive exactly 3 tasks (1 query set, 1 validation/documentation set, 1 seed expansion set) totaling ~5 hours across the week.
3. **Weekly Commit Tracking:** Each member delivers Task 1 by Wednesday 18 Nov, guaranteeing every member displays verified commits on the faculty tracker before the grading sweep.
4. **Appropriate Complexity:** First-year teammates focus on standard PostgreSQL `SELECT`, `JOIN`, `GROUP BY`, and `INSERT` statements with pre-built starter templates and step-by-step guides. Aryan manages all complex tuning (`EXPLAIN (ANALYZE, BUFFERS)`), indexing strategy, partitioning DDL, and final branch merging.

---

## 3. Merge & Integration Plan (Aryan Mudgal)

As Group Lead, Aryan will integrate individual contributions into the official checkpoint deliverable files according to this protocol:

1. **Review & Test:** When a member pushes their branch (`git push origin <member>/<task>`), Aryan checks out the branch locally and executes the script against the local PostgreSQL test instance (`tripsketch_db`).
2. **Integration into Official Checkpoint Deliverables:**
   - **For CP2 (`docs/03_baseline_timings.md`):** Aryan integrates Kanika's discovery queries (K1), Dia's activity queries (D1), and Ayesha's itinerary queries (A1) into the core application benchmark suite, runs timing benchmarks, and compiles `docs/03_baseline_timings.md`.
   - **For CP3 (`sql/05_indexes.sql` & `docs/04_optimization_report.md`):** Aryan uses Dia's query mapping (D2), builds indexing rules for the queries written by Kanika/Ayesha, tests execution plan improvements, and creates `sql/05_indexes.sql`.
   - **For CP4 (`docs/05_scalability_report.md` & `sql/08_partitioning.sql`):** Aryan incorporates the 18 new spots created by Kanika (K3), Dia (D3), and Ayesha (A3) into the dataset scale test, drafts the partitioning scheme, and compiles the final scalability report.
3. **Commit & Push to Default Branch (`main`):** Aryan merges the verified branch into `main` and pushes, preserving full authorship history in Git logs.
