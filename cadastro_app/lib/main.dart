import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'cadastro.dart'; // Importe a classe Cadastro
import 'database_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit(); // Inicializa o sqflite_common_ffi
  databaseFactory = databaseFactoryFfi; // Configura o databaseFactory

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
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Cadastro> _cadastros = [];

  @override
  void initState() {
    super.initState();
    _loadCadastros();
  }

  Future<void> _loadCadastros() async {
    List<Cadastro> cadastros = await _dbHelper.queryAllCadastros();
    setState(() {
      _cadastros = cadastros;
    });
  }

  Future<void> _insertCadastro() async {
    String texto = _textoController.text.trim();
    int numerico = int.tryParse(_numericoController.text.trim()) ?? 0;

    if (texto.isEmpty || numerico <= 0) {
      _showErrorDialog('Todos os campos são obrigatórios e o campo numérico deve ser maior que zero.');
      return;
    }

    Cadastro newCadastro = Cadastro(texto: texto, numerico: numerico);
    try {
      int id = await _dbHelper.insertCadastro(newCadastro);
      print('Novo cadastro inserido com ID: $id');
      _resetForm();
      _loadCadastros();
    } catch (e) {
      _showErrorDialog('Erro ao inserir cadastro: ${e.toString()}');
    }
  }

  Future<void> _updateCadastro(Cadastro cadastro) async {
    String texto = _textoController.text.trim();
    int numerico = int.tryParse(_numericoController.text.trim()) ?? 0;

    if (texto.isEmpty || numerico <= 0) {
      _showErrorDialog('Todos os campos são obrigatórios e o campo numérico deve ser maior que zero.');
      return;
    }

    Cadastro updatedCadastro = Cadastro(id: cadastro.id, texto: texto, numerico: numerico);
    try {
      await _dbHelper.updateCadastro(updatedCadastro);
      _resetForm();
      _loadCadastros();
    } catch (e) {
      _showErrorDialog('Erro ao atualizar cadastro: ${e.toString()}');
    }
  }

  Future<void> _deleteCadastro(int id) async {
    try {
      await _dbHelper.deleteCadastro(id);
      _loadCadastros();
    } catch (e) {
      _showErrorDialog('Erro ao deletar cadastro: ${e.toString()}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro App'),
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
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _cadastros.length,
                itemBuilder: (context, index) {
                  final cadastro = _cadastros[index];
                  return ListTile(
                    title: Text(cadastro.texto),
                    subtitle: Text(cadastro.numerico.toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _textoController.text = cadastro.texto;
                            _numericoController.text = cadastro.numerico.toString();
                            _updateCadastro(cadastro);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteCadastro(cadastro.id!);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
