# Modify feature

Read the [profile lock](../project-setup/ARCHITECTURE_LOCK.md) and trace existing callers before edits. Keep conventions, routes, state lifetime, storage keys and backend contract compatible. Identify migration or cross-profile exceptions before touching related files. Follow [feature validation](CREATE_FEATURE.md) through the unchanged normal entry point.

For an approved STATE-CUBIT project follow the [Cubit workflow](../state-management/cubit/WORKFLOW.md) and [templates](../state-management/cubit/TEMPLATES.md).
