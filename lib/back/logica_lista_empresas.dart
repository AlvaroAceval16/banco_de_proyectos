import 'package:supabase_flutter/supabase_flutter.dart';

class LogicaListaEmpresas {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Obtener todas las empresas
  Future<List<Map<String, dynamic>>> obtenerEmpresas() async {
    try {
      final response = await _supabase
          .from('empresas')
          .select('*')
          .eq('activo', true) // Solo empresas activas
          .order('nombre', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error al cargar empresas: $e');
    }
  }

  // Filtrar empresas por tamaño
  Future<List<Map<String, dynamic>>> filtrarEmpresas(
    List<String> tamanos,
  ) async {
    try {
      final response = await _supabase
          .from('empresas')
          .select('*')
          .inFilter('tamano', tamanos);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error al filtrar empresas: $e');
    }
  }
}
