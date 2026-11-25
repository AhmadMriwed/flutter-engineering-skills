# Portability test

## Historical theoretical scenario

Plan a new maintenance checklist app using only this knowledge base. The app displays a searchable, filterable task list with server paging and adds or edits tasks. Notifications, identity, offline writes and branded artwork are absent from the scenario.

| Step | Documentation input | Theoretical result |
| --- | --- | --- |
| Foundation | [Bootstrap](../architecture/profiles/feature-first/GETX_BOOTSTRAP.md) | Create Android/iOS app; use Get, GetIt, Dio, ScreenUtil, and Flutter localizations. Configure API_ORIGIN, Android network access, route table, startup and translations. |
| Ownership | [Architecture](../architecture/profiles/feature-first/ARCHITECTURE.md) | Place Tasks under features. Keep the API gateway, result wrapper, app root and locator shared. |
| Integration | [Connect API](../architecture/profiles/feature-first/CONNECT_API.md) | Define record, input and page types. Implement GET, POST and PUT with a source, repository and interface registration. |
| State | [State and DI](../state-management/getx/STATE_ARCHITECTURE.md) | Three route controllers own list, details and editor. List owns search version and next page. Editor owns validation and mutation state. |
| Presentation | [Tasks example](../architecture/profiles/feature-first/examples/TASKS_FEATURE.md) | Route from list to detail by ID. Open an editor from list or details. Reload list after save. Cover untouched, loading, results, empty, retry and append progress. |
| Checks | [Engineering quality](../core/quality/ENGINEERING_QUALITY.md) | Inject fake repository and test async ordering, error response, validation, paging and route ownership. Verify device RTL and keyboard with a matching server fixture. |

## Result

The workflow resolved all assembly choices for the scenario with no source repository dependency. Walking it surfaced the need for the example's explicit fixture contract, environment parameter, and Android networking note. This test is theoretical. It does not establish SDK compilation, device behavior, or server interoperability.

## Executed reference-free scenarios

Copy the [portable Items fixture](../assets/portable_items) to a temporary directory. It is included in the installed skill. From the temporary copy run:

```sh
flutter pub get
dart analyze
flutter analyze --no-pub
flutter test --no-pub
```

Use `flutter pub get --offline` when all pinned dependencies are cached. The tests use an injected Dio adapter and synthetic data with no external server. The two apps share the repository, screen, widgets and request policy. The GetX assembly resolves its controller through a route binding. The Cubit assembly resolves a factory through a route-owned BlocProvider.

| Scenario | Executed checks | Result |
| --- | --- | --- |
| A, GetX | Open route, failed request and retry UI, loading, late result, pagination, query change during append, form validation and save, route disposal and reopen | Passed |
| B, Cubit | Same behavior through Flutter Navigator and BlocProvider | Passed |

Flutter 3.44.5 and Dart 3.12.2 on macOS. Both analyzers passed. These are widget runs with a fake HTTP transport. The alternative paging solution passed this case. REF-002 source pagination under overlapping filters, native release and real backend behavior still need separate verification.

## Agent invocation smoke test

On macOS, Codex CLI 0.171.0-alpha.13 opened an isolated project with the skill installed under .agents/skills. It read the task index, decision workflow and compatibility matrix, compared GetX and Cubit, and requested an explicit choice before writing a profile. After receiving a synthetic Cubit approval, it wrote PROJECT_PROFILE.md, adapted the portable fixture and added a Cubit empty-state widget test. The adapted app passed both analyzers and all three widget tests with fake transport.

A project-scope installation tree was also checked for Claude Code. The Claude Code CLI was unavailable, so invocation remains unverified. The smoke test used project scope. User-wide activation, implicit selection, Windows, Linux and GitHub-hosted CI were outside this run.
