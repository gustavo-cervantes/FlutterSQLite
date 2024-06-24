import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "cadastro.db";
  static final _databaseVersion = 1;

  static final tableCadastro = 'cadastro';
  static final tableLog = 'log';

  static final columnId = '_id';
  static final columnTexto = 'texto';
  static final columnNumerico = 'numerico';
  static final columnDataHora = 'data_hora';
  static final columnOperacao = 'operacao';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationCacheDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCadastro (
      $columnId INTEGER PRIMARY KEY,
      $columnTexto TEXT NOT NULL,
      $columnNumerico INTEGER NOT NULL UNIQUE CHECK($columnNumerico > 0)
      )
    ''');
  }

Future<int> insert(Map<String, dynamic> row) async {
  Database? db = await instance.database;
  int id = await db!.insert(tableCadastro, row); // Usando db.insert para inserir os dados
  await _logOperation('Insert');
  return id;
}


  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = await db!.update(tableCadastro, row,
        where: '$columnId = ?', whereArgs: [row[columnId]]);
    await _logOperation('Update');
    return id;
  }

  Future<int> delete(int id) async {
    Database? db = await instance.database;
    int result = await db!.delete(tableCadastro,
        where: '$columnId = ?', whereArgs: [id]);
    await _logOperation('Delete');
    return result;
  }

  Future<void> _logOperation(String operation) async {
    Database? db = await instance.database;
    await db!.insert(tableLog, {
      columnDataHora: DateTime.now().toIso8601String(),
      columnOperacao: operation
    });
  }
}