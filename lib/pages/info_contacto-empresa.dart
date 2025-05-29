import 'package:banco_de_proyectos/back/logica_contactoEmpresa.dart';
import 'package:banco_de_proyectos/classes/contacto_empresa.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class InfoContactoEmpresa extends StatefulWidget {
  final ContactoEmpresa contacto;

  const InfoContactoEmpresa({required this.contacto, Key? key}) : super(key: key);

  @override
  State<InfoContactoEmpresa> createState() => _InfoContactoEmpresaState();
}

class _InfoContactoEmpresaState extends State<InfoContactoEmpresa> {
  String nombreEmpresa = 'Cargando...';
  String descripcionEmpresa = '';

  @override
  void initState() {
    super.initState();
    _cargarEmpresa();
  }

  Future<void> _cargarEmpresa() async {
    final empresa = await _obtenerEmpresa(widget.contacto.idempresa);
    setState(() {
      nombreEmpresa = empresa['nombre']!;
      descripcionEmpresa = empresa['descripcion']!;
    });
  }

  Future<Map<String, String>> _obtenerEmpresa(int idEmpresa) async {
    try {
      final response = await Supabase.instance.client
          .from('empresas')
          .select('nombre, descripcion')
          .eq('idempresa', idEmpresa)
          .maybeSingle();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del Contacto'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Tarjeta de empresa
          Card(
            color: Colors.grey[100],
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombreEmpresa,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    descripcionEmpresa,
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                ],
              ),
            ),
          ),

          // Tarjeta de contacto
          Card(
            color: const Color(0xFFF3F3F3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  infoRow('Nombre', widget.contacto.nombre),
                  infoRow('Apellido Paterno', widget.contacto.apellidopaterno),
                  infoRow('Apellido Materno', widget.contacto.apellidomaterno),
                  infoRow('Teléfono', widget.contacto.telefono),
                  infoRow('Correo', widget.contacto.correo),
                  infoRow('Puesto', widget.contacto.puesto),
                  infoRow('Horario de atención', widget.contacto.horarioAtencion),
                  infoRow('Comentarios', widget.contacto.comentarios),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
          ),
        ],
      ),
    );
  }
}
