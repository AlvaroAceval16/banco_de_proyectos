import 'package:flutter/material.dart';
import 'info_proyecto.dart';

class ResumenProyectosPage extends StatefulWidget {
  const ResumenProyectosPage({super.key});

  @override
  State<ResumenProyectosPage> createState() => _ResumenProyectosPageState();
}

class _ResumenProyectosPageState extends State<ResumenProyectosPage> {
  final List<Map<String, String>> proyectos = List.generate(
    8,
    (index) => {
      'empresa': 'Proyecto ${String.fromCharCode(65 + index)}',
      'descripcion': 'Descripción pequeña',
    },
  );

  // Filtros de búsqueda
  final Map<String, bool> filtros = {
    'Activo': true,
    'En Proceso': true,
    'Finalizado': true,
    'Presencial': true,
    'En Línea': true,
    'Híbrido': true,
    'Ene-Jun': true,
    'Ago-Dic': true,
  };

  List<Map<String, String>> get proyectosFiltrados {
    return proyectos.where((proyecto) {
      // Aquí se puede aplicar lógica de filtrado real si se tuviera más información
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Poppins'),
      ),
      child: Scaffold(
        drawer: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filtros',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Estado'),
                  _buildSwitchTile('Activo'),
                  _buildSwitchTile('En Proceso'),
                  _buildSwitchTile('Finalizado'),
                  const SizedBox(height: 8),
                  _buildSectionTitle('Modalidad'),
                  _buildSwitchTile('Presencial'),
                  _buildSwitchTile('En Línea'),
                  _buildSwitchTile('Híbrido'),
                  const SizedBox(height: 8),
                  _buildSectionTitle('Periodo'),
                  const Text('2025'),
                  _buildSwitchTile('Ene-Jun'),
                  _buildSwitchTile('Ago-Dic'),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Aplicar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            filtros.updateAll((key, value) => true);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade400,
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text('Resumen de Proyectos'),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushNamed(context, '/dashboard'),
          ),
          actions: [
            Builder(
              builder:
                  (context) => IconButton(
                    icon: const Icon(Icons.tune),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Busca tus proyectos...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: proyectosFiltrados.length,
                  itemBuilder: (context, index) {
                    final proyecto = proyectosFiltrados[index];
                    return Card(
                      color: Theme.of(context).cardColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(proyecto['empresa']!),
                        subtitle: Text(proyecto['descripcion']!),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                //Cambiar esto para que me lleve a la info de proyectos
                                builder: (context) => InfoProyecto(),
                              ),
                            ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/form_proyecto'),
          backgroundColor: const Color(0xFF5285E8),
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSwitchTile(String label) {
    return SwitchListTile(
      title: Text(label),
      value: filtros[label]!,
      onChanged: (val) {
        setState(() {
          filtros[label] = val;
        });
      },
      activeColor: Colors.green,
    );
  }
}
