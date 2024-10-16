import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../add_item_widget.dart';
import '../state/purchased_items_state.dart';
import '../state/shopping_list_state.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  String selectedCategoryFilter = 'Todos';

  @override
  Widget build(BuildContext context) {
    final shoppingList = ref.watch(shoppingListProvider).items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras Inteligente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const AddItemWidget(),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedCategoryFilter,
              items: ['Todos', 'Hortifruti', 'Laticínios', 'Limpeza', 'Outros']
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategoryFilter = value;
                  });
                }
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: shoppingList.length,
                itemBuilder: (context, index) {
                  final item = shoppingList[index];
                  if (selectedCategoryFilter == 'Todos' ||
                      item.category == selectedCategoryFilter) {
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.category),
                      trailing: IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          ref
                              .read(shoppingListProvider.notifier)
                              .removeItem(item);
                          ref
                              .read(purchasedItemsProvider.notifier)
                              .addPurchasedItem(item.name);
                        },
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
