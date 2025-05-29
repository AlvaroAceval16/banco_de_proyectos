import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Row(
              children: [
                Icon(Icons.account_circle, size: 60),
                SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anibal Saucedo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text("Mi cuenta"),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dataset_outlined),
            title: Text('Proyectos'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer primero
              Future.delayed(const Duration(milliseconds: 200), () {
                Navigator.pushNamed(context, '/vista_proyectos');
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.business_outlined),
            title: Text('Empresas'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer primero
              Future.delayed(const Duration(milliseconds: 200), () {
                Navigator.pushNamed(context, '/vista_empresas');
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment_ind_outlined),
            title: Text('Contacto Empresa'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer primero
              Future.delayed(const Duration(milliseconds: 200), () {
                Navigator.pushNamed(context, '/vista_contacto_empresa');
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment_outlined),
            title: Text('Asignaciones'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer primero
              Future.delayed(const Duration(milliseconds: 200), () {
                Navigator.pushNamed(context, '/form_asignaciones');
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.analytics_outlined),
            title: Text('Reportes'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.pie_chart_outline),
            title: Text('Gráficos'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.question_mark_rounded),
            title: Text('Soporte'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline_rounded),
            title: Text('Sobre nosotros'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
