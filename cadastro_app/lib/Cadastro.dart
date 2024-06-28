class Cadastro {
  final int? id;
  final String texto;
  final int numerico;

  Cadastro({
    this.id,
    required this.texto,
    required this.numerico,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'texto': texto,
      'numerico': numerico,
    };
  }

  factory Cadastro.fromMap(Map<String, dynamic> map) {
    return Cadastro(
      id: map['id'],
      texto: map['texto'],
      numerico: map['numerico'],
    );
  }
}
