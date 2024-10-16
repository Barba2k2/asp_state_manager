import 'dart:developer';

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
  TextEditingController priceController = TextEditingController();
  String selectedCategory = 'Hortifruti';
  String selectedPriceType = 'Unidade';

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
        TextField(
          controller: priceController,
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
        DropdownButton<String>(
          value: selectedPriceType,
          items: ['Unidade', 'Quilo', 'Bandeja', 'Litro']
              .map(
                (priceType) => DropdownMenuItem(
                  value: priceType,
                  child: Text(priceType),
                ),
              )
              .toList(),
          onChanged: (value) {
            log('PriceL ${priceController.toString()}');
            if (value != null) {
              setState(() {
                selectedPriceType = value;
              });
            }
          },
        ),
        ElevatedButton(
          onPressed: () {
            final newItemName = itemController.text.trim();
            final newItemPrice =
                double.tryParse(priceController.text.trim()) ?? 0.0;

            if (newItemName.isNotEmpty) {
              final newItem = ShoppingItem(
                name: newItemName,
                category: selectedCategory,
                price: newItemPrice,
                priceType: selectedPriceType,
              );
              ref.read(shoppingListProvider.notifier).addItem(newItem);
              itemController.clear();
              priceController.clear();
              setState(() {
                selectedCategory = 'Hortifruti';
                selectedPriceType = 'Unidade';
              });
            }
          },
          child: const Text('Adicionar Item'),
        ),
      ],
    );
  }
}
