# CityOfAnimals Production Workflow

Version: WORKFLOW-2

## Authority

- One accountable producer owns priority, shared-file ordering, and final status.
- Design, engineering, and art owners are long-lived role entrances.
- Role owners define contracts, monitor their tasks, and accept results.
- Production is performed by short-lived execution tasks.
- The PM execution operator monitors and refreshes status but cannot make producer decisions.

## Requirement Intake

Natural-language producer requests are valid intake. File behavior-changing requests into a functional source and corresponding configuration source before implementation when required. Do not ask for redundant confirmation when the requested outcome and identity are clear from approved sources.

## Work Order

Use `PM/feature_progress.xlsx` as the advancement queue. Higher priority goes first. Same priority uses ascending feature ID. Completed features are last. Skip only for dependencies, shared locks, or safety blockers and record the reason.

## Execution Task Gate

Every task has one objective, one accountable owner, one primary Skill, one isolated write scope, source baselines, acceptance evidence, cleanup, and close conditions.

The task first submits a read-only receipt. The owner independently reviews it and explicitly authorizes writes. Contract READY is not task READY.

## Runtime And Asset Rules

- Final assets already available must be used completely.
- Missing assets may use explicit development placeholders.
- UI may use temporary visuals; non-UI art targets final quality from first production.
- Candidate and not-runtime assets cannot be read by release/runtime code.
- Mechanical art checks may hand directly to a development preview unless the producer requests art review.

## Player-Facing Language

- Default player locale is Simplified Chinese (`zh-CN`) unless the producer explicitly specifies another locale.
- Settings must offer English (`en`) as a selectable language and persist the player's choice.
- Player-visible strings use locale keys and locale tables; do not add uncatalogued hardcoded runtime UI text.
- An already accepted feature is localized only through a separate approved task contract.

## Default Mobile Presentation

- The default mobile design canvas is portrait `720 x 1280` unless an approved project profile and feature source declare an override.
- Engine defaults must use that viewport. Layouts must scale responsively; do not treat a smaller desktop window as the design target.
- Verify safe areas, touch targets, readable text, and core state changes at `720 x 1280`.
- A landscape or alternate-resolution exception requires a filed producer decision in both the profile and the affected feature source.

## Mandatory Penpot UE and UI/UX Handoff

Every new or materially revised player-facing design, functional specification, product plan, or feature plan that defines UI, interaction, client behavior, or a UE flow must complete this gate before its UI/UE design is accepted:

1. Apply `ui-design-priority`: identify the single primary decision, rank P0-P3 content, define full state coverage, map dynamic elements to data, and check text fit, touch targets, contrast, and color-independent cues.
2. Create editable Penpot artifacts: use named boards/frames/components for screen layouts and named vector/connector groups for system, UI interaction, state, reward, and UE/client flows.
3. Record a `Penpot UE & UI/UX Artifact Register` in the planning source with `penpot_url`, `workspace_id`, `project_id`, `file_id`, `page_or_board`, `object_refs`, `source_version`, `owner`, `review_state`, `coverage`, and `local_source_backup`.
4. A document/PDF may show a preview, but the authenticated, editable, read-back-verified Penpot file is the review and change source of truth. Mermaid, PNG, SVG, PDF, browser-open state, or local import source alone is insufficient.
5. If Penpot authentication, creation, import, or object-level readback is unavailable, file `PENDING: Penpot editable source creation/readback` with an accountable owner and next action; do not call the plan's UI/UE section complete.

Pure research that defines no player interaction may be marked `Not applicable` with reason and owner. Historical accepted Figma/FigJam sources remain valid evidence; Penpot is the selected editable source for new or materially revised CityOfAnimals work under `PD-003`.

## Evidence

Real player-visible behavior is preferred. Exit code zero, parsing, file existence, or direct callback tests cannot replace a real behavior requirement.

## Monitoring

Monitor the current batch on a short interval. Refresh the workbook on a slower interval. Healthy checks remain quiet. Report exceptions, decisions, playable previews, and completion.

## Stuck Task Replacement

Inspect files, processes, outputs, and locks. Start a read-only replacement candidate, verify handoff, switch the unique task/role identity, then archive the old task. Never permit dual writers.

## Completion

Verify acceptance, regression, authorized files, placeholder/runtime boundaries, temporary cleanup, process exit, lock release, task archive, workbook update, and selection of the next feature.
