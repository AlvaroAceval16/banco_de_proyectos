import 'package:banco_de_proyectos/pages/Dashboard_page.dart';
import 'package:banco_de_proyectos/pages/form_contacto-empresa.dart';
import 'package:banco_de_proyectos/pages/form_empresa.dart';
import 'package:banco_de_proyectos/pages/form_proyecto.dart';
import 'package:banco_de_proyectos/pages/info_contacto-empresa.dart';
import 'package:banco_de_proyectos/pages/login_page.dart';
import 'package:banco_de_proyectos/pages/vista_contactos-empresa.dart';
import 'package:banco_de_proyectos/pages/vista_empresas.dart';
import 'package:banco_de_proyectos/pages/vista_proyectos.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
        cardColor: Colors.grey[100],
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFFFFFFF),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      routes: {
        '/dashboard': (context) => DashboardScreen(),
        '/form_empresa': (context) => FormularioEmpresa(),
        '/form_proyecto': (context) => FormularioProyecto(),
        '/form_contacto_empresa': (context) => FormularioContactoEmpresa(),
        '/info_contacto_empresa': (context) => InfoContactoEmpresa(),
        '/vista_proyectos': (context) => ResumenProyectosPage(),
        '/vista_empresas': (context) => ResumenEmpresasPage(),
        '/vista_contacto_empresa': (context) => ResumenContactoEmpresaPage(),
        '/login': (context) => LoginPage(),
      },
      title: 'Material App',
      home: LoginPage(),
    );
  }
}
