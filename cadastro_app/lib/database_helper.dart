import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'cadastro.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal() {
    // Inicializar a fábrica de bancos de dados para FFI (somente para desktop)
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'cadastro.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cadastros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        idade INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE log_operacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data_hora TEXT NOT NULL,
        tipo_operacao TEXT NOT NULL
      )
    ''');
  }

  Future<List<Cadastro>> getCadastros() async {
    final db = await database;
    var result = await db.query('cadastros');
    return result.map((json) => Cadastro.fromMap(json)).toList();
  }

  Future<void> insertCadastro(Cadastro cadastro) async {
    final db = await database;
    await db.insert('cadastros', cadastro.toMap());
    await _logOperacao('Insert');
  }

  Future<void> updateCadastro(Cadastro cadastro) async {
    final db = await database;
    await db.update(
      'cadastros',
      cadastro.toMap(),
      where: 'id = ?',
      whereArgs: [cadastro.id],
    );
    await _logOperacao('Update');
  }

  Future<void> deleteCadastro(int id) async {
    final db = await database;
    await db.delete(
      'cadastros',
      where: 'id = ?',
      whereArgs: [id],
    );
    await _logOperacao('Delete');
  }

  Future<void> _logOperacao(String tipoOperacao) async {
    final db = await database;
    String dataHora = DateTime.now().toIso8601String();
    await db.insert('log_operacoes', {
      'data_hora': dataHora,
      'tipo_operacao': tipoOperacao,
    });
  }
}
