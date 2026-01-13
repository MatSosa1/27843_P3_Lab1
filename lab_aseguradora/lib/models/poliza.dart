class Poliza {
  final String id;
  final double costoTotal;
  final String modeloAuto;
  final double valorAuto;
  final int accidentes;
  final String propietario;

  Poliza({
    required this.id,
    required this.costoTotal,
    required this.modeloAuto,
    required this.valorAuto,
    required this.accidentes,
    required this.propietario,
  });

  factory Poliza.fromJson(Map<String, dynamic> json) {
    final auto = json['automovil'];
    final prop = auto['propietario'];

    return Poliza(
      id: json['_id'],
      costoTotal: json['costoTotal'].toDouble(),
      modeloAuto: auto['modelo'],
      valorAuto: auto['valor'].toDouble(),
      accidentes: auto['accidentes'],
      propietario: '${prop['nombre']} ${prop['apellido']}',
    );
  }
}
