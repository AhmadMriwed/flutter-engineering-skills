# Profile refactor audit

- Existing instructions now route to shared core and UI, an architecture catalog, a separate GetX state profile, and GetIt DI. Dio and GetStorage recipes remain explicit.
- Original rule IDs and classifications are preserved. Existing source evidence and the complete Tasks code are retained. Historical extraction counts remain in the [baseline audit](FINAL_AUDIT.md).
- A new app reaches [decision approval](../project-setup/PROJECT_DECISION_WORKFLOW.md) before scaffolding. Approval is captured in PROJECT_PROFILE.md. Existing projects follow the [lock](../project-setup/ARCHITECTURE_LOCK.md).
- The supported combination is limited to the verified reference. Cubit remains Pending. The [matrix](../compatibility/COMPATIBILITY_MATRIX.md) distinguishes unverified combinations and ownership conflicts.
- The [portability walkthrough](PORTABILITY_TEST.md) remains theoretical. It applies after the user approves the reference combination. The refactor checks internal links, preservation of classified rules and example code, source code scope, and decision routing.

## Verification results

The refactor contains 58 Markdown files. Comparing snapshots preserved 42 unique baseline rule definitions with their classifications and all 29 Dart blocks byte-for-byte. All relative Markdown file links resolved. Cubit contains only its two intake documents. Git status showed the documentation folder and the existing staged manifest. No runtime tests were added or run in this refactor.
