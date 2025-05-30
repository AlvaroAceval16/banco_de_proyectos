import 'package:banco_de_proyectos/pages/Dashboard_page.dart';
import 'package:banco_de_proyectos/pages/form_contacto-empresa.dart';
import 'package:banco_de_proyectos/pages/form_empresa.dart';
import 'package:banco_de_proyectos/pages/form_proyecto.dart';
import 'package:banco_de_proyectos/pages/info_contacto-empresa.dart';
import 'package:banco_de_proyectos/pages/info_empresa.dart';
import 'package:banco_de_proyectos/pages/info_proyecto.dart';
import 'package:banco_de_proyectos/pages/login_page.dart';
import 'package:banco_de_proyectos/pages/vista_contactos-empresa.dart';
import 'package:banco_de_proyectos/pages/vista_empresas.dart';
import 'package:banco_de_proyectos/pages/vista_proyectos.dart';
import 'package:banco_de_proyectos/classes/proyecto.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:banco_de_proyectos/classes/contacto_empresa.dart';
import 'package:banco_de_proyectos/pages/form_asignaciones.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://skgmviurmpgpetpqnixa.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNrZ212aXVybXBncGV0cHFuaXhhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQxNjQ3MjYsImV4cCI6MjA1OTc0MDcyNn0.jE0FIU4JW6648b3yDVr3MQzBpP0UMcz4n8Q3dIY2Nqw',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
        cardColor: Colors.grey[100],
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFFFFF),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/dashboard': (context) => DashboardScreen(),
        '/form_empresa': (context) => FormularioEmpresa(),
        '/form_proyecto': (context) => FormularioProyecto(),
        '/form_contacto_empresa': (context) => FormularioContactoEmpresa(),
        '/vista_proyectos': (context) => ResumenProyectosPage(),
        '/vista_empresas': (context) => ResumenEmpresasPage(),
        '/vista_contacto_empresa': (context) => ResumenContactoEmpresaPage(),
        '/login': (context) => LoginPage(),
        '/form_asignaciones': (context) => FormAsignaciones(),
      },
      onGenerateRoute: (settings) {
        final args = settings.arguments;

        if (settings.name == '/info_proyecto') {
          if (args is Proyecto) {
            return MaterialPageRoute(
              builder: (context) => InfoProyecto(proyecto: args),
            );
          }
        }

        if (settings.name == '/info_empresa') {
          if (args is int) {
            return MaterialPageRoute(
              builder: (context) => InfoEmpresa(idEmpresa: args),
            );
          } else {
            return _errorRoute('ID de empresa no válido.');
          }
        }

        if (settings.name == '/info_contacto-empresa') {
          if (args is ContactoEmpresa) {
            return MaterialPageRoute(
              builder: (context) => InfoContactoEmpresa(contacto: args),
            );
          } else {
            return _errorRoute('Objeto ContactoEmpresa no válido.');
          }
        }
        return _errorRoute('Ruta no encontrada');
      },
      title: 'Material App',
      home: LoginPage(),
    );
  }

  MaterialPageRoute _errorRoute(String mensaje) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(body: Center(child: Text('Error: $mensaje'))),
    );
  }
}
