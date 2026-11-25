# State management selection

Inventory screen-local and shared state, forms, async concurrency, realtime needs and persistence. Determine ownership and disposal at each route boundary. Compare test seams, team familiarity, dependency cost, UI binding and rebuilding. [GetX](getx/PROFILE.md) offers compact route-owned bindings and scoped observable updates. Its ownership and effect paths must be checked explicitly because registration and reactivity are separate concerns.

Use [the comparison](COMPARISON_MATRIX.md) and [compatibility](../compatibility/COMPATIBILITY_MATRIX.md). Present the eligible profiles, recommendation and confidence to the user. The only eligible state profile in this release is STATE-GETX within the validated reference combination. Wait for explicit approval even when one option qualifies. Use the approved profile for existing features.
