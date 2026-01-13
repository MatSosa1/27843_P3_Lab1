import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab_aseguradora/models/automovil.dart';
import 'package:lab_aseguradora/models/poliza.dart';
import 'package:lab_aseguradora/models/propietario.dart';
import 'package:lab_aseguradora/models/seguro.dart';

class PolizaService {
  static const String baseUrl = 'http://localhost:3000/api';

  Future<Propietario> crearPropietario(Propietario p) async {
    final res = await http.post(
      Uri.parse('$baseUrl/propietarios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(p.toJson()),
    );
    return Propietario.fromJson(jsonDecode(res.body));
  }

  Future<Automovil> crearAutomovil(Automovil a) async {
    final res = await http.post(
      Uri.parse('$baseUrl/automoviles'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(a.toJson()),
    );
    return Automovil.fromJson(jsonDecode(res.body));
  }

  Future<Seguro> crearSeguro(Seguro s) async {
    final res = await http.post(
      Uri.parse('$baseUrl/seguros'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(s.toJson()),
    );
    return Seguro.fromJson(jsonDecode(res.body));
  }

  Future<List<Poliza>> obtenerPolizas() async {
    final res = await http.get(
      Uri.parse('$baseUrl/seguros'),
    );

    final List data = jsonDecode(res.body);
    return data.map((e) => Poliza.fromJson(e)).toList();
  }
}
