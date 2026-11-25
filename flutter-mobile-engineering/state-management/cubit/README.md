# Cubit state profile

| Field | Value |
| --- | --- |
| ID and version | STATE-CUBIT v1 |
| Status | Validated within the portable example scope |
| Evidence | REF-002 and the [portability checks](../../validation/PORTABILITY_TEST.md) |
| Dependencies | Flutter and flutter_bloc. Freezed is optional. |
| Composition | ARCH-FEATURE + DI-GETIT + Dio + Flutter Navigator |
| Limits | Runtime claims are limited to the documented fixture. Production backends, device behavior and performance need target validation. |

Cubit emits state from explicit commands. Event-driven Bloc has separate event processing and is outside this profile. REF-002 uses Freezed unions and generated equality and copyWith where applicable. Provider creation and borrowing, builder/listener/consumer, and filtered callbacks were observed. BlocSelector and active event-driven Bloc were not observed. Use shared rules for networking, UI, storage and models.

- **CUBIT-001 CONDITIONAL** Establish one owner per invariant and lifetime. Widget-local focus, animation and expansion fit StatefulWidget. Reuse a feature Cubit when screens need the same working state and lifetime. New route-owned editors or independent requests earn separate owners. Share across a flow through the common ancestor or borrow through BlocProvider.value, keeping the owner alive. Use app scope for intentional session or application state and reset account-owned data on session change. REF-002-E01/E05. Check route reopen, direct navigation, account change and exactly one close.
- **CUBIT-002 DEFAULT** Emit immutable value snapshots, using a union for mutually exclusive phases and separate status fields for genuinely independent work. Clone collections and preserve concurrent fields by updating the latest snapshot after await. Distinguish empty, loading and failure where meaningful. REF-002-E02/E03/E05. Check equality, previous snapshots, null clearing and both completion orders.
- **CUBIT-003 CONDITIONAL** Guard repeated submissions, use generation or cancellation for replaceable queries, and check identity and isClosed before applying a late completion. Dispose owned controllers/subscriptions and cancel owned work on close. A non-cancellable mutation may still commit remotely and needs reconciliation. REF-002-E03/E05. Check stale success/failure, retry and leaving the route.
- **CUBIT-004 DEFAULT** Render through BlocBuilder or the builder half of BlocConsumer. Drive effects through listener transitions or explicit action completions, and check mounted after awaits. Select only the values actually consumed in buildWhen and compare effect transitions in listenWhen. Use a stable transition or explicit completion for repeatable effects. REF-002-E02/E05. Check duplicates, route pop and completeness of rebuild dependencies.
- **CUBIT-005 DEFAULT** Use constructor injection and GetIt factories for independently owned Cubits. Compose a new instance in BlocProvider.create. BlocProvider.value borrows an existing instance. Shared repositories can use lazy singleton registration with their own resource lifecycle. REF-002-E01/E05. Check two distinct resolutions and route disposal.

Follow the [implementation workflow](WORKFLOW.md), use the [templates](TEMPLATES.md), and check [compatibility](../../compatibility/COMPATIBILITY_MATRIX.md).
