class ContactoEmpresa {
  final int idContacto;
  final int idEmpresa;
  final String nombre;
  final String apellidopaterno;
  final String apellidomaterno;
  final String telefono;
  final String correo;
  final String puesto;
  final String horarioatencion;
  final String comentarios;
  

  ContactoEmpresa({
    required this.idContacto,
    required this.idEmpresa,
    required this.nombre,
    required this.apellidopaterno,
    required this.apellidomaterno,
    required this.telefono,
    required this.correo,
    required this.puesto,
    required this.horarioatencion,
    required this.comentarios,
  });

  factory ContactoEmpresa.fromMap(Map<String, dynamic> map) {
  return ContactoEmpresa(
    idContacto: map['idContacto'] != null ? map['idContacto'] as int : 0,
    idEmpresa: map['idEmpresa'] != null ? map['idEmpresa'] as int : 0,
    nombre: map['nombre'] ?? '',
    apellidopaterno: map['apellidopaterno'] ?? '',
    apellidomaterno: map['apellidomaterno'] ?? '',
    telefono: map['telefono'] ?? '',
    correo: map['correo'] ?? '',
    puesto: map['puesto'] ?? '',
    horarioatencion: map['horarioatencion'] ?? '',
    comentarios: map['comentarios'] ?? '',
  );
}
}
