class Cadastro {
  final String texto;
  final int numerico;

  Cadastro({required this.texto, required this.numerico});

  Map<String, dynamic> toMap() {
    return {
      'texto': texto,
      'numerico': numerico,
    };
  }
}
