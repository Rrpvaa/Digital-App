import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'toko_digital.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE master_products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            price REAL NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE local_cart (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            product_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            price REAL NOT NULL,
            quantity INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // =========================
  // PRODUK
  // =========================

  static Future<int> insertProduct(
    String name,
    double price,
  ) async {
    final db = await database;

    return await db.insert(
      'master_products',
      {
        'name': name,
        'price': price,
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;

    return await db.query('master_products');
  }

  // =========================
  // KERANJANG
  // =========================

  static Future<int> addToCart(
    int productId,
    String name,
    double price,
  ) async {
    final db = await database;

    // Cek apakah produk sudah ada di keranjang
    final existing = await db.query(
      'local_cart',
      where: 'product_id = ?',
      whereArgs: [productId],
    );

    if (existing.isNotEmpty) {
      // Kalau sudah ada, tambah quantity
      int currentQuantity = existing.first['quantity'] as int;

      return await db.update(
        'local_cart',
        {
          'quantity': currentQuantity + 1,
        },
        where: 'product_id = ?',
        whereArgs: [productId],
      );
    }

    // Kalau belum ada, masukkan sebagai item baru
    return await db.insert(
      'local_cart',
      {
        'product_id': productId,
        'name': name,
        'price': price,
        'quantity': 1,
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getCart() async {
    final db = await database;

    return await db.query('local_cart');
  }

  // Tambah jumlah
  static Future<void> increaseQuantity(int cartId) async {
    final db = await database;

    final result = await db.query(
      'local_cart',
      where: 'id = ?',
      whereArgs: [cartId],
    );

    if (result.isNotEmpty) {
      int quantity = result.first['quantity'] as int;

      await db.update(
        'local_cart',
        {
          'quantity': quantity + 1,
        },
        where: 'id = ?',
        whereArgs: [cartId],
      );
    }
  }

  // Kurangi jumlah
  static Future<void> decreaseQuantity(int cartId) async {
    final db = await database;

    final result = await db.query(
      'local_cart',
      where: 'id = ?',
      whereArgs: [cartId],
    );

    if (result.isNotEmpty) {
      int quantity = result.first['quantity'] as int;

      if (quantity > 1) {
        await db.update(
          'local_cart',
          {
            'quantity': quantity - 1,
          },
          where: 'id = ?',
          whereArgs: [cartId],
        );
      } else {
        await db.delete(
          'local_cart',
          where: 'id = ?',
          whereArgs: [cartId],
        );
      }
    }
  }

  // Hapus item dari keranjang
  static Future<void> removeFromCart(int cartId) async {
    final db = await database;

    await db.delete(
      'local_cart',
      where: 'id = ?',
      whereArgs: [cartId],
    );
  }

  // Kosongkan keranjang
  static Future<void> clearCart() async {
    final db = await database;

    await db.delete('local_cart');
  }
}