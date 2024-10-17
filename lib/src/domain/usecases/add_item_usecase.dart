import '../../data/repositories/shopping_item_repository.dart';
import '../entities/shopping_item.dart';

class AddItemUseCase {
  final ShoppingItemRepository repository;

  AddItemUseCase({required this.repository});

  Future<void> call(ShoppingItem item) async {
    await repository.addItem(item);
  }
}
