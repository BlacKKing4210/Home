# CityOfAnimals Workspace Rules
## Current Adaptive Game Workflow

This is the current common game-workflow rule and takes precedence over later generic workflow wording in this file. Preserve every project-specific rule, approved design, engine constraint, and data pipeline as the project adapter.

Use `game-studio-orchestrator` from the personal `game-studio-agent-workflow` plugin as the primary workflow. Load `game-project-control-plane` for intake, state synchronization, task deduplication, write-lock checks, evidence tracking, and adaptive routing. Keep exactly one accountable producer; the control plane is the producer-facing coordination surface, not a second producer.

Classify requests as discussion, producer decision, execution request, status query, or reusable-method candidate. Use the smallest safe level: L0 inline discussion/status, L1 direct low-risk single-domain execution with reproducible checks, L2 bounded work with separate review, L3 only the needed design/engineering/art owner for cross-domain, shared, high-risk, milestone, or concurrent work, and L4 for unresolved material or irreversible choices. If profile, priority, active-scope, ownership, or write-lock sources are absent, return NOT READY instead of inventing state.

Before any production write, confirm the formal source, owner, primary Skill, task fingerprint, non-conflicting write set, baseline, acceptance, evidence, and cleanup conditions; record a read-only receipt. Use the priority matrix when it exists: higher priority, then ascending feature ID, with skip reasons recorded. Close only with behavior or asset evidence, scoped regression, cleanup, and returned shared locks.

The explicit-user-request rule for agent creation remains absolute: L2/L3 describe the required review or ownership level, but never create, spawn, fork, delegate to, or start an agent, sub-agent, Codex task/thread, worktree task, or execution task unless the user explicitly requests it. Otherwise continue with the current agent or ask for authorization when a separate actor is genuinely required.

`codex-game-studio-default` is supplementary only for engine, art, UI, Sprite Forge, procedural motion, CSV data, and QA conventions; it must not replace this workflow's orchestration order.

## Feature Design Document Standard Default

For every formal game feature, system, activity, UI/UE, or gameplay-subsystem specification, load the globally installed personal Skill `game-feature-design-docs` and use `C:\Users\76398\Documents\Codex\standards\game-design\feature-design-document-standard.md`.

Use `game-feature-design-docs/assets/general-feature-design-template.docx` for general features and `game-feature-design-docs/assets/simple-feature-design-template.docx` for simple features. The same templates are available globally as `artifact-template-game-feature-design-general` and `artifact-template-game-feature-design-simple`.

Treat `B-庇护所.docx` as the general-document reference and `Z-在线奖励.docx` as the simple-document reference. Choose by system complexity, not page count; default to the general template when the feature is new, cross-system, multi-screen, multi-state, configuration-heavy, or interruption-sensitive. The simple template must still contain versioning, TOC, objectives, overview, editable UE flow, exact configuration sources, core logic, boundaries, UI behavior, art/audio/telemetry requirements, related systems, and QA acceptance. If a simple feature grows beyond those limits, migrate it to the general template before implementation continues.

Create final system, UE, swimlane, state, and page-spec diagrams in the project's selected editable design source with clear PNG/PDF exports linked from the DOCX. For CityOfAnimals the selected source is Penpot under `PD-003`. Mermaid, ASCII, text arrows, standalone SVG, and Visio-only diagrams are drafts or import sources, not final planning artifacts. The producer-reviewed Word, Penpot, and configuration files are the source of truth.

## AnySearch Primary Search Default

For all external information retrieval and research discovery, use the installed `anysearch` Skill and `https://www.anysearch.com/home` as the primary search method. Project files, supplied documents, approved decisions, and other local formal sources still come first when they already answer the question.

- Begin external discovery with AnySearch `search` or `batch_search`.
- For a supported vertical domain, call `get_sub_domains` first and include every required parameter. When domain overlap is uncertain, use a hybrid batch with one general query and the relevant vertical queries.
- Treat AnySearch results and snippets as discovery evidence, not final authority. Follow decision-critical results to the original source and prefer official documentation, official repositories, release notes, standards, research papers, and first-party statements.
- Use GitHub CLI, Jina Reader, Exa, authenticated platform tools, RSS, video tools, or a supported browser as targeted follow-up sources, exact-platform evidence routes, or fallbacks. An AnySearch result that links to a platform does not count as an independent platform check.
- If AnySearch is unavailable, retry the AnySearch route directly, then through the approved local `7890` proxy, then through the supported browser flow. After those attempts, use the existing authorized specialist fallback and record `DEGRADED: AnySearch unavailable`; never claim that AnySearch succeeded.
- Do not send passwords, tokens, private keys, personal data, or project secrets in AnySearch queries. Keep raw search packets under `~/.agent-reach/research/<project>/` or the operating-system temp directory, not in the project.
- Record the query families, AnySearch access state, result URLs, original sources, dates/versions, conflicts, evidence level, remaining unknowns, and the effect on the decision.

## Alibaba Cloud Server Deployment Default

All persistent server-side components for every game project must be deployed to the producer-owned Alibaba Cloud environment. The local workstation is never a server deployment target.

