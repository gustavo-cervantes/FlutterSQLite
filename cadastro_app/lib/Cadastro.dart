// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

class Cadastro {
  int? id;
  String texto;
  int numerico;

  Cadastro({this.id, required this.texto, required this.numerico});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'texto': texto,
      'numerico': numerico,
    };
  }

  factory Cadastro.fromMap(Map<String, dynamic> map){
    return Cadastro(
      id: map['id'],
      texto: map['texto'],
      numerico: map['numerico'],
    );
  }
}