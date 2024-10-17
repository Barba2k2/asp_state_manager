import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/notifiers/shopping_list_notifier.dart';
import '../widgets/add_item_form.dart';

class ShoppingListScreen extends ConsumerWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shoppingList = ref.watch(shoppingListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras Inteligente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const AddItemForm(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: shoppingList.length,
                itemBuilder: (context, index) {
                  final item = shoppingList[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(
                          'Categoria: ${item.category}, Preço: R\$ ${item.price?.toStringAsFixed(2) ?? ''}, Tipo: ${item.priceType}'),
                      trailing: IconButton(
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
