import 'package:banco_de_proyectos/back/logica_lista_empresas.dart';
import 'package:banco_de_proyectos/pages/info_empresa.dart';
import 'package:flutter/material.dart';

class ResumenEmpresasPage extends StatefulWidget {
  const ResumenEmpresasPage({super.key});

  @override
  State<ResumenEmpresasPage> createState() => _ResumenEmpresasPageState();
}

class _ResumenEmpresasPageState extends State<ResumenEmpresasPage> {
  //inicir la lista de empresas y filtros
  final LogicaListaEmpresas _logicaListaEmpresas = LogicaListaEmpresas();
  late Future<List<Map<String, dynamic>>> _empresasFuture;
  final TextEditingController _searchController = TextEditingController();

  // final List<Map<String, String>> empresas = List.generate(
  //   6,
  //   (index) => {
  //     'nombre': 'Empresa ${String.fromCharCode(65 + index)}',
  //     'descripcion': 'Descripción de la empresa',
  //   },
  // );

  final Map<String, bool> filtros = {
    'Microempresa': true,
    'Pequeña': true,
    'Mediana': true,
    'Grande': true,
  };

  // List<Map<String, String>> get empresasFiltradas {
  //   return empresas.where((empresa) {
  //     // Lógica de filtrado puede agregarse aquí
  //     return true;
  //   }).toList();
  // }

  //lista dinamica para almacenar las empresas filtradas
  List<Map<String, dynamic>> _currentEmpresas = [];

  @override
  void initState() {
    super.initState();
    _fetchAndFilterEmpresas(); // Initial fetch when the widget is created
    _searchController.addListener(
      _onSearchChanged,
    ); // Listen for search input changes
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Function to fetch and filter companies based on current filters and search query
  Future<void> _fetchAndFilterEmpresas() async {
    setState(() {
      // Create a list of active filters
      final activeFilters =
          filtros.entries
              .where((entry) => entry.value)
              .map((entry) => entry.key)
              .toList();

      // If no filters are active, fetch all companies; otherwise, apply filters
      if (activeFilters.isEmpty) {
        _empresasFuture = _logicaListaEmpresas.obtenerEmpresas();
      } else {
        _empresasFuture = _logicaListaEmpresas.filtrarEmpresas(activeFilters);
      }
    });

    // Await the future and then apply search filtering
    final fetchedCompanies = await _empresasFuture;
    _applySearchFilter(fetchedCompanies);
  }

  // Function to apply search filter to the current list of companies
  void _applySearchFilter(List<Map<String, dynamic>> companies) {
    final searchQuery = _searchController.text.toLowerCase();
    setState(() {
      if (searchQuery.isEmpty) {
        _currentEmpresas = companies;
      } else {
        _currentEmpresas =
            companies.where((empresa) {
              final nombre = empresa['nombre']?.toLowerCase() ?? '';
              final descripcion = empresa['descripcion']?.toLowerCase() ?? '';
              return nombre.contains(searchQuery) ||
                  descripcion.contains(searchQuery);
            }).toList();
      }
    });
  }

  // Listener for changes in the search text field
  void _onSearchChanged() {
    _fetchAndFilterEmpresas(); // Re-fetch and filter whenever search query changes
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
                  _buildSectionTitle('Tamaño de Empresa'),
                  _buildSwitchTile('Microempresa'),
                  _buildSwitchTile('Pequeña'),
                  _buildSwitchTile('Mediana'),
                  _buildSwitchTile('Grande'),
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
          title: const Text('Empresas Registradas'),
          //centerTitle: false,
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
                controller: _searchController, // Controller for search input
                decoration: InputDecoration(
                  hintText: 'Buscar empresas...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                // Use FutureBuilder to handle asynchronous data fetching
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _empresasFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || _currentEmpresas.isEmpty) {
                      return const Center(
                        child: Text('No hay empresas registradas.'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: _currentEmpresas.length,
                        itemBuilder: (context, index) {
                          final empresa = _currentEmpresas[index];
                          return Card(
                            color: Theme.of(context).cardColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(
                                empresa['nombre'] ?? 'Nombre no disponible',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                empresa['descripcion'] ??
                                    'Descripción no disponible',
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward,
                                size: 20,
                              ),
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InfoEmpresa(),
                                    ),
                                  ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/form_empresa'),
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
