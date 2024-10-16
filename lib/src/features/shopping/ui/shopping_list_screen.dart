import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../add_item_widget.dart';
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
                    return Card(
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Categoria: ${item.category}'),
                            Text('Comprado ${item.purchaseCount} vezes'),
                            if (item.price != null)
                              Text(
                                'Preço: R\$ ${item.price!.toStringAsFixed(2)} por ${item.priceType}',
                              ),
                            if (item.isUrgent)
                              const Text(
                                'Urgente',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                item.isUrgent
                                    ? Icons.warning
                                    : Icons.warning_outlined,
                                color: item.isUrgent ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                ref
                                    .read(shoppingListProvider.notifier)
                                    .toggleUrgentStatus(item);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () {
                                ref
                                    .read(shoppingListProvider.notifier)
                                    .removeItem(item);
                                ref
                                    .read(shoppingListProvider.notifier)
                                    .incrementPurchaseCount(item);
                              },
                            ),
                          ],
                        ),
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
