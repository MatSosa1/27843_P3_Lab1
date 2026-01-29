import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lab_aseguradora/controllers/poliza_controller.dart';
import 'package:lab_aseguradora/models/automovil.dart';
import 'package:lab_aseguradora/models/propietario.dart';
import 'package:lab_aseguradora/models/seguro.dart';
import 'package:lab_aseguradora/services/poliza_service.dart';
import 'package:lab_aseguradora/views/pages/crear_poliza_page.dart';
import 'package:lab_aseguradora/views/providers/poliza_provider.dart';

class MockPolizaService extends Mock implements PolizaService {}

class FakePropietario extends Fake implements Propietario {}

class FakeAutomovil extends Fake implements Automovil {}

class FakeSeguro extends Fake implements Seguro {}

void main() {
  late MockPolizaService mockService;

  setUpAll(() {
    registerFallbackValue(FakePropietario());
    registerFallbackValue(FakeAutomovil());
    registerFallbackValue(FakeSeguro());
  });

  setUp(() {
    mockService = MockPolizaService();
  });

  Widget createTestWidget({MockPolizaService? service, Size? surfaceSize}) {
    return ProviderScope(
      overrides: [
        polizaServiceProvider.overrideWithValue(service ?? mockService),
        polizaControllerProvider.overrideWith((ref) {
          final svc = ref.watch(polizaServiceProvider);
          return PolizaController(svc);
        }),
      ],
      child: MaterialApp(
        home: const CrearPolizaPage(),
        builder: (context, child) {
          return MediaQuery(
            data: const MediaQueryData(size: Size(800, 1200)),
            child: child!,
          );
        },
      ),
    );
  }

  group('CrearPolizaPage', () {
    testWidgets('muestra todos los campos del formulario', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Nombre propietario'), findsOneWidget);
      expect(find.text('Apellido propietario'), findsOneWidget);
      expect(find.text('Edad propietario'), findsOneWidget);
      expect(find.text('Valor del automovil'), findsOneWidget);
      expect(find.text('Número de accidentes'), findsOneWidget);
    });

    testWidgets('muestra opciones de modelo de auto', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Modelo A'), findsOneWidget);
      expect(find.text('Modelo B'), findsOneWidget);
      expect(find.text('Modelo C'), findsOneWidget);
    });

    testWidgets('Modelo C esta seleccionado por defecto', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final radioC = tester.widget<RadioListTile<String>>(
        find.widgetWithText(RadioListTile<String>, 'Modelo C'),
      );

      expect(radioC.value, 'Modelo C');
    });

    testWidgets('tiene boton CREAR POLIZA', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('CREAR PÓLIZA'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('tiene AppBar con titulo Crear Poliza', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Crear Póliza'), findsOneWidget);
    });

    testWidgets('muestra error de validacion cuando campos estan vacios', (tester) async {
      // Usamos un tamaño de pantalla más grande para el test
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Hacemos scroll hacia abajo para ver el botón
      await tester.dragUntilVisible(
        find.text('CREAR PÓLIZA'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('CREAR PÓLIZA'));
      await tester.pumpAndSettle();

      expect(find.text('Campo obligatorio'), findsWidgets);
    });

    testWidgets('permite seleccionar diferentes modelos de auto', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('Modelo A'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(RadioListTile<String>, 'Modelo A'), findsOneWidget);

      await tester.tap(find.text('Modelo B'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(RadioListTile<String>, 'Modelo B'), findsOneWidget);
    });

    testWidgets('permite ingresar texto en los campos', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre propietario'),
        'Juan',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Apellido propietario'),
        'Perez',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Edad propietario'),
        '30',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Valor del automovil'),
        '25000',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Número de accidentes'),
        '0',
      );

      await tester.pumpAndSettle();

      expect(find.text('Juan'), findsOneWidget);
      expect(find.text('Perez'), findsOneWidget);
      expect(find.text('30'), findsOneWidget);
      expect(find.text('25000'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('llama al servicio cuando se envía el formulario', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      when(() => mockService.crearPropietario(any())).thenAnswer(
        (_) async => Propietario(id: 'p1', nombre: 'Juan', apellido: 'Perez', edad: 30),
      );
      when(() => mockService.crearAutomovil(any())).thenAnswer(
        (_) async => Automovil(
          id: 'a1',
          modelo: 'Modelo C',
          valor: 25000.0,
          accidentes: 0,
          propietarioId: 'p1',
        ),
      );
      when(() => mockService.crearSeguro(any())).thenAnswer(
        (_) async => Seguro(id: 's1', costoTotal: 1200.0, automovilId: 'a1'),
      );

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre propietario'),
        'Juan',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Apellido propietario'),
        'Perez',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Edad propietario'),
        '30',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Valor del automovil'),
        '25000',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Número de accidentes'),
        '0',
      );

      await tester.pumpAndSettle();

      // Scroll hasta el botón
      await tester.dragUntilVisible(
        find.text('CREAR PÓLIZA'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('CREAR PÓLIZA'));
      await tester.pumpAndSettle();

      verify(() => mockService.crearPropietario(any())).called(1);
      verify(() => mockService.crearAutomovil(any())).called(1);
      verify(() => mockService.crearSeguro(any())).called(1);
    });

    testWidgets('muestra snackbar de exito cuando la poliza se crea', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      when(() => mockService.crearPropietario(any())).thenAnswer(
        (_) async => Propietario(id: 'p1', nombre: 'Juan', apellido: 'Perez', edad: 30),
      );
      when(() => mockService.crearAutomovil(any())).thenAnswer(
        (_) async => Automovil(
          id: 'a1',
          modelo: 'Modelo C',
          valor: 25000.0,
          accidentes: 0,
          propietarioId: 'p1',
        ),
      );
      when(() => mockService.crearSeguro(any())).thenAnswer(
        (_) async => Seguro(id: 's1', costoTotal: 1200.0, automovilId: 'a1'),
      );

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre propietario'),
        'Juan',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Apellido propietario'),
        'Perez',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Edad propietario'),
        '30',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Valor del automovil'),
        '25000',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Número de accidentes'),
        '0',
      );

      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.text('CREAR PÓLIZA'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('CREAR PÓLIZA'));
      await tester.pumpAndSettle();

      expect(find.text('Póliza creada con éxito'), findsOneWidget);
    });

    testWidgets('muestra snackbar de error cuando falla la creacion', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      when(() => mockService.crearPropietario(any())).thenThrow(
        Exception('Error de red'),
      );

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre propietario'),
        'Juan',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Apellido propietario'),
        'Perez',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Edad propietario'),
        '30',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Valor del automovil'),
        '25000',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Número de accidentes'),
        '0',
      );

      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.text('CREAR PÓLIZA'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('CREAR PÓLIZA'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Error'), findsOneWidget);
    });
  });
}
