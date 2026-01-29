import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_aseguradora/views/providers/poliza_provider.dart';
import 'package:mocktail/mocktail.dart';

// Ajusta estos imports a la estructura real de tu proyecto
import 'package:lab_aseguradora/services/poliza_service.dart';
import 'package:lab_aseguradora/controllers/poliza_controller.dart';
import 'package:lab_aseguradora/models/poliza.dart';

// Mock del Servicio para aislar pruebas
class MockPolizaService extends Mock implements PolizaService {}

void main() {
  late MockPolizaService mockService;

  setUp(() {
    mockService = MockPolizaService();
  });

  group('Poliza Providers Test', () {
    
    // --- Test 1: Service Provider ---
    test('polizaServiceProvider debe retornar una instancia de PolizaService', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(polizaServiceProvider);
      
      expect(service, isA<PolizaService>());
    });

    // --- Test 2: Controller Provider ---
    test('polizaControllerProvider debe crear un controlador inyectando el servicio', () {
      final container = ProviderContainer(
        overrides: [
          // Sobrescribimos el servicio con nuestro Mock
          polizaServiceProvider.overrideWithValue(mockService),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(polizaControllerProvider);
      
      expect(controller, isA<PolizaController>());
      // Al no lanzar error, confirmamos que el controller recibió su dependencia
    });

    // --- Test 3: Loading Provider ---
    test('polizaLoadingProvider debe iniciar en false y cambiar de estado', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Verificar estado inicial
      expect(container.read(polizaLoadingProvider), false);

      // Cambiar estado
      container.read(polizaLoadingProvider.notifier).state = true;
      expect(container.read(polizaLoadingProvider), true);
    });

    // --- Test 4: Polizas Future Provider ---
    test('polizasProvider debe llamar a obtenerPolizas y retornar datos', () async {
      // Datos simulados (Lista vacía para evitar dependencias de constructores complejos)
      final List<Poliza> mockPolizas = [];
      
      // Configurar el mock para devolver la lista cuando se llame al método
      when(() => mockService.obtenerPolizas()).thenAnswer((_) async => mockPolizas);

      final container = ProviderContainer(
        overrides: [
          polizaServiceProvider.overrideWithValue(mockService),
        ],
      );
      addTearDown(container.dispose);

      // Leer el FutureProvider (usamos .future para esperar la resolución)
      final resultado = await container.read(polizasProvider.future);

      // Validaciones
      expect(resultado, isA<List<Poliza>>());
      expect(resultado, isEmpty);
      
      // Verificamos que el provider realmente usó el servicio
      verify(() => mockService.obtenerPolizas()).called(1);
    });
  });
}