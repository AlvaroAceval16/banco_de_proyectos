import 'package:flutter/material.dart';

// Clase que contiene todo
class FormContactoEmpresa extends StatelessWidget{
  //const FormContactoEmpresa({super.key});
  final _formKey = GlobalKey<FormState>();
  //variables
  String nombreContacto ='';
  @override
  Widget build(BuildContext context) {
    // Scaffold es la estructura que tendra nuestra aplicacion
   return Scaffold(
   backgroundColor: Colors.white,
   //Aqui se crea toda la AppBar que es la parte de arribita
   appBar: AppBar(
    automaticallyImplyLeading: false,//kita el boton de retroceso
    backgroundColor: Colors.white,
    elevation: 0,//kita sombra
    title: Row( //Organiza el AppBar en fila
      children: [
        Icon(Icons.menu, color: Colors.black),//Importo el icono de las rayitas
        SizedBox(width: 10,),//Espacio entre las cosas
        Text("Contacto de la empresa",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), //Ponerle ahi el Poppins pq si no empieza a chingar vicky
      ],
    ),
   ),
  //Empieza el body es el centro de la pantalla
  body: SingleChildScrollView(//Esta madre crea el cuerpo con desplazamiento
    padding: EdgeInsets.all(16),
    child: Form(//Esta madre esmas para formularios
       key: _formKey,
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, //Todo va alineado a la izquierda
        children: [
          //Titulo
          Text(
            "Datos del Contacto",
            style:TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
        //Campos
        //Nombre del Contacto
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Nombre del contacto',
          ),
          //Validacion del campo
          validator: (value) {
            if(value == null || value.isEmpty){
              return 'Por favor ingrese el nombre';
            }
            return null;
          },
          onSaved: (value) => nombreContacto = value!,
        ),
        SizedBox(height: 12),
        ],
       ),
    
    ),
  ),
  );
    throw UnimplementedError();
  }



  
}