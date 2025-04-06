import 'package:flutter/material.dart';

//Crear el drawer(Menu lateral)
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //Appbar(la barrita de arriba donde va el titulo y el boton de la barra lateral) ya se puede copiar y pegar quiza hacer hasta componente.
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.menu, color: Colors.black),
            SizedBox(width: 10),
            Text("Banco de Proyectos", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bienvenido Aníbal!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("Explorar proyectos", style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "Busca tus proyectos...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              ),
            ),
            SizedBox(height: 30),
            Text("Estadísticas generales", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 10),
            Row(
              children: [
                _statsCard(Icons.folder, "Proyectos totales", "10", "+2 esta semana"),
                SizedBox(width: 10),
                _summaryCard(),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Últimos proyectos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Icon(Icons.arrow_forward),
              ],
            ),
            SizedBox(height: 10),
            _projectItem("Proyecto A", "Hoy"),
            _projectItem("Proyecto B", "20 abr."),
            _projectItem("Proyecto C", "10 abr."),
            SizedBox(height: 30),
            Text("Acciones Rápidas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

  Widget _statsCard(IconData icon, String title, String number, String subtitle) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(number, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(color: Colors.green)),
            SizedBox(height: 8),
            Align(alignment: Alignment.centerRight, child: Text("Ver todo", style: TextStyle(color: Colors.grey))),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(Icons.pie_chart, color: Colors.blue),
            SizedBox(height: 8),
            Text("Resumen", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("10", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text("• 6 Activos\n• 1 En revisión\n• 2 Finalizados", textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
            SizedBox(height: 8),
            Align(alignment: Alignment.centerRight, child: Text("Ver todo", style: TextStyle(color: Colors.grey))),
          ],
        ),
      ),
    );
  }

  Widget _projectItem(String title, String date) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Lorem ipsum dolor sit amet, consectetur"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(date, style: TextStyle(fontWeight: FontWeight.w600)),
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
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}