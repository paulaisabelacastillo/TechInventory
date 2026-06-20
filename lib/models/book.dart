class Equipo {
  final int? id;
  final String codigo;
  final String nombre;
  final String descripcion;
  final String fecha;
  final String foto;

  Equipo({
    this.id,
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.fecha,
    required this.foto,
  });

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
      id: map['id'],
      codigo: map['codigo'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      fecha: map['fecha'],
      foto: map['foto'],
    );
  }
}
