import 'package:flutter/material.dart';

void main() => runApp(FormularioContactoEmpresaApp());

class FormularioContactoEmpresaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario Contacto Empresa',
      debugShowCheckedModeBanner: false,
      home: FormularioContactoEmpresa(),
    );
  }
}

class FormularioContactoEmpresa extends StatefulWidget {
  @override
  _FormularioContactoEmpresaState createState() => _FormularioContactoEmpresaState();
}

class _FormularioContactoEmpresaState extends State<FormularioContactoEmpresa> {
  final _formKey = GlobalKey<FormState>();
  String? empresaSeleccionada;
  TimeOfDay horaInicio = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay horaFin = TimeOfDay(hour: 17, minute: 0);

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoPaternoController = TextEditingController();
  final TextEditingController apellidoMaternoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController puestoController = TextEditingController();
  final TextEditingController comentariosController = TextEditingController();

  Future<void> _seleccionarHora(BuildContext context, bool esInicio) async {
    final TimeOfDay? nuevaHora = await showTimePicker(
      context: context,
      initialTime: esInicio ? horaInicio : horaFin,
    );
    if (nuevaHora != null) {
      setState(() {
        if (esInicio) {
          horaInicio = nuevaHora;
        } else {
          horaFin = nuevaHora;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Color.fromARGB(80, 147, 143, 153),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
    );

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
        "Contacto Empresarial",
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600, // SemiBold
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
              Text(
                   "Datos del Contacto",
                    style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                     ),
                  ),
              SizedBox(height: 10),
              _campoTexto("Nombre del Contacto", "Alvaro",nombreController, inputDecoration),
              _campoTexto("Apellido paterno", "Aceval",apellidoPaternoController, inputDecoration),
              _campoTexto("Apellido materno", "Morales",apellidoMaternoController, inputDecoration),
              _campoTexto("Teléfono de contacto", "6182991675",telefonoController, inputDecoration, keyboardType: TextInputType.phone),
              _campoTexto("Correo electrónico", "morales@empresarial.com",correoController, inputDecoration, keyboardType: TextInputType.emailAddress),
              SizedBox(height: 20),
              Text("Datos de Empresa",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                     ),
                  ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: inputDecoration,
                value: empresaSeleccionada,
                hint: Text("Empresa"),
                items: ["Empresa 1", "Empresa 2", "Empresa 3"].map((String empresa) {
                  return DropdownMenuItem<String>(
                    value: empresa,
                    child: Text(empresa),
                  );
                }).toList(),
                onChanged: (valor) {
                  setState(() {
                    empresaSeleccionada = valor;
                  });
                },
                validator: (value) => value == null ? 'Seleccione una empresa' : null,
              ),
              SizedBox(height: 10),
              _campoTexto("Puesto/Cargo", "Presidente",puestoController, inputDecoration),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("Horario de atención:", style: TextStyle(fontWeight: FontWeight.w500)),
                  Spacer(),
                  TextButton(
                    onPressed: () => _seleccionarHora(context, true),
                    child: Text("de ${horaInicio.format(context)}"),
                  ),
                  Text(" a "),
                  TextButton(
                    onPressed: () => _seleccionarHora(context, false),
                    child: Text("${horaFin.format(context)}"),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text("Comentarios:"),
              SizedBox(height: 5),
              TextFormField(
                controller: comentariosController,
                decoration: inputDecoration.copyWith(hintText: "Escribe tus comentarios"),
                maxLines: 4,
                validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Aquí puedes guardar los datos
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoTexto(String label,String elfakinhint, TextEditingController controller, InputDecoration decoration,
    {TextInputType keyboardType = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 1),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500, // Medium
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: decoration.copyWith(hintText: elfakinhint),
          keyboardType: keyboardType,
          validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
          ),
        ],
      ),
    );
  }
}