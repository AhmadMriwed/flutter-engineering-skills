# GetX state architecture

## Purpose and scope

Choose controller lifetime, reactive boundaries, and dependency ownership.

## Rules and decision criteria

- **STATE-001 MANDATORY** Guard duplicate mutations, set loading before await, and release it in finally. Render initial/loading/data/empty/error distinctly where relevant. Preserve usable results for refresh or append errors. Scope Obx to readers of the values that change.
- **STATE-002 CONDITIONAL** Keep TextEditingController, FocusNode and request coordinators with their feature controller if they participate in feature behavior. Dispose objects, workers, timers and subscriptions in onClose. StatefulWidget fits animation, layout lifecycle, or ephemeral state with a widget-local owner.
- **STATE-003 CONDITIONAL** Scope multiple controllers to separate lifetimes or operations when they can run independently. Share one route or shell owner for state across pages only while the workflow requires it. Confirm how direct navigation reconstructs any state the destination needs.
- **STATE-004 NOT IMPLEMENTED** No observed BlocProvider, BlocBuilder, BlocListener, BlocConsumer, BlocSelector, Cubit or generated immutable state framework. GetX observables, plain enum states and selective Obx fulfill those roles. Use explicit callbacks for effects. Use copyWith for value updates where an immutable value warrants it.

## Implementation workflow and validation

Register the route binding with GetPage. Trigger initial data from the controller lifecycle. In asynchronous reads, invalidate stale work and check isClosed before committing results. In UI feedback callbacks capture an OverlayState before the await if the shared helper requires it.

## Source evidence

High confidence. `lib/features/search/binding/search_binding.dart:13` injects two controllers. `search_controller.dart` under the sibling controller directory shows onReady, search, debounce and onClose. `locator.dart:508` registers realtime factories.

## Related skills

[Templates](../../architecture/profiles/feature-first/templates/TEMPLATES.md) · [Networking](../../core/networking/profiles/dio/API_GATEWAY.md)

## Navigation, locale and tests

For the observed navigation integration, use GetMaterialApp, GetPage, AppRoutes and bindings. Route controllers own navigation decisions. Use typed arguments or IDs for detail routes and validate missing input at entry. The shell may coordinate activation separately from route disposal.

The reference locale integration uses GetX keys with .tr and calls Get.updateLocale after an approved language change. It persists the language through AppStorage and supplies it to the Dio gateway. Screens still need Flutter delegates and RTL-safe layout.

For tests, inject a fake repository, exercise Rx values before and after response delivery, and use the normal binding in widget tests to verify teardown. Close a controller while a request is pending and ensure no post-close update. Reset GetX registrations between tests. These checks are recommendations. The original reference had no verified Dart test suite.
