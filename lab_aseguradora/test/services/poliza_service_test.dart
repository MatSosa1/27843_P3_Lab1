import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import 'package:lab_aseguradora/services/poliza_service.dart';
import 'package:lab_aseguradora/models/propietario.dart';
import 'package:lab_aseguradora/models/automovil.dart';
import 'package:lab_aseguradora/models/seguro.dart';
import 'package:lab_aseguradora/models/poliza.dart';

class MockHttpClient extends Mock implements http.Client {}

// Clase falsa para Uri necesaria para mocktail
class FakeUri extends Fake implements Uri {}

void main() {
  late PolizaService service;
  late MockHttpClient mockClient;
  const baseUrl = 'http://192.168.1.3:3000/api';

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockClient = MockHttpClient();
    service = PolizaService(client: mockClient);
  });

  group('PolizaService Tests', () {
    
    // --- Test crearPropietario ---
    test('crearPropietario realiza petición POST y retorna objeto', () async {
      // CORRECCIÓN: id es String y añadimos 'edad'
      final propietarioInput = Propietario(
        id: '1', 
        nombre: 'Juan', 
        apellido: 'Perez',
        edad: 30, 
      );
      
      // JSON que simula respuesta del backend (usamos _id por convención Mongo)
      final responseJson = {
        '_id': '1', 
        'nombre': 'Juan', 
        'apellido': 'Perez', 
        'edad': 30
      };
      
      when(() => mockClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(responseJson), 200));

      final result = await service.crearPropietario(propietarioInput);

      expect(result, isA<Propietario>());
      verify(() => mockClient.post(
        Uri.parse('$baseUrl/propietarios'),
        headers: {'Content-Type': 'application/json'},
        body: any(named: 'body'),
      )).called(1);
    });

    // --- Test crearAutomovil ---
    test('crearAutomovil realiza petición POST y retorna objeto', () async {
      // CORRECCIÓN: Agregados campos requeridos y quitado 'placa'
      final autoInput = Automovil(
        id: '1',
        modelo: '2020',
        valor: 15000.0,
        accidentes: 0,
        propietarioId: '1',
      );

      final responseJson = {
        '_id': '5',
        'modelo': '2020',
        'valor': 15000.0,
        'accidentes': 0,
        'propietario': '1' // Simulando la referencia
      };

      when(() => mockClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(responseJson), 200));

      final result = await service.crearAutomovil(autoInput);

      expect(result, isA<Automovil>());
      verify(() => mockClient.post(
        Uri.parse('$baseUrl/automoviles'),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).called(1);
    });

    // --- Test crearSeguro ---
    test('crearSeguro realiza petición POST y retorna objeto', () async {
      // CORRECCIÓN: Ajustado a la definición de clase Seguro que me diste
      final seguroInput = Seguro(
        id: '1',
        costoTotal: 500.0,
        automovilId: '1',
      ); 

      // Mock debe coincidir con Seguro.fromJson (usa _id y automovil)
      final responseJson = {
        '_id': '10', 
        'costoTotal': 500.0,
        'automovil': '1'
      };

      when(() => mockClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(responseJson), 200));

      final result = await service.crearSeguro(seguroInput);

      expect(result, isA<Seguro>());
      verify(() => mockClient.post(
        Uri.parse('$baseUrl/seguros'),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).called(1);
    });

    // --- Test obtenerPolizas ---
    test('obtenerPolizas realiza petición GET y retorna lista con estructura anidada', () async {
      final responseList = [
        {
          '_id': '1',
          'costoTotal': 500.0,
          'automovil': {
            'modelo': 'Toyota Corolla',
            'valor': 15000.0,
            'accidentes': 0,
            'propietario': {
              'nombre': 'Juan',
              'apellido': 'Perez'
            }
          }
        },
        {
          '_id': '2',
          'costoTotal': 800.0,
          'automovil': {
            'modelo': 'Honda Civic',
            'valor': 18000.0,
            'accidentes': 1,
            'propietario': {
              'nombre': 'Ana',
              'apellido': 'Gomez'
            }
          }
        }
      ];

      when(() => mockClient.get(
        any(),
        headers: any(named: 'headers'),
      )).thenAnswer((_) async => http.Response(jsonEncode(responseList), 200));

      final result = await service.obtenerPolizas();

      // Validaciones
      expect(result, isA<List<Poliza>>());
      expect(result.length, 2);
      
      // Validación extra para asegurar que el mapeo anidado funcionó
      expect(result[0].modeloAuto, 'Toyota Corolla');
      expect(result[0].propietario, 'Juan Perez'); // Verifica la concatenación
      
      verify(() => mockClient.get(
        Uri.parse('$baseUrl/seguros'),
      )).called(1);
    });
  });
}