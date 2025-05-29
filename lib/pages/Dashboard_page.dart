import 'package:banco_de_proyectos/consts/text_styles.dart';
import 'package:banco_de_proyectos/components/main_drawer.dart';
import 'package:banco_de_proyectos/components/stats_card.dart';
import 'package:banco_de_proyectos/pages/info_proyecto.dart';
import 'package:flutter/material.dart';
import 'package:banco_de_proyectos/classes/proyecto.dart';
import 'package:banco_de_proyectos/back/logica_proyectos.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ProyectoService _proyectoService = ProyectoService();
  late Future<List<Proyecto>> _recentProjectsFuture;

  // --- NUEVA LÓGICA PARA LOS CONTEOS DE ESTADÍSTICAS ---
  late Future<List<int>> _statsCountsFuture;

  @override
  void initState() {
    super.initState();
    _recentProjectsFuture = _proyectoService.getRecentProjects();

    // Inicializa el Future para los conteos de las estadísticas
    _statsCountsFuture = Future.wait([
      ProyectoService.getTotalProjectsCountBasedOnAll(),
      ProyectoService.getActiveProjectsCountBasedOnStatus(),
      ProyectoService.getReviewProjectsCountBasedOnStatus(),
      ProyectoService.getFinishedProjectsCountBasedOnStatus(),
    ]);
  }
  // --- FIN NUEVA LÓGICA ---

  // Método para construir un elemento de proyecto individual
  Widget _projectItem(Proyecto project, BuildContext context) {
    String formattedDate = _formatDate(project.fechaSolicitud);

    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InfoProyecto(proyecto: project),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.nombreProyecto,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      project.descripcion,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  formattedDate,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Función auxiliar para formatear la fecha
  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      if (date.day == DateTime.now().day && date.month == DateTime.now().month && date.year == DateTime.now().year) {
        return "Hoy";
      } else {
        final monthNames = ["ene.", "feb.", "mar.", "abr.", "may.", "jun.", "jul.", "ago.", "sep.", "oct.", "nov.", "dic."];
        return "${date.day} ${monthNames[date.month - 1]}.";
      }
    } catch (e) {
      print('Error al formatear fecha: $dateString, Error: $e');
      return dateString;
    }
  }

  // Método para construir un botón de acción rápida
  Widget _quickAction(String title, String subtitle, VoidCallback? onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.add_circle, color: Colors.blue),
              SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            SizedBox(width: 10),
            Text(
              "Banco de Proyectos",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bienvenido Aníbal!", style: titleStyle),
            Text(
              "Explorar proyectos",
              style: TextStyle(color: Colors.grey[700], fontFamily: 'Poppins'),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "Busca tus proyectos...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Estadísticas generales",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 10),
            // --- FutureBuilder para las StatsCards ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FutureBuilder<List<int>>(
                future: _statsCountsFuture, // Usa el Future que inicializamos en initState
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Muestra un cargador mientras se obtienen los datos
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Muestra un mensaje de error si algo sale mal
                    return Center(child: Text('Error al cargar estadísticas: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    // Mensaje si no hay datos disponibles
                    return const Center(child: Text('No hay datos de estadísticas disponibles.'));
                  } else {
                    // Cuando los datos están disponibles, construye las StatsCard
                    final counts = snapshot.data!;
                    final totalProjects = counts[0];
                    final activeProjects = counts[1];
                    final reviewProjects = counts[2];
                    final finishedProjects = counts[3];

                    return Row(
                      spacing: 10,
                      children: [
                        StatsCard(
                          iconColor: const Color(0xFF5285E8),
                          icon: Icons.folder_outlined,
                          title: "Proyectos totales",
                          number: totalProjects.toString(),
                          subtitle: "+2 esta semana", // Puedes hacer este dinámico también
                        ),
                        StatsCard(
                          iconColor: Colors.red,
                          icon: Icons.show_chart,
                          title: "Proyectos activos",
                          number: activeProjects.toString(),
                          subtitle: "+1 esta semana",
                        ),
                        StatsCard(
                          iconColor: Colors.orange,
                          icon: Icons.pending_actions,
                          title: "Proyectos en revisión",
                          number: reviewProjects.toString(),
                          subtitle: "+1 esta semana",
                        ),
                        StatsCard(
                          iconColor: Colors.green,
                          icon: Icons.task_outlined,
                          title: "Proyectos finalizados",
                          number: finishedProjects.toString(),
                          subtitle: "+1 esta semana",
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            // --- FIN FutureBuilder para las StatsCards ---
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Últimos proyectos",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            FutureBuilder<List<Proyecto>>(
              future: _recentProjectsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar proyectos: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay proyectos recientes para mostrar.'));
                } else {
                  return Column(
                    children: snapshot.data!.map((proyecto) {
                      return _projectItem(proyecto, context);
                    }).toList(),
                  );
                }
              },
            ),
            SizedBox(height: 30),
            Text(
              "Acciones Rápidas",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                _quickAction(
                  "Proyectos",
                  "Agregar nuevo proyecto",
                  () {
                    Navigator.pushNamed(context, '/form_proyecto');
                  },
                ),
                SizedBox(width: 10),
                _quickAction(
                  "Empresas",
                  "Agregar nueva empresa",
                  () {
                    Navigator.pushNamed(context, '/form_empresa');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}