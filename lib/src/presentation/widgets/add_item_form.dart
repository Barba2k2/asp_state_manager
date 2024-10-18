import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/shopping_item.dart';
// import '../../features/shopping/state/shopping_list_state.dart';
import '../../application/notifiers/shopping_list_notifier.dart';

class AddItemForm extends ConsumerStatefulWidget {
  const AddItemForm({super.key});

  @override
  ConsumerState<AddItemForm> createState() => _AddItemFormState();
}

class _AddItemFormState extends ConsumerState<AddItemForm> {
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
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d{0,2}')),
          ],
          decoration: const InputDecoration(
            labelText: 'Preço do Item',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        DropdownButton(
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
              log('Categoria selecionada: $selectedCategory');
            }
          },
        ),
        DropdownButton(
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
            if (value != null) {
              setState(() {
                selectedPriceType = value;
              });
              log('Tipo de preço selecionado: $selectedPriceType');
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
              log('''
                Tentando adicionar item: ${newItem.name}
                Preço: ${newItem.price}
                Categoria: ${newItem.category}
                Tipo de Preço: ${newItem.priceType}
              ''');
              await ref
                  .read(shoppingListProvider.notifier)
                  .addItem(newItem);
              log('Item adicionado com sucesso e estado deve ser atualizado agora.');
        
              _itemController.clear();
              _priceController.clear();
            }
          },
          child: const Text('Adicionar Item'),
        ),
      ],
    );
  }
}
