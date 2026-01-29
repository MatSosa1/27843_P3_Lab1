import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab_aseguradora/models/automovil.dart';
import 'package:lab_aseguradora/models/poliza.dart';
import 'package:lab_aseguradora/models/propietario.dart';
import 'package:lab_aseguradora/models/seguro.dart';

class PolizaService {
  static const String baseUrl = 'http://192.168.1.3:3000/api';
  
  // 1. Añadimos la propiedad cliente
  final http.Client client;

  // 2. Constructor que permite inyectar un cliente mockeado o usar el real
  PolizaService({http.Client? client}) : client = client ?? http.Client();

  Future<Propietario> crearPropietario(Propietario p) async {
    // 3. Usamos 'client.post' en lugar de 'http.post'
    final res = await client.post(
      Uri.parse('$baseUrl/propietarios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(p.toJson()),
    );
    
    return Propietario.fromJson(jsonDecode(res.body));
  }

  Future<Automovil> crearAutomovil(Automovil a) async {
    final res = await client.post(
      Uri.parse('$baseUrl/automoviles'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(a.toJson()),
    );
    return Automovil.fromJson(jsonDecode(res.body));
  }

  Future<Seguro> crearSeguro(Seguro s) async {
    final res = await client.post(
      Uri.parse('$baseUrl/seguros'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(s.toJson()),
    );
    return Seguro.fromJson(jsonDecode(res.body));
  }

  Future<List<Poliza>> obtenerPolizas() async {
    final res = await client.get(
      Uri.parse('$baseUrl/seguros'),
    );

    final List data = jsonDecode(res.body);
    return data.map((e) => Poliza.fromJson(e)).toList();
  }
}