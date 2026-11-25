# Storage principles

Use typed storage interfaces and durable keys. Classify credentials, preferences, identity and cached data by sensitivity and lifetime. Preserve preferences on sign-out unless product requirements specify otherwise. Design migration recovery, account isolation, freshness, invalidation and offline conflict policy before persisting synchronized data. Use appropriate platform credential protection when required. The [GetStorage recipe](profiles/get_storage/STORAGE_AND_SESSION.md) documents the reference implementation and its gaps.
