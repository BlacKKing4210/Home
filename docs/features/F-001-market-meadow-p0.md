# F-001 Market Meadow P0 - Functional Specification

**Version:** F001-P0.1  
**Status:** SOURCE READY / EXECUTION LOCKED  
**Owner:** Codex /root, producer and P0 source owner  
**Target:** Godot 4.6, portrait 720 x 1280 desktop/mobile input prototype

## Product and commercial-safety boundary

Market Meadow is an original animal-town management prototype for CityOfAnimals. It may use the broad, genre-common loop of growing resources, converting them in a workshop, fulfilling a local delivery, and expanding a small settlement. It must not copy Township or any other commercial game's names, art, maps, characters, recipes, text, interface hierarchy, layout, economy, assets, or implementation.

The initial visual language uses Unicode emoji and original geometric SVG placeholders only. Do not generate raster art, scrape reference art, or import external commercial assets. Fisher is a user-owned implementation reference for a 720 x 1280 portrait canvas, flat outlined cards, high-contrast action states, and deterministic custom hit testing only. CityOfAnimals must use an original screen composition, labels, and content.

## Research gate

- Generic genre-loop research: **PASS**. Successful multi-query general search supports the non-proprietary pattern `grow -> process -> fulfill -> reward -> expand` and highlights timer/inventory opacity as a common prototype risk.
- Zhihu research: **DEGRADED**. A direct Jina Reader request timed out; proxy retry failed during Windows TLS credential acquisition. No Zhihu content is used in this design.
- Producer decision: **approved for a technical P0 only** because all selected mechanics are generic, original, and testable. A QA review is required before any user-facing demo claim.

## Player promise

"Plan one tiny production chain, then watch your animal town gain a visibly useful new place."

The player should finish the first loop in under two minutes without a guide: plant a Sunseed, collect Grainleaf, make a Meadow Loaf, complete a Market Cart, then unlock a plot.

## In-scope loop

1. The player taps an empty Meadow Plot to sow one **Sunseed**.
2. The plot becomes **Growing** for 6 real-time seconds and displays a clear countdown.
3. The player taps the ripe plot to collect one **Grainleaf**.
4. With two Grainleaf in stock, the player taps **Crumbworks** to queue one **Meadow Loaf** for 5 seconds.
5. The player taps the completed workshop to collect the loaf.
6. The player taps **Market Cart** when it has one Meadow Loaf to receive coins and renown.
7. The player may spend coins to unlock the fourth plot, visibly changing the town.

## Initial state and rules

| Element | Starting state | Rule |
|---|---:|---|
| Meadow Plots | 3 open, 1 locked | Open plot accepts one crop at a time. |
| Sunseed | Infinite prototype supply | No purchase or premium currency. |
| Grainleaf | 0 | Maximum 8; full inventory gives feedback and does not silently consume a crop. |
| Meadow Loaf | 0 | Maximum 4. |
| Crumbworks | Idle | Needs 2 Grainleaf; one active job at a time. |
| Market Cart | Needs 1 Meadow Loaf | Gives 24 coins and 1 renown, then refreshes with the same prototype order. |
| Coins | 12 | Fourth plot costs 30 coins. |
| Renown | 0 | Display only in P0; no rank gate. |

## Screen and interaction requirements

- Use an original 720 x 1280 portrait Control screen with a clear top resource bar, central town board, and bottom action/status area.
- Render gameplay objects with emoji plus original vector panels: `🌱`, `🌾`, `🥖`, `📦`, `🦊`, and simple SVG badges. Emoji are placeholder content, not final art.
- Adapt Fisher's generic interaction principles: a stable portrait design canvas, flat outlined surfaces, obvious enabled/disabled states, pointer/tap feedback, and hit regions that match the visible control.
- Every tap either changes visible state or shows a concise feedback message. Never leave a visible control silently inert.
- A user can complete the loop with mouse; touch events use the same path.
- Include reduced-motion-safe state changes. Any feedback animation applies only to visual children and is resettable.

## Explicit non-goals

- No proprietary game replication, brand references, map/rail/train systems, social systems, monetization, premium currency, timers longer than ten seconds, persistence, networking, external art, generated raster art, or copied Fisher screens.
- No mobile store release or commercial-use claim from this P0.

## Acceptance criteria

1. A player can execute plant -> grow -> harvest -> process -> collect -> order in one fresh run and sees each material count and reward change.
2. Growth and production cannot be claimed early; the UI presents a countdown and a reason when the player taps too early.
3. An insufficient-material, inventory-full, locked-plot, and busy-workshop interaction each provides visible feedback without corrupting state.
4. Completing an order allows the player to unlock the fourth plot after a second order; the lock changes into an interactive empty plot.
5. Visible controls and their hit regions are behavior-tested at their centers and edges. A headless model test plus a normal runtime launch must pass.
6. Runtime only reads `config/tables/f001_market_meadow.csv` for P0 numeric content; placeholder SVG/emoji remain under project control.

## Open questions after P0

- Does the initial 6s/5s cadence feel satisfying without feeling like a wait wall?
- Is four open/locked plot feedback legible at 720 x 1280?
- Which original art direction should replace emoji after the interaction loop is accepted?
