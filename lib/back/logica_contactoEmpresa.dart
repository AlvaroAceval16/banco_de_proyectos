import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:banco_de_proyectos/classes/contacto_empresa.dart';

class ContactoService {
  static final _supabase = Supabase.instance.client;

  static Future<ContactoEmpresa?> obtenerContacto(int idContacto) async {
    try {
      final response =
          await _supabase
              .from('contactoempresa')
              .select('''
            *,
            empresa:empresas(idempresa, nombre, descripcion) 
          ''')
              .eq('idcontacto', idContacto)
              .single(); // Espera un solo resultado

      if (response != null && response.isNotEmpty) {
        // Mapea el mapa de respuesta de Supabase a tu objeto ContactoEmpresa
        return ContactoEmpresa.fromMap(response);
      }
      return null; // Si no se encuentra el contacto
    } catch (e) {
      print('❌ Error al obtener contacto por ID: $e');
      // Puedes lanzar una excepción o retornar null dependiendo de cómo quieras manejar el error
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getEmpresas() async {
    try {
      final response = await _supabase
          .from('empresas')
          .select('*')
          .eq('activo', true) // Filtra solo empresas activas
          .order('nombre', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error al obtener empresas: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerContactos() async {
    try {
      final response = await _supabase
          .from('contactoempresa')
          .select('*')
          .eq('activo', true) // Filtra solo contactos activos
          .order('nombre', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error al cargar los contactos: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getContactosByEmpresa(
    int idEmpresa,
  ) async {
    try {
      final response = await _supabase
          .from('contactoempresa')
          .select('*')
          .eq('idempresa', idEmpresa)
          .order('nombre', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error al obtener contactos por empresa: $e');
    }
  }

  static Future<Map<String, dynamic>?> getContactoById(int idContacto) async {
    try {
      final response =
          await _supabase
              .from('contactoempresa')
              .select('''
            idcontacto,
            nombre,
            apellidopaterno,
            apellidomaterno,
            telefono,
            correo,
            puesto,
            horarioatencion,
            comentarios,
            idempresa,
            empresa (
              nombre,
              descripcion
            )
          ''')
              .eq('idcontacto', idContacto)
              .single();

      return response;
    } catch (e) {
      print('Error al obtener contacto por ID: $e');
      return null;
    }
  }

  static Future<void> createContacto({
    required String nombre,
    required String apellidopaterno,
    required String apellidomaterno,
    required String telefono,
    required String correo,
    required String puesto,
    required String horaInicio,
    required String horaFin,
    required String comentarios,
    required int idempresa,
  }) async {
    try {
      final String horarioAtencion = '$horaInicio - $horaFin';

      await _supabase.from('contactoempresa').insert({
        'nombre': nombre,
        'apellidopaterno': apellidopaterno,
        'apellidomaterno': apellidomaterno,
        'telefono': telefono,
        'correo': correo,
        'puesto': puesto,
        'horarioatencion': horarioAtencion,
        'comentarios': comentarios,
        'idempresa': idempresa,
      });
    } catch (e) {
      throw Exception('Error al crear contacto: $e');
    }
  }

  static Future<void> updateContacto(
    int idContacto,
    Map<String, dynamic> data,
  ) async {
    try {
      await _supabase
          .from('contactoempresa')
          .update(data)
          .eq('idcontacto', idContacto);
    } catch (e) {
      throw Exception('Error al actualizar contacto: $e');
    }
  }

  static Future<void> deleteContacto(int idContacto) async {
    try {
      await _supabase
          .from('contactoempresa')
          .delete()
          .eq('idcontacto', idContacto);
    } catch (e) {
      throw Exception('Error al eliminar contacto: $e');
    }
  }
}
