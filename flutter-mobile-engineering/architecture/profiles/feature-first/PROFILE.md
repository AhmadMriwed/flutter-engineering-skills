# Feature-first API layered profile

| Field | Value |
| --- | --- |
| ID and version | ARCH-FEATURE v1 |
| Status | Validated with the reference combination |
| Source | REF-001 |
| Description | Feature-owned controllers, repository contracts, data adapters and shared infrastructure |
| Supported use | API-backed features and static screens inside one Flutter app |
| Limitations | Repository signatures may expose DTOs. No prescribed use-case or entity layer. No observed automatic cycle enforcement. |
| Dependencies | Flutter and selected integrations. The validated recipe uses GetX, GetIt, Dio and GetStorage where needed. |
| Compatible profiles | STATE-GETX or STATE-CUBIT with DI-GETIT in their respective matrix scopes |
| Incompatible combinations | None established beyond role and lifecycle conflicts in the compatibility rules |
| Required skills | [Layers, folder layout and flow](ARCHITECTURE.md), [feature workflow](FEATURE_WORKFLOW.md), [API integration](CONNECT_API.md) |
| Templates and example | [Templates](templates/TEMPLATES.md), [Tasks](examples/TASKS_FEATURE.md) |
| Validation | Trace a static screen and a remote route through composition, success, failure and disposal. See [audit](../../../validation/ARCHITECTURE_VALIDATION.md). |
| Evidence | [Reference source registry](../../../knowledge-management/SOURCE_REGISTRY.md) |
