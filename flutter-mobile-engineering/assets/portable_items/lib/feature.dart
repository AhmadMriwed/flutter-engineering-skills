import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'repository.dart';

enum Phase { initial, loading, ready, failed }

class ItemState {
  const ItemState({
    this.items = const [],
    this.phase = Phase.initial,
    this.save = Phase.initial,
    this.next,
  });

  final List<Item> items;
  final Phase phase;
  final Phase save;
  final String? next;

  ItemState withSave(Phase value) =>
      ItemState(items: items, phase: phase, save: value, next: next);
}

class ItemActions {
  ItemActions(this.repo, this.read, this.emit);
  final ItemRepository repo;
  final ItemState Function() read;
  final void Function(ItemState) emit;
  String _query = '';
  CancelToken? _active;
  bool disposed = false;

  Future<void> search(String query) {
    _query = query.trim();
    return _load(append: false);
  }

  Future<void> more() async {
    if (_active != null || read().next == null) return;
    await _load(append: true);
  }

  Future<void> _load({required bool append}) async {
    if (disposed) return;
    _active?.cancel();
    final token = _active = CancelToken();
    final previous = read();
    final cursor = append ? previous.next : null;
    final items = append ? previous.items : const <Item>[];
    emit(ItemState(items: items, phase: Phase.loading, save: previous.save));
    try {
      final page = await repo.list(_query, cursor, token);
      if (disposed || !identical(_active, token)) return;
      final byId = {
        for (final item in [...items, ...page.items]) item.id: item
      };
      emit(ItemState(
          items: List.unmodifiable(byId.values),
          phase: Phase.ready,
          save: read().save,
          next: page.next == cursor ? null : page.next));
    } catch (_) {
      if (disposed || !identical(_active, token)) return;
      emit(ItemState(
          items: items, phase: Phase.failed, save: read().save, next: cursor));
    } finally {
      if (identical(_active, token)) _active = null;
    }
  }

  Future<void> save(String label) async {
    if (disposed || read().save == Phase.loading) return;
    emit(read().withSave(Phase.loading));
    try {
      await repo.save(label);
    } catch (_) {
      if (!disposed) emit(read().withSave(Phase.failed));
      return;
    }
    if (disposed) return;
    emit(read().withSave(Phase.ready));
    await search(_query);
  }

  void dispose() {
    disposed = true;
    _active?.cancel();
  }
}

class ItemScreen extends StatefulWidget {
  const ItemScreen(this.state, this.actions, {super.key});
  final ItemState state;
  final ItemActions actions;

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final _form = GlobalKey<FormState>();
  String _label = '';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              key: const Key('search'),
              decoration: const InputDecoration(labelText: 'Search'),
              onChanged: (value) => _query = value,
              onSubmitted: (value) => unawaited(widget.actions.search(value)),
            ),
            if (state.phase == Phase.loading) const LinearProgressIndicator(),
            if (state.phase == Phase.failed)
              TextButton(
                onPressed: state.next != null
                    ? widget.actions.more
                    : () => widget.actions.search(_query),
                child: const Text('Retry'),
              ),
            if (state.phase == Phase.ready && state.items.isEmpty)
              const Text('No items'),
            Expanded(
              child: ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (_, index) => ItemRow(state.items[index]),
              ),
            ),
            if (state.phase == Phase.ready && state.next != null)
              TextButton(
                  onPressed: widget.actions.more, child: const Text('More')),
            Form(
              key: _form,
              child: TextFormField(
                key: const Key('label'),
                onChanged: (value) => _label = value.trim(),
                validator: (_) => _label.isEmpty ? 'Enter a label' : null,
              ),
            ),
            if (state.save == Phase.failed) const Text('Could not save'),
            FilledButton(
              onPressed: state.save == Phase.loading
                  ? null
                  : () {
                      if (_form.currentState!.validate()) {
                        unawaited(widget.actions.save(_label));
                      }
                    },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemRow extends StatelessWidget {
  const ItemRow(this.item, {super.key});
  final Item item;

  @override
  Widget build(BuildContext context) => ListTile(title: Text(item.label));
}
