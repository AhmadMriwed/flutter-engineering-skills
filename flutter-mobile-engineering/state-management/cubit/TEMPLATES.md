# Cubit integration templates

Use [shared feature and model templates](../../architecture/profiles/feature-first/templates/TEMPLATES.md) for transport, repository and display contracts. Use the [portable fixture instructions](../../validation/PORTABILITY_TEST.md) for the complete screen, widget, Dio, filter, pagination, form, error and test integration.

### Route and factory

```dart
getIt.registerFactory<ItemCubit>(() => ItemCubit(getIt<ItemRepository>()));
// In the item route builder:
return BlocProvider(
  create: (_) => getIt<ItemCubit>()..load(),
  child: const ItemScreen(),
);
```

### State and effects

Choose typed immutable fields for data and statuses. A Freezed union is useful for exclusive transitions. For independent work, use an aggregate whose list and save statuses can each change independently. A widget listening for completion can use:

```dart
listenWhen: (old, next) => old.save != next.save &&
    next.save == SaveStatus.success,
listener: (context, state) => ScaffoldMessenger.of(context)
    .showSnackBar(const SnackBar(content: Text('Item saved'))),
```

### Test

Inject a fake repository. Start a search with a controllable future, start a newer search and complete it first. Complete the old future and assert the newer result stays visible. Repeat after close, and verify the normal route closes its own instance. Keep platform or backend tests separate from these deterministic checks.
