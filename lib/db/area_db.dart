import 'package:efishery_bank/model/area.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AreaDatabase {
  Future<Database> openDB() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'area_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE areas(id INTEGER PRIMARY KEY AUTOINCREMENT, province TEXT , city TEXT)',
        );
      },
      version: 1,
    );
    return database;
  }

  Future<void> insertArea(AreaLocal area) async {
    // Get a reference to the database.
    final db = await openDB();
    await db.insert(
      'areas',
      area.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<AreaLocal>> areas() async {
    final db = await openDB();
    final List<Map<String, dynamic>> maps = await db.query('areas');

    return List.generate(maps.length, (i) {
      return AreaLocal(
        id: maps[i]['id'],
        province: maps[i]['province'],
        city: maps[i]['city'],
      );
    });
  }

  Future<void> updateArea(AreaLocal area) async {
    final db = await openDB();

    await db.update(
      'areas',
      area.toMap(),
      where: 'id = ?',
      whereArgs: [area.id],
    );
  }

  Future<void> deleteArea(String id) async {
    final db = await openDB();
    await db.delete(
      'areas',
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
