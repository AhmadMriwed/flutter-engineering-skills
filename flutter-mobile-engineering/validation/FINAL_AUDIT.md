# Baseline extraction audit

These counts apply to the original extraction. See [the refactor audit](REFACTOR_AUDIT.md) for the current layout.

## Result

The repository implements a pragmatic feature-first Flutter architecture. GetX owns reactive presentation, routes, and controller lifetime. GetIt composes services and repository interfaces. Repositories handle typed results and exception mapping, remote sources own wire parsing, and a shared gateway owns Dio requests. Repository contracts can refer to data models.

| Measure | Result |
| --- | --- |
| Dart source scanned | 1,103 files across lib and tool. The scan read source contents for architectural markers. |
| Feature inventory | 39 immediate roots. Detailed evidence centers on FAQ, Search, Orders, auth, Home, shell, notifications, order tracking, address and product media paths. |
| Rule definitions | 42 unique classified rule IDs, including conditional and recommended guidance. Additional inconsistencies are recorded separately. |
| Indexed pattern families | 10 coverage-matrix groups. These are grouped behaviors rather than a count of all source idioms. |
| Markdown deliverables | 25 files. Related topics are consolidated under the requested numbered sections. |
| Portable example | 29 complete Dart files embedded as Markdown blocks. |

## Observations and gaps

The analysis documents mixed controller lifetimes, repository contracts importing DTO-style models, model placement across several feature subdirectories, and multiple reactive state representations. It also captures the shell's keyed activity tracking, request-generation checks, scoped cancellation, and separate cold-start notification processing. Cubit, generic token refresh, durable offline synchronization, and generalized background scheduling were not verified as implemented.

The source review included manifest and lockfile dependencies, startup, app composition, platform settings, assets by declaration, and representative API and UI paths. The source was scanned across all Dart files. Depth varies by feature. No claim is made that every feature had a line-by-line audit. Generated artifacts, credential contents, binaries, signing inputs, backend behavior and device operation were excluded from detailed verification.

## Validation

- YAML frontmatter passed a Ruby YAML schema and naming check. The bundled Python validator could not start because PyYAML was unavailable.
- Relative Markdown links and all local imports in the extracted Dart examples resolved.
- The example blocks passed Dart static analysis with no reported issues using the locally resolved Flutter dependencies and disabled analytics. They were analyzed as temporary snippets and were not installed as a new Flutter project.
- The rule inventory contained no duplicate definition IDs. Automated text checks found no private-key blocks, example Google API credential patterns or JWT-shaped tokens.
- The [portability walkthrough](PORTABILITY_TEST.md) assembled an unrelated Tasks app and identified its fixture, build configuration, and test plan. No runtime, backend, or signed-release verification was performed.
- The [architecture checks](ARCHITECTURE_VALIDATION.md) and [coverage matrix](COVERAGE_MATRIX.md) document the evidence and remaining scope.

## Recommendations for applicable target projects

Consider platform-backed credential storage, redacted logging, a dependency direction check, and focused lifecycle and request-race tests. These are recommendations and do not change the source application.

## Start in a new project

Open [SKILL](../SKILL.md), follow [the task index](../SKILL_INDEX.md), and bootstrap against the target API and product requirements. Use [the Tasks example](../architecture/profiles/feature-first/examples/TASKS_FEATURE.md) for runnable-structure reference and replace its illustrative API contract with the destination contract.
