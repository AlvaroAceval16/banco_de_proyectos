import 'package:flutter/material.dart';

void main() => runApp(FormularioProyectoApp());

class FormularioProyectoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario Proyecto',
      debugShowCheckedModeBanner: false,
      home: FormularioProyecto(),
    );
  }
}

class FormularioProyecto extends StatefulWidget {
  @override
  _FormularioProyectoState createState() => _FormularioProyectoState();
}

class _FormularioProyectoState extends State<FormularioProyecto> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreProyectoController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController apoyoController = TextEditingController();
  final TextEditingController tecnologiasController = TextEditingController();

  String? carreraSeleccionada;
  String? periodoSeleccionado;
  String? tipoProyectoSeleccionado;
  String? plazoSeleccionado;
  String? modalidadSeleccionada;

  final inputDecoration = InputDecoration(
    filled: true,
    fillColor: Color.fromARGB(80, 147, 143, 153),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.menu, color: Colors.black),
            SizedBox(width: 10),
            Text(
              "Formulario de Proyecto",
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
              _campoTexto("Nombre del Proyecto", "Aplicacion web", nombreProyectoController),
              _comboBox("Carrera","ISC", carreraSeleccionada, ["Sistemas", "Industrial", "Electrónica"], (val) {
                setState(() => carreraSeleccionada = val);
              }),
              _campoTexto("Descripción", "Desarrollar una app para la compañia", descripcionController, maxLines: 4),
              _comboBox("Periodo semestral","ENE-JUN", periodoSeleccionado, ["ENE-JUN", "AGO-DIC"], (val) {
                setState(() => periodoSeleccionado = val);
              }),
              _campoTexto("Fecha de Solicitud", "DD/MM/YYYY", fechaController, keyboardType: TextInputType.datetime),

              SizedBox(height: 20),
              _seccion("Detalles del Proyecto"),
              _campoTexto("Tipo de Proyecto", "Base de Datos", TextEditingController()),
              _campoTexto("¿Apoyo económico?", "2000 (mensualmente)", apoyoController),
              _comboBox("Plazos de Entrega","12 meses", plazoSeleccionado, ["1 mes", "2 meses", "3 meses"], (val) {
                setState(() => plazoSeleccionado = val);
              }),
              _campoTexto("Tecnologías", "java", tecnologiasController),
              _comboBox("Modalidad","Presencial", modalidadSeleccionada, ["Presencial", "Virtual", "Mixta"], (val) {
                setState(() => modalidadSeleccionada = val);
              }),

              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Formulario válido")));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4A90E2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _campoTexto(String label, String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
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
            validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
          ),
        ],
      ),
    );
  }

  Widget _comboBox(String label,String elfakinhint2, String? value, List<String> items, Function(String?) onChanged) {
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
            hint: Text(elfakinhint2),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) => value == null ? 'Seleccione una opción' : null,
          ),
        ],
      ),
    );
  }
}