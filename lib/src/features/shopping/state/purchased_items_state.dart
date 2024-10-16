import 'package:flutter_riverpod/flutter_riverpod.dart';

// Estado dos Itens Comprados
class PurchasedItemsState {
  final List<String> items;
  PurchasedItemsState({
    this.items = const [],
  });

  PurchasedItemsState addPurchasedItem(String item) {
    return PurchasedItemsState(
      items: [...items, item],
    );
  }
}

final purchasedItemsProvider =
    StateNotifierProvider<PurchasedItemsNotifier, PurchasedItemsState>(
  (ref) => PurchasedItemsNotifier(),
);

class PurchasedItemsNotifier extends StateNotifier<PurchasedItemsState> {
  PurchasedItemsNotifier() : super(PurchasedItemsState());

  void addPurchasedItem(String item) {
    state = state.addPurchasedItem(item);
  }
}
