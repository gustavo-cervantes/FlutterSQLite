import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'cadastro.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro App',
      home: CadastroScreen(),
    );
  }
}

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final TextEditingController textoController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  List<Cadastro> cadastros = [];
  Cadastro? selectedCadastro;

  @override
  void initState() {
    super.initState();
    _loadCadastros();
  }

  Future<void> _loadCadastros() async {
    List<Cadastro> _cadastros = await dbHelper.getCadastros();
    setState(() {
      cadastros = _cadastros;
    });
  }

void _insertCadastro() async {
  String texto = textoController.text;
  int numero = int.tryParse(numeroController.text) ?? 0;
  if (texto.isNotEmpty && numero > 0) {
    try {
      await dbHelper.insertCadastro(Cadastro(texto: texto, numero: numero));
      textoController.clear();
      numeroController.clear();
      _loadCadastros();
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  } else {
    _showErrorDialog('Todos os campos são obrigatórios e o número deve ser maior que zero.');
  }
}


  void _updateCadastro() async {
    if (selectedCadastro != null) {
      String texto = textoController.text;
      int numero = int.tryParse(numeroController.text) ?? 0;
      if (texto.isNotEmpty && numero > 0) {
        try {
          await dbHelper.updateCadastro(Cadastro(
            id: selectedCadastro!.id,
            texto: texto,
            numero: numero,
          ));
          textoController.clear();
          numeroController.clear();
          setState(() {
            selectedCadastro = null;
          });
          _loadCadastros();
        } catch (e) {
          _showErrorDialog(e.toString());
        }
      } else {
        _showErrorDialog('Todos os campos são obrigatórios e o número deve ser maior que zero.');
      }
    }
  }

  void _deleteCadastro() async {
    if (selectedCadastro != null) {
      try {
        await dbHelper.deleteCadastro(selectedCadastro!.id!);
        textoController.clear();
        numeroController.clear();
        setState(() {
          selectedCadastro = null;
        });
        _loadCadastros();
      } catch (e) {
        _showErrorDialog(e.toString());
      }
    } else {
      _showErrorDialog('Selecione um cadastro para deletar.');
    }
  }

  void _selectCadastro(Cadastro cadastro) {
    setState(() {
      selectedCadastro = cadastro;
      textoController.text = cadastro.texto;
      numeroController.text = cadastro.numero.toString();
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: textoController,
                  decoration: InputDecoration(labelText: 'Texto'),
                ),
                TextField(
                  controller: numeroController,
                  decoration: InputDecoration(labelText: 'Número'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _insertCadastro,
                      child: Text('Inserir'),
                    ),
                    ElevatedButton(
                      onPressed: selectedCadastro != null ? _updateCadastro : null,
                      child: Text('Atualizar'),
                    ),
                    ElevatedButton(
                      onPressed: selectedCadastro != null ? _deleteCadastro : null,
                      child: Text('Deletar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cadastros.length,
              itemBuilder: (context, index) {
                Cadastro cadastro = cadastros[index];
                return ListTile(
                  title: Text(cadastro.texto),
                  subtitle: Text('Número: ${cadastro.numero}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _selectCadastro(cadastro),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteCadastro(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
