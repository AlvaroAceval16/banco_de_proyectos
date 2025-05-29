import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:banco_de_proyectos/classes/proyecto.dart';
import 'package:banco_de_proyectos/back/logica_proyectos.dart'; 

class InfoProyecto extends StatefulWidget {
  final Proyecto proyecto;

  const InfoProyecto({Key? key, required this.proyecto}) : super(key: key);

  @override
  State<InfoProyecto> createState() => _InfoProyectoState();
}

class _InfoProyectoState extends State<InfoProyecto> {
  // Estado para controlar el modo de edición
  bool _isEditing = false;
  // Mensaje de error para la UI
  String? _errorMessage;

  // Controladores para los campos de texto
  late TextEditingController _nombreProyectoController;
  late TextEditingController _descripcionController;
  late TextEditingController _modalidadController;
  late TextEditingController _carrerasController;
  late TextEditingController _periodoController;
  late TextEditingController _fechaSolicitudController;
  late TextEditingController _apoyoEconomicoController;
  late TextEditingController _plazosEntregaController;
  late TextEditingController _tecnologiasController;

  // Future para la información de la empresa (se mantiene el fix de maybeSingle)
  late Future<Map<String, String>> _empresaInfoFuture;

  // Instancia del servicio para interactuar con Supabase
  final ProyectoService _proyectoService = ProyectoService();

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los datos actuales del proyecto
    _nombreProyectoController = TextEditingController(
      text: widget.proyecto.nombreProyecto,
    );
    _descripcionController = TextEditingController(
      text: widget.proyecto.descripcion,
    );
    _modalidadController = TextEditingController(
      text: widget.proyecto.modalidad,
    );
    _carrerasController = TextEditingController(text: widget.proyecto.carreras);
    _periodoController = TextEditingController(text: widget.proyecto.periodo);
    _fechaSolicitudController = TextEditingController(
      text: widget.proyecto.fechaSolicitud,
    );
    _apoyoEconomicoController = TextEditingController(
      text: widget.proyecto.apoyoEconomico,
    );
    _plazosEntregaController = TextEditingController(
      text: widget.proyecto.plazosEntrega,
    );
    _tecnologiasController = TextEditingController(
      text: widget.proyecto.tecnologias,
    );

