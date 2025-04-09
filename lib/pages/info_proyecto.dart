import 'package:flutter/material.dart';

class InfoProyecto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF052659),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para editar
        },
        backgroundColor: Color(0xFF052659),
        child: Icon(Icons.edit, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFF052659),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Parte azul superior
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF052659),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.only(bottom: 30, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          _infoItem(
                            "Carrera",
                            "Ingeniería en Sistemas Computacionales",
                          ),
                          _infoItem("Periodo", "AGO 2025 - DIC 2025"),
                          _infoItem(
                            "Fecha de solicitud",
                            "01 de Abril del 2026",
                          ),
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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
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
                      SizedBox(height: 25),
                      // Sección Empresa
                      InfoCard(
                        label: "Empresa",
                        title: "Nombre de la Empresa",
                        subtitle: "Descripción de la empresa, etc.",
                        icon: Icons.business,
                      ),
                      SizedBox(height: 20),
                      // Sección Tecnologías
                      InfoCard(
                        label: "Tecnologías utilizadas",
                        title: "Tecnologías utilizadas",
                        subtitle: "Excel, Java, Python, Flutter, SQL",
                        icon: Icons.code,
                      ),
                      SizedBox(height: 20),
                      // Sección Residente
                      InfoCard(
                        label: "Residente",
                        title: "Nombre del Residente",
                        subtitle: "Número de control: 12345678",
                        icon: Icons.person,
                      ),
                      SizedBox(height: 20),
                      // Sección Asesor
                      InfoCard(
                        label: "Asesor",
                        title: "Nombre del Asesor",
                        subtitle: "Número de control: 87654321",
                        icon: Icons.school,
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
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
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
        items:
            List.generate(24, (index) => index.toString().padLeft(2, '0')).map((
              val,
            ) {
              return DropdownMenuItem(value: val, child: Text(val));
            }).toList(),
        onChanged: (_) {},
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.label,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        SizedBox(height: 8),
        Card(
          elevation: 0,
          color: Theme.of(context).cardColor,
          child: ListTile(
            title: Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(fontFamily: 'Poppins', color: Colors.grey[600]),
            ),
            leading: Icon(icon),
          ),
        ),
      ],
    );
  }

  TextStyle _labelStyle() {
    return TextStyle(
      fontSize: 14,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    );
  }
}
