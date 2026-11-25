# Observed variations

## Purpose and scope

Distinguish de facto patterns from aspirational repository rules.

## Rules and decision criteria

| Classification | Observation | Portable decision |
| --- | --- | --- |
| INCONSISTENT | State uses feature enums, independent flags, and collections. Search and FAQ do not share a universal state class. | Keep each operation's state explicit. Use one enum for mutually exclusive render states and separate refresh/mutation flags when needed. |
| INCONSISTENT | Route bindings commonly use lazy registration. Shell and home also register shared controllers with different lifetimes. | Use route-owned registration by default. Use a shared owner only where multiple routes genuinely share state. |
| INCONSISTENT | Domain repository signatures import data response models. Screen modules can consume repositories owned by other feature roots. Some shared UI is product-aware. | Keep the observed pragmatic contracts. Place cross-feature behavior under a clear owner and move UI to core only when reusable independently of the feature. |
| INCONSISTENT | Repository guidance describes an IndexedStack or equivalent. Source has no IndexedStack usage. | Verify actual shell retention through tab switching and navigation. |
| PROJECT-SPECIFIC | The source requires complete debug network logs. | Use redacted, metadata-first logs in a portable app. |
| NOT IMPLEMENTED | Cubit/Bloc and Equatable/Freezed-driven state are not part of the observed stack. | Apply GetX state and route binding guidance. |

## Implementation workflow and validation

Check normal route entry, exit, and reopening for controller ownership. Compare imports before extracting shared widgets or repository contracts.

## Source evidence

High confidence for exact token scans and inspected examples. See `lib/features/search/controller/search_controller.dart`, FAQ controller, shell binding, and `pubspec.yaml`.

## Related skills

[State and DI](../../state-management/getx/STATE_ARCHITECTURE.md)

## Ownership details

- `MainShellPage.build` renders one active keyed tab in PageStorage and reports activity through AppPageActivity. This can retain registered state and selected scroll offsets independently of mounted widget state. The shell binding registers a permanent customer controller and invokes HomeBinding. Check which data survives tab changes and which user state must be reset on logout.
- `setupLocator` has guarded and unguarded registrations. Its single startup call is the portable default. GetIt lazy callbacks allow declarations before dependencies that resolve later, provided every dependency is registered before first lookup.
- `api_services_imp.dart` owns transport. `NetworkExceptions` also knows Dio exceptions and triggers unauthorized-session handling. Keep that central policy, and consider a narrow injected session invalidator in a new codebase that needs independently testable error conversion.
- Source remote sources sometimes receive storage directly, as Search does for guest adaptation. Preserve an injected boundary when a mode changes the actual API contract. A typed request or injected read-only policy is an alternative when that improves ownership.
