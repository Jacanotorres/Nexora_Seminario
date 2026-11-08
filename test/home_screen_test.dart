import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nexora/screens/home_screen.dart';
import 'package:nexora/theme/app_theme.dart';

Widget _app() => MaterialApp(
  theme: buildNexoraTheme(),
  home: const HomeScreen(nombreUsuario: 'Juan'),
);

void main() {
  testWidgets('vista ancha: saludo, catálogo y filtro por tipo', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app());

    expect(find.text('Hola, Juan'), findsOneWidget);
    expect(find.text('Catálogo de Eventos'), findsOneWidget);
    expect(find.text('Inscribirme'), findsNWidgets(6));

    await tester.tap(find.widgetWithText(ChoiceChip, 'Corporativo'));
    await tester.pump();
    expect(find.text('Inscribirme'), findsNWidgets(3));
    expect(find.text('Taller de Flutter'), findsNothing);
  });

  testWidgets('la búsqueda filtra por nombre y muestra mensaje vacío', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app());

    await tester.enterText(find.byType(TextField), 'flutter');
    await tester.pump();
    expect(find.text('Taller de Flutter'), findsOneWidget);
    expect(find.text('Inscribirme'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump();
    expect(find.text('No hay eventos que coincidan.'), findsOneWidget);
  });

  testWidgets('vista móvil usa navegación inferior', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app());

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Catálogo de Eventos'), findsOneWidget);
  });
}
