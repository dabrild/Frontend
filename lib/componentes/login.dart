import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final cedulaController = TextEditingController();
  final claveController = TextEditingController();

  Future<void> login() async {
    final url = Uri.parse('http://192.168.1.7:8862/conductores/autenticar');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cedula': int.parse(cedulaController.text),
        'clave': claveController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bienvenido ${data['nombre']}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales inválidas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio de Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: cedulaController,
              decoration: const InputDecoration(labelText: 'Correo'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: claveController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: const Text('Ingresar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registro');
              },
              child: const Text('¿No tienes cuenta? Regístrate'),
            )
          ],
        ),
      ),
    );
  }
}
