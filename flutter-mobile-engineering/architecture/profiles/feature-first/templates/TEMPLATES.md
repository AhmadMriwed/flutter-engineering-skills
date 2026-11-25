# Copyable Flutter templates

The complete imports and code are in [Tasks feature](../examples/TASKS_FEATURE.md). Copy the matching file groups, replace Tasks identifiers and translation keys with the target feature names, and update the wire contract where it crosses the remote boundary. File paths below are relative to `lib/`.

| Template | Files to copy | Replace or adapt | Use when |
| --- | --- | --- | --- |
| New project | main.dart, app.dart, core/routes, locale and locator | Product name, startup, locale, theme, shared services | New app using this reference stack |
| Feature | features/tasks plus route and DI registrations | Feature path/name, responsibilities, typed route inputs | Remote feature that owns the capability |
| Screen | features/tasks/pages/tasks_page.dart | Page sections, callbacks, translated copy | Route-level layout |
| Widget | features/tasks/widgets/tasks_list.dart | Display inputs, callbacks and list constraints | An independent rendering section |
| Controller | features/tasks/controller/tasks_controller.dart | Repository type, list triggers, query operations and routes | Feature behavior with a route-owned lifetime |
| State | features/tasks/controller/task_load_state.dart | Mutually exclusive presentation states and independent operation flags | Screen has state branches |
| Model | features/tasks/data/models/task.dart, task_page.dart, task_input.dart | Wire keys, field types, null rules, metadata | Transport contract requires typed data |
| Repository | features/tasks/domain/repository and data/repository | Operations, source type, envelope status mapping | Typed feature API |
| Remote source | features/tasks/data/remote | AppUrl endpoint, query/body and parser | API-backed operations |
| API integration | core/domain/services, core/utils/app_url.dart, core/domain/error_handler, data/datasource/remote and feature adapter | Origin policy, gateway headers, error types | Shared infrastructure for a server |
| DI registration | data/datasource/configuration/locator.dart and features/tasks/binding | Interface registrations and per-route controller ownership | Composing the feature graph |

For a static screen use only the route, page, locale and optional widgets. For an existing API owner inject that repository from the new binding. Omit paging, dependencies and models that the target requirement does not use. The example controller and enum are GetX templates. See [State and DI](../../../../state-management/getx/STATE_ARCHITECTURE.md) for the underlying lifecycle.
