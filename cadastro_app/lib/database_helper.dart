import 'dart:async';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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

  // Singleton instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    final db = await databaseFactoryFfi.openDatabase(
      _databaseName,
      options: OpenDatabaseOptions(
        version: _databaseVersion,
        onCreate: _onCreate,
      ),
    );
    return db;
  }

  Future _onCreate(Database db, int version) async {
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

  Future<int> insertCadastro(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = await db.insert(tableCadastro, row);
    await _insertLog(db, 'Insert');
    return id;
  }

  Future<int> updateCadastro(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    int result = await db.update(tableCadastro, row, where: '$columnId = ?',
