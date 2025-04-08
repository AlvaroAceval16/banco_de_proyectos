import 'package:banco_de_proyectos/pages/Dashboard_page.dart';
import 'package:banco_de_proyectos/pages/form_empresa.dart';
import 'package:banco_de_proyectos/pages/form_proyecto.dart';
import 'package:banco_de_proyectos/pages/info_contacto-empresa.dart';
//import 'package:banco_de_proyectos/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      title: 'Material App',
      home: DashboardScreen(),
    );
  }
}
