import 'package:banco_de_proyectos/pages/info_empresa.dart';
import 'package:flutter/material.dart';

class ResumenEmpresasPage extends StatefulWidget {
  const ResumenEmpresasPage({super.key});

  @override
  State<ResumenEmpresasPage> createState() => _ResumenEmpresasPageState();
}

class _ResumenEmpresasPageState extends State<ResumenEmpresasPage> {
  final List<Map<String, String>> empresas = List.generate(
    6,
    (index) => {
      'nombre': 'Empresa ${String.fromCharCode(65 + index)}',
      'descripcion': 'Descripción de la empresa',
    },
  );

  final Map<String, bool> filtros = {
    'Microempresa': true,
    'Pequeña': true,
    'Mediana': true,
    'Grande': true,
  };

  List<Map<String, String>> get empresasFiltradas {
    return empresas.where((empresa) {
      // Lógica de filtrado puede agregarse aquí
      return true;
    }).toList();
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
                  _buildSectionTitle('Tamaño de Empresa'),
                  _buildSwitchTile('Microempresa'),
                  _buildSwitchTile('Pequeña'),
                  _buildSwitchTile('Mediana'),
                  _buildSwitchTile('Grande'),
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
          title: const Text('Empresas Registradas'),
          //centerTitle: false,
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
                  hintText: 'Buscar empresas...',
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
                child: ListView.builder(
                  itemCount: empresasFiltradas.length,
                  itemBuilder: (context, index) {
                    final empresa = empresasFiltradas[index];
                    return Card(
                      color: Theme.of(context).cardColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(empresa['nombre']!,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500, // Semibold
                          fontSize: 16,
                        ),),
                        subtitle: Text(empresa['descripcion']!),
                        trailing: const Icon(Icons.arrow_forward, size: 20,),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            //Cambiar esta madre para que vaya a la informacion de empresas
                            builder: (context) => InfoEmpresa(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/form_empresa'),
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
