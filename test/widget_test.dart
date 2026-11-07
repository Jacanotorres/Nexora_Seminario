import 'package:flutter_test/flutter_test.dart';

import 'package:nexora/main.dart';

void main() {
  testWidgets('muestra la pantalla de inicio de sesión', (tester) async {
    await tester.pumpWidget(const NexoraApp());

    expect(find.text('Bienvenido'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}
