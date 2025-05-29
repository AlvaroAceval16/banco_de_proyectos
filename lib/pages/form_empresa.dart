import 'package:banco_de_proyectos/back/logica_empresas.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
final _empresaService = EmpresaService();
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

  String? sectorSeleccionado;
  String? tamanoSeleccionado;
  String? estadoSeleccionado;
  String? ciudadSeleccionada;

  Future<void> guardarEmpresa() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _empresaService.guardarEmpresa(
          nombre: nombreEmpresaController.text,
          descripcion: descripcionController.text,
          sector: sectorSeleccionado,
          giro: giroController.text,
          tamano: tamanoSeleccionado,
          rfc: rfcController.text,
          cp: cpController.text,
          pais: "México", // Asumiendo que el país es México
          ciudad: ciudadSeleccionada ?? "Ciudad no seleccionada",
          estado: estadoSeleccionado ?? "Estado no seleccionado",
          direccion: direccionController.text,
          telefono: "1234567890", // Placeholder
          fecha_registro: DateTime.now().toIso8601String(),
          convenio: true,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Empresa guardada correctamente')),
        );

        // Opcional: Limpiar el formulario después de guardar
        _formKey.currentState?.reset();

        // Opcional: Navegar a otra pantalla
        // Navigator.pop(context);
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

              _seccion("Ubicación"),
              _campoTexto("CP", "58000", cpController),
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
