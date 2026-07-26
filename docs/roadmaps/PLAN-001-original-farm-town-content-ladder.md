# PLAN-001 Original Farm-Town Content Ladder

**Version:** FARM-TOWN-DIRECTION.3  
**Status:** Filed producer direction - roadmap only  
**Owner:** Codex /root, producer  
**Target:** CityOfAnimals, Godot 4.6, portrait 720 x 1280  
**Research basis:** `docs/research/2026-07-farm-town-market-architecture.md` (MARKET-FARMTOWN.2)

## Producer decision

CityOfAnimals will become an original, content-rich farm-town management game. Its target is the **genre-level breadth** of a working farm, visible animal and factory districts, layered logistics, town services, and expansion - not a reconstruction of a named commercial game.

All recipes, names, values, art direction, building silhouettes, layouts, maps, order presentation, characters, assets, and implementation remain original to CityOfAnimals. Reference research establishes only that a long-lived farm-town game needs a wide and connected content architecture.

## Product promise

"Every new building makes the town visibly more alive and gives me a new reason to grow, prepare, ship, or expand."

The recurring decision is: **which visible district should I prepare next, and which delivery horizon deserves the goods I have?**

## Product content floor

Before any live operations or social layer is considered, the original mainline should cover at least six crop/orchard sources, four animal shelters, ten production buildings, four town-service buildings, three delivery channels, three infrastructure/upgrade points, and three expandable functional districts. These are content-coverage floors, not copied progression values or implementation scope for one feature.

## Execution ladder

| Order | Feature arc | Player-facing contribution | Gate |
|---|---|---|---|
| F-003 | Herd and Local Orders | Existing first chain: field -> animal material -> workshop -> local orders. | Reviewed 720 x 1280 runtime capture and F-003 acceptance. |
| F-004 | Farm District Board and Industry I | Replace the cramped single-board limitation with direct agricultural, animal, and workshop districts. Add original feed, animal, and first-stage factory connections. | F-003 accepted; dedicated functional source, data tables, receipt, and write authorization. |
| F-005 | Rail Freight Yard | A rail-side multi-good manifest uses Industry I goods, visibly loads cargo, departs, and returns construction-oriented rewards. | F-004 accepted; dedicated functional source, data tables, receipt, and write authorization. |
| F-006 | Town Trade Quarter and Industry II | Add visible service buildings and a second cross-linked workshop family so goods are consumed by a town, not only an order list. | F-005 accepted; dedicated functional source, data tables, receipt, and write authorization. |
| F-007 | Sky Cargo Harbor | A long-horizon mixed shipment uses goods from multiple districts and proves pre-manifest -> loaded -> manual departure -> resolved. | F-006 accepted; dedicated functional source, data tables, receipt, and write authorization. |
| F-008 | Land and District Expansion | Renown and construction rewards unlock functional space, new building sites, or route choices. | F-007 accepted; dedicated functional source, data tables, receipt, and write authorization. |
| F-009 | Riverbank and Stoneworks | Add an original side-resource district and a collection/construction branch without disconnecting it from the main supply web. | F-008 accepted; focused source, data tables, and playtest evidence. |
| F-010 | Collections and Cooperative Layer | Consider long-tail collections and co-operative requests only after the solo farm-town loop has sufficient building and order depth. | F-009 accepted; separate product decision required. |

## Content rules

1. **Visible building first.** Fields, animal shelters, workshops, service buildings, and logistics sites are recognisable direct world objects. Text cards cannot substitute for a town.
2. **One shared supply web.** Each content pack reuses at least one existing material and gives at least one existing building a new demand or output relationship.
3. **Different logistics horizons.** Local orders are flexible and short; rail freight is a medium manifest that advances construction; sky cargo is a longer mixed batch. They must not be the same order with different icons.
4. **Original balance.** Timers, capacity, reward, unlock, and recipe values are created and playtested in CityOfAnimals CSV sources. None are inferred from a reference title.
5. **Few resources, richer choices.** Reuse coins and renown until a focused feature proves another resource is needed. Do not add currencies merely to simulate scale.
6. **Mobile object clarity.** At 720 x 1280, a player identifies the next action from silhouette, item icon, state cue, and a short locale-table label. Text explains state; it does not carry the interaction.
7. **Locale contract.** New player text defaults to `zh-CN`, is catalogued in locale tables, and remains switchable to `en` through persistent Settings.

