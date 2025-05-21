import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<Map<String, dynamic>?> obtenerProyectoPorId(String proyectoId) async {
  try {
    final response = await supabase
        .from('proyectos')
        .select('''
          nombre,
          descripcion,
          modalidad,
          carrera,
          periodo,
          fecha_solicitud,
          apoyo_economico,
          plazos_entrega,
          tecnologias_utilizadas,
          empresa (
            nombre,
            descripcion
          ),
          asesor (
            nombre
          ),
          residente (
            nombre
          )
        ''')
        .eq('idProyecto', proyectoId)
        .single();

    return response;
  } catch (e) {
    print('❌ Error al obtener proyecto: $e');
    return null;
  }
}
/*
void cargarDatosProyecto() async {
  final data = await obtenerProyectoPorId('id-del-proyecto');

  if (data != null) {
    setState(() {
      titulo = data['titulo'];
      descripcion = data['descripcion'];
      modalidad = data['modalidad'];
      carrera = data['carrera'];
      periodo = data['periodo'];
      fechaSolicitud = data['fecha_solicitud'];
      apoyoEconomico = data['apoyo_economico'];
      plazosEntrega = data['plazos_entrega'];
      tecnologias = data['tecnologias_utilizadas'];
      empresaNombre = data['empresa']['nombre'];
      empresaDescripcion = data['empresa']['descripcion'];
      asesorNombre = data['asesor']['nombre'];
      residenteNombre = data['residente']['nombre'];
    });
  }
}
*/