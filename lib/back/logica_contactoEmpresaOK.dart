import 'package:supabase_flutter/supabase_flutter.dart';

class LogicaContactoEmpresa {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> obtenerDetallesContacto(
    int idContacto,
    int idEmpresa,
  ) async {
    try {
      // Corrected line: Removed the explicit type argument <Map<String, dynamic>?> from select()
      final response =
          await _supabase
              .from('contactoempresa')
              .select('''
            *,
            empresas!idempresa (nombre, descripcion)
          ''')
              .eq('idcontacto', idContacto)
              .eq('idempresa', idEmpresa)
              .maybeSingle();

      // Supabase's .select() now returns dynamic or a specific type if you provide it in the .from()
      // We can cast the result if needed or handle it as dynamic.
      // For .maybeSingle(), it will return a Map<String, dynamic> or null.
      return response;
    } on PostgrestException catch (e) {
      print('❌ Error de PostgREST al obtener contacto: ${e.message}');
      throw Exception('Error de base de datos: ${e.message}');
    } catch (e) {
      print('❌ Error inesperado al obtener contacto: $e');
      throw Exception('Error al cargar la información del contacto.');
    }
  }

  Future<void> actualizarContacto(
    int idContacto,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      await _supabase
          .from('contactoempresa')
          .update(updatedData)
          .eq('idcontacto', idContacto);
    } on PostgrestException catch (e) {
      print('❌ Error de PostgREST al actualizar contacto: ${e.message}');
      throw Exception('Error de base de datos al actualizar: ${e.message}');
    } catch (e) {
      print('❌ Error inesperado al actualizar contacto: $e');
      throw Exception('Error al guardar los cambios del contacto.');
    }
  }

  Future<void> eliminarContactoLogic(int idContacto) async {
    try {
      await _supabase
          .from('contactoempresa')
          .update({'activo': false})
          .eq('idcontacto', idContacto);
    } on PostgrestException catch (e) {
      print(
        '❌ Error de PostgREST al eliminar contacto lógicamente: ${e.message}',
      );
      throw Exception('Error de base de datos al eliminar: ${e.message}');
    } catch (e) {
      print('❌ Error inesperado al eliminar contacto lógicamente: $e');
      throw Exception('Error al eliminar el contacto.');
    }
  }
}
