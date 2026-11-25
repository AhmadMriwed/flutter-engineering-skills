# Profile and integration rules

Profile dimensions include architecture, state, DI, and optional networking, storage and navigation profiles. Each catalog entry records a stable ID, name, version, status, sources and pinned evidence, supported cases, limitations, dependencies, compatible and incompatible combinations, required skills, workflows, templates and verification. Use an explicit none or deferred value for an unused integration.

| Status | Meaning |
| --- | --- |
| Pending | Extraction and review outstanding |
| Experimental | Draft integration with stated validation gaps and separate approval required |
| Validated | Evidence supports listed combinations and use cases |
| Stable | Maintained, reproducible verification supports routine adoption |
| Deprecated | Historical reference with migration direction |

Record compatibility independently of status. Validate dependency versions, construction and disposal, navigation, state observation, effects, request and data contracts, and test substitution. Use compatible, conditional, incompatible or unverified with evidence and scope. Offer only eligible validated or stable combinations in the ordinary bootstrap path. Document isolated cross-profile coexistence by owner and seam. Any major integration departure requires an approved exception.
