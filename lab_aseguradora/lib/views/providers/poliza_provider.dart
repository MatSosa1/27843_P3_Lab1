import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:lab_aseguradora/controllers/poliza_controller.dart';
import 'package:lab_aseguradora/models/poliza.dart';
import 'package:lab_aseguradora/services/poliza_service.dart';

/// Service provider
final polizaServiceProvider = Provider<PolizaService>((ref) {
  return PolizaService();
});

/// Controller provider
final polizaControllerProvider = Provider<PolizaController>((ref) {
  final service = ref.watch(polizaServiceProvider);
  return PolizaController(service);
});

/// Estado de carga
final polizaLoadingProvider = StateProvider<bool>((ref) => false);

final polizasProvider = FutureProvider<List<Poliza>>((ref) async {
  final service = ref.watch(polizaServiceProvider);
  return service.obtenerPolizas();
});
