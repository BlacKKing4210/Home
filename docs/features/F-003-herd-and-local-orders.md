# F-003 Herd and Local Orders - Functional Specification

**Version:** F003-FARM.1  
**Status:** IMPLEMENTED / VISUAL CAPTURE PENDING  
**Owner:** Codex /root, producer and source owner  
**Target:** Godot 4.6, mobile portrait 720 x 1280

## Product and commercial-safety boundary

F-003 expands CityOfAnimals with an original farm-production loop. It may use the genre-common ideas of animal care, processing buildings, local orders, and later logistics unlocks. It must not reproduce Township, Hay Day, Supercell, Playrix, or any other commercial game's names, buildings, recipes, art, maps, interface layout, order design, progression values, assets, or code.

All current visuals remain project-owned GDScript vector primitives plus the existing approved emoji/SVG development placeholders. No scraped assets, generated raster art, brand terms, screenshots, or copied layouts may enter the runtime.

## Player promise

"A field can feed a living farm: crop becomes animal material, material becomes a crafted good, and several local orders give me a meaningful delivery choice."

## Smallest closed loop

`plant -> Grainleaf -> Willow Pen -> soft fleece -> Threadmill -> yarn roll -> choose a local order -> coins and renown`

The existing loaf path remains a parallel short order. Grainleaf is intentionally shared between the bakery and the Willow Pen, so the player chooses which next order to prepare rather than receiving disconnected content.

## F-003 scope

1. Add **Willow Pen**: spend one Grainleaf, wait seven seconds, then collect one Soft Fleece.
2. Add **Threadmill**: spend two Soft Fleece, wait seven seconds, then collect one Yarn Roll.
3. Replace the single-purpose delivery target with an original **Order Board** and delivery van treatment that exposes three selectable local orders:
   - existing Market Cart loaf order: 1 Meadow Loaf -> 24 coins + 1 renown;
   - Fleece Bundle: 1 Soft Fleece -> 18 coins + 1 renown;
   - Yarn Crate: 1 Yarn Roll -> 42 coins + 2 renown.
4. Every production building uses the same visible `idle -> busy -> ready -> collect` contract. Input shortage, busy, full output storage, and insufficient order material always produce localized feedback.
5. Keep all player-facing strings in locale tables. First launch remains `zh-CN`; English remains selectable and persistent in Settings.
6. Make 720 x 1280 portrait the engine and project-profile default. The board must preserve direct touch targets and readable icon/count states at that size.

## Data contract

| Source | Owner | Contract |
|---|---|---|
| `config/tables/f001_market_meadow.csv` | F-001 | Sealed original crop, bakery, loaf order, currency, and field values. |
| `config/tables/f003_farm_content.csv` | F-003 | Adds animal/process buildings, inventories, and two new local orders through the existing 14-column schema. |
| `config/tables/f002_town_ui.csv` | F-002 | Sealed locale catalog for accepted labels and feedback. |
| `config/tables/f003_town_ui.csv` | F-003 | Adds all F-003 labels, actions, item names, and feedback keys. |

Initial values: Soft Fleece capacity 6; Yarn Roll capacity 3; Willow Pen output 1 Soft Fleece/7s from 1 Grainleaf; Threadmill output 1 Yarn Roll/7s from 2 Soft Fleece. No premium currency, timed real-world orders, save progression, networking, or new currency is added.

## Visual and interaction hierarchy

**Primary decision:** choose the next physical farm object or the local order that advances the shared supply chain.

| Priority | Runtime content | Treatment |
|---|---|---|
| P0 | Fields, bakery, Willow Pen, Threadmill, three order tickets | Large direct world-object targets; icon/silhouette, count, state ring, and short action pill. |
| P1 | Four inventory counts, coins, renown, delivery rewards | Compact item chips and ticket reward icons. |
| P2 | Context feedback and language settings | One short footer ribbon and the existing settings tray. |
| P3 | Fences, path, smoke, sheep-like wool shapes, thread wheel, flowers | Original decorative primitives only; never the only state cue. |

The Order Board presents three side-by-side visual tickets. A ticket shows item icon, required count, and reward icons. It is tappable even when short on materials so that failure feedback explains the missing item; it never silently ignores a tap.

## Deferred logistics roadmap

These are filed direction, not F-003 code or acceptance scope:

| Planned feature | Unlock concept | Original gameplay contract |
|---|---|---|
| F-004 Rail Freight Depot | Renown 6 | A two-item freight manifest, 15-second loading state, and a visible departing rail cart. |
| F-005 Cloud Cargo Port | Renown 12 | A three-good long-distance cargo request, 20-second loading state, and a visible sky-cargo departure. |

F-004 and F-005 require their own functional/configuration sources, contracts, and behavior evidence before implementation. They must not be implied by a decorative train, airplane, timer, or disabled button in F-003.

## Explicit non-goals

- No commercial-game replication, external art, raster generation, copied naming, copied order UI, branded train/aircraft, world map, characters, monetization, premium currency, real-time appointments, social features, networking, persistence beyond language preference, camera controls, or new scene.
- No change to F-001 crop/bakery/loaf/economy values or F-002 locale behavior.
- No F-004/F-005 runtime code, unlock gates, placeholder rails, or placeholder aircraft.

## Acceptance criteria

1. On a normal 720 x 1280 launch, fields, bakery, Willow Pen, Threadmill, and a three-ticket local Order Board are recognizable as different direct objects rather than a text-card list.
2. A player can complete Grainleaf -> Soft Fleece -> Yarn Roll -> Yarn Crate in one fresh run, with every material and reward transition observable.
3. The original loaf loop, plot unlock, Chinese first launch, English setting persistence, and F-001 numeric values continue to work unchanged.
4. The player can fulfill each of the three local orders through its visible ticket; missing materials, busy buildings, and full Soft Fleece/Yarn Roll inventories retain state and show localized feedback.
5. Deterministic tests cover the two new production chains, all three orders, failure paths, direct-object centre/edge hit targets, and the original regressions. A normal runtime launch and reviewed 720 x 1280 capture prove player-visible behavior.
6. `project.godot`, project profile, project workflow, and the selected common workflow use 720 x 1280 portrait as the mobile default. A scan finds no protected commercial-reference terms or external asset paths in F-003 runtime files.
