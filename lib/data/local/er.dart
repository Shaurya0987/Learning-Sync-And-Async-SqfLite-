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

  // 4 Create 
  Future _createDB(Database db,int version)async{
    await db.execute(
      ''' 
      CREATE TABLE notes(
        id : INTEGER PRIMARY KEY AUTOINCREMENT,
        title : TEXT NOT NULL
        desciption : TEXT NOT NULL 
      )
    ''');
  }

  // 5 Insert
  Future<int>insert(Map<String,dynamic>row)async{
    final db=await DatabaseHelper.instance.database;
    return await db.insert('notes',row);
  }

  // 6 DELETE
  Future<int>delete(int id)async{
    final db=await DatabaseHelper.instance.database;
    return  await db.delete('notes',where:'id=?',whereArgs:[id]);
  }

  // 7 Update
  Future<int>update(Map<String,dynamic>row) async{
    final db= await DatabaseHelper.instance.database;
    int id=row['id'];
    return await db.update('notes',row,where:'id=?',whereArgs:[id]);
  }

  // 8 Read All Notes
  Future<List<Map<String,dynamic>>> getAllNotes()async{
    final db=await DatabaseHelper.instance.database;
    return db.query('notes');
  }

  //Close DataBase
  Future close() async{
    final db=await DatabaseHelper.instance.database;
    db.close();
  }

}