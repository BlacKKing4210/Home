# CORE-FUNCTIONS-001 Completion Receipt

**Date:** 2026-07-20  
**Owner:** Codex /root, chief planner and design owner  
**Task class:** L1 design documentation  
**Control-plane receipt:** `READY`, `direct_execute`, `design_owner`  
**Task fingerprint:** `4F417869CDFA7EE2EB9696E31C1C634959A44CDD89E93DA9B1BAB532E5B4BD72`  
**Conflict check:** No write-set conflict with F-003's runtime locks.

## Request

Create the current game's core-function design using the general game-design template, taking Township and Hay Day only as genre-level system references.

## Read-only receipt

- Read the CityOfAnimals workflow, Profile, active scope, handoff, task contract, design/config indexes, and feature-progress matrix.
- Verified F-003 is the sole active feature and remains `IMPLEMENTED_PENDING_VISUAL_CAPTURE`.
- Confirmed the handoff/active scope references `docs/receipts/F-003-ENG-002.md`, but that file does not yet exist. This is recorded as an evidence concern; it does not change F-003 state or authorize a successor feature.
- Read the current general design template and its GDD package specification. The template's referenced `assets/design.md` is absent from the installed package; the available canonical `write-game-design.md` plus `gdd-package-spec.md` were used instead.
- Used `MARKET-FARMTOWN.2` as the external-reference evidence boundary. It records official-source system observations dated 2026-07-20 and explicitly excludes unverified video claims and third-party expression.

## Outputs

- `docs/design/CORE-FUNCTIONS-001-original-farm-town-design.md` — editable Chinese core-function design source.
- `output/pdf/CORE-FUNCTIONS-001-original-farm-town-design.pdf` — review/share PDF rendition.
- `docs/design_index.md` and `docs/PM_HANDOFF.md` — formal source registrations.

## Acceptance scope

- Covers the general template's Systems Index, core GDD, LDD, Difficulty Curve, Economy Model, and Faction Design sections.
- Provides system dependencies, common state machines, UI rules, configuration-field contracts, art/audio/telemetry lists, edge cases, QA, and pending-decision owners.
- Defines no production numbers, runtime code, configuration CSV, external assets, commercial model, or F-004 implementation scope.
- F-003 remains capture-pending; its files and locks were not modified.

## Verification evidence

- Required general-template sections were checked in order: Systems Index, Core System GDD, Level Design Document, Difficulty Curve, Economy Model, Faction Design, and completion handoff.
- `output/pdf/CORE-FUNCTIONS-001-original-farm-town-design.pdf` rendered successfully as a 19-page landscape A4 PDF. Pages 1, 5, 10, and 19 were visually inspected after a pagination revision for Chinese legibility, table overflow, diagram-source visibility, headers, footers, blank pages, and final handoff readability.
- PDF SHA-256: `8D17183541159722F9D5B42440CE1448B9C083ABE9417300341192509E9BD2AA`.
- F-003 remains `IMPLEMENTED_PENDING_VISUAL_CAPTURE`; no runtime file, configuration source, asset, active-scope row, or shared lock was changed.
