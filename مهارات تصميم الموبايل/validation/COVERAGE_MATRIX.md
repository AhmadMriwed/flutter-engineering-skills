# Coverage matrix

The rows below map the original reference to its relocated skill owners. For profile governance and reuse checks see [the refactor audit](REFACTOR_AUDIT.md).

Evidence paths in topic files explain the observed symbols and context. Confidence applies to source observations within the inspected scope. Recommendations describe the target workflow.

| Component | Rule IDs | Skills | Evidence | Confidence | Gap |
| --- | --- | --- | --- | --- | --- |
| Startup and routing | BOOT-001, DI-001 | [Reference](../architecture/profiles/feature-first/GETX_BOOTSTRAP.md) | main.dart, app.dart, app_pages.dart | High | Device startup not run |
| Layered feature API | ARCH-001, API-001–003 | [Reference](../architecture/profiles/feature-first/CONNECT_API.md) | Search and FAQ controller/binding/repository/remote | High | No live endpoint calls |
| State and lifetime | STATE-001–004, DI-002 | [Reference](../state-management/getx/STATE_ARCHITECTURE.md) | Search, FAQ, locator, shell binding | High | No runtime disposal measurement |
| Search/paging and models | API-002, API-004 | [Reference](../core/networking/profiles/dio/API_GATEWAY.md) | Search controller, Orders controller, shared product readers | High | Other paging variants sampled via inventory |
| Upload/download and error mapping | API-003, API-005–006 | [Reference](../core/networking/profiles/dio/API_GATEWAY.md) | ApiServicesImp and NetworkExceptions | High | File integrity and native I/O untested |
| Preferences/session/offline | STORAGE-001–005 | [Reference](../core/storage/profiles/get_storage/STORAGE_AND_SESSION.md) | AppStorage and AuthSessionService | High | No recovery tests after process death |
| Composition and feedback | UI-001–005 | [Reference](../ui/screens/UI_ARCHITECTURE.md) | Home, search, shared layout and response helpers | High | No device visual or accessibility audit |
| Theme/resources/locale | DESIGN-001–004 | [Reference](../ui/design-system/DESIGN_SYSTEM.md) | AppTheme, pubspec, AppResponsive, AppTranslation | High | Font and art content excluded |
| Native services | MOBILE-001–004 | [Reference](../core/mobile-services/MOBILE_SERVICES.md) | NotificationService, app startup, media and tracking lifecycle | Medium | No live push, sockets or native integration tests |
| Quality and release | QUALITY-001–004 | [Reference](../core/quality/ENGINEERING_QUALITY.md) | Logging tool, manifests, build metadata | Medium | CI history and signed artifacts excluded |

[Repository discovery](../knowledge-management/evidence/PROJECT_ANALYSIS.md) accounts for each top-level feature directory. [Final audit](FINAL_AUDIT.md) distinguishes scans, traced examples, and open verification.
