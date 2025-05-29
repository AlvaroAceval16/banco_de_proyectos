import 'package:flutter/material.dart';
import 'info_proyecto.dart';
import 'package:banco_de_proyectos/back/logica_proyectos.dart';
import 'package:banco_de_proyectos/classes/proyecto.dart';

class ResumenProyectosPage extends StatefulWidget {
  const ResumenProyectosPage({super.key});

  @override
  State<ResumenProyectosPage> createState() => _ResumenProyectosPageState();
}

class _ResumenProyectosPageState extends State<ResumenProyectosPage> {
  late Future<List<Map<String, dynamic>>> _obtenerProyectosFuture;

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

  @override
  void initState() {
    super.initState();
    _obtenerProyectosFuture = ProyectoService.obtenerProyectos();
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
                  _buildDrawerHeader(),
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
                  _buildDrawerButtons(),
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
              builder: (context) => IconButton(
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
              _buildSearchField(),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _obtenerProyectosFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No hay proyectos disponibles.'));
                    }

                    final proyectos = snapshot.data!;
                    return ListView.builder(
                      itemCount: proyectos.length,
                      itemBuilder: (context, index) {
                        final proyectoMap = proyectos[index];
                        final proyecto = Proyecto.fromMap(proyectoMap);
                        return Card(
                          color: Theme.of(context).cardColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(
                              proyecto.nombreProyecto,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(proyecto.descripcion),
                            trailing: const Icon(Icons.arrow_forward, size: 20),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InfoProyecto(proyecto: proyecto),
                                ),
                              );
                            },
                          ),
                        );
                      },
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

  Widget _buildDrawerHeader() {
    return Row(
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

  Widget _buildDrawerButtons() {
    return Row(
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
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Busca tus proyectos...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}