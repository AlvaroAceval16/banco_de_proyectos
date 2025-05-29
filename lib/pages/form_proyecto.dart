import 'package:flutter/material.dart';
// Importa tu clase de servicio de proyecto
import 'package:banco_de_proyectos/back/logica_proyectos.dart'; // Ajusta la ruta si es necesario

class FormularioProyectoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario Proyecto',
      debugShowCheckedModeBanner: false,
      home: FormularioProyecto(), // Renombra tu clase de formulario aquí
    );
  }
}

class FormularioProyecto extends StatefulWidget {
  // Renombra tu clase de formulario aquí
  @override
  _FormularioProyectoState createState() => _FormularioProyectoState();
}

class _FormularioProyectoState extends State<FormularioProyecto> {
  final _formKey = GlobalKey<FormState>();
  final ProyectoService _proyectoService =
      ProyectoService(); // Instancia de tu servicio

  // Variables de estado para el dropdown de empresas
  List<Map<String, dynamic>> _empresasDropdownList = [];
  int? _selectedEmpresaId; // Aquí guardaremos el ID de la empresa seleccionada
  String?
  _selectedEmpresaNombre; // Opcional: para mostrar el nombre seleccionado
  bool _isLoadingEmpresas = true; // Para manejar el estado de carga de empresas

  // Controladores para los campos de texto del PROYECTO (ejemplo)
  final TextEditingController nombreProyectoController =
      TextEditingController();
  final TextEditingController descripcionProyectoController =
      TextEditingController();
  final TextEditingController tecnologiasController = TextEditingController();
  final TextEditingController apoyoEconomicoController =
      TextEditingController();
  final TextEditingController plazosEntregaController = TextEditingController();
  // ... más controladores para campos de proyecto como modalidad, carrera, etc.

  // Variables para los Dropdowns de proyecto (ejemplo)
  String? _selectedModalidad;
  String? _selectedCarrera;
  String? _selectedPeriodo;

  // Ya tienes estas si las necesitas para el proyecto (ejemplo de la hora, pero para proyecto no aplica)
  // TimeOfDay horaInicio = TimeOfDay(hour: 9, minute: 0);
  // TimeOfDay horaFin = TimeOfDay(hour: 17, minute: 0);

  @override
  void initState() {
    super.initState();
    _fetchEmpresasForDropdown(); // Cargar empresas al iniciar el formulario
    // ... inicializar otros controladores de proyecto si es necesario
  }

  @override
  void dispose() {
    // Disponer controladores de proyecto
    nombreProyectoController.dispose();
    descripcionProyectoController.dispose();
    tecnologiasController.dispose();
    apoyoEconomicoController.dispose();
    plazosEntregaController.dispose();
    super.dispose();
  }

  // Nuevo método para cargar la lista de empresas para el Dropdown
  Future<void> _fetchEmpresasForDropdown() async {
    setState(() {
      _isLoadingEmpresas = true;
    });
    try {
      final empresas = await ProyectoService.obtenerEmpresasParaDropdown();
      setState(() {
        _empresasDropdownList = empresas;
        _isLoadingEmpresas = false;
      });
    } catch (e) {
      print('Error al cargar empresas para el dropdown: $e');
      setState(() {
        _isLoadingEmpresas = false;
        // Puedes mostrar un SnackBar o AlertDialog si hay un error
      });
    }
  }

