import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:banco_de_proyectos/classes/proyecto.dart';

class ContactoServiceProyecto {
    static Future<List<Proyecto>> obtenerProyectosConFiltros({
    String filtro = '',
    List<String>? estados,
    List<String>? modalidades,
    List<String>? periodos,
  }) async {
    final response = await Supabase.instance.client.from('proyectos').select();
    final data = List<Map<String, dynamic>>.from(response);

    final queryLower = filtro.toLowerCase();

    List<Map<String, dynamic>> filtered = data.where((proyecto) {
      final nombre = proyecto['nombreProyecto']?.toLowerCase() ?? '';
      final carreras = proyecto['carreras']?.toLowerCase() ?? '';
      final modalidad = proyecto['modalidad'] ?? '';
      final estado = proyecto['estado'] ?? '';
      final periodo = proyecto['periodo'] ?? '';

      bool matchesFiltro = filtro.isEmpty ||
          nombre.contains(queryLower) ||
          carreras.contains(queryLower);

      bool matchesEstado = estados == null || estados.isEmpty || estados.contains(estado);
      bool matchesModalidad = modalidades == null || modalidades.isEmpty || modalidades.contains(modalidad);
      bool matchesPeriodo = periodos == null || periodos.isEmpty || periodos.contains(periodo);

      return matchesFiltro && matchesEstado && matchesModalidad && matchesPeriodo;
    }).toList();

    return filtered.map((map) => Proyecto.fromMap(map)).toList();
  }
}
