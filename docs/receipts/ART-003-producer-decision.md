# ART-003 Producer Decision Receipt: Asset Promotion Boundary

**Date:** 2026-07-21  
**Owner:** Codex /root, producer  
**Decision version:** ART-PROMOTION.1  
**Control-plane request:** ART-003-DECISION-001  
**Control-plane route:** L3, `art_owner`, `continue_role_conversation`  
**Decision state:** APPROVED

## Decision

The existing five animal candidate PNGs (`chicken`, `cow`, `pig`, `bear`, and `rabbit`) may be promoted only through a subsequent ART-003 asset contract that records their owned source, provenance, intended CityOfAnimals IDs, target paths, review evidence, and first authorized runtime consumer.

The ART-001 building review board remains `NOT_RUNTIME`. It is not authorized for cropping, splitting, transparent extraction, runtime loading, scene references, resource registration, or formal-asset archival. New farm-house assets will be independently authored as original, discrete files. The board can inform only broad style language, never an identifiable building design, layout, or silhouette.

## Scope and non-goals

- This is a producer decision and roadmap clarification, not an asset promotion contract or runtime write.
- No files under `assets/candidate/`, `assets/`, `scenes/`, `scripts/`, `config/`, or `tests/` were changed.
- F-003 remains the only active feature and its lock set is unchanged.
- F-004 has not received a functional specification, Figma UE/UI artifact, data table, runtime authorization, or implementation task.
- **Figma UE/UI applicability:** not applicable to this decision because it creates no player-facing screen, interaction, or behavior. It is mandatory when the F-004 player-facing source is created after its gate opens.

## Control-plane result

The control-plane preflight reported no conflicting or duplicate task IDs. It selected L3 and required a structured decision receipt plus a formal source record. This receipt is the structured decision record; `docs/roadmaps/PLAN-001-original-farm-town-content-ladder.md` is the formal source record. No separate agent was created because no such delegation was requested.

## Gate and next action

F-003 cannot be accepted until its required clean 720 x 1280 runtime capture is archived and reviewed. During validation on 2026-07-21, the normal supply chain was manually exercised through field collection, Willow Pen collection, Threadmill collection, and a completed local order; however, the required archive capture remains blocked by a visible Godot application-error dialog. A headless model-test invocation did not finish within the observed interval and is recorded as inconclusive, not passing evidence.

After the F-003 blocker is resolved and the feature is accepted, create the F-004 functional source and its editable Figma Design/FigJam UE artifacts before any runtime asset integration.
