import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/book.dart';

class DbService {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'tech_inventory.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE equipos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        codigo TEXT,
        nombre TEXT,
        descripcion TEXT,
        fecha TEXT,
        foto TEXT
      )
    ''');
  }

  Future<int> insertEquipo(Equipo equipo) async {
    final db = await database;
    return await db.insert(
      'equipos',
      equipo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Equipo>> getEquipos() async {
    final db = await database;
    final maps = await db.query('equipos', orderBy: 'id DESC');
    return List.generate(maps.length, (i) {
      return Equipo.fromMap(maps[i]);
    });
  }

  Future<int> deleteEquipo(int id) async {
    final db = await database;
    return await db.delete('equipos', where: 'id = ?', whereArgs: [id]);
  }
}
