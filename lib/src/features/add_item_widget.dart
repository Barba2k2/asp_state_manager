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
  final _itemControllerEC = TextEditingController();
  final _priceControllerEC = TextEditingController();
  String selectedCategory = 'Hortifruti';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _itemControllerEC,
          decoration: const InputDecoration(
            labelText: 'Novo item',
          ),
        ),
        TextField(
          controller: _priceControllerEC,
          decoration: const InputDecoration(
            labelText: 'Preço do Item',
          ),
          keyboardType: TextInputType.number,
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
            final newItemName = _itemControllerEC.text.trim();
            final newItemPrice =
                double.tryParse(_priceControllerEC.text.trim()) ?? 0.0;

            if (newItemName.isNotEmpty) {
              final newItem = ShoppingItem(
                name: newItemName,
                category: selectedCategory,
                price: newItemPrice,
              );
              ref.read(shoppingListProvider.notifier).addItem(newItem);
              _itemControllerEC.clear();
              _priceControllerEC.clear(); // Limpar o campo de preço
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
