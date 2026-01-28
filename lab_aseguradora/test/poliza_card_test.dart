import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_aseguradora/models/poliza.dart';
import 'package:lab_aseguradora/views/widgets/poliza_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('PolizaCard Widget', () {
    testWidgets('debería mostrar los datos básicos de la póliza', (
      WidgetTester tester,
    ) async {
      // Arrange
      final poliza = Poliza(
        id: '1',
        propietario: 'Juan Perez',
        modeloAuto: 'Toyota Corolla',
        valorAuto: 15000,
        accidentes: 2,
        costoTotal: 1200,
      );

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: Scaffold(body: PolizaCard(poliza))),
        ),
      );

      // Assert
      expect(find.text('Juan Perez'), findsOneWidget);
      expect(find.text('Modelo: Toyota Corolla'), findsOneWidget);
      expect(find.text('Valor auto: \$15000.0'), findsOneWidget);
      expect(find.text('Accidentes: 2'), findsOneWidget);
      expect(find.text('Costo total: \$1200.0'), findsOneWidget);
    });
  });
}
