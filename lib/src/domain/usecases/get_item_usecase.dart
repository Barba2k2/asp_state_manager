import '../../data/repositories/shopping_item_repository.dart';
import '../entities/shopping_item.dart';

class GetItemsUseCase {
  final ShoppingItemRepository repository;

  GetItemsUseCase({required this.repository});

  Future<List<ShoppingItem>> call() async {
    return await repository.getItems();
  }
}
