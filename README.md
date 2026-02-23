# Claims, Denials & Appeals Analytics (dbt Project)

## Overview

This project models healthcare claim denials and appeal outcomes to calculate remaining revenue at risk using a layered dbt architecture.

It demonstrates production-minded analytics engineering patterns, including:

- Source modeling
- Layered transformations (staging → intermediate → marts)
- Referential integrity tests
- Custom business logic tests
- Incremental modeling
- Snapshot-based change tracking
- Auto-generated documentation & lineage

Built using dbt-core + DuckDB for a fully reproducible local workflow.

---

## Business Objective

Healthcare payers frequently deny claims, which may later be appealed and overturned.

This project answers:

- What is the final denial outcome after appeals?
- How much revenue remains at risk?
- How do denial outcomes trend over time?

---

## Architecture

### Sources (Seeded Stand-Ins for Warehouse Tables)

- `raw.claim_lines`
- `raw.denials`
- `raw.appeals`

### Staging Layer

- `stg_claim_lines`
- `stg_denials`
- `stg_appeals`

**Responsibilities:**
- Type normalization
- Column cleaning
- Grain enforcement
- Referential integrity validation

### Intermediate Layer

- `int_denial_final_outcome`

**Responsibilities:**
- Roll up appeals to the denial level
- Classify final outcome:
  - `Denied - No Appeal`
  - `Denied - Appeal Upheld`
  - `Overturned`
- Calculate `final_denied_amount` (remaining revenue at risk)

### Mart Layer

- `fct_denial_resolution` — Denial-level fact table enriched with claim context
- `fct_revenue_at_risk_daily` — Incremental payer-level daily aggregation

### Snapshot

- `snap_denial_final_outcome` — Tracks historical changes in denial outcome status over time

---

## Testing Strategy

### Schema Tests

- `not_null`
- `unique`
- `accepted_values`
- `relationships`

### Custom Business Logic Tests

- Overturned denials must have `final_denied_amount = 0`
- Appeal resolution date cannot precede appeal date

---

## Running the Project
```bash
dbt seed
dbt build
dbt snapshot
dbt docs generate
dbt docs serve
```

---

## Lineage

The lineage graph demonstrates full dependency tracking from raw sources through staging, intermediate transformations, and marts.

---

## Why This Matters

This project reflects real-world healthcare analytics engineering patterns:

- Declarative modeling with dbt
- Data contract enforcement via tests
- Change data tracking via snapshots
- Performance optimization via incremental models
- Clear separation of transformation layers

---

## Future Enhancements

- Simulated dev/prod targets
- Merge-based incremental strategy
- Additional dimension modeling (payer, provider)
- CI integration for automated testing
```