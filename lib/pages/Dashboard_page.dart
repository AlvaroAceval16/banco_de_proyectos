import 'package:banco_de_proyectos/components/main_drawer.dart';
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
            Text(
              "Bienvenido Aníbal!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              "Explorar proyectos",
              style: TextStyle(color: Colors.grey[600], fontFamily: 'Poppins'),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "Busca tus proyectos...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
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
            Row(
              children: [
                _statsCard(
                  Icons.folder,
                  "Proyectos totales",
                  "10",
                  "+2 esta semana",
                ),
                SizedBox(width: 10),
                _summaryCard(),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Últimos proyectos",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                Icon(Icons.arrow_forward),
              ],
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

  Widget _statsCard(
    IconData icon,
    String title,
    String number,
    String subtitle,
  ) {
    return Expanded(
      child: Container(
        height: 200,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.blue),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              number,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.green, fontFamily: 'Poppins'),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Ver todo",
                style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard() {
    return Expanded(
      child: Container(
        height: 200,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.pie_chart, color: Colors.blue),
            Text(
              "Resumen",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              "10",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              "• 6 Activos\n• 1 En revisión\n• 2 Finalizados",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Ver todo",
                style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _projectItem(String title, String date) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
        subtitle: Text(
          "Lorem ipsum dolor sit amet, consectetur",
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 12),
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
}
