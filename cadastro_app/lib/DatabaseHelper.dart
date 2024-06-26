import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    if (_instance == null) {
      _instance = DatabaseHelper._internal();
    }
    return _instance!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'my_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cadastros (
        id INTEGER PRIMARY KEY,
        texto TEXT,
        numerico INTEGER
      )
    ''');
  }

  Future<int> insertCadastro(Cadastro cadastro) async {
    final db = await database;
    return await db.insert('cadastros', cadastro.toMap());
  }

  Future<List<Cadastro>> getCadastros() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cadastros');
    return List.generate(maps.length, (i) {
      return Cadastro(
        id: maps[i]['id'],
        texto: maps[i]['texto'],
        numerico: maps[i]['numerico'],
      );
    });
  }
}

class Cadastro {
  final int? id;
  final String texto;
  final int numerico;

  Cadastro({this.id, required this.texto, required this.numerico});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'texto': texto,
      'numerico': numerico,
    };
  }
}
