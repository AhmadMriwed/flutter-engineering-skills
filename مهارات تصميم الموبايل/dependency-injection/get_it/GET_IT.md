# GetIt profile

| Field | Value |
| --- | --- |
| ID and version | DI-GETIT v1 |
| Status | Validated for the reference composition |
| Source and evidence | REF-001, locator setup and route composition |
| Role | Resolve infrastructure and interface implementations in a composition root |
| Required dependency | get_it |
| Supported uses | Shared services, repositories, and factory-owned runtime resources |
| Limits | Instances require registration and an owner for disposal. Registration provides no UI subscriptions. |
| Compatibility | Validated with ARCH-FEATURE + STATE-GETX. Other integrations require evidence. |
| Incompatible usage | Treating the locator as a reactive state provider |

- **DI-001 MANDATORY** Register infrastructure, data source interfaces, and repository interfaces in `data/datasource/configuration/locator.dart`. Inject dependencies through constructors. The route binding resolves interface implementations and creates the controller with `Get.lazyPut`.
- **DI-002 DEFAULT** Use `registerLazySingleton` for shared service graphs. Use a factory for a resource owned and stopped independently by each caller. An eager singleton is an option when async preparation must finish before consumers exist. The source predominantly uses lazy singletons and registers realtime factories.

DI-001 describes the full reference seam. The composition-root location comes from ARCH-FEATURE and the binding handoff comes from STATE-GETX. Other compositions can inject the same interfaces at their own assembly point.

Register lazy callbacks before first resolution and keep dependencies acyclic. Use shared registration when consumers intentionally share identity. Have the caller dispose a factory-owned socket or stream. In tests reset or replace the locator and await registered disposal callbacks. A registered service can expose a stream or observable. Its consumers own subscriptions according to the state profile.

See [GetX integration](../../state-management/getx/GET_IT_INTEGRATION.md), [compatibility](../../compatibility/COMPATIBILITY_MATRIX.md), and [registration example](../../architecture/profiles/feature-first/examples/TASKS_FEATURE.md). Validate registration, first resolution and distinct ownership for factories.
