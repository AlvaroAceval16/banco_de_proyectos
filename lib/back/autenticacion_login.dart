import 'package:supabase_flutter/supabase_flutter.dart';

class AutenticacionLogin {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> login(String correo, String contrasena) async {
    try {
      final response = await _supabase
          .from('usuarios')
          .select()
          .eq('correo', correo)
          .eq('contrasena', contrasena)
          .maybeSingle(); 

      if (response != null) {
        return null; 
      } else {
        return 'Correo o contraseña incorrectos.';
      }
    } catch (e) {
      return 'Error al intentar iniciar sesión: $e';
    }
  }
}
