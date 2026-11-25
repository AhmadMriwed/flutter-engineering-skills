# Agent instructions

Read [SKILL](SKILL.md) and [the task index](SKILL_INDEX.md). For a new project, present the supported options, actual tradeoffs, recommendation and confidence. Wait for explicit user approval before scaffolding or writing a project profile. For an existing project, read its approved PROJECT_PROFILE.md and inspect actual implementation. Continue under its selected profiles without repeated selection. Obtain explicit approval for a migration or a new cross-profile exception.

Apply shared standards independently of library choice. Respect the boundaries in the selected profile and review compatibility before combining profiles. Reuse nearby services and widgets, preserve API contracts and route behavior, and keep business logic out of rendering. Keep credentials and customer data outside examples and logs. Verify through normal entry points. Record deviations and validation gaps.

For a Cubit feature use its [ownership and workflow guidance](state-management/cubit/README.md). Keep reference evidence optional at application development time.
