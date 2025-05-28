import 'package:supabase_flutter/supabase_flutter.dart';

class EmpresaService {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> guardarEmpresa({
    required String nombre,
    required String descripcion,
    required String? sector,
    required String giro,
    required String? tamano,
    required String rfc,
    required String cp,
    required String pais,
    required String ciudad,
    required String estado,
    required String direccion,
    required String telefono,
    required String fecha_registro,
    bool convenio = true,
  }) async {
    try {
      if (sector == null || tamano == null) {
        throw Exception(
          'Todos los campos select deben tener un valor seleccionado',
        );
      }

      final response =
          await _supabase
              .from('empresas')
              .insert({
                'nombre': nombre,
                'descripcion': descripcion,
                'sector': sector,
                'giro': giro,
                'tamano': tamano,
                'rfc': rfc,
                'cp': cp,
                'pais': pais,
                'ciudad': ciudad,
                'estado': estado,
                'direccion': direccion,
                'telefono': telefono,
                'fecha_registro': fecha_registro,
                'convenio': convenio,
              })
              .select()
              .single();

      return response;
    } catch (e) {
      print('❌ Error al guardar empresa: $e');
      throw Exception('Error al guardar empresa: ${e.toString()}');
    }
  }
}
