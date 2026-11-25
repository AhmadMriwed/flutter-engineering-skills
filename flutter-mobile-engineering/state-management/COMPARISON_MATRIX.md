# State profile comparison

| Profile | Status | Folder and UI impact | Testing and maintenance | GetIt evidence |
| --- | --- | --- | --- | --- |
| STATE-GETX | Validated | Controller and binding per owning route as needed. Small Obx regions consume observables. | Constructor injection supports fakes. Explicit lifetime, stale response and effect checks are required. | Observed binding resolves repositories from GetIt. Controllers are registered in GetX. |
| STATE-CUBIT | Validated in fixture scope | Cubit and immutable state per feature owner. BlocProvider integrates with Navigator. | Value transitions and deterministic fake tests. Additional state modeling and optional generation. | GetIt factories create route-owned instances. |

Use [selection](STATE_MANAGEMENT_SELECTION.md) when bootstrapping. This matrix compares readiness and observed implementation without rating pending techniques.
