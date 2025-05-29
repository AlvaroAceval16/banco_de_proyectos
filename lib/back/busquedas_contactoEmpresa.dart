import 'package:supabase_flutter/supabase_flutter.dart';

class ContactoServiceEmpresa {
  static Future<List<Map<String, dynamic>>> obtenerContactos({String filtro = ''}) async {
    final response = await Supabase.instance.client
        .from('contactoempresa')
        .select();

    final data = List<Map<String, dynamic>>.from(response);

    if (filtro.isEmpty) return data;

    final queryLower = filtro.toLowerCase();

    return data.where((contacto) {
      final nombreCompleto = '${contacto['nombre']} ${contacto['apellidoPaterno']} ${contacto['apellidoMaterno']}'.toLowerCase();
      final puesto = contacto['puesto'].toLowerCase();
      return nombreCompleto.contains(queryLower) || puesto.contains(queryLower);
    }).toList();
  }
}
