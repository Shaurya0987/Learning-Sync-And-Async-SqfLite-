import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; 

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
  Future<int>insert(Map<String,dynamic>row)async{
    final db =await instance.database;
    return await db.insert("notes", row);
  }

  // Step 6 --> Read All Notes
  Future<List<Map<String,dynamic>>>getAllNotes() async{
    final db= await instance.database;
    return await db.query('notes');
  }

  // Step 7 --> Update a Note
  Future<int>Update(Map<String,dynamic>row) async{
    final db=await instance.database;
    int id=row['id'];
    return await db.update('notes', row,where: 'id=?',whereArgs: [id]);
  }

  // Step 8 --> Delete a Note
  Future<int>Delete(int id) async{
    final db = await instance.database;
    return await db.delete('notes',where: 'id=?',whereArgs: [id]);
  }

  // Step 9 --> Close the DataBase
  Future Close() async{
    final db = await instance.database;
    db.close();
  }
  
}
