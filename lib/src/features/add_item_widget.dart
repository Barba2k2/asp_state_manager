import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/shopping_item.dart';
import '../application/notifiers/shopping_list_notifier.dart';

class AddItemWidget extends ConsumerStatefulWidget {
  const AddItemWidget({super.key});

  @override
  ConsumerState<AddItemWidget> createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends ConsumerState<AddItemWidget> {
  final _itemController = TextEditingController();
  final _priceController = TextEditingController();
  var selectedCategory = 'Hortifruti';
  var selectedPriceType = 'Unidade';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _itemController,
          decoration: const InputDecoration(
            labelText: 'Novo item',
          ),
        ),
        TextField(
          controller: _priceController,
          decoration: const InputDecoration(
            labelText: 'Preço do Item',
          ),
          keyboardType: TextInputType.number,
        ),
        DropdownButton(
          value: selectedCategory,
          items: ['Hortifruti', 'Laticínios', 'Limpeza', 'Bebida', 'Outros']
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
        DropdownButton(
          value: selectedPriceType,
          items: ['Unidade', 'Quilo (Kg)', 'Bandeja', 'Litro']
              .map(
                (priceType) => DropdownMenuItem(
                  value: priceType,
                  child: Text(priceType),
                ),
              )
              .toList(),
          onChanged: (value) {
            log('Price: ${_priceController.toString()}');
            if (value != null) {
              setState(() {
                selectedPriceType = value;
              });
            }
          },
        ),
        ElevatedButton(
          onPressed: () async {
            final newItemName = _itemController.text.trim();
            final newItemPrice =
                double.tryParse(_priceController.text.trim()) ?? 0.0;

            if (newItemName.isNotEmpty) {
              final newItem = ShoppingItem(
                name: newItemName,
                category: selectedCategory,
                price: newItemPrice,
                priceType: selectedPriceType,
              );
              await ref.read(shoppingListProvider.notifier).addItem(newItem);
              log('Item adicionado: $newItemName');

              // Limpar campos e resetar valores após adicionar com sucesso
              _itemController.clear();
              _priceController.clear();
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
