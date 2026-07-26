# F-004 Formal Design Authorization

**Receipt:** F-004-DESIGN-001  
**State:** ACTIVE / CONFIG+DOCUMENT VALIDATED / FIGMA BLOCKED / FORMAL DESIGN ONLY  
**Date:** 2026-07-24  
**Producer and design owner:** Codex `/root`  
**Feature:** F-004 / F004-DISTRICT.1  
**Task fingerprint:** `D59A3CA5733E743B7316DE5F86D604BB592E6FD7C84EC5A45BD883C897CDDF25`

## Read-only preflight result

- Control-plane result: `READY / L3`.
- Route owner: `design_owner`.
- Duplicate tasks: none.
- Conflicting tasks or shared locks: none.
- Dependency: F003-FARM.2 is `ACCEPTED FOR PROTOTYPE` and its lock is released.
- L3 means a cross-domain milestone review is required. It does not authorize creating an agent, sub-agent, Codex task, thread or worktree.
- The unique producer remains Codex `/root`; the current agent directly owns this design package.

## Formal inputs

- `docs/roadmaps/PLAN-001-original-farm-town-content-ladder.md`
- `docs/roadmaps/PRODUCT-PLAN-001-city-of-animals.md`
- `docs/design/CORE-LOOP-001-original-farm-town-core-loop.md`
- `docs/design/CORE-FUNCTIONS-001-original-farm-town-design.md`
- `docs/research/2026-07-farm-town-market-architecture.md`
- `docs/features/F-003-farm-town-foundation-v2.md`
- `docs/receipts/F-003-FARM2-ENG-002.md`

## Authorized outcome

Create an implementation-ready general feature package for an original, commercially safe “Farm District Board and Industry I” slice:

1. preserve the accepted 1800 x 1700 FARM.2 world and organize its existing land into readable agriculture, animal and workshop districts;
2. define a world-first District Board and fixed construction sites without implementing free land expansion;
3. activate a first connected extension of existing agriculture, animal and workshop content;
4. make at least one shared material visibly compete between two valid uses;
5. define exact original configuration tables, player-visible states, UI/UE, localization, persistence boundaries and QA;
6. deliver editable Figma/FigJam artifacts plus reviewed DOCX and PDF.

## Authorized write set

- `docs/features/F-004-farm-district-industry-i.md`
- `config/tables/f004_districts.csv`
- `config/tables/f004_sites.csv`
- `config/tables/f004_items.csv`
- `config/tables/f004_sources.csv`
- `config/tables/f004_animals.csv`
- `config/tables/f004_recipes.csv`
- `config/tables/f004_requests.csv`
- `config/tables/f004_locale.csv`
- `docs/receipts/F-004-DESIGN-001.md`
- `docs/active_scope.yaml`
- `docs/task_contract.md`
- `docs/project_profile.yaml`
- `docs/design_index.md`
- `docs/config_index.md`
- `docs/PM_HANDOFF.md`
- `PM/feature_progress.xlsx`
- `output/documents/F004-DISTRICT.1/`

The editable Figma artifact is an external design source registered by file key, URL, page and node references in the feature document.

## Explicit exclusions

- No Godot scene, script, test, `project.godot`, save data or runtime-asset write.
- No F-005 rail freight, F-006 town services, F-007 air cargo or F-008 land expansion implementation.
- No copied commercial-game art, map, UI layout, text, names, recipes, values, code or proprietary assets.
- No agent creation, server work, deployment, monetization or external publication.

## Design acceptance gates

- General feature document contains one player-facing memory point and at least five observable rules.
- UI priority is recorded before drawing, including entry, exit, loading, empty, disabled, failure, success and interrupted states.
- Player UE, system/state flow and 720 x 1280 screen layouts are editable in Figma/FigJam and their node references are verified.
- All eight F-004 CSVs have exact field contracts, locale coverage and passing cross-reference validation.
- DOCX and PDF are generated from the approved content and pass visual inspection.
- A separate milestone review confirms commercial safety, F-003 compatibility, implementation readiness and continued runtime gating.

## Runtime authority

This receipt authorizes formal design/configuration work only. Runtime implementation remains `NOT AUTHORIZED` until the completed feature source, editable Figma artifact, configuration validation, document review and a new engineering read-only receipt establish a non-conflicting runtime write set.

## 2026-07-25 validation checkpoint

- Market discovery followed the current AnySearch-first route, then original/official sources, Exa, public Reddit fallback and three locally inspected Bilibili samples. The user-provided YouTube sample remained `DEGRADED: platform bot verification` and was not used as decision evidence.
- The research was converted into observable density, object-state, output-shelf and production-context rules in `docs/features/F-004-farm-district-industry-i.md`.
- All eight F-004 tables passed the reproducible validator at `output/documents/F004-DISTRICT.1/validate_f004_config.py`; the report is `f004-config-validation.json` with zero warnings and zero errors.
- The general-template DOCX/PDF package was generated. The final PDF contains 27 pages and passed full-page Word/Poppler visual review.
- `BLOCKED: Figma UE attachment` remains. Three connector probes failed at the Figma transport layer and the browser fallback did not expose a connected authenticated Chrome channel. Static review figures do not satisfy the editable-artifact gate.
- Milestone result: `HOLD / FIGMA`. Commercial-safety, F003 compatibility, configuration closure and document QA pass; the shared design lock remains active and runtime authority remains false.
