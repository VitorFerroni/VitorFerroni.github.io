import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'planet.dart'; // Adicione esta linha

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
    String path = join(await getDatabasesPath(), 'planets.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE planets (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        distance REAL NOT NULL,
        size REAL NOT NULL,
        nickname TEXT
      )
    ''');
  }

  Future<int> insertPlanet(Planet planet) async {
    Database db = await database;
    return await db.insert('planets', planet.toMap());
  }

  Future<List<Planet>> getPlanets() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('planets');
    return List.generate(maps.length, (i) {
      return Planet.fromMap(maps[i]);
    });
  }

  Future<int> updatePlanet(Planet planet) async {
    Database db = await database;
    return await db.update(
      'planets',
      planet.toMap(),
      where: 'id = ?',
      whereArgs: [planet.id],
    );
  }

  Future<int> deletePlanet(int id) async {
    Database db = await database;
    return await db.delete(
      'planets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}