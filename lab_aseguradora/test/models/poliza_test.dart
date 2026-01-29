import 'package:flutter_test/flutter_test.dart';
import 'package:lab_aseguradora/models/poliza.dart';

void main() {
  group('Poliza', () {
    test('fromJson crea una Poliza correctamente', () {
      final json = {
        '_id': '123abc',
        'costoTotal': 1500.50,
        'automovil': {
          'modelo': 'Modelo A',
          'valor': 25000.0,
          'accidentes': 2,
          'propietario': {
            'nombre': 'Juan',
            'apellido': 'Perez',
          },
        },
      };

      final poliza = Poliza.fromJson(json);

      expect(poliza.id, '123abc');
      expect(poliza.costoTotal, 1500.50);
      expect(poliza.modeloAuto, 'Modelo A');
      expect(poliza.valorAuto, 25000.0);
      expect(poliza.accidentes, 2);
      expect(poliza.propietario, 'Juan Perez');
    });

    test('fromJson maneja valores enteros correctamente', () {
      final json = {
        '_id': '456def',
        'costoTotal': 2000,
        'automovil': {
          'modelo': 'Modelo B',
          'valor': 30000,
          'accidentes': 0,
          'propietario': {
            'nombre': 'Maria',
            'apellido': 'Lopez',
          },
        },
      };

      final poliza = Poliza.fromJson(json);

      expect(poliza.costoTotal, 2000.0);
      expect(poliza.valorAuto, 30000.0);
    });

    test('constructor crea instancia con todos los campos', () {
      final poliza = Poliza(
        id: 'test-id',
        costoTotal: 1200.0,
        modeloAuto: 'Modelo C',
        valorAuto: 20000.0,
        accidentes: 1,
        propietario: 'Carlos Garcia',
      );

      expect(poliza.id, 'test-id');
      expect(poliza.costoTotal, 1200.0);
      expect(poliza.modeloAuto, 'Modelo C');
      expect(poliza.valorAuto, 20000.0);
      expect(poliza.accidentes, 1);
      expect(poliza.propietario, 'Carlos Garcia');
    });
  });
}
