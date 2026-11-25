# Lifecycle and mobile services

## Purpose and scope

Add platform capabilities as separately owned integrations.

## Rules and decision criteria

- **MOBILE-001 CONDITIONAL** Wrap image picking, geolocation and push APIs in app services. Request runtime permission in the feature flow, handle denied and permanently denied states, and add matching Android/iOS usage declarations.
- **MOBILE-002 CONDITIONAL** Keep foreground, background and cold-start notification handling distinct. Persist registration data through storage, synchronize refreshed device tokens, and defer navigation until the app is ready. Deduplicate tap handling and guard target routes by session state.
- **MOBILE-003 CONDITIONAL** Attach realtime streams and media to an explicit screen or service owner. Stop subscriptions and playback at disposal or foreground loss when required. Resume or reconcile after return. Socket contracts and payloads come from the server.
- **MOBILE-004 NOT IMPLEMENTED** No verified generalized universal-link router, persistent background scheduler or connectivity monitor. Notification routing, Firebase's background callback and classified connection failures exist. Add broader facilities only when a target requirement calls for them.

## Implementation workflow and validation

Specify permissions, native prerequisites and lifecycle owners first. Keep background push processing independent of available UI. Test notification open from terminated, background and active states, permission rejection, repeated tap delivery, account change, connectivity loss and resumption. Test on actual devices for permission prompts and token registration.

## Source evidence

High confidence. `lib/main.dart:27–33,48–57`, `lib/core/services/notification_service.dart:142–244,458–492,626–744`, core image/location services, `lib/core/widgets/layout/app_page_activity.dart:80` and order tracking lifecycle at line 314. Device delivery and native behavior were not executed.

## Related skills

[Storage and session](../storage/profiles/get_storage/STORAGE_AND_SESSION.md) · [Engineering quality](../quality/ENGINEERING_QUALITY.md)
