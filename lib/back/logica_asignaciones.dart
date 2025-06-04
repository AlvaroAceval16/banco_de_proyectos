// lib/back/logica_asignaciones.dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// lib/back/logica_asignaciones.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:banco_de_proyectos/back/logica_proyectos.dart'; // Asegúrate de importar tu ProyectoService

class AsignacionService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ProyectoService _proyectoService = ProyectoService(); // Instancia de ProyectoService

  String _mapAsignacionEstadoToProyectoEstado(String asignacionEstado) {
    switch (asignacionEstado) {
      case 'En curso':
        return 'En curso';
      case 'Finalizado':
        return 'Concluido';
      default:
        return 'Abierto'; 
    }
  }

  // CREATE - Crear una nueva asignación
  Future<Map<String, dynamic>?> crearAsignacion({
    required BuildContext context,
    required int idProyecto,
    required int idEstudiante,
    required int idTutor,
    String? fechaAsignacion,
    String? fechaFinalizacion,
    required String estado,
  }) async {
    try {
      final asignacionesMismoProyecto = await _supabase
          .from('asignaciones')
          .select()
          .eq('idproyecto', idProyecto)
          .eq('idestudiante', idEstudiante);

      if (asignacionesMismoProyecto.isNotEmpty) {
        return {
          'error': 'Este estudiante ya tiene asignado este proyecto.'
        };
      }

      final asignacionesNoFinalizadas = await _supabase
          .from('asignaciones')
          .select()
          .eq('idestudiante', idEstudiante)
          .neq('estado', 'finalizado');

      bool hayAdvertencia = asignacionesNoFinalizadas.isNotEmpty;

      final response = await _supabase
          .from('asignaciones')
          .insert({
            'idproyecto': idProyecto,
            'idestudiante': idEstudiante,
            'idtutor': idTutor,
            if (fechaAsignacion != null && fechaAsignacion.isNotEmpty)
              'fechaasignacion': fechaAsignacion,
            if (fechaFinalizacion != null && fechaFinalizacion.isNotEmpty)
              'fechafinalizacion': fechaFinalizacion,
            'estado': estado,
          })
          .select()
          .single();

      final newEstadoProyecto = _mapAsignacionEstadoToProyectoEstado(estado);
      await _proyectoService.actualizarEstadoProyecto(idProyecto, newEstadoProyecto);

      return {
        'data': response,
        if (hayAdvertencia)
          'advertencia': 'Este estudiante ya tiene un proyecto asignado que no ha finalizado.',
      };
    } catch (e) {
      return {
        'error': '❌ Error al crear asignación: ${e.toString()}'
      };
    }
  }

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

      if (newData.containsKey('estado')) {
        
        final asignacionExistente = await obtenerAsignacionPorId(idAsignacion);
        if (asignacionExistente != null && asignacionExistente.containsKey('idproyecto')) {
          final int idProyecto = asignacionExistente['idproyecto'];
          final String newAsignacionEstado = newData['estado'] as String;
          final newProyectoEstado = _mapAsignacionEstadoToProyectoEstado(newAsignacionEstado);

          await _proyectoService.actualizarEstadoProyecto(
            idProyecto,
            newProyectoEstado,
          );
          print('Estado del proyecto $idProyecto actualizado a: $newProyectoEstado');
        } else {
          print('Advertencia: No se pudo encontrar el idProyecto para la asignación $idAsignacion o el estado no está en newData.');
        }
      }

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

  static Future<List<Map<String, dynamic>>> obtenerProyectosParaDropdown() async {
    try {
      final response = await Supabase.instance.client
          .from('proyectos')
          .select('idproyecto, nombreproyecto')
          .eq('activo', true)
          .order('nombreproyecto', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      print('❌ Error de PostgREST al obtener proyectos para dropdown: ${e.message}');
      throw Exception('Error al cargar proyectos para el dropdown: ${e.message}');
    } catch (e) {
      print('❌ Error inesperado al obtener proyectos para dropdown: $e');
      throw Exception('Error al cargar proyectos para el dropdown: ${e.toString()}');
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerEstudiantesParaDropdown() async {
    try {
      final response = await Supabase.instance.client
          .from('estudiantes')
          .select('idestudiante, nombre')
          .eq('activo', true)
          .order('nombre', ascending: true);
      return response
          .map(
            (e) => {
              'idestudiante': e['idestudiante'],
              'nombre': '${e['nombre']}',
            },
          )
          .toList();
    } on PostgrestException catch (e) {
      print('❌ Error de PostgREST al obtener estudiantes para dropdown: ${e.message}');
      throw Exception('Error al cargar estudiantes para el dropdown: ${e.message}');
    } catch (e) {
      print('❌ Error inesperado al obtener estudiantes para dropdown: $e');
      throw Exception('Error al cargar estudiantes para el dropdown: ${e.toString()}');
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerTutoresParaDropdown() async {
    try {
      final response = await Supabase.instance.client
          .from('tutoracademico')
          .select('idtutor, nombre, apellidopaterno')
          .eq('activo', true)
          .order('apellidopaterno', ascending: true);
      return response
          .map(
            (e) => {
              'idtutor': e['idtutor'],
              'nombre': '${e['nombre']} ${e['apellidopaterno']}',
            },
          )
          .toList();
    } on PostgrestException catch (e) {
      print('❌ Error de PostgREST al obtener tutores para dropdown: ${e.message}');
      throw Exception('Error de base de datos al obtener tutores: ${e.message}');
    } catch (e) {
      print('❌ Error inesperado al obtener tutores para dropdown: $e');
      throw Exception('Error al cargar tutores: ${e.toString()}');
    }
  }
}