- This includes dedicated/game servers, account/auth services, gateways, matchmaking/ranking services, live-ops/admin APIs, databases, caches, queues, reverse proxies, TLS endpoints, storage/backup workers, and scheduled server jobs.
- Local work is limited to source editing, client development, versioned builds, static checks, unit tests, pure mocks/stubs, and short-lived isolated test doubles. Do not install or leave persistent server daemons, production-like databases, reverse proxies, persistent server containers, certificates, exposed service ports, scheduled jobs, or authoritative server data on the workstation.
- Production-like integration, smoke, persistence, restart/reboot, and release acceptance must target an authorized Alibaba Cloud staging/test or production endpoint. Local mocks, probes, and passing exit codes are not server deployment evidence.
- Release/runtime client configuration must never point to `localhost`, `127.0.0.1`, a LAN address, or a workstation path. Use the approved Alibaba Cloud DNS/domain and ports.
- Before any remote write, load `production/deployment/aliyun-profile.yaml` or its formally declared project equivalent. It must identify the environment, SSH alias, host role/region/OS, domains/ports, runtime/service paths, dependencies, TLS/reverse proxy, health checks, backup, rollback, monitoring, and ownership.
- Keep passwords, tokens, private keys, and secret values out of repositories, documents, logs, and chat. Use SSH agent/config or an approved secret store.
- If the profile, target environment, authorization, backup, or rollback facts are absent, return `NOT READY: Aliyun deployment profile`; do not guess IPs, domains, ports, paths, accounts, or credentials.
- Adding this default does not itself authorize a live deployment. Remote deployment requires an explicitly scoped target, environment, and change authorization.
- Deploy in order: read-only remote preflight and baseline; versioned build artifact; backup and migration plan; upload to Alibaba Cloud staging/test; remote start/restart; health/TLS/port/log/version checks; real external client/package validation; persistence and restart/reboot validation; rollback proof; then production promotion after acceptance.
- Completion evidence must name the Alibaba Cloud environment and deployed version, remote service state, endpoint, health result, relevant logs, persistent-data result, external client/package result, and rollback status.
- Use another server location only when the producer explicitly approves the exception in the project's formal deployment source.

## Mandatory Default Game Workflow

For every game-design, development, UI, art, QA, balance, planning, implementation, monitoring, or release request in this project, use `game-studio-orchestrator` from the personal `game-studio-agent-workflow` plugin as the primary workflow. This is mandatory even when the user only says “use the default workflow”, “start/continue the game”, “开始做游戏”, “继续开发”, or “接管项目”.

At the beginning of every task, load `city-of-animals-project-adapter`, then follow `game-studio-orchestrator`: one accountable producer, read-only receipt before writes, explicit write ownership, feature-progress ordering, and behavior-level acceptance evidence. `codex-game-studio-default` is supplementary only for engine, art, UI, data, and QA conventions; it must not replace the primary workflow.

If the plugin Skill is not present in the current task's Skill list, load the verified local fallback before taking any project action:
`C:\Users\76398\plugins\game-studio-agent-workflow\skills\game-studio-orchestrator\SKILL.md`.

## Default Player-Facing Language

All player-facing game UI, onboarding, tutorials, system feedback, errors, settings labels, prototype text, and player-facing design documents default to Simplified Chinese (`zh-CN`) unless the producer explicitly selects another locale.

Every new game must provide an in-game language selector in Settings, with `zh-CN` as the first-launch default and English (`en`) as a selectable option. Persist the player's selection through the project's preferences system. Player-visible text must use locale keys and locale tables rather than uncatalogued hardcoded UI strings. Retrofitting an already accepted feature still requires its own approved task contract.

## Default Mobile Presentation

Unless an approved project profile and feature source explicitly choose another target, every mobile game screen uses a **720 x 1280 portrait** design canvas. Configure the engine with that viewport as its default, then use responsive scaling rather than designing at a smaller desktop size. Verify safe areas, touch targets, readable text, and state transitions at 720 x 1280; any resolution or orientation override must be filed in the project profile and the affected feature source.

## Mandatory Penpot UE and UI/UX Handoff

For every new or materially revised player-facing game design, functional specification, product plan, or feature plan that defines UI, player interaction, client behavior, or a UE flow:

1. Use `ui-design-priority` before drawing. Define the screen/state's single primary decision; rank P0-P3 information; then define entry, exit, loading, empty, disabled, failure, success, interrupted states, data sources, touch/text/contrast checks, and explicit removals.
2. Produce editable Penpot artifacts, not only a static export. Use Penpot boards/frames/components for editable screen layouts and named vector/connector groups for system, UI interaction, state, reward, and UE/client flows.
3. Attach a `Penpot UE & UI/UX Artifact Register` to the planning document with the Penpot URL, workspace/project/file ID, page or board name, object references, source version, owner, review state, diagram/frame coverage, and local editable-source backup.
4. Insert a review preview or link in the document/PDF, but treat the authenticated, editable, read-back-verified Penpot file as the source of truth. Mermaid, PNG, SVG, PDF, browser-open state, or a local import source alone cannot satisfy this handoff.
5. Do not mark the plan's UI/UE portion design-complete without a verified editable Penpot link and object-level readback. If Penpot authentication, creation, import, or readback is unavailable, record `PENDING: Penpot editable source creation/readback` with an owner and next action; do not silently downgrade to a static diagram.

Pure research with no player interaction may record `Not applicable` with a reason and owner. Historical accepted Figma/FigJam documents remain valid historical evidence and are not retroactively invalidated, but Penpot is the current source for new or materially revised CityOfAnimals work.
 
## Producer Takeover Phrases

When the producer says `you are the PM`, `take over PM`, `continue as PM`, `start PM`, or an equivalent phrase:

1. Read `docs/PM_HANDOFF.md`.
2. Follow its source order to read the workflow, Profile, active scope, and feature progress workbook.
3. Stay read-only until the handoff sources are verified.
4. On success, reply exactly: `I have taken over the previous PM's file-based handoff.`
5. Prove the takeover by listing workflow version, accountable roles, active tasks, blockers, and takeover state.
6. After READY, update the unique producer identity and archive the old producer entry. Never keep two active producers.

All work follows `docs/WORKFLOW.md`, `docs/project_profile.yaml`, and `docs/active_scope.yaml`.
