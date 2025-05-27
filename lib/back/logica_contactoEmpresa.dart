import 'package:supabase_flutter/supabase_flutter.dart';

/*final supabase = Supabase.instance.client;

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
*/
class ContactoService {
  final _supabase = Supabase.instance.client;

  // Crear nuevo contacto
  Future<void> createContacto({
    required int idEmpresa,
    required String nombre,
    required String apellidoPaterno,
    required String apellidoMaterno,
    required String telefono,
    required String correo,
    required String puesto,
    required String horarioAtencion,
    required String comentarios,
  }) async {
    try {
      await _supabase.from('contactoEmpresa').insert({
        'idEmpresa': idEmpresa,
        'nombre': nombre,
        'apellidoPaterno': apellidoPaterno,
        'apellidoMaterno': apellidoMaterno,
        'telefono': telefono,
        'correo': correo,
        'puesto': puesto,
        'horarioAtencion': horarioAtencion,
        'comentarios': comentarios,
      });
    } catch (e) {
      throw Exception('Error al crear contacto: ${e.toString()}');
    }
  }

  // Obtener contactos por empresa
  Future<List<Map<String, dynamic>>> getContactosByEmpresa(int idEmpresa) async {
    try {
      return await _supabase
          .from('contactoEmpresa')
          .select()
          .eq('idEmpresa', idEmpresa)
          .order('nombre', ascending: true);
    } catch (e) {
      throw Exception('Error al obtener contactos: ${e.toString()}');
    }
  }

  // Obtener contacto por ID
  Future<Map<String, dynamic>> getContactoById(int idContacto) async {
    try {
      return await _supabase
          .from('contactoEmpresa')
          .select('*, empresa:empresas(nombre, descripcion)')
          .eq('idContacto', idContacto)
          .single();
    } catch (e) {
      throw Exception('Error al obtener contacto: ${e.toString()}');
    }
  }
}
