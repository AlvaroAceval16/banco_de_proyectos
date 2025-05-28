// info_empresa.dart
import 'package:flutter/material.dart';
import 'package:banco_de_proyectos/back/logica_info_empresa.dart';

class InfoEmpresa extends StatefulWidget {
  final int idEmpresa;

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

  bool _isEditing = false;

  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _sectorController;
  late TextEditingController _giroController;
  late TextEditingController _tamanoController;
  late TextEditingController _rfcController;
  late TextEditingController _codigoPostalController;
  late TextEditingController _estadoController;
  late TextEditingController _ciudadController;
  late TextEditingController _direccionController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _descripcionController = TextEditingController();
    _sectorController = TextEditingController();
    _giroController = TextEditingController();
    _tamanoController = TextEditingController();
    _rfcController = TextEditingController();
    _codigoPostalController = TextEditingController();
    _estadoController = TextEditingController();
    _ciudadController = TextEditingController();
    _direccionController = TextEditingController();

    _fetchEmpresaDetails();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _sectorController.dispose();
    _giroController.dispose();
    _tamanoController.dispose();
    _rfcController.dispose();
    _codigoPostalController.dispose();
    _estadoController.dispose();
    _ciudadController.dispose();
    _direccionController.dispose();
    super.dispose();
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

          _nombreController.text = _empresaData?['nombre'] ?? '';
          _descripcionController.text = _empresaData?['descripcion'] ?? '';
          _sectorController.text = _empresaData?['sector'] ?? '';
          _giroController.text = _empresaData?['giro'] ?? '';
          _tamanoController.text = _empresaData?['tamano'] ?? '';
          _rfcController.text = _empresaData?['rfc'] ?? '';
          _codigoPostalController.text = _empresaData?['cp'] ?? '';
          _estadoController.text = _empresaData?['estado'] ?? '';
          _ciudadController.text = _empresaData?['ciudad'] ?? '';
          _direccionController.text = _empresaData?['direccion'] ?? '';
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

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final updatedData = {
        'nombre': _nombreController.text,
        'descripcion': _descripcionController.text,
        'sector': _sectorController.text,
        'giro': _giroController.text,
        'tamano': _tamanoController.text,
        'rfc': _rfcController.text,
        'cp': _codigoPostalController.text,
        'estado': _estadoController.text,
        'ciudad': _ciudadController.text,
        'direccion': _direccionController.text,
      };

      await _logicaInfoEmpresa.actualizarEmpresa(widget.idEmpresa, updatedData);

      setState(() {
        _isEditing = false;
      });
      await _fetchEmpresaDetails();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al guardar los cambios: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // New: Method to handle logical deletion
  Future<void> _deleteEmpresaLogic() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text(
            '¿Estás seguro de que quieres eliminar lógicamente esta empresa?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      try {
        await _logicaInfoEmpresa.eliminarEmpresaLogic(widget.idEmpresa);
        // If deletion is successful, navigate back
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _errorMessage = 'Error al eliminar la empresa: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002A5C),
      // New: Add an AppBar for the delete button
      appBar: AppBar(
        backgroundColor: const Color(0xFF002A5C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_isEditing) // Only show delete button in view mode
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.white),
              onPressed: _deleteEmpresaLogic,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isEditing) {
            _saveChanges();
          } else {
            setState(() {
              _isEditing = true;
            });
          }
        },
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Icon(_isEditing ? Icons.save : Icons.edit, color: Colors.white),
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
                        // Parte azul superior (removed AppBar content as it's now in actual AppBar)
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF002A5C),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 0,
                          ), // Adjust vertical padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // No need for Icon(Icons.arrow_back) here anymore
                              // It's in the AppBar now
                              const SizedBox(
                                height: 20,
                              ), // Add some space if needed
                              _isEditing
                                  ? TextField(
                                    controller: _nombreController,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Nombre de la empresa',
                                      hintStyle: TextStyle(
                                        color: Colors.white70,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  )
                                  : Text(
                                    _nombreController.text,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                  ),
                              const SizedBox(height: 10),
                              _isEditing
                                  ? TextField(
                                    controller: _descripcionController,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Descripción de la empresa',
                                      hintStyle: TextStyle(
                                        color: Colors.white70,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    maxLines: null,
                                  )
                                  : Text(
                                    _descripcionController.text,
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
                                  _buildEditableInfoItem(
                                    "Sector o industria",
                                    _sectorController,
                                    _isEditing,
                                  ),
                                  _buildEditableInfoItem(
                                    "Giro de la empresa",
                                    _giroController,
                                    _isEditing,
                                  ),
                                  _buildEditableInfoItem(
                                    "Tamaño de la empresa",
                                    _tamanoController,
                                    _isEditing,
                                  ),
                                  _buildEditableInfoItem(
                                    "RFC",
                                    _rfcController,
                                    _isEditing,
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
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                      _proyectos.isEmpty
                                          ? [
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'No hay proyectos registrados.',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ]
                                          : _proyectos.map((proyecto) {
                                            return _projectBox(
                                              proyecto['nombreproyecto'] ??
                                                  'Sin Nombre',
                                              proyecto['descripcion'] ??
                                                  'Sin Descripción',
                                            );
                                          }).toList(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Ubicacion",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildEditableInfoCard(
                                label: "Código postal",
                                controller: _codigoPostalController,
                                icon: Icons.location_on_outlined,
                                isEditing: _isEditing,
                              ),
                              const SizedBox(height: 10),
                              _buildEditableInfoCard(
                                label: "Estado",
                                controller: _estadoController,
                                icon: Icons.location_on_outlined,
                                isEditing: _isEditing,
                              ),
                              const SizedBox(height: 10),
                              _buildEditableInfoCard(
                                label: "Ciudad",
                                controller: _ciudadController,
                                icon: Icons.location_on_outlined,
                                isEditing: _isEditing,
                              ),
                              const SizedBox(height: 10),
                              _buildEditableInfoCard(
                                label: "Dirección",
                                controller: _direccionController,
                                icon: Icons.location_on_outlined,
                                isEditing: _isEditing,
                                maxLines: null,
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

  Widget _buildEditableInfoItem(
    String label,
    TextEditingController controller,
    bool isEditing,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
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
            child:
                isEditing
                    ? TextField(
                      controller: controller,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.end,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 0,
                        ),
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                    )
                    : Text(
                      controller.text.isNotEmpty ? controller.text : 'N/A',
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

  Widget _buildEditableInfoCard({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isEditing,
    int? maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          color: Theme.of(context).cardColor,
          child:
              isEditing
                  ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      children: [
                        Icon(icon, color: Theme.of(context).iconTheme.color),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: controller,
                            maxLines: maxLines,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListTile(
                    title: Text(
                      controller.text.isNotEmpty ? controller.text : 'N/A',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
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

  Widget _projectBox(String title, String description) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 246, 247, 248),
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

// Keep InfoCard for completeness if used elsewhere, otherwise remove
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
