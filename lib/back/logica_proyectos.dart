import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:banco_de_proyectos/classes/proyecto.dart';

class ProyectoService {
  static final _supabase = Supabase.instance.client;
  //Dashboard
  //Concluidos
   static Future<int> getFinishedProjectsCountBasedOnStatus() async {
    try {
      final response = await _supabase
          .from('proyectos')
          .select('idproyecto') // Solo necesitamos una columna para el conteo
          .eq('activo', true) // Aseguramos que solo contamos proyectos activos
          .eq('estado', 'Concluido'); // Filtramos por el estado "concluido"
      return response.length;
    } catch (e) {
      print('❌ Error al obtener el conteo de proyectos finalizados por estado: $e');
      return 0; // Devuelve 0 en caso de error
    }
  }
  //En curso
   static Future<int> getActiveProjectsCountBasedOnStatus() async {
    try {
      final response = await _supabase
          .from('proyectos')
          .select('idproyecto')
          .eq('activo', true)
          .eq('estado', 'Abierto');

      return response.length;
    } catch (e) {
      print('❌ Error al obtener el conteo de proyectos activos por estado: $e');
      return 0;
    }
  }
  //obtener el conteo de proyectos "En capacitacion".
  static Future<int> getReviewProjectsCountBasedOnStatus() async {
    try {
      final response = await _supabase
          .from('proyectos')
          .select('idproyecto')
          .eq('activo', true)
          .eq('estado', 'En curso');

      return response.length;
    } catch (e) {
      print('❌ Error al obtener el conteo de proyectos en revisión por estado: $e');
      return 0;
    }
  }
  //obtener el conteo total de proyectos (activos).
  static Future<int> getTotalProjectsCountBasedOnAll() async {
    try {
      final response = await _supabase
          .from('proyectos')
          .select('idproyecto')
          .eq('activo', true); // Solo cuenta proyectos activos

      return response.length;
    } catch (e) {
      print('❌ Error al obtener el conteo total de proyectos: $e');
      return 0; // Devuelve 0 en caso de error
    }
  }

  
  //Obtener proyectos para vista
  static Future<List<Map<String, dynamic>>> obtenerProyectos() async {
    try {
      final response = await _supabase
          .from('proyectos')
          .select('*')
          .eq('activo', true)
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

  //Dashboard
  Future<List<Proyecto>> getRecentProjects({
    int limit = 3,
    String orderByColumn =
        'fechasolicitud', // Asumiendo que esta columna te indica la fecha de creación/actualización
  }) async {
    try {
      final response = await _supabase
          .from(
            'proyectos',
          ) // Reemplaza 'proyectos' con el nombre real de tu tabla en Supabase
          .select()
          .order(
            orderByColumn,
            ascending: false,
          ) // Ordena de más reciente a más antiguo
          .limit(limit);

      if (response.isEmpty) {
        return [];
      }

      // Supabase devuelve una lista de mapas. Mapeamos cada mapa a una instancia de Proyecto.
      return response.map((json) => Proyecto.fromMap(json)).toList();
    } catch (e) {
      print('Error al obtener proyectos recientes: $e');
      return []; // Devuelve una lista vacía en caso de error
    }
  }

  //Eliminacion logica infoproyecto
  Future<void> eliminarProyectoinfoLogic(int idproyecto) async {
    try {
      await _supabase
          .from('proyectos')
          .update({
            'activo': false, // Set 'activo' to false for logical deletion
            'fechaeliminacion':
                DateTime.now().toIso8601String(), // Record deletion date
          })
          .eq('idproyecto', idproyecto);
      print('Proyecto eliminado lógicamente exitosamente!');
    } catch (e) {
      print('Error al eliminar lógicamente el proyecto: $e');
      throw Exception('Error al eliminar el proyecto: $e');
    }
  }

  static Future<List<Proyecto>> obtenerProyectosConFiltros({
    List<String>? filtrosEstado,
    List<String>? filtrosModalidad,
    List<String>? filtrosPeriodo,
    String? searchTerm,
    String orderByColumn = 'fechasolicitud', // Por defecto
    bool ascending = false, // Por defecto
  }) async {
    try {
      // Inicia la consulta
      var query = _supabase.from('proyectos').select('*');

      // Aplica el filtro 'activo = true' por defecto
      query = query.eq('activo', true);

      // Aplicar filtros de estado
      if (filtrosEstado != null && filtrosEstado.isNotEmpty) {
        query = query.filter('estado', 'in', '(${filtrosEstado.map((e) => "'$e'").join(',')})');
      }

      // Aplicar filtros de modalidad
      if (filtrosModalidad != null && filtrosModalidad.isNotEmpty) {
        query = query.filter('modalidad', 'in', '(${filtrosModalidad.map((e) => "'$e'").join(',')})');
      }

      // Aplicar filtros de periodo
      if (filtrosPeriodo != null && filtrosPeriodo.isNotEmpty) {
        query = query.filter('periodo', 'in', '(${filtrosPeriodo.map((e) => "'$e'").join(',')})');
      }

      // Aplicar término de búsqueda
      if (searchTerm != null && searchTerm.isNotEmpty) {
        // Encadena la condición .or() directamente al query
        query = query.or('nombreproyecto.ilike.%$searchTerm%,descripcion.ilike.%$searchTerm%');
      }

      // Aplicar ordenamiento. El método .order() devuelve un PostgrestTransformBuilder,
      // por eso el encadenamiento directo es crucial para evitar el error de asignación.
      final List<Map<String, dynamic>> response = await query.order(orderByColumn, ascending: ascending);

      if (response.isEmpty) {
        return [];
      }

      // Mapea los resultados a objetos Proyecto
      return response.map((json) => Proyecto.fromMap(json)).toList();
    } catch (e) {
      print('Error al obtener proyectos con filtros: $e');
      throw Exception('Error al cargar proyectos con filtros: $e');
    }
  }
}