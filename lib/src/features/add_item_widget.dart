import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/shopping/state/suggested_items_state.dart';
import 'shopping/state/shopping_list_state.dart';

class AddItemWidget extends ConsumerWidget {
  const AddItemWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController itemController = TextEditingController();

    return TextField(
      controller: itemController,
      decoration: InputDecoration(
        labelText: 'Novo item',
        suffixIcon: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            final newItem = itemController.text.trim();
            if (newItem.isNotEmpty) {
              ref.read(shoppingListProvider.notifier).addItem(newItem);
              ref
                  .read(suggestedItemsProvider.notifier)
                  .addSuggestedItem(newItem);
              itemController.clear();
            }
          },
        ),
      ),
    );
  }
}
