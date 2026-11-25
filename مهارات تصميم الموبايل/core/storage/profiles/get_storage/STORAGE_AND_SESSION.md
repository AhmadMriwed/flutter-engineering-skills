# Storage and session

## Purpose and scope

Persist preferences and scope session-dependent state.

## Rules and decision criteria

- **STORAGE-001 MANDATORY** Keep raw GetStorage calls in storage initialization and AppStorage. Centralize stable keys and expose typed accessors. Keep theme and locale separate from auth cleanup.
- **STORAGE-002 DEFAULT** Use GetStorage for small preferences. Source also writes token, token type, expiry and profile to GetStorage. Treat that mechanism as source evidence.
- **STORAGE-003 RECOMMENDED** In new authenticated apps, keep sensitive credentials behind a platform-backed credential store when security requirements call for it. Expose the same typed boundary. Establish migration rules before changing deployed keys, including interrupted migration and missing data.
- **STORAGE-004 CONDITIONAL** On confirmed sign-out or authenticated session expiry, clear session values, invalidate scoped requests and user caches, and route once to a safe screen. Reconcile optional device registration on account changes.
- **STORAGE-005 NOT IMPLEMENTED** No verified local database, general persistent API cache/invalidation framework, or offline write queue. Image caching and in-memory retained results have separate lifetimes. Use offline results or synchronization only under a product-defined freshness and conflict policy.

## Implementation workflow and validation

Initialize storage before constructing the API client. Persist credentials after auth success and restore preferences before building the app root. Test fresh install, missing or malformed values, restart, expired session, duplicate unauthorized responses, and cross-account isolation.

## Source evidence

High confidence. `lib/data/datasource/storage/app_storage.dart:27–85,145–200`, `lib/features/auth/services/auth_session_service.dart` saveSession, and `lib/core/domain/error_handler/network_exceptions.dart:553` unauthorized handling.

## Related skills

[Networking](../../../networking/profiles/dio/API_GATEWAY.md) · [Mobile services](../../../mobile-services/MOBILE_SERVICES.md)

## Authentication example

The source login controller submits a challenge request, routes to verification, and holds submission state through finally. The verification controller validates and sends the code, then saves the session before opening the authenticated shell. Another response branch continues onboarding. The choice of challenge mechanism and continuation depends on the target contract.

For a passwordless target, model the challenge ID, expiration and verification response separately. Pass the challenge ID to the verification route, own resend and verify as independent guarded operations, and validate their concurrency rules. Treat session creation as a single logical operation. If storage writes can fail midway, recover to a coherent signed-out state. Ignore a late verification response after the flow closes. Route to the appropriate screen after credential storage succeeds.

Evidence is `lib/features/auth/login/controller/login_controller.dart:108–171`, `lib/features/auth/verification_code/controller/verification_code_controller.dart:128–216,223–268` and the login remote source under `lib/features/auth/login/data/remote`.
