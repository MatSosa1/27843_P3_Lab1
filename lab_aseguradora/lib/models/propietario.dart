class Propietario {
  final String? id;
  final String nombre;
  final String apellido;
  final int edad;

  Propietario({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.edad,
  });

  factory Propietario.fromJson(Map<String, dynamic> json) {
    return Propietario(
      id: json['_id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      edad: json['edad'],
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'apellido': apellido,
        'edad': edad,
      };
}
