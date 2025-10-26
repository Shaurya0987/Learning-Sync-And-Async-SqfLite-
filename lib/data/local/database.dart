import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; // ✅ correct import

class DatabaseHelper {
  // Step 1 --> Singleton
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  // Step 2 --> Get database (create or open)
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  // Step 3 --> Initialize Database and create table if not exists
  Future<Database> _initDB(String filename) async {
    final dbPath = await getDatabasesPath();
    final Path = join(dbPath, filename);
    return await openDatabase(Path, version: 1, onCreate: _createDB);
  }

  // CRUD Operations ==>Create ,  Read  ,  Update  ,  Delete

  // Step 4 --> Create Table
  Future _createDB(Database db, int version) async {
    await db.execute(''' 
    CREATE TABLE notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL
    )
  ''');
  }

  // Step 5 --> Insert A Note
}
