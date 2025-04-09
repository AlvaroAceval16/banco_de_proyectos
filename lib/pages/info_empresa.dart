import 'package:flutter/material.dart';

class InfoEmpresa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF002A5C),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para editar
        },
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    color: Color(0xFF002A5C),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white),
                      SizedBox(height: 20),
                      Text(
                        "Nombre de la empresa",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Descripción de la empresa, aquí va toda la descripción de la empresa.",
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
                          _infoItem("Sector o industria", "Tecnología"),
                          _infoItem(
                            "Giro de la empresa",
                            "Comercialización de software",
                          ),
                          _infoItem("Tamaño de la empresa", "Mediana"),
                          _infoItem("RFC", "ABC123456789"),
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
                        "Proyectos",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      // Sección Proyectos
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 10,
                          children: [
                            _projectBox(
                              "Proyecto 1",
                              "Descripción del proyecto 1",
                            ),
                            _projectBox(
                              "Proyecto 2",
                              "Descripción del proyecto 2",
                            ),
                            _projectBox(
                              "Proyecto 3",
                              "Descripción del proyecto 3",
                            ),
                            _projectBox(
                              "Proyecto 4",
                              "Descripción del proyecto 4",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Sección Empresa
                      Text(
                        "Ubicacion",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      InfoCard(
                        label: "Código postal",
                        title: "Código postal",
                        subtitle: "12345",
                        icon: Icons.location_on_outlined,
                      ),
                      SizedBox(height: 10),
                      // Sección Tecnologías
                      InfoCard(
                        label: "Estado",
                        title: "Estado donde se encuentra la empresa",
                        subtitle: "Durango",
                        icon: Icons.location_on_outlined,
                      ),
                      SizedBox(height: 10),
                      InfoCard(
                        label: "Ciudad",
                        title: "Ciudad donde se encuentra la empresa",
                        subtitle: "Durango",
                        icon: Icons.location_on_outlined,
                      ),
                      SizedBox(height: 10),
                      InfoCard(
                        label: "Dirección",
                        title: "Direccion",
                        subtitle: "Dirección de la emopresa",
                        icon: Icons.location_on_outlined,
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
                color: Color.fromARGB(255, 246, 247, 248),
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
        color: const Color.fromARGB(255, 246, 247, 248),
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

  Widget _projectBox(String title, String description) {
    return Container(
      width: 200, // Ancho de cada caja
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(
          255,
          246,
          247,
          248,
        ), // Color de fondo de la caja
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: const Color.fromARGB(179, 1, 1, 1),
              fontSize: 12,
              fontFamily: 'Poppins',
            ),
          ),
        ],
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
              style: TextStyle(
                fontFamily: 'Poppins',
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
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