import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title 'Cadastro App'
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
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
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

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
            )
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
}

Future<void> _insertCadastro() async {
  String texto = _textoController.text.trim();
  int numerico = int.tryParse(_numericoController.text.trim()) ?? 0;

  if (texto.isEmpty || numerico <= 0) {
    return;
  }

}



