import 'package:flutter_test/flutter_test.dart';
import 'package:lab_aseguradora/models/poliza.dart';

void main() {
  print('----------------------');
  print('Pruebas unitarias de Poliza');
  print('----------------------\n');

  group('Grupo 1 - Pruebas Correctas', () {
    test('Prueba 1 - Crear instancia de Poliza', () {
      print('\nPrueba 1 - Crear instancia de Poliza');
      // Arrange
      final poliza = Poliza(
        id: '1',
        propietario: 'Ana Lopez',
        modeloAuto: 'Honda Civic',
        valorAuto: 20000,
        accidentes: 1,
        costoTotal: 1000,
      );
      print('Datos de entrada: id: 1, propietario: Ana Lopez, modelo: Honda Civic, valor: 20000, accidentes: 1, costo: 1000');

      // Act & Assert
      expect(poliza.id, '1');
      expect(poliza.propietario, 'Ana Lopez');
      expect(poliza.modeloAuto, 'Honda Civic');
      expect(poliza.valorAuto, 20000);
      expect(poliza.accidentes, 1);
      expect(poliza.costoTotal, 1000);

      print('Prueba 1 Pasada');
    });

    // Puedes agregar más pruebas aquí si tu modelo tiene lógica adicional
  });

  group('Grupo 2 - Pruebas Negativas', () {
    test('Prueba 2 - Crear Poliza con valores negativos', () {
      print('\nPrueba 2 - Crear Poliza con valores negativos');
      // Arrange
      final poliza = Poliza(
        id: '2',
        propietario: 'Pedro Perez',
        modeloAuto: 'Mazda 3',
        valorAuto: -5000,
        accidentes: -2,
        costoTotal: -100,
      );
      print('Datos de entrada: valorAuto: -5000, accidentes: -2, costoTotal: -100');

      // Act & Assert
      // Dependiendo de tu implementación, aquí podrías esperar una excepción o simplemente comprobar los valores negativos
      expect(poliza.valorAuto, -5000);
      expect(poliza.accidentes, -2);
      expect(poliza.costoTotal, -100);

      print('Prueba 2 Pasada');
    });
  });
}
