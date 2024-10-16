import 'package:flutter_riverpod/flutter_riverpod.dart';

// Estado da Lista de Compras
class ShoppingListState {
  final List<String> items;
  ShoppingListState({this.items = const []});

  ShoppingListState addItem(String item) {
    return ShoppingListState(items: [...items, item]);
  }

  ShoppingListState removeItem(String item) {
    return ShoppingListState(items: items.where((i) => i != item).toList());
  }
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, ShoppingListState>(
  (ref) => ShoppingListNotifier(),
);

class ShoppingListNotifier extends StateNotifier<ShoppingListState> {
  ShoppingListNotifier() : super(ShoppingListState());

  void addItem(String item) {
    state = state.addItem(item);
  }

  void removeItem(String item) {
    state = state.removeItem(item);
  }
}
