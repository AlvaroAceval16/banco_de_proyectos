import 'package:banco_de_proyectos/consts/text_styles.dart';
import 'package:banco_de_proyectos/components/main_drawer.dart';
import 'package:banco_de_proyectos/components/stats_card.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
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
                    icon: Icons.folder_outlined,
                    title: "Proyectos totales",
                    number: "20",
                    subtitle: "+2 esta semana",
                  ),
                  StatsCard(
                    icon: Icons.show_chart,
                    title: "Proyectos activos",
                    number: "5",
                    subtitle: "+3 esta semana",
                  ),
                  StatsCard(
                    icon: Icons.person,
                    title: "Proyectos en revisión",
                    number: "12",
                    subtitle: "+3 esta semana",
                  ),
                  StatsCard(
                    icon: Icons.pie_chart,
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
                ),              ],
            ),
            SizedBox(height: 10),
            _projectItem("Proyecto A", "Hoy"),
            _projectItem("Proyecto B", "20 abr."),
            _projectItem("Proyecto C", "10 abr."),
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

  Widget _projectItem(String title, String date) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text("Lorem ipsum dolor sit amet, consectetur", style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              date,
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
                  Text(title, style: TextStyle (fontWeight: FontWeight.bold, fontFamily: 'Poppins',),),
                  Text(subtitle, style: TextStyle (fontSize: 12, color: Colors.grey[700], fontFamily: 'Poppins', fontWeight: FontWeight.w500),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
