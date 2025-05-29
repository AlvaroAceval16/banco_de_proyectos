import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:banco_de_proyectos/classes/proyecto.dart';

class InfoProyecto extends StatefulWidget {
  final Proyecto proyecto;

  const InfoProyecto({Key? key, required this.proyecto}) : super(key: key);

  @override
  State<InfoProyecto> createState() => _InfoProyectoState();
}

class _InfoProyectoState extends State<InfoProyecto> {
  late Future<Map<String, String>> empresaInfo;

  @override
  void initState() {
    super.initState();
    empresaInfo = obtenerEmpresa(widget.proyecto.idEmpresa);
  }

  Future<Map<String, String>> obtenerEmpresa(int idEmpresa) async {
    final response = await Supabase.instance.client
        .from('empresas')
        .select('nombre, descripcion')
        .eq('idempresa', idEmpresa)
        .single();

    return {
      'nombre': response['nombre'] ?? 'Desconocido',
      'descripcion': response['descripcion'] ?? 'Sin descripción',
    };
  }

  @override
  Widget build(BuildContext context) {
    final proyecto = widget.proyecto;

    return Scaffold(
      backgroundColor: const Color(0xFF052659),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para editar
        },
        backgroundColor: const Color(0xFF5285E8),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF052659),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF052659),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        proyecto.nombreProyecto,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        proyecto.descripcion,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 20),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  decoration: const BoxDecoration(
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
                      const SizedBox(height: 20),
                      const Text(
                        "Información Adicional",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 25),
                      FutureBuilder<Map<String, String>>(
                        future: empresaInfo,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Text("Error al cargar la empresa");
                          } else {
                            final empresa = snapshot.data!;
                            return InfoCard(
                              label: "Empresa",
                              title: empresa['nombre']!,
                              subtitle: empresa['descripcion']!,
                              icon: Icons.business,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      InfoCard(
                        label: "Tecnologías utilizadas",
                        title: "Tecnologías utilizadas",
                        subtitle: proyecto.tecnologias,
                        icon: Icons.code,
                      ),
                      const SizedBox(height: 20),
                      InfoCard(
                        label: "Residente",
                        title: "No disponible",
                        subtitle: "Número de control: N/A",
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 20),
                      InfoCard(
                        label: "Asesor",
                        title: "No disponible",
                        subtitle: "Número de control: N/A",
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
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
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
        Text(label, style: const TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          color: Theme.of(context).cardColor,
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
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