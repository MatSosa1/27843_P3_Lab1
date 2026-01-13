class Seguro {
  final String? id;
  final double costoTotal;
  final String automovilId;

  Seguro({
    this.id,
    required this.costoTotal,
    required this.automovilId,
  });

  factory Seguro.fromJson(Map<String, dynamic> json) {
    return Seguro(
      id: json['_id'],
      costoTotal: json['costoTotal'].toDouble(),
      automovilId: json['automovil'],
    );
  }

  Map<String, dynamic> toJson() => {
        'costoTotal': costoTotal,
        'automovil': automovilId,
      };
}
