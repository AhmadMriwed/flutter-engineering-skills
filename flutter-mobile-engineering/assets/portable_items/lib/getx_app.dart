import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'feature.dart';
import 'repository.dart';

class ItemController extends GetxController {
  ItemController(ItemRepository repo) {
    actions =
        ItemActions(repo, () => state.value, (value) => state.value = value);
  }

  final state = const ItemState().obs;
  late final ItemActions actions;

  @override
  void onClose() {
    actions.dispose();
    super.onClose();
  }
}

Widget getxApp(GetIt locator) => GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => Scaffold(
            body: TextButton(
                onPressed: () => Get.toNamed('/items'),
                child: const Text('Open items')),
          ),
        ),
        GetPage(
          name: '/items',
          binding: BindingsBuilder(
              () => Get.lazyPut(() => ItemController(locator()))),
          page: () {
            final controller = Get.find<ItemController>();
            return Obx(
                () => ItemScreen(controller.state.value, controller.actions));
          },
        ),
      ],
    );
