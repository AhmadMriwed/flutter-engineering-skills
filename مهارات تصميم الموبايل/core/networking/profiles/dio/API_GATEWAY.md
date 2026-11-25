# Networking and typed data

## Purpose and scope

Integrate HTTP, models, errors and paging with one gateway.

## Rules and decision criteria

- **API-001 MANDATORY** Centralize endpoints, transport timeouts and per-request headers. Issue calls through ApiServices. Supply JSON Accept and locale; attach auth only for the endpoint policy. Keep transport and UI effects separate.
- **API-002 DEFAULT** Parse envelopes and nested records manually at the remote boundary. Use typed lists and nullable optional fields. Throw or map malformed required values. Coerce number or timestamp variants only when the contract admits them. Give request, record and envelope separate types when they change independently. Define toJson for outgoing contract fields. Extract pagination metadata when reused. Use enums at the boundary where the value set is defined, with an unknown case when appropriate. Shared models belong under shared data only when consumed in multiple features.
- **API-003 MANDATORY** Return `ApiResponse<T>` from the repository. Distinguish an HTTP success carrying backend failure from usable data. Map timeout, connection, cancellation, 401, 403, 404, 422 and server failures centrally. Send actionable validation messages to the form and translated fallback copy to the view.
- **API-004 CONDITIONAL** For search, normalize input, debounce keystrokes, deduplicate only equivalent in-flight queries, and use a generation or cancellation handle so late results cannot overwrite a new query. Reset pages when filters change. For paging, derive the next request from metadata, guard concurrent appends, deduplicate by stable ID, and advance only after successful commit.
- **API-005 CONDITIONAL** Upload fields and files with multipart where specified. Enforce acceptable sizes and file types according to contract. Use the gateway download operation for authorized downloads, with an app-controlled destination and partial-file cleanup when required.
- **API-006 NOT IMPLEMENTED** No verified generic token refresh or automatic transport retry policy. Add a scoped policy only when required, and retry mutations only under the endpoint's idempotency contract.

## Implementation workflow and validation

The source uses Dio connect and receive timeouts of 30 seconds, a per-call header builder, and an optional logging interceptor. It adapts a GET cancellation handle to CancelToken with listener removal in finally. Dynamic base URL and selected-zone browse parameters are source-specific. For a new app, validate the configured HTTPS origin and ensure credentials are sent only to approved hosts.

1. Define cases for OK, empty data, malformed payload, unauthorized, validation error, timeout and cancellation.
2. Validate initial load, pull to refresh, append failure/retry, and out-of-order responses under replaced filters.
3. Keep server field names and status semantics tied to the target API specification.

## Source evidence

High confidence. `lib/core/domain/services/api_services_imp.dart:14–67,119–141,218–255`, `lib/core/domain/error_handler/network_exceptions.dart:182–308,553–584`, `lib/features/orders/controller/orders_controller.dart:123–211`, and Search repository and remote implementations. Shared product JSON readers and pagination metadata show reuse across envelopes.

## Related skills

[Connect API](../../../../architecture/profiles/feature-first/CONNECT_API.md) · [Tasks example](../../../../architecture/profiles/feature-first/examples/TASKS_FEATURE.md)

## Pagination shape and concurrency

The source orders controller keeps state per tab. `loadTab` replaces page one and preserves existing content during refresh. `loadMore` gates on the current page, last page, total and tab request lock, deduplicates non-null IDs, and commits metadata after success. It also reconciles pending notification refreshes after a request finishes. The Tasks sample uses a next-page field and list generation instead. If your backend uses cursors, store the returned opaque cursor and pass it verbatim. Handle an absent continuation as terminal.

Search's request-generation guard blocks stale results, but does not itself stop transport. Use generation checks for UI correctness even when reads can be cancelled. Use a scoped cancel handle to stop network work where supported. Test refresh during append, duplicate pages, empty responses, repeated retry and the same item arriving with changed fields. Whether duplicate records should replace prior values or preserve their current snapshot is a data policy.
