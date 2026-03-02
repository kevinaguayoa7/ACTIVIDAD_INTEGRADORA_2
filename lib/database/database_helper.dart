import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('usuarios.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        email TEXT NOT NULL,
        edad INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertUsuario(Map<String, dynamic> usuario) async {
    final db = await instance.database;
    return await db.insert('usuarios', usuario);
  }

  Future<List<Map<String, dynamic>>> getUsuarios() async {
    final db = await instance.database;
    return await db.query('usuarios', orderBy: 'id DESC');
  }

  Future<int> deleteUsuario(int id) async {
    final db = await instance.database;
    return await db.delete(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}