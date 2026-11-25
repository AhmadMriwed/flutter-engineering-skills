# Evidence registry

| Evidence | Rules or profile seam | Source-relative anchor | Confidence and scope |
| --- | --- | --- | --- |
| REF-001-E01 | ARCH-001–003, API-001–003 | Search and FAQ repository, remote and controller paths under lib/features | High for representative API chains |
| REF-001-E02 | DI-001–002, STATE-001–004 | lib/data/datasource/configuration/locator.dart, SearchBinding, CustomerSearchController, MainShellBinding | High for observed ownership and registration |
| REF-001-E03 | API-004–006 | OrdersController.loadMore, SearchController.search as implemented by CustomerSearchController, ApiServicesImp | High for visible paging, stale commit guard and scoped transport |
| REF-001-E04 | STORAGE-001–005 | AppStorage, AuthSessionService, NetworkExceptions | High for observed persistence and expiry handling |
| REF-001-E05 | UI, DESIGN, MOBILE and QUALITY | AppTheme, Home and Search pages, AppPageActivity, notification service and app startup | Source traces only. Runtime behavior unverified. |

See the original [coverage matrix](../validation/COVERAGE_MATRIX.md) for exact rule groups and topic links. For new entries give source ID, revision, relative path, symbol, line span if available, observed behavior, counterexample, confidence, and validation method.
