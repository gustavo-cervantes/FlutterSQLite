import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'cadastro.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal() {
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
    String path = join(Directory.current.path, 'cadastro.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cadastros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        texto TEXT NOT NULL,
        numero INTEGER NOT NULL UNIQUE
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

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Adicione aqui a lógica de atualização do banco de dados, se necessário
  }

  Future<List<Cadastro>> getCadastros() async {
    final db = await database;
    var result = await db.query('cadastros');
    return result.map((json) => Cadastro.fromMap(json)).toList();
  }

  Future<void> insertCadastro(Cadastro cadastro) async {
    final db = await database;
    try {
      await db.insert('cadastros', cadastro.toMap());
      await _logOperacao('Insert');
    } catch (e) {
      if (e is DatabaseException && e.isUniqueConstraintError()) {
        throw Exception('Número já existe. Cada número deve ser único.');
      }
      throw e;
    }
  }

  Future<void> updateCadastro(Cadastro cadastro) async {
    final db = await database;
    try {
      await db.update(
        'cadastros',
        cadastro.toMap(),
        where: 'id = ?',
        whereArgs: [cadastro.id],
      );
      await _logOperacao('Update');
    } catch (e) {
      if (e is DatabaseException && e.isUniqueConstraintError()) {
        throw Exception('Número já existe. Cada número deve ser único.');
      }
      throw e;
    }
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
