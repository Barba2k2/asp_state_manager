import '../../domain/entities/shopping_item.dart';
import '../datasources/database_helper.dart';

class ShoppingItemRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> addItem(ShoppingItem item) async {
    final db = await _databaseHelper.database;
    await db.insert('shopping_items', {
      'name': item.name,
      'category': item.category,
      'isUrgent': item.isUrgent ? 1 : 0,
      'purchaseCount': item.purchaseCount,
      'price': item.price ?? 0.0,
      'priceType': item.priceType,
    });
  }

  Future<List<ShoppingItem>> getItems() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('shopping_items');

    return List.generate(maps.length, (i) {
      return ShoppingItem(
        name: maps[i]['name'],
        category: maps[i]['category'],
        isUrgent: maps[i]['isUrgent'] == 1,
        purchaseCount: maps[i]['purchaseCount'],
        price: maps[i]['price'],
        priceType: maps[i]['priceType'],
      );
    });
  }

  Future<void> updateItem(ShoppingItem item) async {
    final db = await _databaseHelper.database;
    await db.update(
      'shopping_items',
      {
        'name': item.name,
        'category': item.category,
        'isUrgent': item.isUrgent ? 1 : 0,
        'purchaseCount': item.purchaseCount,
        'price': item.price ?? 0.0,
        'priceType': item.priceType,
      },
      where: 'name = ?',
      whereArgs: [item.name],
    );
  }

  Future<void> removeItem(String name) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'shopping_items',
      where: 'name = ?',
      whereArgs: [name],
    );
  }
}
