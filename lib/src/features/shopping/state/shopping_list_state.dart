import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../entities/shopping_item_entitie.dart';

// Estado da Lista de Compras
class ShoppingListState {
  final List<ShoppingItem> items;
  ShoppingListState({this.items = const []});

  ShoppingListState addItem(ShoppingItem item) {
    return ShoppingListState(items: [...items, item]);
  }

  ShoppingListState removeItem(ShoppingItem item) {
    return ShoppingListState(
        items: items.where((i) => i.name != item.name).toList());
  }
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, ShoppingListState>(
  (ref) => ShoppingListNotifier(),
);

class ShoppingListNotifier extends StateNotifier<ShoppingListState> {
  ShoppingListNotifier() : super(ShoppingListState()) {
    _loadItems();
  }

  void addItem(ShoppingItem item) async {
    state = state.addItem(item);
    await _saveItems();
  }

  void removeItem(ShoppingItem item) async {
    state = state.removeItem(item);
    await _saveItems();
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList('shopping_list');
    if (items != null) {
      final parsedItems = items.map(
        (item) {
          final split = item.split('::');
          return ShoppingItem(name: split[0], category: split[1]);
        },
      ).toList();

      state = ShoppingListState(items: parsedItems);
    }
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> itemsToSave = state.items
        .map(
          (item) => '${item.name}::${item.category}',
        )
        .toList();

    await prefs.setStringList('shopping_list', itemsToSave);
  }
}
