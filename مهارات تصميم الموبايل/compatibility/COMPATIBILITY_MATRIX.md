# Profile compatibility

| Architecture | State | DI | Other integrations | Decision |
| --- | --- | --- | --- | --- |
| ARCH-FEATURE v1 | STATE-GETX v1 | DI-GETIT v1 | Dio; GetStorage where persistence applies; GetX routes | Validated by REF-001 call paths, portable example static analysis and theoretical walkthrough. No runtime portability test. |
| ARCH-FEATURE v1 | STATE-CUBIT pending | DI-GETIT v1 | Undetermined | Unverified. Await source and ownership evidence. |
| Future profile | Any | Any | Any | Unverified until the complete assembly and its constraints are recorded. |
| Any | GetIt as sole reactive state mechanism | DI-GETIT v1 | Any | Incompatible as specified. Instance lookup supplies no reactive observation. |
| Any | Two owners of the same feature state | Any | Any | Incompatible until ownership and synchronization are resolved. |

Evidence applies to the full combination and listed integration scope. See [integration rules](INTEGRATION_RULES.md).
