# GetX reactive controllers

| Field | Value |
| --- | --- |
| ID and version | STATE-GETX v1 |
| Status | Validated with the reference combination |
| Source | REF-001 |
| Description | GetxController, Rx/Rxn/RxList, feature enums, Obx and route bindings |
| Dependencies | get and Flutter |
| Supported use | Forms, list and detail states, search, paging, independent operations and selected shell-owned state |
| Limits | App-scoped lifetime requires explicit cleanup. Guard stale state commits and rebuild scope. |
| Compatibility | ARCH-FEATURE + DI-GETIT is validated. Competing owners for the same state are incompatible. Other combinations are unverified. |
| Required skills | [State architecture and lifecycle](STATE_ARCHITECTURE.md), [GetIt handoff](GET_IT_INTEGRATION.md) |
| Templates and workflows | [Feature workflow](../../architecture/profiles/feature-first/FEATURE_WORKFLOW.md), [controller templates](../../architecture/profiles/feature-first/templates/TEMPLATES.md) |
| Validation | Open, leave and reopen the normal route. Test close, async stale responses, repeated actions and narrow reactive updates. |
| Evidence | [Evidence registry](../../knowledge-management/EVIDENCE_REGISTRY.md) |

Controllers own feature state. Leaf widgets may own lifecycle-bound presentation state. App-level services can hold observable shared data when several features have a common owner. GetX supplies reactivity while GetIt can supply the service instance.
