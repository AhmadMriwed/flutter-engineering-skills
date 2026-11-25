# Example prompts

Prefix a prompt with `$flutter-mobile-engineering` in Codex or `/flutter-mobile-engineering` in Claude Code. For an existing project, ask the agent to read its approved `PROJECT_PROFILE.md` and inspect the current code before proposing changes.

| Task | Copyable prompt |
| --- | --- |
| New app | Plan a Flutter app for tracking household supplies. Compare eligible stacks and wait for my explicit choice before creating PROJECT_PROFILE.md or scaffolding. |
| Analyze existing app | Inventory the architecture, routing, state owners, DI and API paths. Cite files, note exceptions and report the inferred profile. Keep the work read-only. |
| Recommend architecture and state | Compare the GetX and Cubit combinations for a four-person team with two multi-screen editors, searchable lists and fixture-driven tests. Recommend one and explain the tradeoffs. |
| Create feature | Add a bookmarks feature under the approved profile. Trace it from the normal route through state and repository and verify empty, loading and failure behavior. |
| Integrate REST API | Given this REST contract, define request and response types, add a remote adapter and repository, wire DI, and test malformed responses and server errors. Use a fake transport. |
| Paginated list | Build a cursor-paged catalog. Keep rows on append failure, retry the current cursor and ignore results from superseded filters. |
| Create form | Build a create-item form with field validation, server field errors and a duplicate-submit guard. Verify input survives a rejected save. |
| Refactor screen | Refactor this screen into named visual sections while preserving its route, state owner, form behavior and API contract. |
| Reusable widgets | Extract the shared list status and retry view. Give it typed display inputs and callbacks, and verify empty and error rendering. |
| Audit architecture | Trace three normal entry points and assess dependencies, lifecycle and test seams against applicable rule IDs. Report deviations and evidence gaps. |
| Review compliance | Review this feature diff against the approved profiles and shared rules. Cite actionable findings with file locations and validation gaps. |
| Import knowledge | Read this reference project without changing it. Pin its revision, record neutral evidence, compare it to existing rules and propose changes for approval before adoption. |
