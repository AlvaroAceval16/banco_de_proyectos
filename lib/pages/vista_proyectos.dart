import 'package:flutter/material.dart';
import 'info_proyecto.dart'; // Make sure this path is correct
import 'package:banco_de_proyectos/back/logica_proyectos.dart'; // Check if this is still needed, as ContactoServiceProyecto is now in busquedas_proyectos.dart
import 'package:banco_de_proyectos/back/busquedas_proyectos.dart'; // This is where ContactoServiceProyecto is
import 'package:banco_de_proyectos/classes/proyecto.dart'; // Your Proyecto class

class ResumenProyectosPage extends StatefulWidget {
  const ResumenProyectosPage({super.key});

  @override
  State<ResumenProyectosPage> createState() => _ResumenProyectosPageState();
}

class _ResumenProyectosPageState extends State<ResumenProyectosPage> {
  late Future<List<Proyecto>> _obtenerProyectosFuture;

  final Map<String, bool> filtros = {
    'Activo': false,
    'En Proceso': false,
    'Finalizado': false,
    'Presencial': false,
    'En Línea': false,
    'Híbrido': false,
    'Ene-Jun': false,
    'Ago-Dic': false,
  };

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the future when the widget is created
    _actualizarFiltrosYBusqueda();
    // Add a listener to the search controller for real-time filtering
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // This debounces the search slightly to avoid too many requests on every keystroke.
    // For very fast typing, you might want to add a short delay (e.g., using Timer).
    _actualizarFiltrosYBusqueda();
  }

  void _actualizarFiltrosYBusqueda() {
    String filtroTexto = _searchController.text.trim();

    List<String> estadosActivos = [];
    if (filtros['Activo']!) estadosActivos.add('Activo');
    if (filtros['En Proceso']!) estadosActivos.add('En Proceso');
    if (filtros['Finalizado']!) estadosActivos.add('Finalizado');

    List<String> modalidadesActivas = [];
    if (filtros['Presencial']!) modalidadesActivas.add('Presencial');
    if (filtros['En Línea']!) modalidadesActivas.add('En Línea');
    if (filtros['Híbrido']!) modalidadesActivas.add('Híbrido');

    List<String> periodosActivos = [];
    if (filtros['Ene-Jun']!) periodosActivos.add('Ene-Jun');
    if (filtros['Ago-Dic']!) periodosActivos.add('Ago-Dic');

    setState(() {
      _obtenerProyectosFuture = ContactoServiceProyecto.obtenerProyectosConFiltros(
        filtro: filtroTexto,
        estados: estadosActivos.isEmpty ? null : estadosActivos,
        modalidades: modalidadesActivas.isEmpty ? null : modalidadesActivas,
        periodos: periodosActivos.isEmpty ? null : periodosActivos,
      );
    });
  }

  void _resetFilters() {
    setState(() {
      // Set all filter values to false (off) to clear them
      filtros.updateAll((key, value) => false);
      _searchController.clear(); // Clear search text
      _actualizarFiltrosYBusqueda(); // Re-fetch projects with no filters and empty search
    });
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
                  const Text('2025'), // Consider making the year dynamic if needed
                  _buildSwitchTile('Ene-Jun'),
                  _buildSwitchTile('Ago-Dic'),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _actualizarFiltrosYBusqueda();
                          Navigator.pop(context); // Close the drawer
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                        child: const Text('Aplicar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _resetFilters();
                          Navigator.pop(context); // Close the drawer
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, foregroundColor: Colors.white),
                        child: const Text('Restablecer'),
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
                child: FutureBuilder<List<Proyecto>>(
                  future: _obtenerProyectosFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error al cargar proyectos: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No hay proyectos disponibles con los filtros aplicados.'));
                    }

                    final proyectos = snapshot.data!;
                    return ListView.builder(
                      itemCount: proyectos.length,
                      itemBuilder: (context, index) {
                        final proyecto = proyectos[index];
                        return Card(
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.close), // Changed to a close icon for better UX
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
          // Apply filters immediately when a switch is toggled
          _actualizarFiltrosYBusqueda();
        });
      },
      activeColor: Colors.green,
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
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
      // onChanged is now handled by the listener in initState
      // onSubmitted is not strictly needed for live search, but could be added if you want specific behavior on enter
    );
  }
}