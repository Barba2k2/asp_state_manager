import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/shopping_item.dart';
import '../../../data/datasources/database_helper.dart';

class ShoppingListState {
  final List<ShoppingItem> items;
  ShoppingListState({this.items = const []});

  ShoppingListState addItem(ShoppingItem item) {
    return ShoppingListState(
      items: [...items, item],
    );
  }

  ShoppingListState removeItem(ShoppingItem item) {
    return ShoppingListState(
      items: items.where((i) => i.name != item.name).toList(),
    );
  }

  ShoppingListState updateItem(ShoppingItem updatedItem) {
    return ShoppingListState(
      items: items
          .map(
            (i) => i.name == updatedItem.name ? updatedItem : i,
          )
          .toList(),
    );
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
    await DatabaseHelper().addItem(item);
    _loadItems();
  }

  void removeItem(ShoppingItem item) async {
    await DatabaseHelper().deleteItem(item.id!);
    _loadItems();
  }

  void toggleUrgentStatus(ShoppingItem item) async {
    final updatedItem = item.toggleUrgent();
    await DatabaseHelper().updateItem(updatedItem);
    _loadItems();
  }

  void incrementPurchaseCount(ShoppingItem item) async {
    final updatedItem = item.incrementPurchaseCount();
    await DatabaseHelper().updateItem(updatedItem);
    await DatabaseHelper().addPurchaseHistory(item.name);
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await DatabaseHelper().getItems();
    state = ShoppingListState(items: items);
  }
}
