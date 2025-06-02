import 'package:banco_de_proyectos/back/logica_empresas.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// These global variables are generally discouraged in larger apps
// but kept here for consistency with your provided snippet.
final supabase = Supabase.instance.client;
final _empresaService = EmpresaService();

// The main function and MaterialApp are typically in main.dart
// I'm keeping them here for completeness as per your example,
// but if this is a sub-page, you'd remove them.
void main() => runApp(FormularioEmpresaApp());

class FormularioEmpresaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario Empresa',
      debugShowCheckedModeBanner: false,
      home: FormularioEmpresa(),
    );
  }
}

class FormularioEmpresa extends StatefulWidget {
  @override
  _FormularioEmpresaState createState() => _FormularioEmpresaState();
}

class _FormularioEmpresaState extends State<FormularioEmpresa> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreEmpresaController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController giroController = TextEditingController();
  final TextEditingController rfcController = TextEditingController();
  final TextEditingController cpController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController telefonoController =
      TextEditingController(); // NEW: Phone Controller
  final TextEditingController otroPaisController =
      TextEditingController(); // NEW: Otro País Controller
  final TextEditingController ciudadManualController =
      TextEditingController(); // NEW: Ciudad Manual Controller
  final TextEditingController estadoManualController =
      TextEditingController(); // NEW: Estado Manual Controller

  String? sectorSeleccionado;
  String? tamanoSeleccionado;
  String? estadoSeleccionado; // Used for Mexico
  String? ciudadSeleccionada; // Used for Mexico
  String? paisSeleccionado = "México"; // NEW: Default to México

  bool _tieneConvenio = false; // Checkbox state

  @override
  void initState() {
    super.initState();
    // Initialize controllers with empty text
    nombreEmpresaController.text = '';
    descripcionController.text = '';
    giroController.text = '';
    rfcController.text = '';
    cpController.text = '';
    direccionController.text = '';
    telefonoController.text = '';
    otroPaisController.text = '';
    ciudadManualController.text = '';
    estadoManualController.text = '';
  }

  @override
  void dispose() {
    nombreEmpresaController.dispose();
    descripcionController.dispose();
    giroController.dispose();
    rfcController.dispose();
    cpController.dispose();
    direccionController.dispose();
    telefonoController.dispose(); // Dispose phone controller
    otroPaisController.dispose(); // Dispose otroPais controller
    ciudadManualController.dispose(); // Dispose ciudadManual controller
    estadoManualController.dispose(); // Dispose estadoManual controller
    super.dispose();
  }

  Future<void> guardarEmpresa() async {
    if (_formKey.currentState!.validate()) {
      try {
        String finalPais =
            paisSeleccionado == "Extranjero"
                ? otroPaisController.text
                : "México";
        String finalCiudad =
            paisSeleccionado == "Extranjero"
                ? ciudadManualController.text
                : (ciudadSeleccionada ?? "N/A");
        String finalEstado =
            paisSeleccionado == "Extranjero"
                ? estadoManualController.text
                : (estadoSeleccionado ?? "N/A");

        await _empresaService.guardarEmpresa(
          nombre: nombreEmpresaController.text,
          descripcion: descripcionController.text,
          sector: sectorSeleccionado,
          giro: giroController.text,
          tamano: tamanoSeleccionado,
          rfc: rfcController.text,
          cp: cpController.text,
          pais: finalPais, // Dynamic country
          ciudad: finalCiudad, // Dynamic city
          estado: finalEstado, // Dynamic state
          direccion: direccionController.text,
          telefono: telefonoController.text, // Use actual phone
          fecha_registro: DateTime.now().toIso8601String(),
          convenio: _tieneConvenio,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Empresa guardada correctamente')),
        );

        _formKey.currentState?.reset();
        setState(() {
          sectorSeleccionado = null;
          tamanoSeleccionado = null;
          estadoSeleccionado = null;
          ciudadSeleccionada = null;
          paisSeleccionado = "México"; // Reset country to Mexico
          _tieneConvenio = false;
          // Clear manual text controllers
          otroPaisController.text = '';
          ciudadManualController.text = '';
          estadoManualController.text = '';
          telefonoController.text = '';
        });
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Error: ${e.toString()}')));
      }
    }
  }

  final inputDecoration = InputDecoration(
    filled: true,
    fillColor: Color(0xFFF3F3F3),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    ),
  );

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
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(width: 10),
            Text(
              "Empresa",
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _seccion("Datos Básicos"),
              _campoTexto(
                "Nombre de la empresa",
                "Nombre S.A. de C.V.",
                nombreEmpresaController,
              ),
              _campoTexto(
                "Descripción",
                "Descripción general de la empresa",
                descripcionController,
                maxLines: 4,
              ),

              _seccion("Detalles de la Empresa"),
              _comboBox(
                "Sector/Industria",
                "Seleccionar",
                sectorSeleccionado,
                ["Tecnología", "Manufactura", "Servicios", "Otro"],
                (val) {
                  setState(() => sectorSeleccionado = val);
                },
              ),
              _campoTexto(
                "Giro de la empresa",
                "Comercialización de software",
                giroController,
              ),
              _comboBox(
                "Tamaño de la empresa",
                "Seleccionar",
                tamanoSeleccionado,
                ["Micro", "Pequeña", "Mediana", "Grande"],
                (val) {
                  setState(() => tamanoSeleccionado = val);
                },
              ),
              _campoTexto("RFC", "ABC123456789", rfcController),
              _campoTexto(
                "Teléfono",
                "Ej. 5512345678",
                telefonoController,
                keyboardType: TextInputType.phone,
              ), // NEW: Phone field
              // Checkbox for convenio
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Checkbox(
                      value: _tieneConvenio,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _tieneConvenio = newValue ?? false;
                        });
                      },
                      activeColor: Color(0xFF4A90E2),
                    ),
                    const Text(
                      "Tiene Convenio",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              _seccion("Ubicación"),
              // NEW: País ComboBox
              _comboBox(
                "País",
                "Seleccionar País",
                paisSeleccionado,
                ["México", "Extranjero"],
                (val) {
                  setState(() {
                    paisSeleccionado = val;
                    // Reset city/state selections if country changes
                    if (val == "Extranjero") {
                      estadoSeleccionado = null;
                      ciudadSeleccionada = null;
                    } else {
                      otroPaisController.text = ''; // Clear other country field
                      ciudadManualController.text = '';
                      estadoManualController.text = '';
                    }
                  });
                },
              ),
              // NEW: Conditional "Cual?" field for Extranjero
              if (paisSeleccionado == "Extranjero")
                _campoTexto(
                  "¿Cuál país?",
                  "Ej. Estados Unidos",
                  otroPaisController,
                ),

              _campoTexto("CP", "58000", cpController),

              // NEW: Conditional fields for Estado and Ciudad
              if (paisSeleccionado == "México") ...[
                _comboBox(
                  "Estado",
                  "Seleccionar",
                  estadoSeleccionado,
                  ["Michoacán", "Jalisco", "CDMX", "Nuevo León"],
                  (val) {
                    setState(() => estadoSeleccionado = val);
                  },
                ),
                _comboBox(
                  "Ciudad",
                  "Seleccionar",
                  ciudadSeleccionada,
                  ["Morelia", "Guadalajara", "Monterrey", "CDMX"],
                  (val) {
                    setState(() => ciudadSeleccionada = val);
                  },
                ),
              ] else ...[
                _campoTexto(
                  "Estado/Provincia (Extranjero)",
                  "Ej. California",
                  estadoManualController,
                ),
                _campoTexto(
                  "Ciudad (Extranjero)",
                  "Ej. Los Ángeles",
                  ciudadManualController,
                ),
              ],

              _campoTexto(
                "Dirección",
                "Av. Tecnológico 1234",
                direccionController,
              ),

              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Formulario válido")),
                      );
                      guardarEmpresa();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4A90E2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    "Guardar",
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

  Widget _seccion(String titulo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: TextStyle(
            fontSize: 23,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _campoTexto(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: inputDecoration.copyWith(hintText: hint),
            validator:
                (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
          ),
        ],
      ),
    );
  }

  Widget _comboBox(
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
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
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
}
