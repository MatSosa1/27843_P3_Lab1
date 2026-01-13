class Automovil {
  final String? id;
  final String modelo;
  final double valor;
  final int accidentes;
  final String propietarioId;

  Automovil({
    this.id,
    required this.modelo,
    required this.valor,
    required this.accidentes,
    required this.propietarioId,
  });

  factory Automovil.fromJson(Map<String, dynamic> json) {
    return Automovil(
      id: json['_id'],
      modelo: json['modelo'],
      valor: json['valor'].toDouble(),
      accidentes: json['accidentes'],
      propietarioId: json['propietario'],
    );
  }

  Map<String, dynamic> toJson() => {
        'modelo': modelo,
        'valor': valor,
        'accidentes': accidentes,
        'propietario': propietarioId,
      };
}
