import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/shopping_item_repository.dart';
import '../../domain/entities/shopping_item.dart';

class ShoppingListNotifier extends StateNotifier<List<ShoppingItem>> {
  final ShoppingItemRepository _repository;

  ShoppingListNotifier(this._repository) : super([]) {
    loadItems();
  }

  Future<void> addItem(ShoppingItem item) async {
    try {
      final id = await _repository.addItem(item);
      final newItem = item.copyWith(id: id);
      state = [...state, newItem];
    } catch (e) {
      log('Erro ao adicionar item: $e');
    }
  }

  Future<void> loadItems() async {
    try {
      final items = await _repository.getItems();
      state = items;
    } catch (e) {
      log('Erro ao carregar itens: $e');
    }
  }

  Future<void> updateItem(ShoppingItem updatedItem) async {
    try {
      await _repository.updateItem(updatedItem);
      state = [
        for (final item in state)
          if (item.id == updatedItem.id) updatedItem else item,
      ];
    } catch (e) {
      log('Erro ao atualizar item: $e');
    }
  }

  Future<void> removeItem(int id) async {
    try {
      await _repository.removeItem(id);
      state = state.where((item) => item.id != id).toList();
    } catch (e) {
      log('Erro ao remover item: $e');
    }
  }

  Future<void> toggleUrgentStatus(ShoppingItem item) async {
    try {
      final updatedItem = item.toggleUrgent();
      await updateItem(updatedItem);
    } catch (e) {
      log('Erro ao alterar status de urgência: $e');
    }
  }

  Future<void> incrementPurchaseCount(ShoppingItem item) async {
    try {
      final updatedItem = item.incrementPurchaseCount();
      await updateItem(updatedItem);
    } catch (e) {
      log('Erro ao incrementar contagem de compra: $e');
    }
  }
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<ShoppingItem>>((ref) {
  final repository = ShoppingItemRepository();
  return ShoppingListNotifier(repository);
});