## Required proof in every future slice

`source material -> direct building state -> collected good -> chosen local/rail/sky/town route -> reward or new space`

Logistics also proves `manifest -> loaded -> departed -> resolved`. A decorative vehicle, aircraft, timer, or disabled button is not a logistics feature.

## Commercial-safety boundary

- Do not reproduce Township, Hay Day, Supercell, Playrix, or another commercial game's art, buildings, recipes, values, names, interface hierarchy, map, task presentation, characters, assets, screenshots, code, or monetization.
- Do not use sourced balance values or lookalike art. The current emoji/SVG/vector placeholder rule remains until an approved project-art task replaces it.
- Build one verified vertical slice at a time. This roadmap is sequencing and product coverage; it is not implementation authority.

## Immediate gate

F-003 remains the sole active feature. Its clean reviewed runtime capture is required before F-004 receives a functional source or any runtime write authorization.

## F003-SPATIAL.1 producer direction: map-scale correction

**Decision date:** 2026-07-21  
**Status:** Approved direction; runtime work blocked on editable Figma UE/UI artifacts

CityOfAnimals must present its farm as an original, large 45-degree world rather than a fixed one-screen object board. The active F-003 slice is authorized to be materially revised into a drag-navigable, mobile-safe spatial foundation with a visible starter district, a broad map extent, and many clearly reservable construction sites. The current field, bakery, Willow Pen, Threadmill, and local-order loop must remain direct world objects inside that space.

This direction supersedes only the F-003 non-goal that excluded a world map and camera/navigation. It does **not** authorize F-004 production chains, rail/air logistics, commercial layouts, imported reference art, copied building silhouettes, or unrecorded candidate assets. Construction-site capacity must be independently specified, data-backed, and original before it changes runtime behavior.

Before code or configuration changes, create the F003-SPATIAL.1 functional source with `ui-design-priority`, an editable Figma Design map screen, an editable FigJam interaction/state flow, the artifact register, updated task contract, baselines, and acceptance evidence. The Figma prerequisite is currently blocked; see `docs/receipts/F-003-SPATIAL-001.md`.

## ART-003 producer decision: asset promotion boundary

**Decision date:** 2026-07-21  
**Decision version:** ART-PROMOTION.1  
**Status:** Approved direction; no runtime authorization

The five existing animal candidate images (`chicken`, `cow`, `pig`, `bear`, and `rabbit`) are approved to proceed through a later, source-recorded ART-003 promotion contract. That contract must record the owned source, provenance, intended CityOfAnimals asset IDs, destination paths, review evidence, and the first authorized runtime consumer. Until it does, the files remain candidates under `assets/candidate/style_reference/` and are not runtime-loadable.

`art-001-animal-town-buildings-board.png` remains a **style-only, NOT_RUNTIME** review board. It must not be cropped, split, transparently extracted, copied into a scene, or used as a resource registry entry. Future farm houses must be separately authored, individually reviewable original assets with their own source files and provenance. The board may inform only broad visual-language choices such as warm color blocking, rounded silhouette readability, and high-contrast outlines; it must not determine a building's identity, layout, or silhouette.

This decision does not change F-003's active lock or give F-004 implementation authority. Only after F-003 is accepted may F-004 receive its dedicated functional source, `ui-design-priority` brief, editable Figma Design and FigJam UE artifacts, data tables, asset-promotion contract, read-only receipt, and explicit write authorization.
