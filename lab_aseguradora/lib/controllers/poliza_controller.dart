import 'package:lab_aseguradora/models/automovil.dart';
import 'package:lab_aseguradora/models/propietario.dart';
import 'package:lab_aseguradora/models/seguro.dart';
import 'package:lab_aseguradora/services/poliza_service.dart';

class PolizaController {
  final PolizaService _service;

  PolizaController(this._service);

  Future<void> crearPoliza({
    required Propietario propietario,
    required Automovil automovil,
    required Seguro seguro,
  }) async {
    final propietarioCreado = await _service.crearPropietario(propietario);

    final autoCreado = await _service.crearAutomovil(
      Automovil(
        modelo: automovil.modelo,
        valor: automovil.valor,
        accidentes: automovil.accidentes,
        propietarioId: propietarioCreado.id!,
      ),
    );

    await _service.crearSeguro(
      Seguro(
        costoTotal: _calcularCostoTotal(autoCreado.valor, autoCreado.modelo, propietarioCreado.edad, autoCreado.accidentes),
        automovilId: autoCreado.id!,
      ),
    );
  }

  double _calcularCostoTotal(double automovilValor, String modelo, int edad, int numAccidentes) {
    double cargoValor = automovilValor * 0.035;  // 3.5%
    double cargoModelo = automovilValor;
    double cargoEdad = 360;
    double cargoAccidentes = 0;

    // Cargo Modelo
    if (modelo == 'Modelo A') cargoModelo *= 0.011;  // 1.1%
    if (modelo == 'Modelo B') cargoModelo *= 0.012;  // 1.2%
    if (modelo == 'Modelo C') cargoModelo *= 0.015;  // 1.5%

    // Cargo Edad
    if (edad > 24) cargoEdad = 240;
    if (edad >= 53) cargoEdad = 430;

    // Cargo Accidentes
    for (int i = 0; i < numAccidentes; i++) {
      if (i < 3) {
        cargoAccidentes += 17;
      } else {
        cargoAccidentes += 21;
      }
    }

    print(cargoValor);
    print(cargoModelo);
    print(cargoEdad);
    print(cargoAccidentes);

    return cargoValor + cargoModelo + cargoEdad + cargoAccidentes;
  }
}
