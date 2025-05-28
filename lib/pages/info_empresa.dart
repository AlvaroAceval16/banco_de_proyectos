// info_empresa.dart
import 'package:flutter/material.dart';
import 'package:banco_de_proyectos/back/logica_info_empresa.dart'; // Import the new logic class

class InfoEmpresa extends StatefulWidget {
  final int idEmpresa; // Add a constructor to receive the company ID

  const InfoEmpresa({super.key, required this.idEmpresa});

  @override
  State<InfoEmpresa> createState() => _InfoEmpresaState();
}

class _InfoEmpresaState extends State<InfoEmpresa> {
  final LogicaInfoEmpresa _logicaInfoEmpresa = LogicaInfoEmpresa();
  Map<String, dynamic>? _empresaData;
  List<Map<String, dynamic>> _proyectos = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchEmpresaDetails();
  }

  Future<void> _fetchEmpresaDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final empresa = await _logicaInfoEmpresa.obtenerDetallesEmpresa(
        widget.idEmpresa,
      );
      if (empresa != null) {
        final proyectos = await _logicaInfoEmpresa.obtenerProyectosEmpresa(
          widget.idEmpresa,
        );
        setState(() {
          _empresaData = empresa;
          _proyectos = proyectos;
        });
      } else {
        setState(() {
          _errorMessage = 'No se encontraron detalles para esta empresa.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los datos: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002A5C),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para editar - You might want to pass _empresaData for editing
          print('Edit company: ${_empresaData?['nombre']}');
        },
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : _errorMessage.isNotEmpty
              ? Center(
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        // Parte azul superior
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF002A5C),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Back button
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                _empresaData?['nombre'] ??
                                    "Nombre de la empresa",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _empresaData?['descripcion'] ??
                                    "Descripción de la empresa no disponible.",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 4),

                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _infoItem(
                                    "Sector o industria",
                                    _empresaData?['sector'] ?? 'N/A',
                                  ),
                                  _infoItem(
                                    "Giro de la empresa",
                                    _empresaData?['giro'] ?? 'N/A',
                                  ),
                                  _infoItem(
                                    "Tamaño de la empresa",
                                    _empresaData?['tamano'] ?? 'N/A',
                                  ),
                                  _infoItem(
                                    "RFC",
                                    _empresaData?['rfc'] ?? 'N/A',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Parte blanca inferior
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 25,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Proyectos",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Sección Proyectos
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  spacing:
                                      10, // Assuming spacing is a property of Row or similar. If not, add SizedBox between children.
                                  children:
                                      _proyectos.isEmpty
                                          ? [
                                            const Text(
                                              'No hay proyectos registrados.',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ]
                                          : _proyectos.map((proyecto) {
                                            return _projectBox(
                                              proyecto['nombreProyecto'] ??
                                                  'Sin Nombre',
                                              proyecto['descripcion'] ??
                                                  'Sin Descripción',
                                            );
                                          }).toList(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Sección Ubicación
                              const Text(
                                "Ubicacion",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 10),
                              InfoCard(
                                label: "Código postal",
                                title:
                                    "Código postal", // Redundant if subtitle is the value
                                subtitle: _empresaData?['cp'] ?? 'N/A',
                                icon: Icons.location_on_outlined,
                              ),
                              const SizedBox(height: 10),
                              InfoCard(
                                label: "Estado",
                                title:
                                    "Estado donde se encuentra la empresa", // Redundant if subtitle is the value
                                subtitle: _empresaData?['estado'] ?? 'N/A',
                                icon: Icons.location_on_outlined,
                              ),
                              const SizedBox(height: 10),
                              InfoCard(
                                label: "Ciudad",
                                title:
                                    "Ciudad donde se encuentra la empresa", // Redundant if subtitle is the value
                                subtitle: _empresaData?['ciudad'] ?? 'N/A',
                                icon: Icons.location_on_outlined,
                              ),
                              const SizedBox(height: 10),
                              InfoCard(
                                label: "Dirección",
                                title:
                                    "Direccion", // Redundant if subtitle is the value
                                subtitle: _empresaData?['direccion'] ?? 'N/A',
                                icon: Icons.location_on_outlined,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  // Helper method for consistent label style
  TextStyle _labelStyle() {
    return const TextStyle(
      fontSize: 14,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    );
  }

  Widget _infoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 150, // Asegura que las etiquetas tengan un ancho constante
            child: Text(
              label,
              style: const TextStyle(
                color: Color.fromARGB(255, 246, 247, 248),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _projectBox(String title, String description) {
    return Container(
      width: 200, // Ancho de cada caja
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(
        right: 10,
      ), // Add margin for spacing between project boxes
      decoration: BoxDecoration(
        color: const Color.fromARGB(
          255,
          246,
          247,
          248,
        ), // Color de fondo de la caja
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Color.fromARGB(179, 1, 1, 1),
              fontSize: 12,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.label,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          color: Theme.of(context).cardColor,
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            leading: Icon(icon),
          ),
        ),
      ],
    );
  }

  TextStyle _labelStyle() {
    return const TextStyle(
      fontSize: 14,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    );
  }
}
