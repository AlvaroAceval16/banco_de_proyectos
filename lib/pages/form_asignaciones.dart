// lib/pages/form_asignaciones.dart
import 'package:flutter/material.dart';
import 'package:banco_de_proyectos/back/logica_asignaciones.dart'; // Importa tu servicio de asignaciones

// No es necesario un `main` aquí si este formulario se usa como una ruta en tu MaterialApp principal.
// final supabase = Supabase.instance.client; // No es necesario aquí, se usa en el servicio.

class FormAsignaciones extends StatefulWidget {
  final int? idAsignacion; // Opcional: para modo edición

  const FormAsignaciones({Key? key, this.idAsignacion}) : super(key: key);

  @override
  State<FormAsignaciones> createState() => _FormAsignacionesState();
}

class _FormAsignacionesState extends State<FormAsignaciones> {
  final _formKey = GlobalKey<FormState>();
  final AsignacionService _asignacionService = AsignacionService();

  // Controladores para los campos de fecha
  final TextEditingController _fechaAsignacionController =
      TextEditingController();
  final TextEditingController _fechaFinalizacionController =
      TextEditingController();

  // Variables para los valores seleccionados en los dropdowns
  int? _selectedProyectoId;
  int? _selectedEstudianteId;
  int? _selectedTutorId;
  String? _selectedEstado;

  // Listas para poblar los dropdowns
  List<Map<String, dynamic>> _proyectos = [];
  List<Map<String, dynamic>> _estudiantes = [];
  List<Map<String, dynamic>> _tutores = [];
  final List<String> _estados = ['En curso', 'Finalizado'];

  bool _isLoading = true;
  String? _errorMessage;

