import 'package:banco_de_proyectos/back/autenticacion_login.dart';
import 'package:banco_de_proyectos/consts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:banco_de_proyectos/back/empresa_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final AutenticacionLogin autenticacionLogin = AutenticacionLogin();

  void handledLogin() async {
    final correo = emailController.text.trim();
    final contrasena = passwordController.text;

    final error = await autenticacionLogin.login(correo, contrasena);

    if (error == null) {
      
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }
  
  @override
  void initState() {
    super.initState();
    //fetchEmpresas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 33.0, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Inicia sesión', style: titleStyle),
              const SizedBox(height: 10),
              const Text(
                '¡Bienvenido de nuevo!',
                style: TextStyle(color: Colors.black54),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 33.0),
                  child: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Correo electrónico',
                            border: OutlineInputBorder(),
                            hintText: 'Ash catsup',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            border: OutlineInputBorder(),
                            hintText: '********',
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: handledLogin,
                                /*onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/dashboard',
                                  );
                                },*/
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff647AFF),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 100,
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  minimumSize: const Size(double.infinity, 30),
                                ),
                                child: const Text(
                                  'Iniciar sesión',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
}