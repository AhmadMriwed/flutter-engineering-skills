# Source registry

| Field | REF-001 |
| --- | --- |
| Analysis date | 2026-11-25 |
| Source revision | 9dea4e1 at refactor verification. The exact prior extraction revision was not separately pinned. |
| Architecture | ARCH-FEATURE |
| State | STATE-GETX |
| DI | DI-GETIT |
| Extracted skills and patterns | Typed remote data path, scope and lifecycle, network errors, model parsing, session cleanup, UI composition, themes, localization, permission and notification handling, quality checks |
| Limitations | Broad file scan and representative traces. No source runtime, device or backend test evidence. |
| Evidence | [Evidence registry](EVIDENCE_REGISTRY.md), [inventory](evidence/PROJECT_ANALYSIS.md), [inconsistencies](evidence/INCONSISTENCIES.md) |

Allocate the next neutral ID after the material is identified. Record revision and analysis date independently. Keep credentials, customer identifiers and private infrastructure details out of portable instructions.


| Field | REF-002 |
| --- | --- |
| Analysis date | 2026-11-25 |
| Revision | 3828a3cf95566fc3869ca90798b680d4bad338c6 |
| Scope | Feature-centered layers, Cubit, GetIt, Dio, Navigator, storage and platform seams |
| Limitations | 477 Dart paths indexed. Representative traces and test source review. Native artifacts, private configuration, obsolete variants and generated code excluded. |
| Evidence | [REF-002 ledger](evidence/REF-002.md) |
