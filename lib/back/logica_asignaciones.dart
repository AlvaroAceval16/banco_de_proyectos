// lib/back/logica_asignaciones.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AsignacionService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // CREATE - Crear una nueva asignación
  Future<Map<String, dynamic>> crearAsignacion({
    required int idProyecto,
    required int idEstudiante,
    required int idTutor,
    String? fechaAsignacion, // Formato 'YYYY-MM-DD'
    String? fechaFinalizacion, // Formato 'YYYY-MM-DD', opcional
    required String estado, // 'En curso' o 'Finalizado'
  }) async {
    try {
      final response =
          await _supabase
              .from('asignaciones')
              .insert({
                'idproyecto': idProyecto,
                'idestudiante': idEstudiante,
                'idtutor': idTutor,
                // Si fechaAsignacion es null, la DB usará CURRENT_DATE por defecto
                if (fechaAsignacion != null && fechaAsignacion.isNotEmpty)
                  'fechaasignacion': fechaAsignacion,
                if (fechaFinalizacion != null && fechaFinalizacion.isNotEmpty)
                  'fechafinalizacion': fechaFinalizacion,
                'estado': estado,
              })
              .select()
              .single(); // Retorna la asignación creada

      print('Asignación creada exitosamente: $response');
      return response;
    } on PostgrestException catch (e) {
      print('❌ Error de PostgREST al crear asignación: ${e.message}');
      throw Exception(
        'Error de base de datos al crear asignación: ${e.message}',
      );
    } catch (e) {
      print('❌ Error inesperado al crear asignación: $e');
      throw Exception('Error al crear asignación: ${e.toString()}');
    }
  }

  // READ - Obtener una asignación por su ID (para edición)
  Future<Map<String, dynamic>?> obtenerAsignacionPorId(int idAsignacion) async {
    try {
      final response =
          await _supabase
              .from('asignaciones')
              .select('''
        idasignacion, idproyecto, idestudiante, idtutor,
        fechaasignacion, fechafinalizacion, estado
      ''')
              .eq('idasignacion', idAsignacion)
              .maybeSingle();

      return response;
    } on PostgrestException catch (e) {
      print('❌ Error de PostgREST al obtener asignación por ID: ${e.message}');
      throw Exception(
        'Error de base de datos al obtener asignación: ${e.message}',
      );
    } catch (e) {
      print('❌ Error inesperado al obtener asignación por ID: $e');
      throw Exception('Error al obtener asignación: ${e.toString()}');
    }
  }

  // UPDATE - Actualizar una asignación existente
  Future<void> actualizarAsignacion(
    int idAsignacion,
    Map<String, dynamic> newData,
  ) async {
    try {
      await _supabase
          .from('asignaciones')
          .update(newData)
          .eq('idasignacion', idAsignacion);
      print('Asignación actualizada exitosamente!');
    } on PostgrestException catch (e) {
      print('❌ Error de PostgREST al actualizar asignación: ${e.message}');
      throw Exception(
        'Error de base de datos al actualizar asignación: ${e.message}',
      );
    } catch (e) {
      print('❌ Error inesperado al actualizar asignación: $e');
      throw Exception('Error al actualizar asignación: ${e.toString()}');
    }
  }

  // DELETE - Eliminar una asignación (físicamente de la base de datos)
  Future<void> eliminarAsignacion(int idAsignacion) async {
    try {
      await _supabase
          .from('asignaciones')
          .delete()
          .eq('idasignacion', idAsignacion);
      print('Asignación eliminada exitosamente!');
    } on PostgrestException catch (e) {
      print('❌ Error de PostgREST al eliminar asignación: ${e.message}');
      throw Exception(
        'Error de base de datos al eliminar asignación: ${e.message}',
      );
    } catch (e) {
      print('❌ Error inesperado al eliminar asignación: $e');
      throw Exception('Error al eliminar asignación: ${e.toString()}');
    }
  }

  // --- Métodos para obtener datos para Dropdowns ---

  // Obtener proyectos para el dropdown
  static Future<List<Map<String, dynamic>>>
  obtenerProyectosParaDropdown() async {
    try {
      final response = await Supabase.instance.client
          .from('proyectos')
          .select(
            'idproyecto, nombreproyecto',
          ) // Asegúrate de que los nombres de las columnas sean correctos
          .eq('activo', true) // Solo proyectos activos
          .order('nombreproyecto', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      print(
        '❌ Error de PostgREST al obtener proyectos para dropdown: ${e.message}',
      );
      throw Exception(
        'Error al cargar proyectos para el dropdown: ${e.message}',
      );
    } catch (e) {
      print('❌ Error inesperado al obtener proyectos para dropdown: $e');
      throw Exception(
        'Error al cargar proyectos para el dropdown: ${e.toString()}',
      );
    }
  }

  // Obtener estudiantes para el dropdown
  static Future<List<Map<String, dynamic>>>
  obtenerEstudiantesParaDropdown() async {
    try {
      final response = await Supabase.instance.client
          .from('estudiantes') // Nombre de tu tabla de estudiantes
          .select(
            'idestudiante, nombre',
          ) // Asegúrate de los nombres de las columnas
          .eq('activo', true) // Solo estudiantes activos
          .order('nombre', ascending: true);

      // Combina nombre y apellido para el display
      return response
          .map(
            (e) => {
              'idestudiante': e['idestudiante'],
              'nombre': '${e['nombre']}',
            },
          )
          .toList();
    } on PostgrestException catch (e) {
      print(
        '❌ Error de PostgREST al obtener estudiantes para dropdown: ${e.message}',
      );
      throw Exception(
        'Error al cargar estudiantes para el dropdown: ${e.message}',
      );
    } catch (e) {
      print('❌ Error inesperado al obtener estudiantes para dropdown: $e');
      throw Exception(
        'Error al cargar estudiantes para el dropdown: ${e.toString()}',
      );
    }
  }

  // Obtener tutores para el dropdown
  static Future<List<Map<String, dynamic>>> obtenerTutoresParaDropdown() async {
    try {
      final response = await Supabase.instance.client
          .from('tutoracademico') // Nombre de tu tabla de tutores
          .select(
            'idtutor, nombre, apellidopaterno',
          ) // Asegúrate de los nombres de las columnas
          .eq('activo', true) // Solo tutores activos
          .order('apellidopaterno', ascending: true);

      // Combina nombre y apellido para el display
      return response
          .map(
            (e) => {
              'idtutor': e['idtutor'],
              'nombre': '${e['nombre']} ${e['apellidopaterno']}',
            },
          )
          .toList();
    } on PostgrestException catch (e) {
      print(
        '❌ Error de PostgREST al obtener tutores para dropdown: ${e.message}',
      );
      throw Exception(
        'Error de base de datos al obtener tutores: ${e.message}',
      );
    } catch (e) {
      print('❌ Error inesperado al obtener tutores para dropdown: $e');
      throw Exception('Error al cargar tutores: ${e.toString()}');
    }
  }
}
