import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/character.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('characters.db');
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final dbLocation = join(dbPath, path);
    return await openDatabase(dbLocation, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE characters (
        id INTEGER PRIMARY KEY,
        name TEXT,
        status TEXT,
        species TEXT,
        image TEXT,
        isFavorite INTEGER
      )
    ''');
  }

  Future<int> insertCharacter(Character character) async {
    final db = await instance.database;
    return await db.insert('characters', character.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Character>> getAllCharacters() async {
    final db = await instance.database;
    final result = await db.query('characters');
    return result.map((json) => Character.fromMap(json)).toList();
  }

  Future<void> updateCharacter(Character character) async {
    final db = await instance.database;
    await db.update(
      'characters',
      character.toMap(),
      where: 'id = ?',
      whereArgs: [character.id],
    );
  }

  Future<void> deleteCharacter(int id) async {
    final db = await instance.database;
    await db.delete(
      'characters',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Character>> getFavoriteCharacters() async {
    final db = await instance.database;
    final result = await db.query(
      'characters',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'name ASC',
    );
    return result.map((json) => Character.fromMap(json)).toList();
  }

  Future<Character?> getCharacterById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'characters',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Character.fromMap(result.first);
    }
    return null;
  }

  Future<void> toggleFavorite(int characterId) async {
    final db = await instance.database;
    final result = await db.query(
      'characters',
      where: 'id = ?',
      whereArgs: [characterId],
    );
    if (result.isNotEmpty) {
      final character = Character.fromMap(result.first);
      character.toggleFavorite();
      await db.update(
        'characters',
        character.toMap(),
        where: 'id = ?',
        whereArgs: [character.id],
      );
    }
  }
}
