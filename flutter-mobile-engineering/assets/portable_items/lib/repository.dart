import 'package:dio/dio.dart';

class Item {
  const Item(this.id, this.label);
  final int id;
  final String label;

  factory Item.fromJson(Map<String, dynamic> json) =>
      Item(json['id'] as int, json['label'] as String);
}

class ItemPage {
  ItemPage(Iterable<Item> items, this.next) : items = List.unmodifiable(items);
  final List<Item> items;
  final String? next;
}

abstract interface class ItemRepository {
  Future<ItemPage> list(String query, String? cursor, CancelToken cancel);
  Future<void> save(String label);
}

class DioItemRepository implements ItemRepository {
  DioItemRepository(this.dio);
  final Dio dio;

  @override
  Future<ItemPage> list(
      String query, String? cursor, CancelToken cancel) async {
    final response = await dio.get<Map<String, dynamic>>('/items',
        queryParameters: {'q': query, if (cursor != null) 'cursor': cursor},
        cancelToken: cancel);
    final data = response.data!;
    return ItemPage(
      (data['items'] as List).cast<Map<String, dynamic>>().map(Item.fromJson),
      data['next'] as String?,
    );
  }

  @override
  Future<void> save(String label) =>
      dio.post<void>('/items', data: {'label': label});
}
