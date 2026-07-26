# Current-Batch Heartbeat Checklist

1. Read `docs/active_scope.yaml`.
2. Inspect only active batch tasks and required dependencies.
3. Verify latest receipt, owner authorization, Skills, write scope, baselines, shared locks, recent progress, and process state.
4. Check candidate/not-runtime leakage and temporary output boundaries.
5. Detect stalls from output, tool, process, and receipt evidence.
6. Report exceptions immediately; keep healthy checks quiet.
7. Refresh `PM/feature_progress.xlsx` when due or explicitly requested.
8. Preserve Nine Dimensions as the first sheet, `Not needed` labels, formulas, priority/feature-ID order, and completed rows last.
