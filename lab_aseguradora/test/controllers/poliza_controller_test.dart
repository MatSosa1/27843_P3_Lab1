import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lab_aseguradora/controllers/poliza_controller.dart';
import 'package:lab_aseguradora/services/poliza_service.dart';
import 'package:lab_aseguradora/models/propietario.dart';
import 'package:lab_aseguradora/models/automovil.dart';
import 'package:lab_aseguradora/models/seguro.dart';

class MockPolizaService extends Mock implements PolizaService {}

class FakePropietario extends Fake implements Propietario {}

class FakeAutomovil extends Fake implements Automovil {}

class FakeSeguro extends Fake implements Seguro {}

void main() {
  late MockPolizaService mockService;
  late PolizaController controller;

  setUpAll(() {
    registerFallbackValue(FakePropietario());
    registerFallbackValue(FakeAutomovil());
    registerFallbackValue(FakeSeguro());
  });

  setUp(() {
    mockService = MockPolizaService();
    controller = PolizaController(mockService);
  });

  group('PolizaController', () {
    group('crearPoliza', () {
      test('crea propietario, automovil y seguro en orden correcto', () async {
        final propietario = Propietario(
          nombre: 'Juan',
          apellido: 'Perez',
          edad: 30,
        );
        final automovil = Automovil(
          modelo: 'Modelo A',
          valor: 20000.0,
          accidentes: 0,
          propietarioId: '',
        );
        final seguro = Seguro(
          costoTotal: 0,
          automovilId: '',
        );

        when(() => mockService.crearPropietario(any())).thenAnswer(
          (_) async => Propietario(
            id: 'prop-123',
            nombre: 'Juan',
            apellido: 'Perez',
            edad: 30,
          ),
        );

        when(() => mockService.crearAutomovil(any())).thenAnswer(
          (_) async => Automovil(
            id: 'auto-456',
            modelo: 'Modelo A',
            valor: 20000.0,
            accidentes: 0,
            propietarioId: 'prop-123',
          ),
        );

        when(() => mockService.crearSeguro(any())).thenAnswer(
          (_) async => Seguro(
            id: 'seg-789',
            costoTotal: 1200.0,
            automovilId: 'auto-456',
          ),
        );

        await controller.crearPoliza(
          propietario: propietario,
          automovil: automovil,
          seguro: seguro,
        );

        verify(() => mockService.crearPropietario(any())).called(1);
        verify(() => mockService.crearAutomovil(any())).called(1);
        verify(() => mockService.crearSeguro(any())).called(1);
      });

      test('usa el id del propietario creado para el automovil', () async {
        final propietario = Propietario(
          nombre: 'Maria',
          apellido: 'Lopez',
          edad: 25,
        );
        final automovil = Automovil(
          modelo: 'Modelo B',
          valor: 15000.0,
          accidentes: 1,
          propietarioId: '',
        );
        final seguro = Seguro(costoTotal: 0, automovilId: '');

        when(() => mockService.crearPropietario(any())).thenAnswer(
          (_) async => Propietario(
            id: 'new-prop-id',
            nombre: 'Maria',
            apellido: 'Lopez',
            edad: 25,
          ),
        );

        Automovil? capturedAutomovil;
        when(() => mockService.crearAutomovil(any())).thenAnswer((invocation) {
          capturedAutomovil = invocation.positionalArguments[0] as Automovil;
          return Future.value(Automovil(
            id: 'auto-id',
            modelo: 'Modelo B',
            valor: 15000.0,
            accidentes: 1,
            propietarioId: 'new-prop-id',
          ));
        });

        when(() => mockService.crearSeguro(any())).thenAnswer(
          (_) async => Seguro(id: 'seg-id', costoTotal: 1000, automovilId: 'auto-id'),
        );

        await controller.crearPoliza(
          propietario: propietario,
          automovil: automovil,
          seguro: seguro,
        );

        expect(capturedAutomovil?.propietarioId, 'new-prop-id');
      });

      test('usa el id del automovil creado para el seguro', () async {
        final propietario = Propietario(nombre: 'Test', apellido: 'User', edad: 40);
        final automovil = Automovil(modelo: 'Modelo C', valor: 10000.0, accidentes: 0, propietarioId: '');
        final seguro = Seguro(costoTotal: 0, automovilId: '');

        when(() => mockService.crearPropietario(any())).thenAnswer(
          (_) async => Propietario(id: 'p1', nombre: 'Test', apellido: 'User', edad: 40),
        );

        when(() => mockService.crearAutomovil(any())).thenAnswer(
          (_) async => Automovil(id: 'auto-xyz', modelo: 'Modelo C', valor: 10000.0, accidentes: 0, propietarioId: 'p1'),
        );

        Seguro? capturedSeguro;
        when(() => mockService.crearSeguro(any())).thenAnswer((invocation) {
          capturedSeguro = invocation.positionalArguments[0] as Seguro;
          return Future.value(Seguro(id: 's1', costoTotal: 800, automovilId: 'auto-xyz'));
        });

        await controller.crearPoliza(
          propietario: propietario,
          automovil: automovil,
          seguro: seguro,
        );

        expect(capturedSeguro?.automovilId, 'auto-xyz');
      });
    });

    group('calculo de costo total', () {
      test('calcula costo para Modelo A con edad <= 24', () async {
        final propietario = Propietario(nombre: 'Young', apellido: 'Driver', edad: 22);
        final automovil = Automovil(modelo: 'Modelo A', valor: 20000.0, accidentes: 0, propietarioId: '');
        final seguro = Seguro(costoTotal: 0, automovilId: '');

        when(() => mockService.crearPropietario(any())).thenAnswer(
          (_) async => Propietario(id: 'p1', nombre: 'Young', apellido: 'Driver', edad: 22),
        );
        when(() => mockService.crearAutomovil(any())).thenAnswer(
          (_) async => Automovil(id: 'a1', modelo: 'Modelo A', valor: 20000.0, accidentes: 0, propietarioId: 'p1'),
        );

        Seguro? capturedSeguro;
        when(() => mockService.crearSeguro(any())).thenAnswer((invocation) {
          capturedSeguro = invocation.positionalArguments[0] as Seguro;
          return Future.value(Seguro(id: 's1', costoTotal: capturedSeguro!.costoTotal, automovilId: 'a1'));
        });

        await controller.crearPoliza(propietario: propietario, automovil: automovil, seguro: seguro);

        // cargoValor = 20000 * 0.035 = 700
        // cargoModelo = 20000 * 0.011 = 220
        // cargoEdad = 360 (edad <= 24)
        // cargoAccidentes = 0
        // Total = 700 + 220 + 360 + 0 = 1280
        expect(capturedSeguro?.costoTotal, 1280.0);
      });

      test('calcula costo para Modelo B con edad > 24 y < 53', () async {
        final propietario = Propietario(nombre: 'Mid', apellido: 'Age', edad: 35);
        final automovil = Automovil(modelo: 'Modelo B', valor: 25000.0, accidentes: 2, propietarioId: '');
        final seguro = Seguro(costoTotal: 0, automovilId: '');

        when(() => mockService.crearPropietario(any())).thenAnswer(
          (_) async => Propietario(id: 'p1', nombre: 'Mid', apellido: 'Age', edad: 35),
        );
        when(() => mockService.crearAutomovil(any())).thenAnswer(
          (_) async => Automovil(id: 'a1', modelo: 'Modelo B', valor: 25000.0, accidentes: 2, propietarioId: 'p1'),
        );

        Seguro? capturedSeguro;
        when(() => mockService.crearSeguro(any())).thenAnswer((invocation) {
          capturedSeguro = invocation.positionalArguments[0] as Seguro;
          return Future.value(Seguro(id: 's1', costoTotal: capturedSeguro!.costoTotal, automovilId: 'a1'));
        });

        await controller.crearPoliza(propietario: propietario, automovil: automovil, seguro: seguro);

        // cargoValor = 25000 * 0.035 = 875
        // cargoModelo = 25000 * 0.012 = 300
        // cargoEdad = 240 (edad > 24)
        // cargoAccidentes = 17 + 17 = 34 (2 accidentes, cada uno < 3)
        // Total = 875 + 300 + 240 + 34 = 1449
        expect(capturedSeguro?.costoTotal, 1449.0);
      });

      test('calcula costo para Modelo C con edad >= 53', () async {
        final propietario = Propietario(nombre: 'Senior', apellido: 'Driver', edad: 60);
        final automovil = Automovil(modelo: 'Modelo C', valor: 30000.0, accidentes: 0, propietarioId: '');
        final seguro = Seguro(costoTotal: 0, automovilId: '');

        when(() => mockService.crearPropietario(any())).thenAnswer(
          (_) async => Propietario(id: 'p1', nombre: 'Senior', apellido: 'Driver', edad: 60),
        );
        when(() => mockService.crearAutomovil(any())).thenAnswer(
          (_) async => Automovil(id: 'a1', modelo: 'Modelo C', valor: 30000.0, accidentes: 0, propietarioId: 'p1'),
        );

        Seguro? capturedSeguro;
        when(() => mockService.crearSeguro(any())).thenAnswer((invocation) {
          capturedSeguro = invocation.positionalArguments[0] as Seguro;
          return Future.value(Seguro(id: 's1', costoTotal: capturedSeguro!.costoTotal, automovilId: 'a1'));
        });

        await controller.crearPoliza(propietario: propietario, automovil: automovil, seguro: seguro);

        // cargoValor = 30000 * 0.035 = 1050
        // cargoModelo = 30000 * 0.015 = 450
        // cargoEdad = 430 (edad >= 53)
        // cargoAccidentes = 0
        // Total = 1050 + 450 + 430 + 0 = 1930
        expect(capturedSeguro?.costoTotal, 1930.0);
      });

      test('calcula costo con mas de 3 accidentes', () async {
        final propietario = Propietario(nombre: 'Many', apellido: 'Accidents', edad: 30);
        final automovil = Automovil(modelo: 'Modelo A', valor: 15000.0, accidentes: 5, propietarioId: '');
        final seguro = Seguro(costoTotal: 0, automovilId: '');

        when(() => mockService.crearPropietario(any())).thenAnswer(
          (_) async => Propietario(id: 'p1', nombre: 'Many', apellido: 'Accidents', edad: 30),
        );
        when(() => mockService.crearAutomovil(any())).thenAnswer(
          (_) async => Automovil(id: 'a1', modelo: 'Modelo A', valor: 15000.0, accidentes: 5, propietarioId: 'p1'),
        );

        Seguro? capturedSeguro;
        when(() => mockService.crearSeguro(any())).thenAnswer((invocation) {
          capturedSeguro = invocation.positionalArguments[0] as Seguro;
          return Future.value(Seguro(id: 's1', costoTotal: capturedSeguro!.costoTotal, automovilId: 'a1'));
        });

        await controller.crearPoliza(propietario: propietario, automovil: automovil, seguro: seguro);

        // cargoValor = 15000 * 0.035 = 525
        // cargoModelo = 15000 * 0.011 = 165
        // cargoEdad = 240 (edad > 24)
        // cargoAccidentes = 17 + 17 + 17 + 21 + 21 = 93 (primeros 3 a $17, resto a $21)
        // Total = 525 + 165 + 240 + 93 = 1023
        expect(capturedSeguro?.costoTotal, 1023.0);
      });

      test('calcula costo con edad exactamente 24', () async {
        final propietario = Propietario(nombre: 'Exact', apellido: 'Age', edad: 24);
        final automovil = Automovil(modelo: 'Modelo B', valor: 10000.0, accidentes: 0, propietarioId: '');
        final seguro = Seguro(costoTotal: 0, automovilId: '');

        when(() => mockService.crearPropietario(any())).thenAnswer(
          (_) async => Propietario(id: 'p1', nombre: 'Exact', apellido: 'Age', edad: 24),
        );
        when(() => mockService.crearAutomovil(any())).thenAnswer(
          (_) async => Automovil(id: 'a1', modelo: 'Modelo B', valor: 10000.0, accidentes: 0, propietarioId: 'p1'),
        );

        Seguro? capturedSeguro;
        when(() => mockService.crearSeguro(any())).thenAnswer((invocation) {
          capturedSeguro = invocation.positionalArguments[0] as Seguro;
          return Future.value(Seguro(id: 's1', costoTotal: capturedSeguro!.costoTotal, automovilId: 'a1'));
        });

        await controller.crearPoliza(propietario: propietario, automovil: automovil, seguro: seguro);

        // cargoValor = 10000 * 0.035 = 350
        // cargoModelo = 10000 * 0.012 = 120
        // cargoEdad = 360 (edad == 24, no es > 24)
        // cargoAccidentes = 0
        // Total = 350 + 120 + 360 + 0 = 830
        expect(capturedSeguro?.costoTotal, 830.0);
      });

      test('calcula costo con edad exactamente 53', () async {
        final propietario = Propietario(nombre: 'Boundary', apellido: 'Senior', edad: 53);
        final automovil = Automovil(modelo: 'Modelo C', valor: 20000.0, accidentes: 1, propietarioId: '');
        final seguro = Seguro(costoTotal: 0, automovilId: '');

        when(() => mockService.crearPropietario(any())).thenAnswer(
          (_) async => Propietario(id: 'p1', nombre: 'Boundary', apellido: 'Senior', edad: 53),
        );
        when(() => mockService.crearAutomovil(any())).thenAnswer(
          (_) async => Automovil(id: 'a1', modelo: 'Modelo C', valor: 20000.0, accidentes: 1, propietarioId: 'p1'),
        );

        Seguro? capturedSeguro;
        when(() => mockService.crearSeguro(any())).thenAnswer((invocation) {
          capturedSeguro = invocation.positionalArguments[0] as Seguro;
          return Future.value(Seguro(id: 's1', costoTotal: capturedSeguro!.costoTotal, automovilId: 'a1'));
        });

        await controller.crearPoliza(propietario: propietario, automovil: automovil, seguro: seguro);

        // cargoValor = 20000 * 0.035 = 700
        // cargoModelo = 20000 * 0.015 = 300
        // cargoEdad = 430 (edad >= 53)
        // cargoAccidentes = 17
        // Total = 700 + 300 + 430 + 17 = 1447
        expect(capturedSeguro?.costoTotal, 1447.0);
      });
    });
  });
}
