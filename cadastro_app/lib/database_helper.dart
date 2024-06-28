import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cadastro.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE cadastro (
  id $idType,
  texto $textType,
  numerico $intType
)
''');
  }

  Future<int> insertCadastro(Map<String, dynamic> row) async {
    final db = await instance.database;

    return await db.insert('cadastro', row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    final db = await instance.database;

    return await db.query('cadastro');
  }

  Future<int> updateCadastro(Map<String, dynamic> row) async {
    final db = await instance.database;
    final id = row['id'];

    return await db.update('cadastro', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCadastro(int id) async {
    final db = await instance.database;

    return await db.delete('cadastro', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}