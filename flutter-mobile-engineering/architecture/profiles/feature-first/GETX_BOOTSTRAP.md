# Implement the approved GetX reference stack

Use this recipe after the user approves ARCH-FEATURE + STATE-GETX + DI-GETIT. Begin with [project selection](../../../project-setup/PROJECT_DECISION_WORKFLOW.md).

## Purpose and scope

Build a clean mobile Flutter workspace around a destination app identity.

## Rules and decision criteria

- **BOOT-001 DEFAULT** Start with `flutter create --platforms=android,ios --org com.example portable_app`. Add Get and GetIt, ScreenUtil when using responsive tokens, Flutter localizations and intl when shipping multiple locales, GetStorage when persisting preferences, and Dio when connecting a server. Resolve versions against the target Flutter SDK and commit the application lockfile.
- **BOOT-002 CONDITIONAL** Add native plugins, service configurations, signing, and environment switching as requirements become concrete. Public environment metadata can use `--dart-define`; values embedded in the binary are public. Keep signing files and credentials in the authorized release environment.

## Implementation workflow and validation

1. Create `lib/main.dart`, `lib/app.dart`, `lib/core/{routes,theme,widgets}`, `lib/locale`, and the first feature. Add the locator and AppStorage as needed.
2. Initialize Flutter binding, storage, and platform services required before first render. Register the locator and load validated configuration before calling `runApp`. Defer optional service work and handle failures.
3. Build GetMaterialApp with GetPage entries, bindings, translations, themes and initial route. Add splash/session decisions only when startup has multiple destinations.
4. Add AppUrl and a Dio gateway when the first API lands. Add design size and named size tokens, then declare only needed font weights and asset directories in pubspec.
5. Set Android namespace and minimum SDK and iOS bundle and deployment targets for plugins. Check permissions, signing and supported device versions for each build type.
6. Review generated ignores for caches, local settings and signing files. Run dependency resolution, formatting, analyze, widget tests and a debug run. Build Android App Bundle and iOS archive with target-specific versioning and signing when releasing.

Use the [copyable example](examples/TASKS_FEATURE.md) as an independent starter. For visual-only apps, omit Dio, repositories and networking setup.

## Source evidence

High confidence. `lib/main.dart:20–52` and `lib/app.dart:22–75` show startup. `pubspec.yaml`, `android/app/build.gradle.kts`, and `ios/Podfile:2` provide platform evidence. Source deployment targets and environment discovery are project-specific.

## Related skills

[Discovery](../../../knowledge-management/evidence/PROJECT_ANALYSIS.md) · [Architecture](ARCHITECTURE.md)
