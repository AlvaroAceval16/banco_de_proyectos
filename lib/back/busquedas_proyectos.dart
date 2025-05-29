import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:banco_de_proyectos/classes/proyecto.dart';

class ContactoServiceProyecto {
  static Future<List<Proyecto>> obtenerProyectosConFiltros({
    String filtro = '',
    List<String>? estados,
    List<String>? modalidades,
    List<String>? periodos,
  }) async {
    PostgrestFilterBuilder query = Supabase.instance.client.from('proyectos').select();

    if (filtro.isNotEmpty) {
    
      query = query.or(
        'nombreproyecto.ilike.%$filtro%,descripcion.ilike.%$filtro%,carreras.ilike.%$filtro%',
      ); 
    }
    if (estados != null && estados.isNotEmpty) {
      query = query.filter('estado', 'in', estados);
    }

    if (modalidades != null && modalidades.isNotEmpty) {
      query = query.filter('modalidad', 'in', modalidades);
    }

    if (periodos != null && periodos.isNotEmpty) {
      query = query.filter('periodo', 'in', periodos);
    }

    try {
      final response = await query;
      final data = List<Map<String, dynamic>>.from(response);

      return data.map((map) => Proyecto.fromMap(map)).toList();
    } catch (e) {
      print('Error al obtener proyectos con filtros desde Supabase: $e');
      throw Exception('Failed to load projects: $e');
    }
  }
}