import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/shopping_item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'shopping_list.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE shopping_items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            category TEXT,
            isUrgent INTEGER,
            purchaseCount INTEGER,
            price REAL,
            priceType TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE purchase_history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            itemName TEXT,
            datePurchased TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            categoryName TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db
              .execute('ALTER TABLE shopping_items ADD COLUMN priceType TEXT');
        }
      },
    );
  }

  Future<int> addItem(ShoppingItem item) async {
    final db = await database;
    return await db.insert('shopping_items', {
      'name': item.name,
      'category': item.category,
      'isUrgent': item.isUrgent ? 1 : 0,
      'purchaseCount': item.purchaseCount,
      'price': item.price ?? 0.0,
      'priceType': item.priceType,
    });
  }

  Future<List<ShoppingItem>> getItems() async {
    final db = await database;
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

  Future<int> updateItem(ShoppingItem item) async {
    final db = await database;
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
      where: 'name = ?',
      whereArgs: [item.name],
    );
  }

  Future<int> deleteItem(String name) async {
    final db = await database;
    return await db.delete(
      'shopping_items',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<int> addPurchaseHistory(String itemName) async {
    final db = await database;
    return await db.insert('purchase_history', {
      'itemName': itemName,
      'datePurchased': DateTime.now().toIso8601String(),
    });
  }

  Future<List<String>> getPurchaseHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('purchase_history');
    return maps.map((map) => map['itemName'] as String).toList();
  }
}