  // Método para guardar el proyecto
  Future<void> _guardarProyecto() async {
    if (_formKey.currentState!.validate()) {
      // Validar que se haya seleccionado una empresa
      if (_selectedEmpresaId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Por favor, seleccione una empresa.")),
        );
        return;
      }

      // Ejemplo de datos a guardar (adapta esto a tus campos reales del proyecto)
      final String nombre = nombreProyectoController.text;
      final String descripcion = descripcionProyectoController.text;
      final String tecnologias = tecnologiasController.text;
      final String apoyoEconomico = apoyoEconomicoController.text;
      final String plazosEntrega = plazosEntregaController.text;
      final String fechasolicitud =
          DateTime.now().toIso8601String(); // Fecha actual

      try {
        await _proyectoService.guardarProyecto(
          nombre: nombre,
          descripcion: descripcion,
          modalidad:
              _selectedModalidad, // Asegúrate de tener un dropdown para esto
          carrera: _selectedCarrera, // Asegúrate de tener un dropdown para esto
          periodo: _selectedPeriodo, // Asegúrate de tener un dropdown para esto
          fechasolicitud: fechasolicitud,
          apoyoeconomico: apoyoEconomico,
          plazosentrega: plazosEntrega,
          tecnologias: tecnologias,
          idempresa:
              _selectedEmpresaId, // <--- EL ID DE LA EMPRESA SELECCIONADA
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Proyecto guardado exitosamente!")),
        );
        Navigator.pop(context); // Regresar a la pantalla anterior
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar el proyecto: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: const Color.fromARGB(80, 147, 143, 153),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              // Agregamos un botón de regreso
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 10),
            const Text(
              "Registro de Proyecto", // Título para el formulario de proyecto
              style: TextStyle(
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
          _isLoadingEmpresas
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Campos para el Proyecto (ejemplos) ---
                      const Text(
                        "Datos del Proyecto",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _campoTexto(
                        "Nombre del Proyecto",
                        "Proyecto X",
                        nombreProyectoController,
                        inputDecoration,
                      ),
                      _campoTexto(
                        "Descripción",
                        "Descripción detallada del proyecto",
                        descripcionProyectoController,
                        inputDecoration,
                        maxLines: 3,
                      ),
                      _campoTexto(
                        "Tecnologías",
                        "Flutter, Dart, Supabase",
                        tecnologiasController,
                        inputDecoration,
                      ),
                      _campoTexto(
                        "Apoyo Económico",
                        "\$5000",
                        apoyoEconomicoController,
                        inputDecoration,
                      ),
                      _campoTexto(
                        "Plazos de Entrega",
                        "3 meses",
                        plazosEntregaController,
                        inputDecoration,
                      ),

                      // --- Dropdown para Modalidad (ejemplo) ---
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: inputDecoration.copyWith(
                          hintText: "Modalidad",
                        ),
                        value: _selectedModalidad,
                        items:
                            ["Presencial", "Remoto", "Hibrida"].map((
                              String modalidad,
                            ) {
                              return DropdownMenuItem<String>(
                                value: modalidad,
                                child: Text(modalidad),
                              );
                            }).toList(),
                        onChanged: (valor) {
                          setState(() {
                            _selectedModalidad = valor;
                          });
                        },
                        validator:
                            (value) =>
                                value == null
                                    ? 'Seleccione una modalidad'
                                    : null,
                      ),
                      // --- Dropdown para Carrera (ejemplo) ---
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: inputDecoration.copyWith(
                          hintText: "Carrera",
                        ),
                        value: _selectedCarrera,
                        items:
                            [
                              "Ing. Sistemas",
                              "Ing en TICS",
                              "Ing. Informática",
                            ].map((String carrera) {
                              return DropdownMenuItem<String>(
                                value: carrera,
                                child: Text(carrera),
                              );
                            }).toList(),
                        onChanged: (valor) {
                          setState(() {
                            _selectedCarrera = valor;
                          });
                        },
                        validator:
                            (value) =>
                                value == null ? 'Seleccione una carrera' : null,
                      ),
                      // --- Dropdown para Periodo (ejemplo) ---
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: inputDecoration.copyWith(
                          hintText: "Periodo",
                        ),
                        value: _selectedPeriodo,
                        items:
                            ["Enero-Junio", "Agosto-Diciembre"].map((
                              String periodo,
                            ) {
                              return DropdownMenuItem<String>(
                                value: periodo,
                                child: Text(periodo),
                              );
                            }).toList(),
                        onChanged: (valor) {
                          setState(() {
                            _selectedPeriodo = valor;
                          });
                        },
                        validator:
                            (value) =>
                                value == null ? 'Seleccione un periodo' : null,
                      ),

                      // --- Sección de Datos de Empresa ---
                      const SizedBox(height: 20),
                      const Text(
                        "Datos de Empresa",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // --- Dropdown para SELECCIONAR EMPRESA ---
                      DropdownButtonFormField<int>(
                        // El tipo del valor es int (el ID de la empresa)
                        decoration: inputDecoration.copyWith(
                          hintText: "Empresa",
                        ),
                        value: _selectedEmpresaId, // Usa el ID seleccionado
                        items:
                            _empresasDropdownList.map((
                              Map<String, dynamic> empresa,
                            ) {
                              return DropdownMenuItem<int>(
                                value:
                                    empresa['idempresa']
                                        as int, // El valor es el ID de la empresa
                                child: Text(
                                  empresa['nombre'] as String,
                                ), // Muestra el nombre
                              );
                            }).toList(),
                        onChanged: (int? valor) {
                          setState(() {
                            _selectedEmpresaId = valor;
                            // Opcional: Si quieres guardar el nombre también
                            _selectedEmpresaNombre =
                                _empresasDropdownList.firstWhere(
                                      (e) => e['idempresa'] == valor,
                                    )['nombre']
                                    as String?;
                          });
                        },
                        validator:
                            (value) =>
                                value == null ? 'Seleccione una empresa' : null,
                      ),

                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _guardarProyecto, // Llama al nuevo método de guardar
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A90E2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            "Guardar Proyecto",
                            style: TextStyle(
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

  // Función auxiliar para los campos de texto
  Widget _campoTexto(
    String label,
    String hintText,
    TextEditingController controller,
    InputDecoration decoration, {
    TextInputType keyboardType = TextInputType.text,
    int? maxLines = 1,
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
            decoration: decoration.copyWith(hintText: hintText),
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator:
                (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
          ),
        ],
      ),
    );
  }
}