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

  final Map<String, bool> filtros = {
    'Empresa A': true,
    'Empresa B': true,
    'Empresa C': true,
    'Empresa D': true,
    'Empresa E': true,
  };

  @override
  void initState() {
    super.initState();
    _obtenerContactosFuture = ContactoService.obtenerContacto();
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
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filtros',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Empresa'),
                  ...filtros.keys.map(_buildSwitchTile).toList(),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: const Text('Aplicar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            filtros.updateAll((key, value) => true);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade400,
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text('Contactos de Empresa'),
          
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushNamed(context, '/dashboard'),
          ),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
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
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _obtenerContactosFuture,
                  builder: (context, snapshot){
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InfoContactoEmpresaApp(contacto: contacto),
                                ),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSwitchTile(String label) {
    return SwitchListTile(
      title: Text(label),
      value: filtros[label]!,
      onChanged: (val) {
        setState(() {
          filtros[label] = val;
        });
      },
      activeColor: Colors.green,
    );
  }
}