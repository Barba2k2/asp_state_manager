import 'package:flutter_riverpod/flutter_riverpod.dart';

// Estado dos Itens Sugeridos
class SuggestedItemsState {
  final List<String> items;
  SuggestedItemsState({this.items = const []});

  SuggestedItemsState addSuggestedItem(String item) {
    if (!items.contains(item)) {
      return SuggestedItemsState(items: [...items, item]);
    }
    return this;
  }
}

final suggestedItemsProvider =
    StateNotifierProvider<SuggestedItemsNotifier, SuggestedItemsState>(
  (ref) => SuggestedItemsNotifier(),
);

class SuggestedItemsNotifier extends StateNotifier<SuggestedItemsState> {
  SuggestedItemsNotifier() : super(SuggestedItemsState());

  void addSuggestedItem(String item) {
    state = state.addSuggestedItem(item);
  }
}
