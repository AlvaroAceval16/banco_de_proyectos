import 'package:flutter/material.dart';
import 'package:banco_de_proyectos/classes/proyecto.dart';

class InfoProyecto extends StatelessWidget {
  final Proyecto proyecto;

  const InfoProyecto({Key? key, required this.proyecto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF052659),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para editar
        },
        backgroundColor: Color(0xFF5285E8),
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
                        proyecto.titulo,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        proyecto.descripcion,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoItem("Modalidad", proyecto.modalidad),
                          _infoItem("Carrera", proyecto.carreras),
                          _infoItem("Periodo", proyecto.periodo),
                          _infoItem("Fecha de solicitud", proyecto.fechaSolicitud),
                          _infoItem("Apoyo económico", proyecto.apoyoEconomico),
                          _infoItem("Plazos de entrega", proyecto.plazosEntrega),
                        ],
                      ),
                    ],
                  ),
                ),
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
                      SizedBox(height: 25),
                      InfoCard(
                        label: "Empresa",
                        title: proyecto.idEmpresa,
                        subtitle: proyecto.descripcionEmpresa,
                        icon: Icons.business,
                      ),
                      SizedBox(height: 20),
                      InfoCard(
                        label: "Tecnologías utilizadas",
                        title: "Tecnologías utilizadas",
                        subtitle: proyecto.tecnologias,
                        icon: Icons.code,
                      ),
                      SizedBox(height: 20),
                      InfoCard(
                        label: "Residente",
                        title: proyecto.residente,
                        subtitle: "Número de control: ${proyecto.noControlResidente}",
                        icon: Icons.person,
                      ),
                      SizedBox(height: 20),
                      InfoCard(
                        label: "Asesor",
                        title: proyecto.asesor,
                        subtitle: "Número de control: ${proyecto.noControlAsesor}",
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

  Widget _infoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 150,
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
        Text(label, style: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        Card(
          elevation: 0,
          color: Theme.of(context).cardColor,
          child: ListTile(
            title: Text(
              title,
              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
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
}