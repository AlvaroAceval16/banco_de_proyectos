import 'package:supabase_flutter/supabase_flutter.dart';

class AutenticacionLogin {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return null; 
      } else {
        return 'No se pudo iniciar sesión.';
      }
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Error inesperado: $e';
    }
  }
}

