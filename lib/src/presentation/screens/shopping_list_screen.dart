import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/notifiers/shopping_list_notifier.dart';
import '../widgets/add_item_form.dart';
import 'dart:developer';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        log('Iniciando carregamento dos itens na inicialização do widget.');
        ref.read(shoppingListProvider.notifier).loadItems();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final shoppingList = ref.watch(shoppingListProvider);
    log('Construindo tela com ${shoppingList.length} itens');

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
              child: shoppingList.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum item na lista. Adicione um novo item!',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: shoppingList.length,
                      itemBuilder: (context, index) {
                        final item = shoppingList[index];
                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            title: Text(item.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Categoria: ${item.category}'),
                                Text(
                                  'Preço: R\$ ${item.price?.toStringAsFixed(2) ?? ''}',
                                ),
                                Text('Tipo: ${item.priceType}'),
                                Text('Comprado: ${item.purchaseCount} vezes'),
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
                                    color: item.isUrgent
                                        ? Colors.red
                                        : Colors.grey,
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
                                        .markAsPurchased(item);
                                  },
                                ),
                              ],
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
