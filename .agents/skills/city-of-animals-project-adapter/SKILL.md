---
name: city-of-animals-project-adapter
description: Load and enforce CityOfAnimals formal project context before any design, engineering, art, UI, QA, documentation, or asset task. Use before the task's primary domain Skill.
---

# CityOfAnimals Project Context Adapter

## Start

1. Read `docs/WORKFLOW.md`, `docs/project_profile.yaml`, `docs/active_scope.yaml`, and `docs/PM_HANDOFF.md` in that order.
2. Read `docs/task_contract.md`, the relevant functional source from `docs/design_index.md`, and the relevant numeric or configuration source from `docs/config_index.md`.
3. Read `PM/feature_progress.xlsx` to select work by priority and ascending feature ID.
4. Verify goal, scope, non-goals, accountable owner, dependencies, allowed files, shared locks, baselines, acceptance evidence, and required Skills.
5. Return `READY`, `CONCERNS`, or `NOT READY` before loading the task's primary domain Skill or writing files.

## Boundaries

- Project root: `D:\AI\CityOfAnimals`.
- Engine: Godot 4.6; use GDScript and CSV-driven configuration unless approved project sources specify otherwise.
- Do not infer source-of-truth facts from old chat text when formal files exist.
- Do not write before the first read-only receipt has been independently accepted by the accountable owner.
- Stop on source, contract, Skill, baseline, lock, or acceptance conflict.

## Handoff

After this adapter returns `READY`, load `game-studio-orchestrator` plus the task's one primary domain Skill. Pass only task-relevant facts, preserve one accountable producer, and return evidence mapped to the task acceptance criteria.