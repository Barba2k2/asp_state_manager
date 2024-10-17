import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/database_helper.dart';
import '../../data/repositories/shopping_item_repository.dart';
import '../../domain/entities/shopping_item.dart';

class ShoppingListNotifier extends StateNotifier<List<ShoppingItem>> {
  ShoppingListNotifier(ShoppingItemRepository repository) : super([]) {
    loadItems();
  }

  void addItem(ShoppingItem item) async {
    try {
      await DatabaseHelper().addItem(item);
      loadItems();
    } catch (e) {
      log('Error adding item: $e');
    }
  }

  void removeItem(ShoppingItem item) async {
    try {
      await DatabaseHelper().deleteItem(item.id!);
      loadItems();
    } catch (e) {
      log('Error removing item: $e');
    }
  }

  void toggleUrgentStatus(ShoppingItem item) async {
    try {
      final updatedItem = item.toggleUrgent();
      await DatabaseHelper().updateItem(updatedItem);
      loadItems();
    } catch (e) {
      log('Error toggling urgent status: $e');
    }
  }

  void incrementPurchaseCount(ShoppingItem item) async {
    try {
      final updatedItem = item.incrementPurchaseCount();
      await DatabaseHelper().updateItem(updatedItem);
      await DatabaseHelper().addPurchaseHistory(item.name);
      loadItems();
    } catch (e) {
      log('Error incrementing purchase count: $e');
    }
  }

  void markAsPurchased(ShoppingItem item) async {
    try {
      final updatedItem = item.incrementPurchaseCount();
      await DatabaseHelper().updateItem(updatedItem);
      await DatabaseHelper().addPurchaseHistory(item.name);
      loadItems();
    } catch (e) {
      log('Error marking item as purchased: $e');
    }
  }

  Future<void> loadItems() async {
    try {
      final items = await DatabaseHelper().getItems();
      state = items;
    } catch (e) {
      log('Error loading items: $e');
    }
  }
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<ShoppingItem>>(
  (ref) {
    final repository = ShoppingItemRepository();
    return ShoppingListNotifier(repository);
  },
);
