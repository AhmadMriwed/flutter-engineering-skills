# Architecture profiles

[ARCH-FEATURE](profiles/feature-first/PROFILE.md) is the current validated architecture. It owns layer boundaries, feature placement and data flow. See [selection](ARCHITECTURE_SELECTION.md) before choosing it for a new app. A future source that differs only in reactive state may reuse this architecture after compatibility validation. An incompatible dependency graph or change in layer ownership merits a separate profile.
