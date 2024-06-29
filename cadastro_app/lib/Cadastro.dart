class Cadastro {
  int? id;
  String texto; // Anteriormente "nome"
  int numero;   // Anteriormente "idade"

  Cadastro({this.id, required this.texto, required this.numero});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'texto': texto,
      'numero': numero,
    };
  }                                           

  static Cadastro fromMap(Map<String, dynamic> map) {
    return Cadastro(
      id: map['id'],
      texto: map['texto'],
      numero: map['numero'],
    );
  }
}
