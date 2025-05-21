import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> fetchEmpresas() async {
  try {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('empresas').select();

    print('📦 Datos de la tabla empresa:');
    for (var row in response) {
      print(row);
    }
  } catch (e) {
    print('❌ Error al obtener empresas: $e');
  }
}