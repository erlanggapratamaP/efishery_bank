import 'package:efishery_bank/model/size.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SizeDatabase {
  Future<Database> openDB() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'size_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE sizes(id INTEGER PRIMARY KEY AUTOINCREMENT, size TEXT)',
        );
      },
      version: 1,
    );
    return database;
  }

  Future<void> insertSize(SizeFishLocal size) async {
    // Get a reference to the database.
    final db = await openDB();
    await db.insert(
      'sizes',
      size.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<SizeFishLocal>> sizes() async {
    final db = await openDB();
    final List<Map<String, dynamic>> maps = await db.query('sizes');

    return List.generate(maps.length, (i) {
      return SizeFishLocal(
        id: maps[i]['id'],
        size: maps[i]['size'],
      );
    });
  }

  Future<void> updateFish(SizeFishLocal size) async {
    final db = await openDB();

    await db.update(
      'sizes',
      size.toMap(),
      where: 'id = ?',
      whereArgs: [size.id],
    );
  }

  Future<void> deleteFish(String id) async {
    final db = await openDB();
    await db.delete(
      'sizes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close the database
  Future close() async {
    final db = await openDB();
    db.close();
  }
}
