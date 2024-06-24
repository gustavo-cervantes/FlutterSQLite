import 'package:flutter_test/flutter_test.dart';

import 'package:cadastro_app/main.dart';

void main() {
  testWidgets('Teste básico da aplicação de cadastro', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verifica se o texto 'Texto' está presente na tela inicial
    expect(find.text('Texto'), findsOneWidget);

    // Verifica se o texto 'Numérico' está presente na tela inicial
    expect(find.text('Numérico'), findsOneWidget);

    // Verifica se o botão 'Inserir Cadastro' está presente na tela inicial
    expect(find.text('Inserir Cadastro'), findsOneWidget);
  });
}
