import 'package:banco_de_proyectos/consts/text_styles.dart';
import 'package:banco_de_proyectos/components/main_drawer.dart';
import 'package:banco_de_proyectos/components/stats_card.dart';
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

  @override
  void initState() {
    super.initState();
    _recentProjectsFuture = _proyectoService.getRecentProjects();
  }

  // Tu método _projectItem ahora recibirá un objeto Proyecto completo
  Widget _projectItem(Proyecto project, BuildContext context) {
    // Formatear la fecha para mostrarla de forma amigable (opcional, pero recomendado)
    String formattedDate = _formatDate(project.fechaSolicitud);

    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
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
                    project.nombreProyecto, // Usa el nombre del proyecto real
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    project.descripcion, // Usa la descripción real del proyecto
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2, // Limita la descripción a 2 líneas
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                formattedDate, // Muestra la fecha formateada
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
    );
  }

  // Función auxiliar para formatear la fecha (puedes expandirla con paquetes como `intl`)
  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      // Ejemplo simple: "28 may." para hoy, o "20 abr." para otras fechas
      if (date.day == DateTime.now().day && date.month == DateTime.now().month && date.year == DateTime.now().year) {
        return "Hoy";
      } else {
        final monthNames = ["ene.", "feb.", "mar.", "abr.", "may.", "jun.", "jul.", "ago.", "sep.", "oct.", "nov.", "dic."];
        return "${date.day} ${monthNames[date.month - 1]}.";
      }
    } catch (e) {
      return dateString; // Si hay un error, devuelve la cadena original
    }
  }

  Widget _quickAction(String title, String subtitle) {
    return Expanded(
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                children: [
                  StatsCard(
                    iconColor: const Color(0xFF5285E8),
                    icon: Icons.folder_outlined,
                    title: "Proyectos totales",
                    number: "20",
                    subtitle: "+2 esta semana",
                  ),
                  StatsCard(
                    iconColor: Colors.red,
                    icon: Icons.show_chart,
                    title: "Proyectos activos",
                    number: "5",
                    subtitle: "+3 esta semana",
                  ),
                  StatsCard(
                    iconColor: Colors.orange,
                    icon: Icons.pending_actions,
                    title: "Proyectos en revisión",
                    number: "12",
                    subtitle: "+3 esta semana",
                  ),
                  StatsCard(
                    iconColor: Colors.green,
                    icon: Icons.task_outlined,
                    title: "Proyectos finalizados",
                    number: "3",
                    subtitle: "+1 esta semana",
                  ),
                ],
              ),
            ),
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
            // Aquí es donde mostramos los proyectos
            FutureBuilder<List<Proyecto>>(
              future: _recentProjectsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // Muestra un indicador de carga
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar proyectos: ${snapshot.error}')); // Muestra un error
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay proyectos recientes para mostrar.')); // No hay datos
                } else {
                  // Si tenemos datos, los mostramos
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
                _quickAction("Proyectos", "Agregar nuevo proyecto"),
                SizedBox(width: 10),
                _quickAction("Empresas", "Agregar nueva empresa"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}