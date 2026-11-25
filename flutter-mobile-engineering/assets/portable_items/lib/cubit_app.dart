import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'feature.dart';
import 'repository.dart';

class ItemCubit extends Cubit<ItemState> {
  ItemCubit(ItemRepository repo) : super(const ItemState()) {
    actions = ItemActions(repo, () => state, emit);
  }

  late final ItemActions actions;

  @override
  Future<void> close() {
    actions.dispose();
    return super.close();
  }
}

Widget cubitApp(GetIt locator) {
  locator.registerFactory<ItemCubit>(() => ItemCubit(locator()));
  return MaterialApp(
    home: const _Home(),
    routes: {
      '/items': (_) => BlocProvider(
            create: (_) => locator<ItemCubit>(),
            child: BlocBuilder<ItemCubit, ItemState>(
              builder: (context, state) =>
                  ItemScreen(state, context.read<ItemCubit>().actions),
            ),
          ),
    },
  );
}

class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) => Scaffold(
      body: TextButton(
          onPressed: () => Navigator.pushNamed(context, '/items'),
          child: const Text('Open items')));
}
