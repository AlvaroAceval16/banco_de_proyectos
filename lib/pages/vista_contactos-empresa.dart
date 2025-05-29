import 'package:banco_de_proyectos/back/logica_contactoEmpresa.dart';
import 'package:banco_de_proyectos/classes/contacto_empresa.dart';
import 'package:banco_de_proyectos/pages/info_contacto-empresa.dart';
import 'package:flutter/material.dart';


class ResumenContactoEmpresaPage extends StatefulWidget {
  const ResumenContactoEmpresaPage({super.key});

  @override
  State<ResumenContactoEmpresaPage> createState() => _ResumenContactoEmpresaPageState();
}

class _ResumenContactoEmpresaPageState extends State<ResumenContactoEmpresaPage> {
  late Future<List<Map<String, dynamic>>> _obtenerContactosFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _obtenerContactosFuture = ContactoService.obtenerContactos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchContacts() {
    setState(() {
      _obtenerContactosFuture = ContactoService.obtenerContactos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Poppins'),
      ),
      child: Scaffold(
        drawer: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: const SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Filtros aquí (opcional)'),
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text('Contactos de Empresa'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushNamed(context, '/dashboard'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar contactos...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (value) {
                  _fetchContacts();
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _obtenerContactosFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No hay contactos disponibles.'));
                    }

                    final contactos = snapshot.data!;
                    return ListView.builder(
                      itemCount: contactos.length,
                      itemBuilder: (context, index) {
                        final contactoMap = contactos[index];
                        final contacto = ContactoEmpresa.fromMap(contactoMap);
                        return Card(
                          color: Theme.of(context).cardColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(
                              '${contacto.nombre} ${contacto.apellidopaterno} ${contacto.apellidomaterno}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(contacto.puesto),
                            trailing: const Icon(Icons.arrow_forward, size: 20),
                            onTap: () {
                              // Navegación corregida con nombre de ruta
                              Navigator.pushNamed(
                                context,
                                '/info_contacto_empresa',
                                arguments: contacto.idcontacto,
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/form_contacto_empresa'),
          backgroundColor: const Color(0xFF5285E8),
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
