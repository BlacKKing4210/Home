# F003-VQ.1 Runtime Parity Checklist

**Review pass:** 2026-07-25 final independent producer review  
**Result:** `RUNTIME_SLICE_APPROVED`  
**Scale-out:** `NOT APPROVED`

## Source and scope

- [x] Formal F003 source and accepted baseline identified.
- [x] F004 blocked/skip reason recorded and F004 write lock preserved.
- [x] Exact F003-VQ.1 write set and task fingerprint recorded before runtime writes.
- [x] Visual quality contract approved before implementation.
- [x] Existing runtime asset manifest unchanged; no candidate or `NOT_RUNTIME` path referenced.
- [x] New Figma attachment failure recorded as Pending; no material UI redesign performed.

## Player-visible hierarchy

- [x] Mature crop is the first local focal point in the farm district.
- [x] Ready, success and blocked states use shape, motion and value—not color alone.
- [x] Building silhouettes remain legible behind the farm interaction.
- [x] Ground pattern is lower frequency and lower contrast than P0/P1 objects.
- [x] Crop-to-granary cause is readable without opening text panels.

## States

- [x] Default/empty.
- [x] Ready/interactive.
- [x] Successful harvest feedback.
- [x] Successful settlement.
- [x] Granary-full failure with mature crop retained.
- [x] Reduced-motion equivalent.
- [x] Rapid repeated activation with bounded concurrency.
- [x] Panel interruption clears visual-only effects.
- [x] Exit/tree interruption clears visual-only effects.
- [x] Loading: not applicable; this slice introduces no asynchronous load or new resource.

## Native runtime and interaction

- [x] Godot-native dynamic draw layer; no screenshot used as runtime UI.
- [x] Feedback layer ignores mouse/touch and focus.
- [x] Logical world position, model, collision, focus and hit rectangles remain unchanged.
- [x] Existing 720 x 1280 target and responsive design transform remain active.
- [x] Existing settings, navigation and player-visible localized text remain dynamic.
- [x] Normal `project.godot` player entry completed a successful harvest.
- [x] Normal player entry completed a capacity-blocked harvest without data loss.
- [x] 遗留 Godot 崩溃对话框已用 Windows 事件时间与 PID 归因；当前入口未复现并正常退出。

## Visual QA

- [x] No crop or focus ring clipped at the default camera.
- [x] Tutorial pan hint leaves after first field interaction and does not cover mature crops.
- [x] Success arc is visible over both world and HUD without intercepting input.
- [x] `+产量` plate has light background, teal outline and dark text.
- [x] Failure keeps the crop visible and highlights both source and capacity target.
- [x] Reduced-motion state conveys source, destination and amount without moving particles.
- [x] Six 720 x 1280 OpenGL captures and a comparison board visually inspected.

## Performance and regressions

- [x] Static observed FPS above 60 on the recorded Windows prototype environment.
- [x] Four concurrent effects observed FPS above 60 on the recorded Windows prototype environment.
- [x] Draw calls and primitive count recorded for static and active states.
- [x] Static and peak memory recorded.
- [x] FARM.2 behavior regression passed.
- [x] Historical F003 regression passed.
- [x] Normal main scene smoke passed with no script error.
- [ ] Android physical-device performance and touch validation—not part of this desktop slice.

## Severity closure

| Severity | Open count | Disposition |
|---|---:|---|
| BLOCKER | 0 | Gate clear |
| MATERIAL | 0 | Gate clear |
| POLISH | 3 | Figma attachment, approved audio, Android device validation remain explicitly out of scope |

This checklist approves only F003-VQ.1. It does not authorize F004 runtime work or broad visual scale-out.
