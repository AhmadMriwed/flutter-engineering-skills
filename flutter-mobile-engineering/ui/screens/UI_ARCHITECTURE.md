# Screens, widgets and feedback

## Purpose and scope

Compose responsive screens with predictable state and side effects.

## Rules and decision criteria

- **UI-001 MANDATORY** Assemble layout in a page, feature state in a controller, and reusable visuals in widgets. A section widget earns a file when it owns a named visual responsibility, an independent update boundary, or reusable input/output. Pass display values and callbacks to leaf widgets. Keep simple one-off layout inline.
- **UI-002 DEFAULT** Reuse shared inputs, buttons, picker sheets, dialogs and loading, empty and error views. Use a static builder for short content, lazy ListView/GridView builders for growing homogeneous data, and CustomScrollView with sliver sections for mixed scrolling content. Give a scrollable region one primary owner. Ensure refresh remains accessible on short or empty lists.
- **UI-003 CONDITIONAL** Use inline or button loading for a local operation and full screen loading when first render has no meaningful content. Existing skeletons mirror the eventual layout. Keep visible content on refresh and use an inline append retry for paging. Feed no-internet errors through the same classified error path as other failures.
- **UI-004 CONDITIONAL** Use a dialog for confirmation, a sheet for selection/filtering, feedback for transient outcomes, and a persistent inline message for errors users must act on. Trigger side effects from action completions or explicitly managed subscriptions. Capture overlay before async work, check it is mounted before use, and avoid invoking overlays from reactive builds.
- **UI-005 RECOMMENDED** Check tap targets, semantic labels, keyboard traversal, high text scale, contrast, and reduced motion. Keep animations local and dispose owned AnimationControllers. Validate Hero pairing and route lifetime when matching media across screens.

## Implementation workflow and validation

Sketch states and constraints first. Define the shared vocabulary for fields and buttons. Build the page with sections, then scope subscriptions around changing values. Validate and normalize form input before I/O, disable repeated submit, and make the form scroll above the keyboard. Use SafeArea, directional insets and Wrap or Flexible for overflow-prone strings. Test scroll ownership and back navigation during an in-flight operation.

## Source evidence

High confidence for composition in `lib/features/search/pages/search_page.dart`, `lib/features/home/pages/home_page.dart`, FAQ pages and `lib/core/widgets/layout/app_paginated_scroll.dart`. Feedback patterns in `lib/core/helper/response_helper.dart`, `app_response_helpers.dart`, `app_dialog.dart` under core layout, and core bottom sheets. Accessibility checklist is a recommendation.

## Related skills

[Design system](../design-system/DESIGN_SYSTEM.md) · [State and DI](../../state-management/getx/STATE_ARCHITECTURE.md)

Forms can keep editing controllers, selectors and validation at the screen boundary. Send validated values into the state owner and map typed server field failures back to controls. During async work prioritize persistent inline feedback and attach ephemeral effects to a surviving route.
