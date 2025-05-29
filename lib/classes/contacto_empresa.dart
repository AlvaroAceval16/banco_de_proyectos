class ContactoEmpresa {
  final int idcontacto; // Coincide con idContacto -> idcontacto
  final int idempresa;  // Coincide con idEmpresa -> idempresa
  final String nombre;
  final String apellidopaterno; // Coincide con apellidoPaterno -> apellidopaterno
  final String apellidomaterno; // Coincide con apellidoMaterno -> apellidomaterno
  final String telefono;
  final String correo; // CAMBIADO: Antes era 'email'
  final String puesto;
  final String horarioAtencion; // AÑADIDO
  final String comentarios;   // AÑADIDO
  // final bool activo; // ELIMINADO: No está en tu CREATE TABLE. Si lo necesitas, añádelo a la DB.

  ContactoEmpresa({
    required this.idcontacto,
    required this.idempresa,
    required this.nombre,
    required this.apellidopaterno,
    required this.apellidomaterno,
    required this.telefono,
    required this.correo, // CAMBIADO
    required this.puesto,
    required this.horarioAtencion, // AÑADIDO
    required this.comentarios,   // AÑADIDO
    // required this.activo, // ELIMINADO
  });

  factory ContactoEmpresa.fromMap(Map<String, dynamic> map) {
    return ContactoEmpresa(
      idcontacto: map['idcontacto'] as int,
      idempresa: map['idempresa'] as int, // Asegúrate de que no sea null en la DB o maneja el null aquí
      nombre: map['nombre'] as String,
      apellidopaterno: map['apellidopaterno'] as String,
      apellidomaterno: map['apellidomaterno'] as String,
      telefono: map['telefono'] as String,
      correo: map['correo'] as String, // CAMBIADO: Mapea 'correo' de la DB
      puesto: map['puesto'] as String,
      horarioAtencion: map['horarioatencion'] as String, // Mapea 'horarioAtencion' -> 'horarioatencion'
      comentarios: map['comentarios'] as String,     // Mapea 'comentarios'
      // activo: map['activo'] as bool? ?? true, // ELIMINADO
    );
  }

}
