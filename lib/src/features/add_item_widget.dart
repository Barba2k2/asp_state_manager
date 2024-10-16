import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/shopping_item_entitie.dart';
import '../features/shopping/state/shopping_list_state.dart';

class AddItemWidget extends ConsumerStatefulWidget {
  const AddItemWidget({super.key});

  @override
  _AddItemWidgetState createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends ConsumerState<AddItemWidget> {
  TextEditingController itemController = TextEditingController();
  String selectedCategory = 'Hortifruti';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: itemController,
          decoration: const InputDecoration(
            labelText: 'Novo item',
          ),
        ),
        DropdownButton<String>(
          value: selectedCategory,
          items: ['Hortifruti', 'Laticínios', 'Limpeza', 'Outros']
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
                selectedCategory = value;
              });
            }
          },
        ),
        ElevatedButton(
          onPressed: () {
            final newItemName = itemController.text.trim();
            if (newItemName.isNotEmpty) {
              final newItem = ShoppingItem(
                name: newItemName,
                category: selectedCategory,
              );
              ref.read(shoppingListProvider.notifier).addItem(newItem);
              itemController.clear();
              setState(() {
                selectedCategory = 'Hortifruti';
              });
            }
          },
          child: const Text('Adicionar Item'),
        ),
      ],
    );
  }
}
