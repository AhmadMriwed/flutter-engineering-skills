# Architecture validation

| Invariant | Verification | Outcome |
| --- | --- | --- |
| Source route state enters through GetX | Read SearchBinding, SearchPage, and MainShellBinding | Route-local injection and shared shell lifetimes are distinct. |
| Source controller uses a repository contract | Trace Search and FAQ reads | Both return typed ApiResponse and branch on it in the controller. |
| Source JSON parsing is at the remote boundary | Trace both remote implementations | JSON parsing occurs before repository and presentation. |
| Destination code uses an equivalent graph | Inspect example imports and registrations | API gateway, remote adapter, repository, binding, controller and UI are present and connected. |
| Generated relative imports are self-contained | Resolve imports against labeled example files | All local import targets are present. |
| Portable execution is independent of source business contracts | Walk the Tasks plan with its own API fixture | Entry points, service composition and response shape are specified. |

See [final audit](FINAL_AUDIT.md) for tool results and runtime scope.
