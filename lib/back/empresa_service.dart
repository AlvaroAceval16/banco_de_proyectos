import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

/*Future<void> fetchEmpresas() async {
  try {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('empresas').select();

    print('📦 Datos de la tabla empresa:');
    for (var row in response) {
      print(row);
    }
  } catch (e) {
    print('❌ Error al obtener empresas: $e');
  }
}*/

class EmpresaService {
  final _supabase = Supabase.instance.client;

  // CREATE - Insertar nueva empresa
  Future<Map<String, dynamic>> insertEmpresa(Map<String, dynamic> empresaData) async {
    try {
      final response = await _supabase
          .from('empresas')
          .insert(empresaData)
          .select()
          .single();
      
      return response;
    } catch (e) {
      print('❌ Error al insertar empresa: $e');
      throw Exception('Error al crear empresa');
    }
  }

  // READ - Obtener empresa por ID
  Future<Map<String, dynamic>?> getEmpresaById(int idEmpresa) async {
    try {
      final response = await _supabase
          .from('empresas')
          .select('''*''')
          .eq('idEmpresa', idEmpresa)
          .single();
      
      return response;
    } catch (e) {
      print('❌ Error al obtener empresa: $e');
      return null;
    }
  }

  // READ - Obtener todas las empresas
  Future<List<Map<String, dynamic>>> getAllEmpresas() async {
    try {
      final response = await _supabase
          .from('empresas')
          .select('''*''')
          .order('nombre', ascending: true);
      
      return response;
    } catch (e) {
      print('❌ Error al obtener empresas: $e');
      return [];
    }
  }

  // UPDATE - Actualizar empresa
  Future<void> updateEmpresa(int idEmpresa, Map<String, dynamic> updates) async {
    try {
      await _supabase
          .from('empresas')
          .update(updates)
          .eq('idEmpresa', idEmpresa);
    } catch (e) {
      print('❌ Error al actualizar empresa: $e');
      throw Exception('Error al actualizar empresa');
    }
  }

  // DELETE - Eliminar empresa
  Future<void> deleteEmpresa(int idEmpresa) async {
    try {
      await _supabase
          .from('empresas')
          .delete()
          .eq('idEmpresa', idEmpresa);
    } catch (e) {
      print('❌ Error al eliminar empresa: $e');
      throw Exception('Error al eliminar empresa');
    }
  }

  // Consulta especial - Empresas con convenio
  Future<List<Map<String, dynamic>>> getEmpresasConConvenio() async {
    try {
      return await _supabase
          .from('empresas')
          .select()
          .eq('convenio', true)
          .order('nombre');
    } catch (e) {
      print('❌ Error al obtener empresas con convenio: $e');
      return [];
    }
  }
}