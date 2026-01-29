import 'package:flutter_test/flutter_test.dart';
import 'package:lab_aseguradora/models/seguro.dart';

void main() {
  group('Seguro', () {
    test('fromJson crea un Seguro correctamente', () {
      final json = {
        '_id': 'seg123',
        'costoTotal': 1500.75,
        'automovil': 'auto123',
      };

      final seguro = Seguro.fromJson(json);

      expect(seguro.id, 'seg123');
      expect(seguro.costoTotal, 1500.75);
      expect(seguro.automovilId, 'auto123');
    });

    test('fromJson convierte costoTotal entero a double', () {
      final json = {
        '_id': 'seg456',
        'costoTotal': 2000,
        'automovil': 'auto456',
      };

      final seguro = Seguro.fromJson(json);

      expect(seguro.costoTotal, 2000.0);
      expect(seguro.costoTotal, isA<double>());
    });

    test('toJson genera el mapa correctamente', () {
      final seguro = Seguro(
        costoTotal: 1200.50,
        automovilId: 'auto789',
      );

      final json = seguro.toJson();

      expect(json['costoTotal'], 1200.50);
      expect(json['automovil'], 'auto789');
      expect(json.containsKey('id'), false);
    });

    test('constructor con id opcional', () {
      final seguroSinId = Seguro(
        costoTotal: 1000.0,
        automovilId: 'auto1',
      );

      final seguroConId = Seguro(
        id: 'custom-seg-id',
        costoTotal: 1500.0,
        automovilId: 'auto2',
      );

      expect(seguroSinId.id, null);
      expect(seguroConId.id, 'custom-seg-id');
    });

    test('fromJson y toJson son consistentes', () {
      final original = Seguro(
        costoTotal: 1750.25,
        automovilId: 'auto-test',
      );

      final json = original.toJson();
      json['_id'] = 'generated-id';

      final recreated = Seguro.fromJson(json);

      expect(recreated.costoTotal, original.costoTotal);
      expect(recreated.automovilId, original.automovilId);
    });
  });
}
