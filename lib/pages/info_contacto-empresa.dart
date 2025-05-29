import 'package:banco_de_proyectos/back/logica_contactoEmpresa.dart';
import 'package:banco_de_proyectos/classes/contacto_empresa.dart';
import 'package:flutter/material.dart';

class InfoContactoEmpresaApp extends StatelessWidget {

  final ContactoEmpresa contacto;

  const InfoContactoEmpresaApp({Key? key, required this.contacto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InfoContactoEmpresa(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class InfoContactoEmpresa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF002A5C),   
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para editar
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.edit, color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Parte azul superior
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF002A5C), // azul oscuro
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white),
                      SizedBox(height: 20),
                      Text(
                        "Nombre del Empresario",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Comentarios o notas adicionales sobre el empresario.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Correo",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Teléfono",
                        style: TextStyle(color: Colors.white70, fontFamily: 'Poppins'),
                      ),
                      Text(
                        "618-299-16-65",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Correo",
                        style: TextStyle(color: Colors.white70, fontFamily: 'Poppins'),
                      ),
                      Text(
                        "correo@empresarial.com",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),

                // Parte blanca inferior
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Información Adicional",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text("Empresa", style: _labelStyle()),
                      SizedBox(height: 8),
                      _infoBox("Empresa A", "Descripción pequeña"),
                      SizedBox(height: 20),
                      Text("Vínculo con la empresa", style: _labelStyle()),
                      SizedBox(height: 8),
                      _infoBox("Vicepresidente"),
                      SizedBox(height: 20),
                      Text("Horario de atención", style: _labelStyle()),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _timeDropdown("00"),
                          _timeDropdown("00"),
                          Text("a", style: TextStyle(fontFamily: 'Poppins')),
                          _timeDropdown("00"),
                          _timeDropdown("00"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _labelStyle() {
    return TextStyle(
      fontSize: 14,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    );
  }

  Widget _infoBox(String title, [String? subtitle]) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              )),
          if (subtitle != null)
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
        ],
      ),
    );
  }

  Widget _timeDropdown(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: value,
        underline: SizedBox(),
        icon: Icon(Icons.keyboard_arrow_down),
        items: List.generate(24, (index) => index.toString().padLeft(2, '0')).map((val) {
          return DropdownMenuItem(
            value: val,
            child: Text(val),
          );
        }).toList(),
        onChanged: (_) {},
      ),
    );
  }
}