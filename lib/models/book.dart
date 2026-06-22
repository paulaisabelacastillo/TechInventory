class Equipo {
  const Equipo({
    this.id,
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.fecha,
    required this.foto,
  });

  final int? id;
  final String codigo;
  final String nombre;
  final String descripcion;
  final String fecha;
  final String foto;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codigo': codigo,
      'nombre': nombre,
      'descripcion': descripcion,
      'fecha': fecha,
      'foto': foto,
    };
  }

  factory Equipo.fromMap(Map<String, dynamic> map) {
    return Equipo(
      id: map['id'] as int?,
      codigo: map['codigo'] as String,
      nombre: map['nombre'] as String,
      descripcion: map['descripcion'] as String,
      fecha: map['fecha'] as String,
      foto: map['foto'] as String,
    );
  }
}
