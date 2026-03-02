import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _edadController.dispose();
    super.dispose();
  }

  Future<void> _registrarUsuario() async {
    final nombre = _nombreController.text.trim();
    final email = _emailController.text.trim();
    final edadText = _edadController.text.trim();

    if (nombre.isEmpty || email.isEmpty || edadText.isEmpty) {
      _mostrarMensaje('Todos los campos son obligatorios');
      return;
    }

    final edad = int.tryParse(edadText);
    if (edad == null) {
      _mostrarMensaje('Edad inválida');
      return;
    }

    final usuario = {
      'nombre': nombre,
      'email': email,
      'edad': edad,
    };

    await DatabaseHelper.instance.insertUsuario(usuario);

    _mostrarMensaje('Usuario registrado correctamente');

    _nombreController.clear();
    _emailController.clear();
    _edadController.clear();
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _edadController,
              decoration: const InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registrarUsuario,
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}