# F-003 Spatial Map Correction - Producer Decision Receipt

**Decision ID:** F003-SPATIAL-001  
**Version:** F003-SPATIAL.1  
**Date:** 2026-07-21  
**Owner:** Codex /root, producer  
**Control-plane route:** L3 / `pm_control_plane` / `continue_role_conversation`  
**Decision state:** APPROVED DIRECTION / IMPLEMENTATION BLOCKED

## Root cause

The small playable area is a deliberate F-003 implementation boundary, not a mobile-resolution defect.

- `scripts/town/town_view.gd` defines a fixed `720 x 1280` design canvas and a single `FARM_RECT` of `684 x 884` logical pixels.
- Every field, factory, order ticket, and hit region is a fixed screen-space `Rect2`; the input path can only activate those fixed rectangles.
- The view has fit-to-canvas scaling, but no world transform, map bounds, pan input, zoom, construction-site data, or camera/navigation state.
- `docs/features/F-003-herd-and-local-orders.md` explicitly listed a world map, camera controls, and a new scene as non-goals. F-004 was consequently sequenced as the later district expansion feature.

## Approved producer direction

Replace the fixed-board presentation with an original, large 45-degree farm-town map foundation. It must be navigable on a 720 x 1280 portrait device and visibly support a substantial number of future construction sites. Current F-003 production objects remain in a starter district and retain their existing interaction loop.

This direction changes presentation and map capacity only. It does not copy any commercial map, building, UI hierarchy, silhouette, asset, recipe, balance value, or progression rule. It does not move F-004 ahead of F-003 acceptance or authorize unregistered candidate assets.

## Required design gate before runtime changes

- Apply `ui-design-priority` to the map screen and construction-site interaction.
- Create an editable Figma Design map screen and an editable FigJam map interaction/state flow.
- Add the Figma UE & UI/UX Artifact Register to the F003-SPATIAL.1 functional source.
- Create a data-backed spatial layout source, update the F-003 task contract and baselines, and obtain a new read-only implementation receipt before touching runtime files.

## Figma UE attachment blocker

**State:** `BLOCKED: Figma UE attachment`  
**Attempt:** `figma_create_new_file` for `CityOfAnimals F-003 Spatial Map UE` on 2026-07-21.  
**Observed result:** remote transport request failed; the authenticated Figma plan also reports a `View` seat.  
**Owner:** Codex /root with user-provided Figma edit access required.  
**Next action:** restore the Figma MCP connection with an edit-capable plan, or provide an editable Figma Design and FigJam file. Then create the required artifacts and resume the F003-SPATIAL.1 source and implementation contract.

## Lock and scope status

- F-003 remains the sole active feature and retains its current shared runtime lock.
- F-003 is still not accepted because the clean reviewed 720 x 1280 runtime capture is outstanding.
- F-004 through F-010 remain roadmap-only; no queued feature has been advanced.
- No runtime, scene, CSV, candidate asset, or test file was changed by this decision.
