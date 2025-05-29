import 'package:banco_de_proyectos/back/logica_contactoEmpresaOK.dart'; // New import
import 'package:banco_de_proyectos/classes/contacto_empresa.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // This might still be needed if you use Supabase.instance.client directly for some other purpose, but ideally, all Supabase calls go through the logic file.

class InfoContactoEmpresa extends StatefulWidget {
  final ContactoEmpresa contacto;

  const InfoContactoEmpresa({required this.contacto, Key? key})
    : super(key: key);

  @override
  State<InfoContactoEmpresa> createState() => _InfoContactoEmpresaState();
}

class _InfoContactoEmpresaState extends State<InfoContactoEmpresa> {
  final LogicaContactoEmpresa _logicaContactoEmpresa =
      LogicaContactoEmpresa(); // Instance of the new logic class
  Map<String, dynamic>? _contactoData;
  bool _isLoading = true;
  String _errorMessage = '';

  bool _isEditing = false;

  // Controllers for contact details
  late TextEditingController _nombreController;
  late TextEditingController _apellidoPaternoController;
  late TextEditingController _apellidoMaternoController;
  late TextEditingController _telefonoController;
  late TextEditingController _correoController;
  late TextEditingController _puestoController;
  late TextEditingController _horarioAtencionController;
  late TextEditingController _comentariosController;

  // Controllers for associated company details (read-only for this view)
  late TextEditingController _nombreEmpresaController;
  late TextEditingController _descripcionEmpresaController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _apellidoPaternoController = TextEditingController();
    _apellidoMaternoController = TextEditingController();
    _telefonoController = TextEditingController();
    _correoController = TextEditingController();
    _puestoController = TextEditingController();
    _horarioAtencionController = TextEditingController();
    _comentariosController = TextEditingController();
    _nombreEmpresaController = TextEditingController();
    _descripcionEmpresaController = TextEditingController();

    _fetchContactoDetails();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoPaternoController.dispose();
    _apellidoMaternoController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _puestoController.dispose();
    _horarioAtencionController.dispose();
    _comentariosController.dispose();
    _nombreEmpresaController.dispose();
    _descripcionEmpresaController.dispose();
    super.dispose();
  }

  Future<void> _fetchContactoDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final contacto = await _logicaContactoEmpresa.obtenerDetallesContacto(
        widget.contacto.idcontacto,
        widget.contacto.idempresa,
      );
      if (contacto != null) {
        setState(() {
          _contactoData = contacto;

          _nombreController.text = _contactoData?['nombre'] ?? '';
          _apellidoPaternoController.text =
              _contactoData?['apellidopaterno'] ?? '';
          _apellidoMaternoController.text =
              _contactoData?['apellidomaterno'] ?? '';
          _telefonoController.text = _contactoData?['telefono'] ?? '';
          _correoController.text = _contactoData?['correo'] ?? '';
          _puestoController.text = _contactoData?['puesto'] ?? '';
          _horarioAtencionController.text =
              _contactoData?['horarioatencion'] ?? '';
          _comentariosController.text = _contactoData?['comentarios'] ?? '';

          // Populate company details (read-only)
          _nombreEmpresaController.text =
              _contactoData?['empresas']?['nombre'] ?? 'Empresa no disponible';
          _descripcionEmpresaController.text =
              _contactoData?['empresas']?['descripcion'] ??
              'No se encontró la información de la empresa.';
        });
      } else {
        setState(() {
          _errorMessage = 'No se encontraron detalles para este contacto.';
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
        'apellidopaterno': _apellidoPaternoController.text,
        'apellidomaterno': _apellidoMaternoController.text,
        'telefono': _telefonoController.text,
        'correo': _correoController.text,
        'puesto': _puestoController.text,
        'horarioatencion': _horarioAtencionController.text,
        'comentarios': _comentariosController.text,
      };

      await _logicaContactoEmpresa.actualizarContacto(
        widget.contacto.idcontacto,
        updatedData,
      );

      setState(() {
        _isEditing = false;
      });
      await _fetchContactoDetails(); // Refresh data after saving
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

  Future<void> _deleteContactoLogic() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text(
            '¿Estás seguro de que quieres eliminar lógicamente este contacto?',
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
        await _logicaContactoEmpresa.eliminarContactoLogic(
          widget.contacto.idcontacto,
        );
        Navigator.pop(context); // If deletion is successful, navigate back
      } catch (e) {
        setState(() {
          _errorMessage = 'Error al eliminar el contacto: $e';
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
              onPressed: _deleteContactoLogic,
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
                        // Top blue section for company info (read-only)
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
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                _nombreEmpresaController.text,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _descripcionEmpresaController.text,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                  fontFamily: 'Poppins',
                                ),
                                maxLines: null,
                              ),
                              const SizedBox(height: 20),
                              // Contact details in the blue section
                              _buildEditableInfoItem(
                                "Nombre",
                                _nombreController,
                                _isEditing,
                              ),
                              _buildEditableInfoItem(
                                "Apellido Paterno",
                                _apellidoPaternoController,
                                _isEditing,
                              ),
                              _buildEditableInfoItem(
                                "Apellido Materno",
                                _apellidoMaternoController,
                                _isEditing,
                              ),
                            ],
                          ),
                        ),

                        // White section for contact details
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
                                "Detalles de Contacto",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildEditableInfoCard(
                                label: "Teléfono",
                                controller: _telefonoController,
                                icon: Icons.phone,
                                isEditing: _isEditing,
                              ),
                              const SizedBox(height: 10),
                              _buildEditableInfoCard(
                                label: "Correo",
                                controller: _correoController,
                                icon: Icons.email,
                                isEditing: _isEditing,
                              ),
                              const SizedBox(height: 10),
                              _buildEditableInfoCard(
                                label: "Puesto",
                                controller: _puestoController,
                                icon: Icons.work,
                                isEditing: _isEditing,
                              ),
                              const SizedBox(height: 10),
                              _buildEditableInfoCard(
                                label: "Horario de Atención",
                                controller: _horarioAtencionController,
                                icon: Icons.access_time,
                                isEditing: _isEditing,
                              ),
                              const SizedBox(height: 10),
                              _buildEditableInfoCard(
                                label: "Comentarios",
                                controller: _comentariosController,
                                icon: Icons.comment,
                                isEditing: _isEditing,
                                maxLines:
                                    null, // Allow multiple lines for comments
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
}
