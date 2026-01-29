import 'package:flutter_test/flutter_test.dart';
import 'package:lab_aseguradora/models/propietario.dart';

void main() {
  group('Propietario', () {
    test('fromJson crea un Propietario correctamente', () {
      final json = {
        '_id': 'prop123',
        'nombre': 'Juan',
        'apellido': 'Perez',
        'edad': 30,
      };

      final propietario = Propietario.fromJson(json);

      expect(propietario.id, 'prop123');
      expect(propietario.nombre, 'Juan');
      expect(propietario.apellido, 'Perez');
      expect(propietario.edad, 30);
    });

    test('toJson genera el mapa correctamente', () {
      final propietario = Propietario(
        nombre: 'Maria',
        apellido: 'Lopez',
        edad: 25,
      );

      final json = propietario.toJson();

      expect(json['nombre'], 'Maria');
      expect(json['apellido'], 'Lopez');
      expect(json['edad'], 25);
      expect(json.containsKey('id'), false);
    });

    test('constructor con id opcional', () {
      final propietarioSinId = Propietario(
        nombre: 'Carlos',
        apellido: 'Garcia',
        edad: 40,
      );

      final propietarioConId = Propietario(
        id: 'custom-id',
        nombre: 'Ana',
        apellido: 'Martinez',
        edad: 35,
      );

      expect(propietarioSinId.id, null);
      expect(propietarioConId.id, 'custom-id');
    });

    test('fromJson y toJson son consistentes', () {
      final original = Propietario(
        nombre: 'Test',
        apellido: 'User',
        edad: 28,
      );

      final json = original.toJson();
      json['_id'] = 'generated-id';

      final recreated = Propietario.fromJson(json);

      expect(recreated.nombre, original.nombre);
      expect(recreated.apellido, original.apellido);
      expect(recreated.edad, original.edad);
    });
  });
}
