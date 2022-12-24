import 'package:efishery_bank/model/fish.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FishDatabase {
  Future<Database> openDB() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'fish_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE fishes(uuid TEXT PRIMARY KEY, komoditas TEXT, area_provinsi TEXT, area_kota TEXT, size TEXT, price TEXT, tgl_parsed TEXT, timestamp TEXT)',
        );
      },
      version: 1,
    );
    return database;
  }

  Future<void> insertFish(Fish fish) async {
    // Get a reference to the database.
    final db = await openDB();
    await db.insert(
      'fishes',
      fish.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Fish>> fishes() async {
    final db = await openDB();
    final List<Map<String, dynamic>> maps = await db.query('fishes');

    return List.generate(maps.length, (i) {
      return Fish(
        uuid: maps[i]['uuid'],
        komoditas: maps[i]['komoditas'],
        areaProvinsi: maps[i]['area_provinsi'],
        areaKota: maps[i]['area_kota'],
        size: maps[i]['size'],
        price: maps[i]['price'],
        tglParsed: maps[i]['tgl_parsed'],
        timestamp: maps[i]['timestamp'],
      );
    });
  }

  Future<void> updateFish(Fish fish) async {
    final db = await openDB();

    await db.update(
      'fishes',
      fish.toMap(),
      where: 'id = ?',
      whereArgs: [fish.uuid],
    );
  }

  Future<void> deleteFish(String uuid) async {
    final db = await openDB();
    await db.delete(
      'fishes',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
  }

  // Close the database
  Future close() async {
    final db = await openDB();
    db.close();
  }
}
