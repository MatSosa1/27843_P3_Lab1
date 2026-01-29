import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_aseguradora/models/poliza.dart';
import 'package:lab_aseguradora/views/widgets/poliza_card.dart';

void main() {
  group('PolizaCard', () {
    testWidgets('muestra todos los datos de la poliza', (tester) async {
      final poliza = Poliza(
        id: 'test-id',
        costoTotal: 1500.50,
        modeloAuto: 'Modelo A',
        valorAuto: 25000.0,
        accidentes: 2,
        propietario: 'Juan Perez',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PolizaCard(poliza),
          ),
        ),
      );

      expect(find.text('Juan Perez'), findsOneWidget);
      expect(find.text('Modelo: Modelo A'), findsOneWidget);
      expect(find.text('Valor auto: \$25000.0'), findsOneWidget);
      expect(find.text('Accidentes: 2'), findsOneWidget);
      expect(find.text('Costo total: \$1500.5'), findsOneWidget);
    });

    testWidgets('muestra el nombre del propietario en negrita', (tester) async {
      final poliza = Poliza(
        id: 'test-id',
        costoTotal: 1000.0,
        modeloAuto: 'Modelo B',
        valorAuto: 20000.0,
        accidentes: 0,
        propietario: 'Maria Lopez',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PolizaCard(poliza),
          ),
        ),
      );

      final propietarioText = tester.widget<Text>(
        find.text('Maria Lopez'),
      );

      expect(propietarioText.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('muestra el costo total en color teal', (tester) async {
      final poliza = Poliza(
        id: 'test-id',
        costoTotal: 2000.0,
        modeloAuto: 'Modelo C',
        valorAuto: 30000.0,
        accidentes: 1,
        propietario: 'Carlos Garcia',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PolizaCard(poliza),
          ),
        ),
      );

      final costoText = tester.widget<Text>(
        find.text('Costo total: \$2000.0'),
      );

      expect(costoText.style?.color, Colors.teal);
    });

    testWidgets('tiene un Divider entre los datos y el costo', (tester) async {
      final poliza = Poliza(
        id: 'test-id',
        costoTotal: 1200.0,
        modeloAuto: 'Modelo A',
        valorAuto: 15000.0,
        accidentes: 0,
        propietario: 'Test User',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PolizaCard(poliza),
          ),
        ),
      );

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('esta contenido en un Card con bordes redondeados', (tester) async {
      final poliza = Poliza(
        id: 'test-id',
        costoTotal: 1000.0,
        modeloAuto: 'Modelo B',
        valorAuto: 10000.0,
        accidentes: 0,
        propietario: 'Test',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PolizaCard(poliza),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      final shape = card.shape as RoundedRectangleBorder;

      expect(shape.borderRadius, BorderRadius.circular(12));
    });

    testWidgets('muestra cero accidentes correctamente', (tester) async {
      final poliza = Poliza(
        id: 'test-id',
        costoTotal: 800.0,
        modeloAuto: 'Modelo C',
        valorAuto: 12000.0,
        accidentes: 0,
        propietario: 'Safe Driver',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PolizaCard(poliza),
          ),
        ),
      );

      expect(find.text('Accidentes: 0'), findsOneWidget);
    });
  });
}
