import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<Map<String, dynamic>?> obtenerContactoEmpresaPorId(String contactoId) async {
  try {
    final response = await supabase
        .from('contacto_empresa')//Nombre de la tabla
        .select(''' //Nombre de los datos 
          nombre_contacto,
          comentarios,
          telefono,
          correo,
          vinculo,
          hora_inicio,
          hora_fin,
          empresa (
            nombre,
            descripcion
          )
        ''')
        .eq('idContacto', contactoId)//se obtiene el id
        .single();

    return response;
  } catch (e) {
    print('Error al obtener contacto_empresa: $e');
    return null;
  }
}
/* Metodo para obtener los datos
void cargarDatosContacto() async {
  final data = await obtenerContactoEmpresaPorId('id-del-contacto');

  if (data != null) {
    setState(() {
      nombre = data['nombre_contacto'];
      comentarios = data['comentarios'];
      telefono = data['telefono'];
      correo = data['correo'];
      empresaNombre = data['empresa']['nombre'];
      empresaDescripcion = data['empresa']['descripcion'];
      vinculo = data['vinculo'];
      horaInicio = data['hora_inicio'];
      horaFin = data['hora_fin'];
    });
  }
}
*/