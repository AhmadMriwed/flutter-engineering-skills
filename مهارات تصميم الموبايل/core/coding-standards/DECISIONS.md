# Engineering decisions

## Purpose and scope

Assign decisions to the owner of the actual constraint.

## Rules and decision criteria

| Decision | Owner | Default action |
| --- | --- | --- |
| Widget decomposition | Architecture and view needs | Extract a distinct section when it changes independently, repeats, or hides significant layout complexity. |
| Feature versus core | Feature ownership | Keep semantics near the feature. Promote a component once multiple consumers share the same contract. |
| Local versus feature state | Lifetime | Use stateful UI for ephemeral presentation. Use the approved state profile for state that drives feature behavior. |
| Feature versus global state | Lifetime and consumers | Share preference/session data via app-level services. Keep route-local state in its approved ownership boundary. |
| Local versus remote | Product and backend | Treat the server as authoritative for synchronized records. Store small preferences locally. |
| Endpoint, retry and paging | Backend contract | Choose parameters, page or cursor semantics and idempotency behavior only from the contract. |
| Tokens and art | Destination design | Specify colors, assets, motion and sizing according to the new design. |
| Dependency selection | Architecture and team | Reuse existing packages. Evaluate native support, lifecycle, test seams, SDK compatibility and operational cost before adding a package. |
| Unknown product behavior | Project owner | Clarify meaningful requirements and proceed on reversible engineering choices where possible. |

## Implementation workflow and validation

Apply defaults when requirements leave discretion. Record when an explicit target requirement replaces a default. Check for duplicate ownership and circular imports before sharing services.

## Source evidence

High confidence for lifetime and boundaries in bindings, locator and source core widgets. The package evaluation criteria and import gate are recommendations.

## Related skills

[Architecture](../../architecture/profiles/feature-first/ARCHITECTURE.md) · [Create feature](../../architecture/profiles/feature-first/FEATURE_WORKFLOW.md)
