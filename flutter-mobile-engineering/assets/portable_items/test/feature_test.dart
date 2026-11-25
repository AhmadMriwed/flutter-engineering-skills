import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:portable_items/cubit_app.dart';
import 'package:portable_items/feature.dart';
import 'package:portable_items/getx_app.dart';
import 'package:portable_items/repository.dart';

class FixtureTransport implements HttpClientAdapter {
  final stale = Completer<ResponseBody>();
  final outdatedPage = Completer<ResponseBody>();
  int saves = 0;

  @override
  Future<ResponseBody> fetch(RequestOptions request, Stream<Uint8List>? body,
      Future<void>? cancelFuture) async {
    switch (request.method) {
      case 'POST':
        saves++;
        return ResponseBody.fromString('', 204);
      case 'GET':
        final query = request.queryParameters['q'];
        if (query == 'stale') return stale.future;
        if (query == 'fail') return ResponseBody.fromString('', 503);
        final cursor = request.queryParameters['cursor'];
        if (query == 'paged' && cursor != null) return outdatedPage.future;
        return page(
            label: cursor == null ? 'First result' : 'Next result',
            next: cursor == null ? 'page-2' : null,
            id: cursor == null ? 1 : 2);
      default:
        throw StateError('Unexpected request');
    }
  }

  ResponseBody page({required String label, String? next, int id = 3}) =>
      ResponseBody.fromString(
        jsonEncode({
          'items': [
            {'id': id, 'label': label}
          ],
          'next': next
        }),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType]
        },
      );

  @override
  void close({bool force = false}) {}
}

void main() {
  const apps = {'GetX': getxApp, 'Cubit': cubitApp};
  for (final entry in apps.entries) {
    testWidgets('${entry.key} route, form, paging, stale request and disposal',
        (tester) async {
      final locator = GetIt.asNewInstance();
      final transport = FixtureTransport();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.invalid'))
        ..httpClientAdapter = transport;
      final actions = <ItemActions>[];
      final repo = DioItemRepository(dio);
      locator.registerSingleton<ItemRepository>(repo);
      await tester.pumpWidget(entry.value(locator));
      await tester.tap(find.text('Open items'));
      await tester.pumpAndSettle();
      actions.add(tester.widget<ItemScreen>(find.byType(ItemScreen)).actions);

      final search = find.byKey(const Key('search'));
      await tester.enterText(search, 'fail');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.text('Retry'), findsOneWidget);

      await tester.enterText(search, 'stale');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      await tester.enterText(search, 'new');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      transport.stale.complete(transport.page(label: 'Stale result'));
      await tester.pumpAndSettle();
      expect(find.text('Stale result'), findsNothing);
      expect(find.text('First result'), findsOneWidget);
      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();
      expect(find.text('Next result'), findsOneWidget);

      await tester.enterText(search, 'paged');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.tap(find.text('More'));
      await tester.pump();
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      await tester.enterText(search, 'filtered');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      transport.outdatedPage.complete(transport.page(label: 'Obsolete page'));
      await tester.pumpAndSettle();
      expect(find.text('Obsolete page'), findsNothing);
      expect(find.text('First result'), findsOneWidget);
      expect(find.text('More'), findsOneWidget);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a label'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('label')), 'Example item');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(transport.saves, 1);

      Navigator.of(tester.element(find.byType(ItemScreen))).pop();
      await tester.pumpAndSettle();
      expect(actions.single.disposed, isTrue);
      await tester.tap(find.text('Open items'));
      await tester.pumpAndSettle();
      final current =
          tester.widget<ItemScreen>(find.byType(ItemScreen)).actions;
      expect(current, isNot(same(actions.single)));
      expect(current.disposed, isFalse);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await locator.reset();
      Get.reset();
      dio.close();
    });
  }
}