    // Cargar la información de la empresa (con el fix de maybeSingle)
    _empresaInfoFuture = _obtenerEmpresa(widget.proyecto.idEmpresa);
  }

  // --- Fix para obtenerEmpresa (ya corregido en la respuesta anterior) ---
  Future<Map<String, String>> _obtenerEmpresa(int idEmpresa) async {
    try {
      final response =
          await Supabase.instance.client
              .from('empresas')
              .select('nombre, descripcion')
              .eq('idempresa', idEmpresa)
              .maybeSingle(); // Usamos maybeSingle para manejar 0 o 1 resultado

      if (response == null) {
        return {
          'nombre': 'Empresa no disponible',
          'descripcion': 'No se encontró la información de la empresa.',
        };
      } else {
        return {
          'nombre': response['nombre'] ?? 'Desconocido',
          'descripcion': response['descripcion'] ?? 'Sin descripción',
        };
      }
    } on PostgrestException catch (e) {
      print('❌ Error de PostgREST al obtener empresa: ${e.message}');
      return {
        'nombre': 'Error de carga',
        'descripcion': 'Hubo un problema con la base de datos.',
      };
    } catch (e) {
      print('❌ Error inesperado al obtener empresa: $e');
      return {
        'nombre': 'Error',
        'descripcion': 'No se pudo cargar la información de la empresa.',
      };
    }
  }

  @override
  void dispose() {
    // Es crucial liberar los controladores cuando el widget ya no se usa
    _nombreProyectoController.dispose();
    _descripcionController.dispose();
    _modalidadController.dispose();
    _carrerasController.dispose();
    _periodoController.dispose();
    _fechaSolicitudController.dispose();
    _apoyoEconomicoController.dispose();
    _plazosEntregaController.dispose();
    _tecnologiasController.dispose();
    super.dispose();
  }

  // Método para guardar los cambios
  Future<void> _guardarCambios() async {
    setState(() {
      _errorMessage = null; // Limpiar cualquier mensaje de error anterior
    });
    try {
      await _proyectoService.actualizarProyecto(
        idproyecto: widget.proyecto.idProyecto,
        nombre: _nombreProyectoController.text,
        descripcion: _descripcionController.text,
        modalidad: _modalidadController.text,
        carrera: _carrerasController.text,
        periodo: _periodoController.text,
        apoyoeconomico: _apoyoEconomicoController.text,
        plazosentrega: _plazosEntregaController.text,
        tecnologias: _tecnologiasController.text,
        // fechaSolicitud no se actualiza aquí, es un campo de creación.
        // Si necesitas actualizarla, agrégala al ProjectService y aquí.
      );

      // Una vez que los cambios se guardan, salimos del modo de edición
      setState(() {
        _isEditing = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Proyecto actualizado con éxito')),
        );
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al guardar cambios: ${e.toString()}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar cambios: ${e.toString()}')),
      );
    }
  }

  // Método para la eliminación lógica (ya tenías uno, lo integramos aquí)
  Future<void> _confirmarEliminacionLogica() async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text(
            '¿Estás seguro de que quieres eliminar lógicamente este proyecto?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      try {
        await _proyectoService.eliminarProyectoinfoLogic(
          widget.proyecto.idProyecto,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proyecto eliminado lógicamente con éxito'),
          ),
        );
        Navigator.pop(
          context,
        ); // Regresar a la pantalla anterior después de eliminar
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el proyecto: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ya no necesitas obtener proyecto de widget.proyecto directamente para mostrar,
    // ya que los controladores ahora gestionan los valores editables.
    // Pero aún lo necesitamos para el ID y para pasar al _infoItem.
    final proyecto = widget.proyecto;

    return Scaffold(
      backgroundColor: const Color(0xFF052659),
      // Cambiar el FloatingActionButton según el modo de edición
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_isEditing) {
              // Si ya estamos editando, este botón ahora guarda
              _guardarCambios();
            } else {
              // Si no estamos editando, este botón activa el modo de edición
              _isEditing = true;
            }
          });
        },
        backgroundColor: const Color(0xFF5285E8),
        child: Icon(
          _isEditing
              ? Icons.save
              : Icons.edit, // Cambia el icono a guardar o editar
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF052659),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Mostrar botón de cancelar edición solo si estamos editando
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.white),
              onPressed: () {
                setState(() {
                  // Volver al estado original del proyecto y salir del modo edición
                  _nombreProyectoController.text =
                      widget.proyecto.nombreProyecto;
                  _descripcionController.text = widget.proyecto.descripcion;
                  _modalidadController.text = widget.proyecto.modalidad;
                  _carrerasController.text = widget.proyecto.carreras;
                  _periodoController.text = widget.proyecto.periodo;
                  _fechaSolicitudController.text =
                      widget.proyecto.fechaSolicitud;
                  _apoyoEconomicoController.text =
                      widget.proyecto.apoyoEconomico;
                  _plazosEntregaController.text = widget.proyecto.plazosEntrega;
                  _tecnologiasController.text = widget.proyecto.tecnologias;
                  _isEditing = false;
                  _errorMessage = null; // Limpiar mensaje de error
                });
              },
            ),
          // Botón de eliminar (se mantiene como PopupMenuButton)
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'delete') {
                _confirmarEliminacionLogica();
              }
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Eliminar Proyecto'),
                  ),
                ],
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF052659),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    bottom: 30,
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Nombre del Proyecto (Editable)
                      _buildEditableText(
                        controller: _nombreProyectoController,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Descripción (Editable)
                      _buildEditableText(
                        controller: _descripcionController,
                        maxLines: null, // Permite múltiples líneas
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Usamos _buildInfoItemEditable para los campos editables
                          _buildInfoItemEditable(
                            label: "Modalidad",
                            controller: _modalidadController,
                          ),
                          _buildInfoItemEditable(
                            label: "Carrera",
                            controller: _carrerasController,
                          ),
                          _buildInfoItemEditable(
                            label: "Periodo",
                            controller: _periodoController,
                          ),
                          // Fecha de solicitud probablemente no sea editable
                          _infoItem(
                            "Fecha de solicitud",
                            proyecto.fechaSolicitud,
                          ),
                          _buildInfoItemEditable(
                            label: "Apoyo económico",
                            controller: _apoyoEconomicoController,
                          ),
                          _buildInfoItemEditable(
                            label: "Plazos de entrega",
                            controller: _plazosEntregaController,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                        "Información Adicional",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 25),
                      FutureBuilder<Map<String, String>>(
                        future: _empresaInfoFuture, // Usamos el Future guardado
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return const Text("Error al cargar la empresa");
                          } else {
                            final empresa = snapshot.data!;
                            return InfoCard(
                              label: "Empresa",
                              title: empresa['nombre']!,
                              subtitle: empresa['descripcion']!,
                              icon: Icons.business,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      // Tecnologías utilizadas (Editable)
                      InfoCard(
                        label: "Tecnologías utilizadas",
                        title:
                            _tecnologiasController
                                .text, // Muestra el texto del controlador
                        subtitle:
                            _isEditing
                                ? "Edita las tecnologías"
                                : "Tecnologías del proyecto", // Subtítulo cambia en modo edición
                        icon: Icons.code,
                        isEditable:
                            _isEditing, // Pasa el estado de edición al InfoCard
                        textController:
                            _tecnologiasController, // Pasa el controlador
                      ),
                      const SizedBox(height: 20),
                      InfoCard(
                        label: "Residente",
                        title: "No disponible",
                        subtitle: "Número de control: N/A",
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 20),
                      InfoCard(
                        label: "Asesor",
                        title: "No disponible",
                        subtitle: "Número de control: N/A",
                        icon: Icons.school,
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

  // Widget para mostrar texto editable o estático
  Widget _buildEditableText({
    required TextEditingController controller,
    TextStyle? style,
    int? maxLines,
  }) {
    return _isEditing
        ? TextFormField(
          controller: controller,
          style: style?.copyWith(
            color: Colors.white,
          ), // Asegura que el texto editable también sea blanco
          maxLines: maxLines,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ), // Sin borde por defecto
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Colors.blueAccent,
                width: 2.0,
              ), // Borde cuando está enfocado
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(
              0.1,
            ), // Un poco de fondo para destacar
            hintStyle: style?.copyWith(color: Colors.white54),
          ),
        )
        : Text(controller.text, style: style);
  }

  // Widget para mostrar items de información con edición en línea
  Widget _buildInfoItemEditable({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child:
                _isEditing
                    ? TextFormField(
                      controller: controller,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                            width: 1.0,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                      ),
                    )
                    : Text(
                      controller.text,
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

  // Widget _infoItem para campos no editables (como la fecha de solicitud)
  Widget _infoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
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
}

// --- CLASE INFOCARD MODIFICADA ---
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.label,
    this.isEditable = false, // Nuevo parámetro para controlar si es editable
    this.textController, // Nuevo parámetro para el controlador de texto si es editable
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String label;
  final bool isEditable;
  final TextEditingController?
  textController; // Puede ser nulo si no es editable

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          color: Theme.of(context).cardColor,
          child: ListTile(
            leading: Icon(icon),
            title:
                isEditable && textController != null
                    ? TextFormField(
                      controller: textController,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        border:
                            InputBorder
                                .none, // Eliminar el borde del TextFormField
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    )
                    : Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            subtitle: Text(
              subtitle,
              style: TextStyle(fontFamily: 'Poppins', color: Colors.grey[600]),
            ),
          ),
        ),
      ],
    );
  }
}