  // Estilo de decoración de input común, replicando tu ejemplo
  final inputDecoration = InputDecoration(
    filled: true,
    fillColor: const Color(0xFFF3F3F3),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    ),
  );

  @override
  void initState() {
    super.initState();
    _loadFormData(); // Carga los datos para los dropdowns y, si es edición, los datos de la asignación
  }

  @override
  void dispose() {
    _fechaAsignacionController.dispose();
    _fechaFinalizacionController.dispose();
    super.dispose();
  }

  // Carga los datos iniciales para los dropdowns y, si aplica, los datos de la asignación a editar
  Future<void> _loadFormData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      // Cargar datos para los dropdowns
      _proyectos = await AsignacionService.obtenerProyectosParaDropdown();
      _estudiantes = await AsignacionService.obtenerEstudiantesParaDropdown();
      _tutores = await AsignacionService.obtenerTutoresParaDropdown();

      // Si estamos en modo edición, cargar los datos de la asignación
      if (widget.idAsignacion != null) {
        final asignacionData = await _asignacionService.obtenerAsignacionPorId(
          widget.idAsignacion!,
        );
        if (asignacionData != null) {
          // --- Manejo para idProyecto ---
          int? fetchedProyectoId = asignacionData['idproyecto'];
          if (fetchedProyectoId != null &&
              _proyectos.any((p) => p['idproyecto'] == fetchedProyectoId)) {
            _selectedProyectoId = fetchedProyectoId;
          } else if (fetchedProyectoId != null) {
            // El proyecto asignado no está en la lista de proyectos activos
            print(
              'Advertencia: Proyecto ID $fetchedProyectoId de la asignación no encontrado en la lista de proyectos activos.',
            );
            _errorMessage =
                (_errorMessage ?? '') +
                '\nAdvertencia: El proyecto asignado no está disponible.';
          } else {
            // El idProyecto es null en la asignación, o no se encontró
            _selectedProyectoId = null;
          }

          // --- Manejo para idEstudiante ---
          int? fetchedEstudianteId = asignacionData['idestudiante'];
          if (fetchedEstudianteId != null &&
              _estudiantes.any(
                (e) => e['idestudiante'] == fetchedEstudianteId,
              )) {
            _selectedEstudianteId = fetchedEstudianteId;
          } else if (fetchedEstudianteId != null) {
            // El estudiante asignado no está en la lista de estudiantes activos
            print(
              'Advertencia: Estudiante ID $fetchedEstudianteId de la asignación no encontrado en la lista de estudiantes activos.',
            );
            _errorMessage =
                (_errorMessage ?? '') +
                '\nAdvertencia: El estudiante asignado no está disponible.';
          } else {
            _selectedEstudianteId = null;
          }

          // --- Manejo para idTutor ---
          int? fetchedTutorId = asignacionData['idtutor'];
          if (fetchedTutorId != null &&
              _tutores.any((t) => t['idtutor'] == fetchedTutorId)) {
            _selectedTutorId = fetchedTutorId;
          } else if (fetchedTutorId != null) {
            // El tutor asignado no está en la lista de tutores activos
            print(
              'Advertencia: Tutor ID $fetchedTutorId de la asignación no encontrado en la lista de tutores activos.',
            );
            _errorMessage =
                (_errorMessage ?? '') +
                '\nAdvertencia: El tutor asignado no está disponible.';
          } else {
            _selectedTutorId = null;
          }

          // Otros campos (estado, fechas) no necesitan esta verificación de existencia en dropdown
          _selectedEstado = asignacionData['estado'];
          _fechaAsignacionController.text =
              asignacionData['fechaasignacion'] ?? '';
          _fechaFinalizacionController.text =
              asignacionData['fechafinalizacion'] ?? '';
        } else {
          _errorMessage = 'Asignación no encontrada para edición.';
        }
      }
    } catch (e) {
      _errorMessage = 'Error al cargar datos del formulario: ${e.toString()}';
      print('❌ Error al cargar datos del formulario: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Muestra un selector de fecha y formatea la fecha a 'YYYY-MM-DD'
  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        // Formatear la fecha manualmente a 'YYYY-MM-DD'
        controller.text =
            "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // Maneja el envío del formulario (crear o actualizar)
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        if (widget.idAsignacion == null) {
          final resultado = await _asignacionService.crearAsignacion(
            context: context,
            idProyecto: _selectedProyectoId!,
            idEstudiante: _selectedEstudianteId!,
            idTutor: _selectedTutorId!,
            estado: _selectedEstado!,
            fechaAsignacion: _fechaAsignacionController.text.isNotEmpty
                ? _fechaAsignacionController.text
                : null,
            fechaFinalizacion: _fechaFinalizacionController.text.isNotEmpty
                ? _fechaFinalizacionController.text
                : null,
          );

          if (resultado == null || resultado.containsKey('error')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(resultado?['error'] ?? '❌ Error desconocido'),
                backgroundColor: Colors.red,
                ),
            );
            return;
          }

          // Mostrar advertencia si aplica
          if (resultado.containsKey('advertencia')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(resultado['advertencia']),
                backgroundColor: Colors.orange,
              ),
            );
          }

          // Mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Asignación creada exitosamente!'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pop(context, true);

        } else {
          // Edición
          final Map<String, dynamic> updates = {
            'idproyecto': _selectedProyectoId,
            'idestudiante': _selectedEstudianteId,
            'idtutor': _selectedTutorId,
            'estado': _selectedEstado,
            'fechaasignacion': _fechaAsignacionController.text.isNotEmpty
                ? _fechaAsignacionController.text
                : null,
            'fechafinalizacion': _fechaFinalizacionController.text.isNotEmpty
                ? _fechaFinalizacionController.text
                : null,
          };
          await _asignacionService.actualizarAsignacion(widget.idAsignacion!, updates);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Asignación actualizada exitosamente!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error inesperado: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --- Widgets Auxiliares ---
  Widget _seccion(String titulo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 23,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _campoTexto(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false, // Nuevo parámetro para campos de solo lectura
    VoidCallback? onTap, // Nuevo parámetro para el onTap del campo
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            readOnly: readOnly, // Aplica el modo de solo lectura
            onTap: onTap, // Aplica el onTap
            decoration: inputDecoration.copyWith(hintText: hint),
            validator:
                (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
          ),
        ],
      ),
    );
  }

  // _comboBox para String
  Widget _comboBoxString(
    String label,
    String hint,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: inputDecoration,
            value: value,
            hint: Text(hint),
            items:
                items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
            onChanged: onChanged,
            validator:
                (value) => value == null ? 'Seleccione una opción' : null,
          ),
        ],
      ),
    );
  }

  // Nuevo _comboBox para int (para IDs de Proyecto, Estudiante, Tutor)
  Widget _comboBoxInt({
    required String label,
    required String hint,
    required int? value,
    required List<Map<String, dynamic>> items,
    required String
    idKey, // Clave para el ID en el mapa (ej. 'idproyecto', 'idEstudiante')
    required String
    displayKey, // Clave para el texto a mostrar (ej. 'nombreproyecto', 'nombreDisplay')
    required Function(int?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            decoration: inputDecoration,
            value: value,
            hint: Text(hint),
            items:
                items.map((Map<String, dynamic> item) {
                  return DropdownMenuItem<int>(
                    value: item[idKey],
                    child: Text(
                      item[displayKey]?.toString() ?? 'Error de dato',
                    ),
                  );
                }).toList(),
            onChanged: onChanged,
            validator:
                (value) => value == null ? 'Seleccione una opción' : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 10),
            Text(
              widget.idAsignacion == null
                  ? "Nueva Asignación"
                  : "Editar Asignación",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _seccion("Detalles de la Asignación"),
                      _comboBoxInt(
                        label: "Proyecto",
                        hint: "Seleccionar Proyecto",
                        value: _selectedProyectoId,
                        items: _proyectos,
                        idKey: 'idproyecto',
                        displayKey: 'nombreproyecto',
                        onChanged: (val) {
                          setState(() => _selectedProyectoId = val);
                        },
                      ),
                      _comboBoxInt(
                        label: "Estudiante",
                        hint: "Seleccionar Estudiante",
                        value: _selectedEstudianteId,
                        items: _estudiantes,
                        idKey:
                            'idestudiante', // Usamos 'id' como clave para el ID del estudiante
                        displayKey:
                            'nombre', // Usamos 'nombreDisplay' para el texto
                        onChanged: (val) {
                          setState(() => _selectedEstudianteId = val);
                        },
                      ),
                      _comboBoxInt(
                        label: "Tutor",
                        hint: "Seleccionar Tutor",
                        value: _selectedTutorId,
                        items: _tutores,
                        idKey:
                            'idtutor', // Usamos 'id' como clave para el ID del tutor
                        displayKey:
                            'nombre', // Usamos 'nombreDisplay' para el texto
                        onChanged: (val) {
                          setState(() => _selectedTutorId = val);
                        },
                      ),
                      _campoTexto(
                        "Fecha de Asignación",
                        "YYYY-MM-DD",
                        _fechaAsignacionController,
                        readOnly: true,
                        onTap:
                            () => _selectDate(
                              context,
                              _fechaAsignacionController,
                            ),
                      ),
                      _campoTexto(
                        "Fecha de Finalización (Opcional)",
                        "YYYY-MM-DD",
                        _fechaFinalizacionController,
                        readOnly: true,
                        onTap:
                            () => _selectDate(
                              context,
                              _fechaFinalizacionController,
                            ),
                      ),
                      _comboBoxString(
                        "Estado",
                        "Seleccionar Estado",
                        _selectedEstado,
                        _estados,
                        (val) {
                          setState(() => _selectedEstado = val);
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A90E2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            widget.idAsignacion == null
                                ? "Guardar Asignación"
                                : "Actualizar Asignación",
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
