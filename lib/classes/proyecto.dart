class Proyecto {
  final int idProyecto;
  final int idEmpresa;
  final String nombreProyecto;
  final String carreras;
  final String descripcion;
  final String periodo;
  final String fechaSolicitud; // Considera usar DateTime si lo deseas
  final String tipoProyecto;
  final String apoyoEconomico;
  final String plazosEntrega;
  final String tecnologias;
  final String modalidad;
  final String estado;
  final int numeroEstudiantes;

  Proyecto({
    required this.idProyecto,
    required this.idEmpresa,
    required this.nombreProyecto,
    required this.carreras,
    required this.descripcion,
    required this.periodo,
    required this.fechaSolicitud,
    required this.tipoProyecto,
    required this.apoyoEconomico,
    required this.plazosEntrega,
    required this.tecnologias,
    required this.modalidad,
    required this.estado,
    required this.numeroEstudiantes,
  });

  factory Proyecto.fromMap(Map<String, dynamic> map) {
    return Proyecto(
      idProyecto: map['idProyecto'] as int,
      idEmpresa: map['idEmpresa'] as int,
      nombreProyecto: map['nombreProyecto'] ?? '',
      carreras: map['carreras'] ?? '',
      descripcion: map['descripcion'] ?? '',
      periodo: map['periodo'] ?? '',
      fechaSolicitud: map['fechaSolicitud'] ?? '',
      tipoProyecto: map['tipoProyecto'] ?? '',
      apoyoEconomico: map['apoyoEconomico'] ?? '',
      plazosEntrega: map['plazosEntrega'] ?? '',
      tecnologias: map['tecnologias'] ?? '',
      modalidad: map['modalidad'] ?? '',
      estado: map['estado'] ?? '',
      numeroEstudiantes: map['numeroEstudiantes'] as int,
    );
  }
}
