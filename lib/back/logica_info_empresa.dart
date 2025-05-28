// logica_info_empresa.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class LogicaInfoEmpresa {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> obtenerDetallesEmpresa(int idEmpresa) async {
    try {
      final response =
          await _supabase
              .from('empresas')
              .select('*')
              .eq('idempresa', idEmpresa)
              .single();

      return response;
    } catch (e) {
      print('Error al cargar detalles de la empresa: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> obtenerProyectosEmpresa(
    int idEmpresa,
  ) async {
    try {
      final response = await _supabase
          .from('proyectos')
          .select('*')
          .eq('idempresa', idEmpresa)
          .order('nombreproyecto', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error al cargar proyectos de la empresa: $e');
      return [];
    }
  }

  Future<void> actualizarEmpresa(
    int idEmpresa,
    Map<String, dynamic> newData,
  ) async {
    try {
      await _supabase
          .from('empresas')
          .update(newData)
          .eq('idempresa', idEmpresa);
      print('Empresa actualizada exitosamente!');
    } catch (e) {
      print('Error al actualizar empresa: $e');
      throw Exception('Error al actualizar empresa: $e');
    }
  }

  // New: Method for logical deletion
  Future<void> eliminarEmpresaLogic(int idEmpresa) async {
    try {
      await _supabase
          .from('empresas')
          .update({
            'activo': false, // Set 'activo' to false for logical deletion
            'fechaeliminacion':
                DateTime.now().toIso8601String(), // Record deletion date
          })
          .eq('idempresa', idEmpresa);
      print('Empresa eliminada lógicamente exitosamente!');
    } catch (e) {
      print('Error al eliminar lógicamente la empresa: $e');
      throw Exception('Error al eliminar la empresa: $e');
    }
  }
}
