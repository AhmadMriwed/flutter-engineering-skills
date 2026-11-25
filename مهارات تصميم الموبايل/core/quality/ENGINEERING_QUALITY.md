# Testing, performance and release

## Purpose and scope

Choose checks according to observable feature risks.

## Rules and decision criteria

- **QUALITY-001 RECOMMENDED** Use model tests with valid, malformed and partial fixtures. Drive controller tests with fake repository interfaces and reset or dispose the selected state and DI mechanisms between tests. Use widget tests for status, accessibility and action affordances. Smoke test normal routes and real platform capabilities on devices. The source declares flutter_test but no Dart test directory was observed.
- **QUALITY-002 DEFAULT** Use lazy list builders, scoped reactive regions, sized image decoding, and lifecycle-aware subscriptions. Use const for stable subtrees when possible. Measure frame time and memory on representative devices before optimizing.
- **QUALITY-003 RECOMMENDED** Redact credentials, user data and payloads from logs and disable application/network debug logs in production. Review route guards, environment origins, file limits and credential storage. Keep sample fixtures synthetic.
- **QUALITY-004 RECOMMENDED** Review small changes against layer boundaries and contract changes. Use formatter, analyzer, targeted tests and release smoke tests. Keep build artifacts and signing inputs out of tracked source. CI and Git policies follow the target team.

## Implementation workflow and validation

Run `dart format`, `flutter analyze`, and scoped `flutter test` on a project that you are authorized to modify. Profile in profile mode, then verify release mode with the correct Android/iOS config, build number, signed output and real lifecycle paths. When debugging, first reproduce the symptom, isolate the failing layer and inspect sanitized diagnostics.

## Source evidence

High confidence for tool declarations and mechanisms. `analysis_options.yaml`, `pubspec.yaml`, `tool/run_with_logs.dart`, `lib/core/helper/app_logger.dart`, `lib/core/utils/app_image_decode_size.dart`, `lib/core/widgets/layout/app_visible_sliver.dart` and native build configuration. No verified CI or branch strategy.

## Related skills

[Bootstrap](../../architecture/profiles/feature-first/GETX_BOOTSTRAP.md) · [Coverage](../../validation/COVERAGE_MATRIX.md)
