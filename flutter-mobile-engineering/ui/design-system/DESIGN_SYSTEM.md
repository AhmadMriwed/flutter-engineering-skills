# Design system and localization

## Purpose and scope

Translate any destination design into portable tokens and themes.

## Rules and decision criteria

- **DESIGN-001 MANDATORY** Centralize palette, semantic theme colors, font families and weights, spacing, radius, and component sizes. Resolve themed color from context or semantic helpers. Read text styles from typography. Set consistent button, input, app bar and navigation treatments through shared UI.
- **DESIGN-002 DEFAULT** Declare assets and font weights in pubspec and refer to paths through AppAssets. Use vector art for assets provided in SVG, image widgets for raster and network content, and source-appropriate cache sizes. Generate launcher and native splash assets from the new app's artwork.
- **DESIGN-003 MANDATORY** Use translation keys and configure Flutter delegates. Restore and apply the locale through the selected localization integration. Send the configured language when the API contract calls for it. Use EdgeInsetsDirectional, directional alignment and logical start/end. Format dates, numbers, currencies and status labels through central helpers.
- **DESIGN-004 CONDITIONAL** Combine a chosen scaling strategy with width constraints and breakpoint layouts where the design needs tablet columns, changed grids or different content widths. Test font metrics in every supported script. Use system or persisted theme mode according to requirements.

## Implementation workflow and validation

Start with semantic colors and both light/dark ThemeData. Map visual components to shared tokens, then add artwork and fonts. Verify phones, tablets, long translated strings, fallback locale and RTL gestures. Validate adaptive launcher icons and the platform launch screen independently from Dart splash routing.

## Source evidence

High confidence. `lib/core/theme/app_theme.dart`, `app_font_family.dart`, `app_sizes.dart`, `lib/core/responsive/app_responsive.dart`, `lib/locale/app_translation.dart`, `lib/app.dart:25–75`, and asset/tool declarations in pubspec. Source font families, palette, design size, and locale set are project-specific.

## Related skills

[UI architecture](../screens/UI_ARCHITECTURE.md) · [Bootstrap](../../architecture/profiles/feature-first/GETX_BOOTSTRAP.md)

Test narrow RTL with long content, directional alignment and explicitly LTR data such as mixed-script identifiers. Verify locale switching, localized date controls and text scale.
