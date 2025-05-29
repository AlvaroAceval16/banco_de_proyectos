import 'package:supabase_flutter/supabase_flutter.dart';

/*final supabase = Supabase.instance.client;

Future<Map<String, dynamic>?> obtenerProyectoPorId(String proyectoId) async {
  try {
    final response = await supabase
        .from('proyectos')
        .select('''
          nombre,
          descripcion,
          modalidad,
          carrera,
          periodo,
          fecha_solicitud,
          apoyo_economico,
          plazos_entrega,
          tecnologias_utilizadas,
          empresa (
            nombre,
            descripcion
          ),
          asesor (
            nombre
          ),
          residente (
            nombre
          )
        ''')
        .eq('idProyecto', proyectoId)
        .single();

    return response;
  } catch (e) {
    print('❌ Error al obtener proyecto: $e');
    return null;
  }
}
/*
void cargarDatosProyecto() async {
  final data = await obtenerProyectoPorId('id-del-proyecto');

  if (data != null) {
    setState(() {
      titulo = data['titulo'];
      descripcion = data['descripcion'];
      modalidad = data['modalidad'];
      carrera = data['carrera'];
      periodo = data['periodo'];
      fechaSolicitud = data['fecha_solicitud'];
      apoyoEconomico = data['apoyo_economico'];
      plazosEntrega = data['plazos_entrega'];
      tecnologias = data['tecnologias_utilizadas'];
      empresaNombre = data['empresa']['nombre'];
      empresaDescripcion = data['empresa']['descripcion'];
      asesorNombre = data['asesor']['nombre'];
      residenteNombre = data['residente']['nombre'];
    });
  }
}
*/
*/

class ProyectoService {
  static final _supabase = Supabase.instance.client;

