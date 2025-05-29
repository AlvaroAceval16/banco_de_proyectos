import 'package:banco_de_proyectos/back/logica_contactoEmpresa.dart';
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
  final ContactoService _contactoService = ContactoService();

  List<Map<String, dynamic>> _empresasDropdownList = [];
  int? _selectedEmpresaId;
  String? _selectedEmpresaNombre;
  bool _isLoadingEmpresas = true;

  TimeOfDay horaInicio = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay horaFin = TimeOfDay(hour: 17, minute: 0);

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoPaternoController = TextEditingController();
  final TextEditingController apellidoMaternoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController puestoController = TextEditingController();
  final TextEditingController comentariosController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarEmpresas();
  }

  Future<void> _cargarEmpresas() async {
    try {
      final empresas = await ContactoService.getEmpresas(); // Este método debe existir en tu lógica
      setState(() {
        _empresasDropdownList = empresas;
        _isLoadingEmpresas = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingEmpresas = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar empresas: $e')),
      );
    }
  }

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

  Future<void> createContacto() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedEmpresaId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Por favor, seleccione una empresa.")),
        );
        return;
      }

      final String nombre = nombreController.text;
      final String apellidoPaterno = apellidoPaternoController.text;
      final String apellidoMaterno = apellidoMaternoController.text;
      final String telefono = telefonoController.text;
      final String correo = correoController.text;
      final String puesto = puestoController.text;
      final String comentarios = comentariosController.text;

      final String horaInicioStr = horaInicio.format(context); 
      final String horaFinStr = horaFin.format(context);

      try {
        await ContactoService.createContacto(
          nombre: nombre,
          apellidopaterno: apellidoPaterno,
          apellidomaterno: apellidoMaterno,
          telefono: telefono,
          correo: correo,
          puesto: puesto,
          horaInicio: horaInicioStr,
          horaFin: horaFinStr, 
          comentarios: comentarios,
          idempresa: _selectedEmpresaId!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Contacto guardado exitosamente!")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar el contacto: $e")),
        );
      }
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
              Text("Datos del Contacto", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
              SizedBox(height: 15),
              _campoTexto("Nombre del Contacto", "Alvaro", nombreController, inputDecoration),
              _campoTexto("Apellido paterno", "Aceval", apellidoPaternoController, inputDecoration),
              _campoTexto("Apellido materno", "Morales", apellidoMaternoController, inputDecoration),
              _campoTexto("Teléfono de contacto", "6182991675", telefonoController, inputDecoration, keyboardType: TextInputType.phone),
              _campoTexto("Correo electrónico", "morales@empresarial.com", correoController, inputDecoration, keyboardType: TextInputType.emailAddress),
              SizedBox(height: 15),
              Text("Datos de la empresa", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
              SizedBox(height: 15),
              Text("Empresa de origen", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Poppins')),
              SizedBox(height: 15),
              _isLoadingEmpresas
                  ? Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<int>(
                      decoration: inputDecoration.copyWith(hintText: "Seleccionar empresa"),
                      value: _selectedEmpresaId,
                      items: _empresasDropdownList.map((empresa) {
                        return DropdownMenuItem<int>(
                          value: empresa['idempresa'] as int,
                          child: Text(empresa['nombre'] as String),
                        );
                      }).toList(),
                      onChanged: (int? valor) {
                        setState(() {
                          _selectedEmpresaId = valor;
                          _selectedEmpresaNombre = _empresasDropdownList.firstWhere((e) => e['idempresa'] == valor)['nombre'] as String?;
                        });
                      },
                      validator: (value) => value == null ? 'Seleccione una empresa' : null,
                    ),
              SizedBox(height: 10),
              _campoTexto("Puesto/Cargo", "Presidente", puestoController, inputDecoration),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("Horario de atención:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Poppins')),
                  Spacer(),
                  TextButton(
                    onPressed: () => _seleccionarHora(context, true),
                    child: Text("${horaInicio.format(context)}"),
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(80, 147, 143, 153), 
                      foregroundColor: Colors.black, 
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      minimumSize: const Size(120, 48), 
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(" a "),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () => _seleccionarHora(context, false),
                    child: Text("${horaFin.format(context)}"),
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(80, 147, 143, 153), 
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      minimumSize: const Size(120, 48), 
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text("Comentarios", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Poppins')),
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
                  onPressed: createContacto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4A90E2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text("Guardar", style: TextStyle(fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w500, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoTexto(String label, String hint, TextEditingController controller, InputDecoration decoration, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16)),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            decoration: decoration.copyWith(hintText: hint),
            keyboardType: keyboardType,
            validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
          ),
        ],
      ),
    );
  }
}
