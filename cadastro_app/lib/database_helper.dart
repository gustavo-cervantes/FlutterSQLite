import 'dart:async';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'cadastro.dart'; // Certifique-se de importar a classe Cadastro correta

class DatabaseHelper {
  static final _databaseName = "cadastro.db";
  static final _databaseVersion = 1;

  static final tableCadastro = 'cadastro';
  static final tableLog = 'log';

  static final columnId = 'id';
  static final columnTexto = 'texto';
  static final columnNumerico = 'numerico';
  static final columnDataHora = 'data_hora';
  static final columnTipoOperacao = 'tipo_operacao';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static late Database _database;

  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + _databaseName;

    // Ensure the SQLite bindings are initialized
    sqfliteFfiInit();

    return await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: _databaseVersion,
        onCreate: _onCreate,
      ),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCadastro (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTexto TEXT NOT NULL,
        $columnNumerico INTEGER NOT NULL UNIQUE CHECK ($columnNumerico > 0)
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableLog (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDataHora TEXT NOT NULL,
        $columnTipoOperacao TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertCadastro(Cadastro cadastro) async {
    Database db = await instance.database;
    int id = await db.insert(tableCadastro, cadastro.toMap());
    await _insertLog(db, 'Insert');
    return id;
  }

  Future<int> updateCadastro(Cadastro cadastro) async {
    Database db = await instance.database;
    int result = await db.update(
      tableCadastro,
      cadastro.toMap(),
      where: '$columnId = ?',
      whereArgs: [cadastro.id],
    );
    await _insertLog(db, 'Update');
    return result;
  }

  Future<int> deleteCadastro(int id) async {
    Database db = await instance.database;
    int result = await db.delete(
      tableCadastro,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    await _insertLog(db, 'Delete');
    return result;
  }

  Future<List<Cadastro>> queryAllCadastros() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableCadastro);
    return List.generate(maps.length, (i) {
      return Cadastro(
        id: maps[i][columnId],
        texto: maps[i][columnTexto],
        numerico: maps[i][columnNumerico],
      );
    });
  }

  Future<void> _insertLog(Database db, String operation) async {
    Map<String, dynamic> log = {
      columnDataHora: DateTime.now().toIso8601String(),
      columnTipoOperacao: operation,
    };
    await db.insert(tableLog, log);
  }
}
