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
  late Future<List<Proyecto>> _obtenerProyectosFuture;

  // Los filtros iniciales deben estar todos en 'true' para que el usuario pueda desactivarlos
  // Pero la carga INICIAL no usa estos filtros hasta que se presiona "Aplicar"
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

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Al iniciar, cargamos *todos* los proyectos visibles.
    // Esto significa que los filtros de estado/modalidad/periodo se envían como null o vacíos.
    _obtenerProyectosFuture = ProyectoService.obtenerProyectosConFiltros(
      searchTerm: _searchController.text.trim().isNotEmpty ? _searchController.text.trim() : null,
      // No se pasan filtros de estado, modalidad o periodo inicialmente
      // para que el backend no los aplique.
      filtrosEstado: null,
      filtrosModalidad: null,
      filtrosPeriodo: null,
    );
    // No necesitamos un listener para _onSearchChanged si solo aplicamos en onSubmitted o con el botón
    // _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    // Si no usas _onSearchChanged, puedes quitar el removeListener
    // _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Este método ahora se encarga de aplicar los filtros *solo cuando se le llama explícitamente*
  void _applyFilters() {
    setState(() {
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

      String searchTerm = _searchController.text.trim();

      print('--- Aplicando Filtros ---');
      print('Filtros Estado: $estadosActivos');
      print('Filtros Modalidad: $modalidadesActivas');
      print('Filtros Periodo: $periodosActivos');
      print('Término de Búsqueda: "$searchTerm"');
      print('-------------------------');

      _obtenerProyectosFuture = ProyectoService.obtenerProyectosConFiltros(
        searchTerm: searchTerm.isNotEmpty ? searchTerm : null,
        filtrosEstado: estadosActivos.isNotEmpty ? estadosActivos : null,
        filtrosModalidad: modalidadesActivas.isNotEmpty ? modalidadesActivas : null,
        filtrosPeriodo: periodosActivos.isNotEmpty ? periodosActivos : null,
      );
    });
  }

  // Restablece todos los filtros en el UI y recarga los proyectos sin filtros
  void _resetFilters() {
    setState(() {
      filtros.updateAll((key, value) => true); // Activa todos los switches en el UI
      _searchController.clear(); // Limpia el campo de búsqueda
      // Recarga los proyectos sin aplicar ningún filtro específico, solo el activo=true por defecto
      _obtenerProyectosFuture = ProyectoService.obtenerProyectosConFiltros(
        filtrosEstado: null,
        filtrosModalidad: null,
        filtrosPeriodo: null,
        searchTerm: null,
      );
    });
    Navigator.pop(context); // Cierra el Drawer
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
                  const Text('2025'), // Esto es un texto fijo, no un filtro
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
                child: FutureBuilder<List<Proyecto>>(
                  future: _obtenerProyectosFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      print('Error en FutureBuilder: ${snapshot.error}'); // Depuración
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
          onPressed: () {
            _applyFilters(); // <--- Llama al nuevo método para aplicar filtros
            Navigator.pop(context); // Cierra el Drawer
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
        ),
          child: const Text('Aplicar'),
        ),
        ElevatedButton(
          onPressed: () {
            _resetFilters(); // Llama al método para restablecer filtros
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade400,
          ),
          child: const Text('Restablecer'),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
  return TextField(
    controller: _searchController,
    decoration: InputDecoration(
      hintText: 'Buscar proyectos...',
      prefixIcon: const Icon(Icons.search),
      suffixIcon: _searchController.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _applyFilters();
              },
            )
          : null,
      filled: true,
      fillColor: Theme.of(context).cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
    ),
    onChanged: (value) {
      // Opcional: Buscar mientras escribe (con debounce)
      // _debouncer.run(() => _applyFilters());
    },
    onSubmitted: (value) {
      _applyFilters();
    },
  );
}
}