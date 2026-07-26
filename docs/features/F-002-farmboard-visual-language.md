# F-002 Farmboard Visual Language - Functional Specification

**Version:** F002-VIS.1  
**Status:** SOURCE READY / EXECUTION LOCKED  
**Owner:** Codex /root, producer and source owner  
**Target:** Godot 4.6, portrait 720 x 1280 desktop/mobile prototype

## Product and commercial-safety boundary

F-002 changes how the existing Market Meadow loop is communicated, not the loop itself. It uses genre-common farming-game readability: a farm field as the primary play surface, recognisable production buildings, compact item counters, and item-picture order bubbles. The direction is informed by a visual review of public Hay Day farm and order screenshots: fields, production machines, delivery vehicles, and item icons make the next action legible before a player reads an explanation.

CityOfAnimals must remain an original game. Do not copy Hay Day, Township, Supercell, Playrix, or any other commercial game's art, UI layout, maps, buildings, names, characters, recipes, assets, screenshots, or code. All F-002 visuals are constructed from project-owned GDScript vector primitives and the existing original SVG placeholders. No external images, scraped reference art, generated raster art, or commercial-brand strings enter runtime paths.

## Player promise

"I can see my small farm working: fields grow food, the oven transforms it, and the delivery van rewards me."

## Design decision and hierarchy

**Primary decision:** choose the farm object that advances the current chain.

| Priority | Content | Presentation |
|---|---|---|
| P0 | Open field, growing field, ripe field, bakery, delivery van | Large directly tappable world objects with state silhouettes and short action bubbles. |
| P1 | Grainleaf, loaf, coins, renown, timer, order requirement | Compact object icons with counts, progress ring, or a single item bubble. |
| P2 | Outcome explanation and language selector | One short bottom status ribbon and a compact settings tray. |
| P3 | Paths, fences, cloud, flowers, smoke, and hover highlight | Original decoration only; it may not conceal state or create a new system. |

## In-scope behavior

1. Replace the text-card board with a single original Farmboard. Four physical field patches, a bread bakery, and a delivery van occupy stable spatial positions.
2. Fields visually distinguish `empty`, `growing`, `ripe`, and `locked` without relying on long labels. A growing field shows a visible countdown ring; a locked field shows the configured coin cost with a padlock.
3. The bakery visually shows input Grainleaf, baking progress, and a ready loaf. The delivery van shows the required loaf and coin/renown reward as icons.
4. Retain the exact F-001 data and transition rules: Sunseed 6 seconds, two Grainleaf into one Meadow Loaf in 5 seconds, 24 coins and one renown per delivery, and a 30-coin fourth-field unlock.
5. Default all F-002 player-visible text to Simplified Chinese. A settings gear opens a language tray that switches between `zh-CN` and `en`; the selected language persists through project preferences.
6. Use the F-002 language CSV for every F-002 label and feedback message. No new uncatalogued player-visible strings may be hardcoded in runtime UI or model code.
7. Mouse and touch use the same direct-object hit paths. Every valid or invalid tap causes a state change or a concise visible status result.

## Explicit non-goals

- No change to economy, recipes, timers, capacity, plot count, save-game progression, social features, monetization, networking, camera movement, or new product content.
- No world-map imitation, character imitation, commercial visual reference reproduction, raster art generation, or asset scraping.
- No replacement of the existing F-001 test loop with a visual-only demonstration.

## Acceptance criteria

1. A fresh runtime shows a farm-like play canvas with recognisable fields, bakery, and delivery van; the prior repeated text-card layout is absent.
2. The complete F-001 loop remains playable through direct taps on the visible fields, bakery, and van, including fourth-field unlock after two deliveries.
3. `empty`, `growing`, `ripe`, `locked`, bakery `idle/busy/ready`, and delivery-missing/ready states are distinguishable from icons, silhouettes, counts, or progress without reading a paragraph.
4. First launch defaults to `zh-CN`; Settings offers `en`, switches visible labels and feedback, and the choice is reloaded on the next normal launch.
5. The deterministic Godot test covers model transitions, language-catalog lookup, persisted locale behavior, and visible object hit regions. A normal isolated runtime launch and a captured runtime image verify player-visible behavior.
6. A runtime scan finds no `Hay Day`, `Township`, `Supercell`, `Playrix`, or external reference asset path in changed runtime files.

## Visual asset contract

| Object | Runtime treatment | State cues | Replacement boundary |
|---|---|---|---|
| Field | GDScript soil, grass, crops, and padlock primitives | soil, sprouts, grain heads, ring, lock | Development vector placeholder; replace only through an approved art task. |
| Bakery | GDScript roof, chimney, wall, door, bread, smoke primitives | grain input, timer, bread-ready bubble | Development vector placeholder; replace only through an approved art task. |
| Delivery van | GDScript van, wheel, cargo bubble, coin/star primitives | missing loaf, ready cargo, reward | Development vector placeholder; replace only through an approved art task. |
| Resource counters | Existing project SVG/primitive icons plus counts | visible item identity and capacity | Development UI iconography; no commercial source. |

## Research note

Reference review is used only for the inference that spatially placed farm objects and item-picture orders reduce explanatory text. This feature does not reproduce a reference screen. Public screenshots used during review include an order-board example and farm-layout examples; they are not copied into this repository or runtime.
