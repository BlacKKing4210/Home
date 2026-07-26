# F-003 Farm Foundation V2 Producer Decision and Read-only Receipt

**Receipt:** F003-DEEPPLAY-001  
**State:** READY / AUTHORIZED FOR RESEARCH, FORMAL DESIGN, FIGMA, AND ASSET AUDIT ONLY  
**Verified:** 2026-07-24  
**Accountable producer:** Codex `/root`  
**Execution model:** current producer session only; no agent, sub-agent, Codex task, thread, worktree, or delegated execution was created

## Producer decision

The producer rejected the current F003-FARM.1 playable direction because its moment-to-moment farming, content density, map scale, and production interactions remain materially unlike the target farm-town genre. The producer directed a deeper study of Hay Day, supplied the video `https://www.youtube.com/watch?v=zgAysNgvDuk`, requested repeated improvement passes, and authorized the existing animal and building resources for use subject to provenance and runtime-preparation checks.

This decision supersedes the old F003-FARM.1 screenshot-capture gate as the next action. Existing code, tests, receipts, and evidence remain historical and recoverable; they are not accepted as the new gameplay baseline and must not be deleted.

## Commercial-safety boundary

The project may reproduce genre-level system relationships and interaction principles: inventory-backed planting, crop multiplication, timed production queues, animal feeding, storage pressure, player-selected fulfillment, surplus selling, expansion, and a large readable farm-town map.

The project must not copy Hay Day or Township artwork, source code, branded names, characters, dialogue, exact recipes, exact values, progression tables, map layout, screen composition, monetization implementation, audio, or distinctive commercial assets. All player-facing names, values, visual composition, content identity, and tuning must remain original to CityOfAnimals.

## Read-only baseline

- F-003 is still the highest-priority active feature in `PM/feature_progress.xlsx`; its previous state is `EVIDENCE BLOCKED`.
- F-004 and later features remain roadmap-only and are not silently activated by this receipt.
- The existing runtime is a fixed 720 x 1280 board with four fixed plots, single-state production objects, static single-item requests, and no camera/world-space town. It does not prove the requested genre foundation.
- Existing F003 runtime files and their current hashes remain frozen until a separate implementation receipt is issued.
- Existing Figma source of truth: `https://www.figma.com/design/uU2Oek5RqFb19CPoGl48lC/Untitled` (`file_key: uU2Oek5RqFb19CPoGl48lC`).

## Asset audit result

The following existing whole-set boards are visually suitable as project-owned candidates:

- crop, orchard, vegetable-bed, and feedworks board;
- pen, coop, barn, and stable board;
- dairy, preserve kitchen, threadworks, press, and bakery board;
- chicken house, storehouse, grainworks, bakery, and produce market board.

These boards have a colored background and contain multiple subjects. Producer authorization permits promotion, but they remain `CANDIDATE / NOT_RUNTIME` until an ART-003 manifest records source paths, source-session provenance, sprite identifiers, segmentation masks, transparent PNG outputs, scale/origin rules, target paths, visual review, and first runtime consumer.

Existing animal PNGs under `assets/candidate/style_reference/animals/` may be promoted under the same ART-003 manifest. No candidate may silently overwrite an accepted runtime asset.

## UI-design-priority contract

- **Single primary decision:** choose the next useful transformation of the current harvest: keep seed, feed animals, queue a machine, fulfill a request, or sell the surplus.
- **Memory point:** the player sweeps across a cluster of fields, sees the crop stock visibly multiply, and immediately routes the surplus into a living production chain.
- **P0:** fields, selected crop, crop stock, harvest readiness, crop/granary capacity, feedworks, animal readiness, machine queue, ready output, one contextual primary action.
- **P1:** coins, level/renown, storehouse capacity, current requests, surplus market, camera framing, construction/lock state.
- **P2:** secondary queue slots, expansion materials, recovery help, language/settings, interruption and return feedback.
- **P3:** decoration, ambient villagers, cosmetic road details, extra flavor text.
- **Explicit removals:** fixed dashboard cards as the main world, large explanatory paragraphs, multiple equal-weight CTAs, decorative objects that obscure state, and text-only building communication.
- **Canvas and access:** 720 x 1280 portrait; responsive safe areas; touch targets at least 52 logical pixels; icon plus color/shape state cues; `zh-CN` default with persisted `en` selection.

## Authorized write set

- `docs/receipts/F-003-DEEPPLAY-001.md`
- `docs/research/2026-07-hay-day-moment-to-moment-gap-study.md`
- `docs/features/F-003-farm-town-foundation-v2.md`
- New independent Figma page/section `CityOfAnimals F003 Farm Foundation V2` in file `uU2Oek5RqFb19CPoGl48lC`
- Read-only inspection of candidate animals/building boards and project runtime

## Forbidden write set

- No Godot runtime, test, scene, project setting, CSV, matrix, accepted asset, or export write under this receipt.
- Do not alter or delete previous Figma pages.
- Do not promote or split candidate artwork before the separate ART-003 receipt.
- Do not implement F-004 or later roadmap features under the F-003 identifier.

## Control-plane result

- Status: `READY`
- Suggested level: `L3`; route owner: `pm_control_plane`
- Fingerprint: `8AB5EA47E594657F43506D5C69F96E5476C3C443109B429C2F5FB620E781BE82`
- Duplicate tasks: none
- Write conflicts: none
- Required milestone separation: research/design review, Figma visual review, asset-promotion review, implementation receipt, behavior acceptance

## Close condition

Close this receipt only after:

1. the research distinguishes observed facts, source-backed facts, inferences, and unverified details;
2. F003-FARM.2 has an implementation-ready general feature specification and exact configuration contracts;
3. the editable Figma register contains the page/section/node references and reviewed previews;
4. the ART-003 and engineering write sets are separately preflighted before any runtime change.
