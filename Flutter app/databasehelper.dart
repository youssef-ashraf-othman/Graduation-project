import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT)",
        );
      },
    );
  }

  Future<void> insertUser(String username, String password) async {
    final db = await database;
    await db.insert(
      'users',
      {'username': username, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser(String username) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: "username = ?",
      whereArgs: [username],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<bool> userExists(String username) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: "username = ?",
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }
}