class Proyecto {
  final int idProyecto;
  final int idEmpresa;
  final String nombreProyecto;
  final String carreras;
  final String descripcion;
  final String periodo;
  final String fechaSolicitud;
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
    idProyecto: map['idProyecto'] != null ? map['idProyecto'] as int : 0,
    idEmpresa: map['idempresa'] != null ? map['idempresa'] as int : 0,
    nombreProyecto: map['nombreproyecto'] ?? '',
    carreras: map['carreras'] ?? '',
    descripcion: map['descripcion'] ?? '',
    periodo: map['periodo'] ?? '',
    fechaSolicitud: map['fechasolicitud'] ?? '',
    tipoProyecto: map['tipoProyecto'] ?? '',
    apoyoEconomico: map['apoyoeconomico'] ?? '',
    plazosEntrega: map['plazosentrega'] ?? '',
    tecnologias: map['tecnologias'] ?? '',
    modalidad: map['modalidad'] ?? '',
    estado: map['estado'] ?? '',
    numeroEstudiantes: map['numeroestudiantes'] != null
        ? map['numeroestudiantes'] as int
        : 0,
  );
}
}
