import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:taskmanager/sql_helper.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('SQLHelper CRUD operations work', () async {
    final item = const UserItem(title: 'Alice', description: 'alice@example.com');
    final id = await SQLHelper.createItem(item);
    expect(id, isPositive);

    final items = await SQLHelper.getItems();
    expect(items.any((i) => i.title == 'Alice'), isTrue);

    final created = items.firstWhere((i) => i.title == 'Alice');
    final updated = created.copyWith(title: 'Alice Smith');
    await SQLHelper.updateItem(updated);

    final fetched = await SQLHelper.getItem(created.id!);
    expect(fetched?.title, 'Alice Smith');

    await SQLHelper.deleteItem(created.id!);
    final remaining = await SQLHelper.getItems();
    expect(remaining.any((i) => i.id == created.id), isFalse);
  });
}

