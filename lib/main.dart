import 'package:flutter/material.dart';
import 'database/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini App Usuario',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF1FFF5),
      ),
      home: const RegistroPage(),
    );
  }
}

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final edadController = TextEditingController();

  List<Map<String, dynamic>> usuarios = [];
  int? editandoId;

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  Future<void> cargarUsuarios() async {
    final data = await StorageService.getUsuarios();
    setState(() {
      usuarios = data;
    });
  }

  Future<void> guardarUsuario() async {
    if (_formKey.currentState!.validate()) {
      final usuario = {
        'id': editandoId ?? DateTime.now().millisecondsSinceEpoch,
        'nombre': nombreController.text,
        'email': correoController.text,
        'edad': int.parse(edadController.text),
      };

      if (editandoId == null) {
        await StorageService.saveUsuario(usuario);
      } else {
        usuarios.removeWhere((u) => u['id'] == editandoId);
        usuarios.add(usuario);
        editandoId = null;
      }

      nombreController.clear();
      correoController.clear();
      edadController.clear();

      await cargarUsuarios();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario guardado correctamente')),
      );
    }
  }

  void editarUsuario(Map<String, dynamic> usuario) {
    nombreController.text = usuario['nombre'];
    correoController.text = usuario['email'];
    edadController.text = usuario['edad'].toString();
    editandoId = usuario['id'];
  }

  void eliminarUsuario(int id) {
    usuarios.removeWhere((u) => u['id'] == id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 👨‍💻 AUTOR
            const Text(
              'Creado por: Kevin Aguayo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 16),

            // 📝 FORMULARIO
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Ingrese nombre' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: correoController,
                    decoration: const InputDecoration(
                      labelText: 'Correo',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || !v.contains('@')
                            ? 'Correo inválido'
                            : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: edadController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Edad',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Ingrese edad' : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                    ),
                    onPressed: guardarUsuario,
                    child: Text(
                      editandoId == null ? 'Guardar' : 'Actualizar',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 📋 LISTA DE REGISTROS
            usuarios.isEmpty
                ? const Text('No hay usuarios registrados')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: usuarios.length,
                    itemBuilder: (context, index) {
                      final u = usuarios[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.green,
                            child:
                                Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(u['nombre']),
                          subtitle: Text(
                              '${u['email']} • Edad: ${u['edad']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.teal),
                                onPressed: () => editarUsuario(u),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () =>
                                    eliminarUsuario(u['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}