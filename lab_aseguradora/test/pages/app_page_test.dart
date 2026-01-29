import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_aseguradora/views/pages/app_page.dart';
import 'package:lab_aseguradora/views/pages/crear_poliza_page.dart';
import 'package:lab_aseguradora/views/pages/listar_polizas_page.dart';
import 'package:lab_aseguradora/views/providers/poliza_provider.dart';

void main() {
  group('AppPage', () {
    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          polizasProvider.overrideWith((ref) async => []),
        ],
        child: const MaterialApp(
          home: AppPage(),
        ),
      );
    }

    testWidgets('muestra BottomNavigationBar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('tiene dos items de navegacion', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.assignment), findsOneWidget);
      expect(find.byIcon(Icons.list_alt), findsOneWidget);
    });

    testWidgets('muestra CrearPolizaPage por defecto', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(CrearPolizaPage), findsOneWidget);
    });

    testWidgets('navega a ListarPolizasPage al tocar icono Listado', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Usamos el icono en vez del texto para evitar ambiguedades
      await tester.tap(find.byIcon(Icons.list_alt));
      await tester.pumpAndSettle();

      expect(find.byType(ListarPolizasPage), findsOneWidget);
    });

    testWidgets('navega de vuelta a CrearPolizaPage al tocar icono Polizas', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Primero navegamos a Listado
      await tester.tap(find.byIcon(Icons.list_alt));
      await tester.pumpAndSettle();

      // Luego volvemos usando el icono
      await tester.tap(find.byIcon(Icons.assignment));
      await tester.pumpAndSettle();

      // Verifica que CrearPolizaPage es visible (AppBar con "Crear Póliza")
      expect(find.text('Crear Póliza'), findsOneWidget);
    });

    testWidgets('usa IndexedStack para mantener estado de las paginas', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(IndexedStack), findsOneWidget);
    });

    testWidgets('item seleccionado tiene color teal', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );

      expect(navBar.selectedItemColor, Colors.teal);
    });
  });
}
