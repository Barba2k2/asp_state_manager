import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/shopping_item_repository.dart';
import '../../domain/entities/shopping_item.dart';

class ShoppingListNotifier extends StateNotifier<List<ShoppingItem>> {
  final ShoppingItemRepository _repository;

  ShoppingListNotifier(this._repository) : super([]);

  Future<void> addItem(ShoppingItem item) async {
    await _repository.addItem(item);
    state = [...state, item];
  }

  Future<void> loadItems() async {
    final items = await _repository.getItems();
    state = items;
  }

  Future<void> updateItem(ShoppingItem updatedItem) async {
    await _repository.updateItem(updatedItem);
    state = [
      for (final item in state)
        if (item.name == updatedItem.name) updatedItem else item,
    ];
  }

  Future<void> removeItem(String itemName) async {
    await _repository.removeItem(itemName);
    state = state.where((item) => item.name != itemName).toList();
  }

  Future<void> toggleUrgentStatus(ShoppingItem item) async {
    final updatedItem = item.toggleUrgent();
    await updateItem(updatedItem);
  }

  Future<void> incrementPurchaseCount(ShoppingItem item) async {
    final updatedItem = item.incrementPurchaseCount();
    await updateItem(updatedItem);
  }
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<ShoppingItem>>((ref) {
  final repository = ShoppingItemRepository();
  return ShoppingListNotifier(repository);
});
