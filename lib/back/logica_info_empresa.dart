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
              .single(); // Use .single() to get a single row or throw an error if not found

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
          .from('proyectos') // Assuming you have a 'proyectos' table
          .select('*')
          .eq(
            'idempresa',
            idEmpresa,
          ) // Assuming 'empresa_id' links projects to companies
          .order('nombreProyecto', ascending: true); // Order by project name

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error al cargar proyectos de la empresa: $e');
      return []; // Return an empty list on error
    }
  }
}
