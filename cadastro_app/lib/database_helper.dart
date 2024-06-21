import 'package:flutter/material.dart';
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

