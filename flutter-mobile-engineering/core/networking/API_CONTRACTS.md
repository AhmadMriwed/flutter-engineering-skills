# Transport and model contracts

Define endpoint, method, auth policy, locale needs, inputs, expected success and failures, then pagination and concurrency. Preserve field names, nullability and types. Separate request, record and envelope when they evolve independently. Parse nested values at the data boundary, and make malformed required fields fail explicitly. Classify transport errors and user actions centrally while keeping renderer-specific copy near presentation.

Guard stale reads and duplicate mutations. Keep previous data during a failed refresh where it is still meaningful. Verify termination and deduplication for paging. Retry only according to the endpoint's semantics and idempotency. Apply declared constraints to files and use trusted hosts. The [Dio recipe](profiles/dio/API_GATEWAY.md) retains the source-proven implementation, its rule IDs and technical details.

For submit-driven lookups, reject overlap and carry cancellation through the repository to the transport. For replaceable queries, verify query identity and owner lifetime before all commits, including errors. A new query invalidates its previous continuation. Source paging with concurrent filters remains an open verification case.
