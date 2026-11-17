# Group Lead Technical Roadmap & Task Sheet: Aryan Mudgal (`aryanm25096-dotcom`)

**Role:** Group Lead & Principal Database Architect  
**Team:** T0125  
**Ownership:** All HARD technical engineering tasks, benchmark design, performance profiling (`EXPLAIN ANALYZE`), indexing architecture, table partitioning, branch integration, and final deliverable validation.

---

## 1. High-Level Checkpoint Timeline

| Checkpoint | Due Date | Status | Core Deliverables Owned by Aryan |
|---|---|---|---|
| **CP0** | Tue 3 Nov 2026 | **Done** | Cloned repo, `team.json`, `README.md` team table |
| **CP1** | Mon 16 Nov 2026 | **Done** | `01_schema.sql`, `02_load_data.sql`, `er_diagram.png`, `01_problem_understanding.md`, `02_schema_design.md` |
| **CP2** | **Tue 17 Nov 2026 (TODAY)** | **Action Needed** | `docs/03_baseline_timings.md`, `benchmarks/results/baseline/summary.csv` |
| **CP3** | Thu 19 Nov 2026 | Upcoming | `sql/05_indexes.sql`, `sql/06_optimized_queries.sql`, `docs/04_optimization_report.md` |
| **CP4** | Mon 23 Nov 2026 | Final | `sql/08_partitioning.sql`, `docs/05_scalability_report.md`, `benchmarks/results/large/` |
| **CP5** | 25–26 Nov 2026 | Exam | In-class individual analysis and oral defense |

---

## 2. Detailed Task Breakdown (HARD Tasks)

### Task H1 (CP2): Baseline Query Benchmarking & Execution Plan Profiling
- **Due Date:** Wednesday, 18 Nov 2026, 11:59 PM (Overdue buffer)
- **Files to Produce:**
  - `docs/03_baseline_timings.md`
  - `benchmarks/results/baseline/summary.csv`
- **Steps:**
  1. Assemble all 12 core application queries from Kanika (K1), Dia (D1), and Ayesha (A1).
  2. Execute each query 3 times with `EXPLAIN (ANALYZE, BUFFERS)` on PostgreSQL without non-PK/UQ secondary indexes.
  3. Extract average execution time, buffer hits, and scan type (Seq Scan vs Index Scan).
  4. Fill out the baseline timing table in `docs/03_baseline_timings.md`.

### Task H2 (CP3): Indexing Strategy, Query Rewriting & Optimization Report
- **Due Date:** Thursday, 19 Nov 2026, 11:59 PM
- **Files to Produce:**
  - `sql/05_indexes.sql`
  - `sql/06_optimized_queries.sql`
  - `docs/04_optimization_report.md`
  - `benchmarks/results/optimized/summary.csv`
- **Steps:**
  1. Identify bottleneck queries from the baseline plans (e.g. Sequential Scans over `spots`, `spot_tags`, and string matching).
  2. Implement composite B-Tree indexes: `(vibe_id, budget_per_day)`, `(location_id, rating DESC)`.
  3. Implement trigram GIN index (`pg_trgm`) for fuzzy keyword searches (`spots.name ILIKE '%keyword%'`).
  4. Identify the subtle SQL trap (e.g. `NOT IN` vs `NOT EXISTS` handling `NULL` values) and document the formal proof of equivalence in `sql/06_optimized_queries.sql`.
  5. Re-run benchmark to verify 10× to 50× latency reduction.
  6. Compile before/after timing comparisons into `docs/04_optimization_report.md`.

### Task H3 (CP4): Declarative Table Partitioning & 20× Scale Report
- **Due Date:** Monday, 23 Nov 2026, 11:59 PM
- **Files to Produce:**
  - `sql/08_partitioning.sql`
  - `docs/05_scalability_report.md`
  - `benchmarks/results/large/summary.csv`
- **Steps:**
  1. Integrate the 18 expansion spots from Kanika (K3), Dia (D3), and Ayesha (A3).
  2. Design RANGE partitioning on `recently_viewed(viewed_at)` or `favourites(saved_at)`.
  3. Write DDL in `sql/08_partitioning.sql`, proving partition pruning via `EXPLAIN`.
  4. Measure latency degradation under 20× synthetic load and compile `docs/05_scalability_report.md`.

### Task H4 (Continuous): Team Coordination, Branch Merging & Code Review
- **Steps:**
  1. Verify teammate commits on their feature branches (`git log`, `psql` syntax test).
  2. Rebase and merge clean contributions into `main`.
  3. Push to `origin/main` to trigger the faculty automated checkpoint tracker.
