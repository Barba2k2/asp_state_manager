import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../add_item_widget.dart';
import '../state/purchased_items_state.dart';
import '../state/shopping_list_state.dart';
import '../state/suggested_items_state.dart';

class ShoppingListScreen extends ConsumerWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shoppingList = ref.watch(shoppingListProvider).items;
    final purchasedItems = ref.watch(purchasedItemsProvider).items;
    final suggestedItems = ref.watch(suggestedItemsProvider).items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras Inteligente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const AddItemWidget(),
            Expanded(
              child: ListView.builder(
                itemCount: shoppingList.length,
                itemBuilder: (context, index) {
                  final item = shoppingList[index];
                  return ListTile(
                    title: Text(item),
                    trailing: IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        ref
                            .read(shoppingListProvider.notifier)
                            .removeItem(item);
                        ref
                            .read(purchasedItemsProvider.notifier)
                            .addPurchasedItem(item);
                      },
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            const Text(
              'Sugestões:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            ...suggestedItems.map(
              (item) => Text(item),
            ),
            const Divider(),
            const Text(
              'Itens Comprados:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            ...purchasedItems.map(
              (item) => Text(item),
            ),
          ],
        ),
      ),
    );
  }
}
