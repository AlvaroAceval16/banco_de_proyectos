import 'package:flutter/material.dart';

void main() => runApp(InfoProyectoApp());

class InfoProyectoApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InfoProyecto(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InfoProyecto extends StatelessWidget{
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
                        "Título del Proyecto",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Descripción del proyecto, aquí va toda la descripción del proyect, etc, etc.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 4),
                      
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoItem("Modalidad", "Presencial"),
                          _infoItem("Carrera", "Ingeniería en Sistemas Computacionales"),
                          _infoItem("Periodo", "AGO 2025 - DIC 2025"),
                          _infoItem("Fecha de solicitud", "01 de Abril del 2026"),
                          _infoItem("Apoyo económico", "\$200.00 MXM"),
                          _infoItem("Plazos de entrega", "3 Meses"),
                        ],
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text("Vínculo con la empresa", style: _labelStyle()),
                      SizedBox(height: 8),

                      // Card con ListTile
                      Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 25),

                      // Sección Empresa
                      Text("Empresa", style: _labelStyle()),
                      SizedBox(height: 8),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nombre de la Empresa",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Descripción o información adicional sobre la empresa",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Sección Tecnologías
                      Text("Tecnologías", style: _labelStyle()),
                      SizedBox(height: 8),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildTechChip("Excel"),
                              _buildTechChip("Java"),
                              _buildTechChip("Python"),
                              _buildTechChip("Flutter"),
                              _buildTechChip("SQL"),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Sección Residente
                      Text("Residente", style: _labelStyle()),
                      SizedBox(height: 8),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(
                            "Nombre del Residente",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            "Número de control: 12345678",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.grey[600],
                            ),
                          ),
                          leading: Icon(Icons.person, color: Colors.blue),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Sección Asesor
                      Text("Asesor", style: _labelStyle()),
                      SizedBox(height: 8),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(
                            "Nombre del Asesor",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            "Número de control: 87654321",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.grey[600],
                            ),
                          ),
                          leading: Icon(Icons.school, color: Colors.green),
                        ),
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

Widget _buildTechChip(String techName) {
    return Chip(
      label: Text(techName),
      backgroundColor: Colors.blue[50],
      labelStyle: TextStyle(
        color: Colors.blue[800],
        fontFamily: 'Poppins',
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.blue[100]!),
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


Widget _infoItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 150, // Asegura que las etiquetas tengan un ancho constante
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
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
