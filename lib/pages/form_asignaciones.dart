// lib/pages/form_asignaciones.dart
import 'package:flutter/material.dart';
import 'package:banco_de_proyectos/back/logica_asignaciones.dart';
//import 'package:intl/intl.dart'; // Para formatear fechas

class FormAsignacionesPage extends StatefulWidget {
  // Opcional: Si este formulario también se usa para editar, puedes pasar un ID de asignación
  final int? idAsignacion;

  const FormAsignacionesPage({Key? key, this.idAsignacion}) : super(key: key);

  @override
  State<FormAsignacionesPage> createState() => _FormAsignacionesPageState();
}

class _FormAsignacionesPageState extends State<FormAsignacionesPage> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
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
          _selectedProyectoId = asignacionData['idProyecto'];
          _selectedEstudianteId = asignacionData['idEstudiante'];
          _selectedTutorId = asignacionData['idTutor'];
          _selectedEstado = asignacionData['estado'];
          _fechaAsignacionController.text =
              asignacionData['fechaAsignacion'] != null
                  ? DateFormat(
                    'yyyy-MM-dd',
                  ).format(DateTime.parse(asignacionData['fechaAsignacion']))
                  : '';
          _fechaFinalizacionController.text =
              asignacionData['fechaFinalizacion'] != null
                  ? DateFormat(
                    'yyyy-MM-dd',
                  ).format(DateTime.parse(asignacionData['fechaFinalizacion']))
                  : '';
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

  // Muestra un selector de fecha
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
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
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
          // Modo creación
          await _asignacionService.crearAsignacion(
            idProyecto: _selectedProyectoId!,
            idEstudiante: _selectedEstudianteId!,
            idTutor: _selectedTutorId!,
            estado: _selectedEstado!,
            fechaAsignacion:
                _fechaAsignacionController.text.isNotEmpty
                    ? _fechaAsignacionController.text
                    : null,
            fechaFinalizacion:
                _fechaFinalizacionController.text.isNotEmpty
                    ? _fechaFinalizacionController.text
                    : null,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Asignación creada exitosamente!')),
          );
        } else {
          // Modo edición
          final Map<String, dynamic> updates = {
            'idProyecto': _selectedProyectoId,
            'idEstudiante': _selectedEstudianteId,
            'idTutor': _selectedTutorId,
            'estado': _selectedEstado,
            'fechaAsignacion':
                _fechaAsignacionController.text.isNotEmpty
                    ? _fechaAsignacionController.text
                    : null,
            'fechaFinalizacion':
                _fechaFinalizacionController.text.isNotEmpty
                    ? _fechaFinalizacionController.text
                    : null,
          };
          await _asignacionService.actualizarAsignacion(
            widget.idAsignacion!,
            updates,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Asignación actualizada exitosamente!'),
            ),
          );
        }
        Navigator.pop(context, true); // Regresar a la pantalla anterior
      } catch (e) {
        setState(() {
          _errorMessage = 'Error al guardar asignación: ${e.toString()}';
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
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
      appBar: AppBar(
        title: Text(
          widget.idAsignacion == null
              ? 'Nueva Asignación'
              : 'Editar Asignación',
        ),
        backgroundColor: const Color(0xFF052659),
        foregroundColor: Colors.white,
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
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // Dropdown para Proyecto
                      DropdownButtonFormField<int>(
                        value: _selectedProyectoId,
                        decoration: const InputDecoration(
                          labelText: 'Proyecto',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            _proyectos.map((proyecto) {
                              return DropdownMenuItem<int>(
                                value: proyecto['idproyecto'],
                                child: Text(
                                  proyecto['nombreproyecto'] ?? 'Sin nombre',
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedProyectoId = value;
                          });
                        },
                        validator:
                            (value) =>
                                value == null ? 'Selecciona un proyecto' : null,
                      ),
                      const SizedBox(height: 16),

                      // Dropdown para Estudiante
                      DropdownButtonFormField<int>(
                        value: _selectedEstudianteId,
                        decoration: const InputDecoration(
                          labelText: 'Estudiante',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            _estudiantes.map((estudiante) {
                              return DropdownMenuItem<int>(
                                value: estudiante['id'],
                                child: Text(
                                  estudiante['nombreDisplay'] ?? 'Sin nombre',
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedEstudianteId = value;
                          });
                        },
                        validator:
                            (value) =>
                                value == null
                                    ? 'Selecciona un estudiante'
                                    : null,
                      ),
                      const SizedBox(height: 16),

                      // Dropdown para Tutor
                      DropdownButtonFormField<int>(
                        value: _selectedTutorId,
                        decoration: const InputDecoration(
                          labelText: 'Tutor',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            _tutores.map((tutor) {
                              return DropdownMenuItem<int>(
                                value: tutor['id'],
                                child: Text(
                                  tutor['nombreDisplay'] ?? 'Sin nombre',
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTutorId = value;
                          });
                        },
                        validator:
                            (value) =>
                                value == null ? 'Selecciona un tutor' : null,
                      ),
                      const SizedBox(height: 16),

                      // Campo de fecha de asignación
                      TextFormField(
                        controller: _fechaAsignacionController,
                        decoration: InputDecoration(
                          labelText: 'Fecha de Asignación',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed:
                                () => _selectDate(
                                  context,
                                  _fechaAsignacionController,
                                ),
                          ),
                        ),
                        readOnly:
                            true, // Para que el usuario no pueda escribir directamente
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            // Si la DB tiene DEFAULT CURRENT_DATE, este campo podría no ser requerido en la UI
                            // Pero si quieres que el usuario lo seleccione, déjalo así.
                            return 'Selecciona una fecha de asignación';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo de fecha de finalización (opcional)
                      TextFormField(
                        controller: _fechaFinalizacionController,
                        decoration: InputDecoration(
                          labelText: 'Fecha de Finalización (Opcional)',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed:
                                () => _selectDate(
                                  context,
                                  _fechaFinalizacionController,
                                ),
                          ),
                        ),
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),

                      // Dropdown para Estado
                      DropdownButtonFormField<String>(
                        value: _selectedEstado,
                        decoration: const InputDecoration(
                          labelText: 'Estado',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            _estados.map((estado) {
                              return DropdownMenuItem<String>(
                                value: estado,
                                child: Text(estado),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedEstado = value;
                          });
                        },
                        validator:
                            (value) =>
                                value == null ? 'Selecciona un estado' : null,
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5285E8),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          widget.idAsignacion == null
                              ? 'Guardar Asignación'
                              : 'Actualizar Asignación',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
