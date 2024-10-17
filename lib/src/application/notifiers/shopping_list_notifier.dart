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
      log('Tentando adicionar item ao banco de dados: ${item.name}');
      final id = await _repository.addItem(item);
      log('Item adicionado ao banco de dados com ID: $id');

      final newItem = item.copyWith(id: id);
      state = [...state, newItem];
      log('Item adicionado ao estado. Total de itens: ${state.length}');
    } catch (e) {
      log('Erro ao adicionar item: $e');
    }
  }

  Future<void> loadItems() async {
    try {
      log('Carregando itens do banco de dados...');
      final items = await _repository.getItems();
      log('Itens carregados do banco de dados: ${items.length} itens encontrados');
      state = items;
      log('Estado atualizado após carregar itens. Total de itens no estado: ${state.length}');
    } catch (e) {
      log('Erro ao carregar itens: $e');
    }
  }

  Future<void> removeItem(ShoppingItem item) async {
    try {
      log('Removendo item: ${item.name} (ID: ${item.id})');
      await _repository.removeItem(item.id!);
      state =
          state.where((existingItem) => existingItem.id != item.id).toList();
      log('Item removido do estado. Total de itens: ${state.length}');
    } catch (e) {
      log('Erro ao remover item: $e');
    }
  }

  Future<void> toggleUrgentStatus(ShoppingItem item) async {
    try {
      log('Alternando status de urgência do item: ${item.name}');
      final updatedItem = item.toggleUrgent();
      await _repository.updateItem(updatedItem);
      state = [
        for (final i in state)
          if (i.id == updatedItem.id) updatedItem else i,
      ];
      log('Status de urgência alterado no estado.');
    } catch (e) {
      log('Erro ao alternar status de urgência: $e');
    }
  }

  Future<void> incrementPurchaseCount(ShoppingItem item) async {
    try {
      log('Incrementando contagem de compra do item: ${item.name}');
      final updatedItem = item.incrementPurchaseCount();
      await _repository.updateItem(updatedItem);
      await _repository.addPurchaseHistory(item.name);
      state = [
        for (final i in state)
          if (i.id == updatedItem.id) updatedItem else i,
      ];
      log('Contagem de compra incrementada no estado.');
    } catch (e) {
      log('Erro ao incrementar contagem de compra: $e');
    }
  }

  Future<void> markAsPurchased(ShoppingItem item) async {
    try {
      log('Marcando item como comprado: ${item.name}');
      final updatedItem = item.incrementPurchaseCount();
      await _repository.updateItem(updatedItem);
      await _repository.addPurchaseHistory(item.name);
      state = [
        for (final i in state)
          if (i.id == updatedItem.id) updatedItem else i,
      ];
      log('Item marcado como comprado no estado.');
    } catch (e) {
      log('Erro ao marcar item como comprado: $e');
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
