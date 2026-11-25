# Evolve the knowledge base

| Classification | Next action |
| --- | --- |
| NEW_SKILL | Propose a documented addition. |
| IMPROVED_SKILL | Compare to the current rule and retain its ID if the intent remains. |
| ALTERNATIVE_PATTERN | Record the conditions and compatibility that justify an alternative. |
| ARCHITECTURE_SPECIFIC | Keep with the appropriate architecture profile. |
| STATE_SPECIFIC | Keep with its state profile. |
| SHARED_STANDARD | Promote only when the practice is independent of profile APIs. |
| PROJECT_SPECIFIC | Retain relevant evidence locally without promoting product behavior. |
| CONFLICTING_PATTERN | Identify which constraints or ownership rules conflict. |
| REGRESSION | Document why quality or correctness would worsen. |
| DEPRECATED_PATTERN | Retain provenance and migration guidance. |
| UNVERIFIED_PATTERN | State the gap and plan validation. |

Use scope labels alongside the finding's evaluation when both apply. Compare readability, maintainability, reusable seams, testability, scaling, separation, dependency ownership, error recovery, lifecycle, boilerplate, developer experience, security, compatibility and complexity. A performance claim requires measurements. Mark design reasoning as theoretical.

Resolve a conflict by checking higher-priority requirements, exact contract, owner and lifetime. Preserve the original standard when evidence is insufficient. Scope a genuinely beneficial alternative to its conditions. A new state mechanism alone is insufficient justification for a new architecture profile. Record compatibility and tested combinations independently.

Propose a documentation-only patch for clarifications, a minor change for additive profiles and capabilities, and a major change for incompatible rules or project decisions. Preserve IDs and record migration steps. Obtain explicit approval before substantive adoption or version changes. Follow [reference import](../workflows/IMPORT_SKILLS_FROM_PROJECT.md).