  //Obtener proyectos para vista
  static Future<List<Map<String, dynamic>>> obtenerProyectos() async {
    try {
      final response = await _supabase
          .from('proyectos')
          .select('*')
          .order('nombreproyecto', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error al cargar proyectos: $e');
    }
  }

  static Future<List<Map<String, dynamic>>>
  obtenerProyectosOrdenadosPorFecha() async {
    try {
      final response = await _supabase
          .from('proyectos')
          .select('*')
          .order('fechasolicitud', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error al cargar proyectos: $e');
    }
  }

  Future<Map<String, dynamic>> guardarProyecto({
    required String nombre,
    required String descripcion,
    required String? modalidad,
    required String? carrera,
    required String? periodo,
    required String fechasolicitud,
    required String apoyoeconomico,
    required String? plazosentrega,
    required String tecnologias,
    required int? idempresa,
    int numeroestudiantes = 1,
    String estado = 'Abierto',
  }) async {
    try {
      if (modalidad == null ||
          carrera == null ||
          periodo == null ||
          plazosentrega == null) {
        throw Exception(
          'Todos los campos select deben tener un valor seleccionado',
        );
      }

      final response =
          await _supabase
              .from('proyectos')
              .insert({
                'nombreproyecto': nombre,
                'descripcion': descripcion,
                'modalidad': modalidad,
                'carreras': carrera,
                'periodo': periodo,
                'fechasolicitud': fechasolicitud,
                'apoyoeconomico': apoyoeconomico,
                'plazosentrega': plazosentrega,
                'tecnologias': tecnologias,
                'idempresa': idempresa,
                'numeroestudiantes': numeroestudiantes,
                'estado': estado,
                'tipoproyecto': 'Desarrollo',
              })
              .select()
              .single();

      return response;
    } catch (e) {
      print('❌ Error al guardar proyecto: $e');
      throw Exception('Error al guardar proyecto: ${e.toString()}');
    }
  }

  // CREATE - Insertar nuevo proyecto
  Future<Map<String, dynamic>> crearProyecto({
    required String nombre,
    required String descripcion,
    required String carrera,
    required String periodo,
    required String tipoproyecto,
    required String apoyoeconomico,
    required String plazosentrega,
    required String tecnologias,
    required String modalidad,
    int? idempresa, // Opcional si no está en el formulario
    int? numeroestudiantes, // Opcional si no está en el formulario
  }) async {
    try {
      final response =
          await _supabase
              .from('proyectos')
              .insert({
                'nombreproyecto': nombre,
                'descripcion': descripcion,
                'carreras': carrera,
                'periodo': periodo,
                'tipoproyecto': tipoproyecto,
                'apoyoeconomico': apoyoeconomico,
                'plazosentrega': plazosentrega,
                'tecnologias': tecnologias,
                'modalidad': modalidad,
                'fechasolicitud': DateTime.now().toIso8601String(),
                'estado': 'Abierto', // Estado por defecto
                'idempresa':
                    idempresa ?? 1, // Valor por defecto si no se proporciona
                'numeroestudiantes':
                    numeroestudiantes ?? 1, // Valor por defecto
              })
              .select()
              .single();

      return response;
    } catch (e) {
      print('❌ Error al crear proyecto: $e');
      throw Exception('Error al crear proyecto');
    }
  }

  // READ - Obtener proyecto por ID
  Future<Map<String, dynamic>?> obtenerProyecto(int idproyecto) async {
    try {
      final response =
          await _supabase
              .from('proyectos')
              .select('''
            *,
            empresa:empresas(nombre, descripcion)
          ''')
              .eq('idproyecto', idproyecto)
              .single();

      return response;
    } catch (e) {
      print('❌ Error al obtener proyecto: $e');
      return null;
    }
  }

  // READ - Obtener todos los proyectos
  Future<List<Map<String, dynamic>>> listarProyectos() async {
    try {
      final response = await _supabase
          .from('proyectos')
          .select('''
            *,
            empresa:empresas(nombre)
          ''')
          .order('fechasolicitud', ascending: false);

      return response;
    } catch (e) {
      print('❌ Error al listar proyectos: $e');
      return [];
    }
  }

  // UPDATE - Actualizar proyecto
  Future<void> actualizarProyecto({
    required int idproyecto,
    String? nombre,
    String? descripcion,
    String? carrera,
    String? periodo,
    String? tipoproyecto,
    String? apoyoeconomico,
    String? plazosentrega,
    String? tecnologias,
    String? modalidad,
    String? estado,
  }) async {
    try {
      final updates = {
        if (nombre != null) 'nombreproyecto': nombre,
        if (descripcion != null) 'descripcion': descripcion,
        if (carrera != null) 'carreras': carrera,
        if (periodo != null) 'periodo': periodo,
        if (tipoproyecto != null) 'tipoproyecto': tipoproyecto,
        if (apoyoeconomico != null) 'apoyoeconomico': apoyoeconomico,
        if (plazosentrega != null) 'plazosentrega': plazosentrega,
        if (tecnologias != null) 'tecnologias': tecnologias,
        if (modalidad != null) 'modalidad': modalidad,
        if (estado != null) 'estado': estado,
      };

      await _supabase
          .from('proyectos')
          .update(updates)
          .eq('idproyecto', idproyecto);
    } catch (e) {
      print('❌ Error al actualizar proyecto: $e');
      throw Exception('Error al actualizar proyecto');
    }
  }

  // DELETE - Eliminar proyecto
  Future<void> eliminarProyecto(int idproyecto) async {
    try {
      await _supabase.from('proyectos').delete().eq('idproyecto', idproyecto);
    } catch (e) {
      print('❌ Error al eliminar proyecto: $e');
      throw Exception('Error al eliminar proyecto');
    }
  }

  // Método adicional para cambiar estado
  Future<void> cambiarEstadoProyecto(int idproyecto, String nuevoestado) async {
    try {
      await _supabase
          .from('proyectos')
          .update({'estado': nuevoestado})
          .eq('idproyecto', idproyecto);
    } catch (e) {
      print('❌ Error al cambiar estado: $e');
      throw Exception('Error al cambiar estado del proyecto');
    }
  }

  Future<void> eliminarProyectoLogic(int idProyecto) async {
    try {
      await _supabase
          .from('proyectos')
          .update({
            'activo': false, // Set 'activo' to false for logical deletion
            'fechaeliminacion':
                DateTime.now().toIso8601String(), // Record deletion date
          })
          .eq('idproyecto', idProyecto);
      print('Empresa eliminada lógicamente exitosamente!');
    } catch (e) {
      print('Error al eliminar lógicamente la empresa: $e');
      throw Exception('Error al eliminar la empresa: $e');
    }
  }

  static Future<List<Map<String, dynamic>>>
  obtenerEmpresasParaDropdown() async {
    try {
      final response = await _supabase
          .from('empresas')
          .select('idempresa, nombre') // Selecciona el ID y el nombre
          .eq('activo', true) // Filtra solo las empresas activas
          .order('nombre', ascending: true); // Ordena por nombre

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error al obtener empresas para el dropdown: $e');
      throw Exception('Error al cargar empresas para el dropdown: $e');
    }
  }

//Eliminacion logica infoproyecto
Future<void> eliminarProyectoinfoLogic(int idproyecto) async {
    try {
      await _supabase
          .from('proyectos')
          .update({
            'Abierto': false, // Set 'activo' to false for logical deletion
            'fechaeliminacion':
                DateTime.now().toIso8601String(), // Record deletion date
          })
          .eq('idproyecyo', idproyecto);
      print('Proyecto eliminado lógicamente exitosamente!');
    } catch (e) {
      print('Error al eliminar lógicamente el proyecto: $e');
      throw Exception('Error al eliminar el proyecto: $e');
    }
  }

}


