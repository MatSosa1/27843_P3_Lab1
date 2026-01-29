import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_aseguradora/models/poliza.dart';
import 'package:lab_aseguradora/views/pages/listar_polizas_page.dart';
import 'package:lab_aseguradora/views/providers/poliza_provider.dart';
import 'package:lab_aseguradora/views/widgets/poliza_card.dart';

void main() {
  group('ListarPolizasPage', () {
    testWidgets('muestra indicador de carga mientras se cargan las polizas', (tester) async {
      // Usamos un Completer para controlar cuando termina el Future
      final completer = Future<List<Poliza>>.delayed(
        const Duration(milliseconds: 100),
        () => [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            polizasProvider.overrideWith((ref) => completer),
          ],
          child: const MaterialApp(
            home: ListarPolizasPage(),
          ),
        ),
      );

      // Verificamos el estado de carga inmediatamente
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Dejamos que termine el Future para evitar timers pendientes
      await tester.pumpAndSettle();
    });

    testWidgets('muestra mensaje cuando no hay polizas', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            polizasProvider.overrideWith((ref) async => []),
          ],
          child: const MaterialApp(
            home: ListarPolizasPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No hay pólizas registradas'), findsOneWidget);
    });

    testWidgets('muestra lista de polizas cuando hay datos', (tester) async {
      final polizas = [
        Poliza(
          id: '1',
          costoTotal: 1200.0,
          modeloAuto: 'Modelo A',
          valorAuto: 20000.0,
          accidentes: 0,
          propietario: 'Juan Perez',
        ),
        Poliza(
          id: '2',
          costoTotal: 1500.0,
          modeloAuto: 'Modelo B',
          valorAuto: 25000.0,
          accidentes: 1,
          propietario: 'Maria Lopez',
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            polizasProvider.overrideWith((ref) async => polizas),
          ],
          child: const MaterialApp(
            home: ListarPolizasPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(PolizaCard), findsNWidgets(2));
      expect(find.text('Juan Perez'), findsOneWidget);
      expect(find.text('Maria Lopez'), findsOneWidget);
    });

    testWidgets('muestra error cuando falla la carga', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            polizasProvider.overrideWith((ref) async {
              throw Exception('Error de conexión');
            }),
          ],
          child: const MaterialApp(
            home: ListarPolizasPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Error'), findsOneWidget);
    });

    testWidgets('tiene AppBar con titulo Pólizas', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            polizasProvider.overrideWith((ref) async => []),
          ],
          child: const MaterialApp(
            home: ListarPolizasPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Pólizas'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('usa ListView.builder para la lista de polizas', (tester) async {
      final polizas = [
        Poliza(
          id: '1',
          costoTotal: 1000.0,
          modeloAuto: 'Modelo C',
          valorAuto: 15000.0,
          accidentes: 0,
          propietario: 'Test User',
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            polizasProvider.overrideWith((ref) async => polizas),
          ],
          child: const MaterialApp(
            home: ListarPolizasPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
