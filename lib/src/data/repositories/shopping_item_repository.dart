import '../../domain/entities/shopping_item.dart';
import '../datasources/database_helper.dart';

class ShoppingItemRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> addItem(ShoppingItem item) async {
    final db = await _databaseHelper.database;
    return await db.insert(
      'shopping_items',
      {
        'name': item.name,
        'category': item.category,
        'isUrgent': item.isUrgent ? 1 : 0,
        'purchaseCount': item.purchaseCount,
        'price': item.price ?? 0.0,
        'priceType': item.priceType,
      },
    );
  }

  Future<List<ShoppingItem>> getItems() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('shopping_items');

    return List.generate(
      maps.length,
      (i) {
        return ShoppingItem(
          id: maps[i]['id'],
          name: maps[i]['name'],
          category: maps[i]['category'],
          isUrgent: maps[i]['isUrgent'] == 1,
          purchaseCount: maps[i]['purchaseCount'],
          price: maps[i]['price'],
          priceType: maps[i]['priceType'],
        );
      },
    );
  }

  Future<int> updateItem(ShoppingItem item) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'shopping_items',
      {
        'name': item.name,
        'category': item.category,
        'isUrgent': item.isUrgent ? 1 : 0,
        'purchaseCount': item.purchaseCount,
        'price': item.price ?? 0.0,
        'priceType': item.priceType,
      },
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> removeItem(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'shopping_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> addPurchaseHistory(String itemName) async {
    final db = await _databaseHelper.database;
    return await db.insert(
      'purchase_history',
      {
        'itemName': itemName,
        'datePurchased': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<List<String>> getPurchaseHistory() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('purchase_history');
    return maps.map((map) => map['itemName'] as String).toList();
  }
}
