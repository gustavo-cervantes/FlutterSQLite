import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'database_helper.dart'; // Supondo que este seja o nome do arquivo que contém DatabaseHelper
import 'cadastro.dart'; // Supondo que este seja o nome do arquivo que contém a classe Cadastro

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o suporte ao FFI
  sqfliteFfiInit();

  // Define o databaseFactory para utilizar o sqflite_common_ffi
  databaseFactory = databaseFactoryFfi;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textoController = TextEditingController();
  final TextEditingController _numericoController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper(); // Use o construtor da classe DatabaseHelper

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textoController,
              decoration: InputDecoration(labelText: 'Texto'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _numericoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Numérico'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _insertCadastro,
              child: Text('Inserir Cadastro'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _insertCadastro() async {
    String texto = _textoController.text.trim();
    int numerico = int.tryParse(_numericoController.text.trim()) ?? 0;

    if (texto.isEmpty || numerico <= 0) {
      _showErrorDialog('Todos os campos são obrigatórios e o campo numérico deve ser maior que zero.');
      return;
    }

    Cadastro cadastro = Cadastro(texto: texto, numerico: numerico);
    try {
      int id = await _dbHelper.insertCadastro(cadastro); // Método alterado para insertCadastro
      print('Novo cadastro com ID: $id');
      _resetForm();
    } catch (e) {
      _showErrorDialog('Erro ao inserir cadastro: ${e.toString()}');
    }
  }

  void _resetForm() {
    _textoController.clear();
    _numericoController.clear();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
