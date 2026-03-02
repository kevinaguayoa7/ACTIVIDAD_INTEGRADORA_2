import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> usuarios = [];

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  Future<void> cargarUsuarios() async {
    final data = await DatabaseHelper.instance.getUsuarios();
    setState(() {
      usuarios = data;
    });
  }

  Future<void> eliminarUsuario(int id) async {
    await DatabaseHelper.instance.deleteUsuario(id);
    cargarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios Registrados'),
        backgroundColor: Colors.pink,
      ),
      body: usuarios.isEmpty
          ? const Center(child: Text('No hay usuarios registrados'))
          : ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final u = usuarios[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(u['nombre']),
                    subtitle: Text('${u['email']} - ${u['edad']} años'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => eliminarUsuario(u['id']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}