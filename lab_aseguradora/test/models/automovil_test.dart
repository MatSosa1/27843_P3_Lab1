import 'package:flutter_test/flutter_test.dart';
import 'package:lab_aseguradora/models/automovil.dart';

void main() {
  group('Automovil', () {
    test('fromJson crea un Automovil correctamente', () {
      final json = {
        '_id': 'auto123',
        'modelo': 'Modelo A',
        'valor': 25000.0,
        'accidentes': 2,
        'propietario': 'prop123',
      };

      final automovil = Automovil.fromJson(json);

      expect(automovil.id, 'auto123');
      expect(automovil.modelo, 'Modelo A');
      expect(automovil.valor, 25000.0);
      expect(automovil.accidentes, 2);
      expect(automovil.propietarioId, 'prop123');
    });

    test('fromJson convierte valor entero a double', () {
      final json = {
        '_id': 'auto456',
        'modelo': 'Modelo B',
        'valor': 30000,
        'accidentes': 0,
        'propietario': 'prop456',
      };

      final automovil = Automovil.fromJson(json);

      expect(automovil.valor, 30000.0);
      expect(automovil.valor, isA<double>());
    });

    test('toJson genera el mapa correctamente', () {
      final automovil = Automovil(
        modelo: 'Modelo C',
        valor: 20000.0,
        accidentes: 1,
        propietarioId: 'prop789',
      );

      final json = automovil.toJson();

      expect(json['modelo'], 'Modelo C');
      expect(json['valor'], 20000.0);
      expect(json['accidentes'], 1);
      expect(json['propietario'], 'prop789');
      expect(json.containsKey('id'), false);
    });

    test('constructor con id opcional', () {
      final autoSinId = Automovil(
        modelo: 'Modelo A',
        valor: 15000.0,
        accidentes: 0,
        propietarioId: 'prop1',
      );

      final autoConId = Automovil(
        id: 'custom-auto-id',
        modelo: 'Modelo B',
        valor: 18000.0,
        accidentes: 3,
        propietarioId: 'prop2',
      );

      expect(autoSinId.id, null);
      expect(autoConId.id, 'custom-auto-id');
    });

    test('maneja diferentes modelos correctamente', () {
      final modelos = ['Modelo A', 'Modelo B', 'Modelo C'];

      for (final modelo in modelos) {
        final auto = Automovil(
          modelo: modelo,
          valor: 10000.0,
          accidentes: 0,
          propietarioId: 'test',
        );
        expect(auto.modelo, modelo);
      }
    });
  });
}
