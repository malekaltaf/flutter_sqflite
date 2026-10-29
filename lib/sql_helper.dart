import 'package:sqflite/sqflite.dart' as sql;

class UserItem {
  final int? id;
  final String title;
  final String description;
  final String createdAt;

  const UserItem({
    this.id,
    required this.title,
    required this.description,
    this.createdAt = '',
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      if (createdAt.isNotEmpty) 'createdAt': createdAt,
    };
  }

  factory UserItem.fromMap(Map<String, dynamic> map) {
    return UserItem(
      id: map['id'] as int?,
      title: (map['title'] as String?) ?? '',
      description: (map['description'] as String?) ?? '',
      createdAt: (map['createdAt'] as String?) ?? '',
    );
  }

  UserItem copyWith({
    int? id,
    String? title,
    String? description,
    String? createdAt,
  }) {
    return UserItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SQLHelper {
  static sql.Database? _database;

  static Future<void> createTables(sql.Database database) async {
    await database.execute('''CREATE TABLE items(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )''');
  }

  static Future<sql.Database> db() async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }
    _database = await sql.openDatabase(
      'dbtask.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
    return _database!;
  }

  static Future<int> createItem(UserItem item) async {
    final database = await db();
    return database.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<UserItem>> getItems({String? search}) async {
    final database = await db();
    final List<Map<String, dynamic>> maps;
    if (search != null && search.trim().isNotEmpty) {
      final term = '%${search.trim()}%';
      maps = await database.query(
        'items',
        where: 'title LIKE ? OR description LIKE ?',
        whereArgs: [term, term],
        orderBy: 'id DESC',
      );
    } else {
      maps = await database.query('items', orderBy: 'id DESC');
    }
    return maps.map(UserItem.fromMap).toList();
  }

  static Future<UserItem?> getItem(int id) async {
    final database = await db();
    final maps = await database.query(
      'items',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return UserItem.fromMap(maps.first);
    }
    return null;
  }

  static Future<int> updateItem(UserItem item) async {
    if (item.id == null) return 0;
    final database = await db();
    final data = {
      'title': item.title,
      'description': item.description,
      'createdAt': DateTime.now().toIso8601String(),
    };
    return database.update(
      'items',
      data,
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  static Future<int> deleteItem(int id) async {
    final database = await db();
    return database.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}
