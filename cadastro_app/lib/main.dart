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
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
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
    String nome = nomeController.text;
    int idade = int.tryParse(idadeController.text) ?? 0;
    if (nome.isNotEmpty && idade > 0) {
      try {
        await dbHelper.insertCadastro(Cadastro(nome: nome, idade: idade));
        nomeController.clear();
        idadeController.clear();
        _loadCadastros();
      } catch (e) {
        _showErrorDialog(e.toString());
      }
    } else {
      _showErrorDialog('Todos os campos são obrigatórios e a idade deve ser maior que zero.');
    }
  }

  void _updateCadastro() async {
    if (selectedCadastro != null) {
      String nome = nomeController.text;
      int idade = int.tryParse(idadeController.text) ?? 0;
      if (nome.isNotEmpty && idade > 0) {
        try {
          await dbHelper.updateCadastro(Cadastro(
            id: selectedCadastro!.id,
            nome: nome,
            idade: idade,
          ));
          nomeController.clear();
          idadeController.clear();
          setState(() {
            selectedCadastro = null;
          });
          _loadCadastros();
        } catch (e) {
          _showErrorDialog(e.toString());
        }
      } else {
        _showErrorDialog('Todos os campos são obrigatórios e a idade deve ser maior que zero.');
      }
    }
  }

  void _deleteCadastro() async {
    if (selectedCadastro != null) {
      try {
        await dbHelper.deleteCadastro(selectedCadastro!.id!);
        nomeController.clear();
        idadeController.clear();
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
      nomeController.text = cadastro.nome;
      idadeController.text = cadastro.idade.toString();
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
                  controller: nomeController,
                  decoration: InputDecoration(labelText: 'Texto'),
                ),
                TextField(
                  controller: idadeController,
                  decoration: InputDecoration(labelText: 'Numero'),
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
                  title: Text(cadastro.nome),
                  subtitle: Text('Número: ${cadastro.idade}'),
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