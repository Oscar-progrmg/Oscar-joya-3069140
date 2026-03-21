import 'package:flutter/material.dart';
import '../../widgets/appbar.dart';
import '../../utils/api_service.dart';

class UserScreen extends StatefulWidget {
  final String username;
  final String password;
  final int userId;
  final String token;

  const UserScreen({
    super.key,
    required this.username,
    required this.password,
    required this.userId,
    required this.token,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String _statusSeleccionado = 'Active';
  bool _guardando = false;
  bool _creandoStatus = false;

  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }

  Future<void> _guardarStatus() async {
    if (_statusSeleccionado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona un estado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _guardando = true);

    // ── usa crearUserStatus (campos User_status_name / User_status_description)
    final result = await ApiService.crearUserStatus(
      nombre: _statusSeleccionado,
      descripcion: 'Estado registrado desde la app',
      token: widget.token,
    );

    setState(() => _guardando = false);

    if (result['statusCode'] == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Estado aplicado: $_statusSeleccionado'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al registrar el estado'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _crearNuevoStatus() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _creandoStatus = true);

    // ── usa addUserStatus (campos name / description)
    final result = await ApiService.addUserStatus(
      name: _nombreController.text.trim(),
      description: _descripcionController.text.trim(),
      token: widget.token,
    );

    setState(() => _creandoStatus = false);

    if (result['statusCode'] == 201) {
      final nombre =
          result['data']?['data']?[0]?['name'] ?? _nombreController.text;
      _nombreController.clear();
      _descripcionController.clear();
      _formKey.currentState!.reset();
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Status creado: $nombre'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      final error = result['data']?['error'] ?? 'Error al crear el status';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Perfil de usuario',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Avatar ──────────────────────────────────────────
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 70, color: Colors.white),
            ),
            const SizedBox(height: 30),

            // ── Info del usuario ─────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow('Usuario:', widget.username),
                    const SizedBox(height: 15),
                    _buildInfoRow('Email:', '${widget.username}@demo.com'),
                    const SizedBox(height: 15),
                    _buildInfoRow(
                      'Contraseña:',
                      '${'*' * widget.password.length} (${widget.password.length} caracteres)',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            // ── Seleccionar estado existente ─────────────────────

            // ── Crear nuevo status ────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Encabezado
                      Row(
                        children: const [
                          Icon(Icons.add_circle_outline, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Crear nuevo status',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Define un status personalizado para los usuarios',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Divider(height: 24),

                      // Campo name → addUserStatus(name: ...)
                      TextFormField(
                        controller: _nombreController,
                        maxLength: 50,
                        decoration: const InputDecoration(
                          labelText: 'Name *',
                          hintText: 'Ej: Active, Suspended, Pending...',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.label_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El nombre es obligatorio';
                          }
                          if (value.trim().length < 2) {
                            return 'Mínimo 2 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Campo description → addUserStatus(description: ...)
                      TextFormField(
                        controller: _descripcionController,
                        maxLength: 200,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description *',
                          hintText: 'Describe cuándo se aplica este status...',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description_outlined),
                          alignLabelWithHint: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La descripción es obligatoria';
                          }
                          if (value.trim().length < 5) {
                            return 'Mínimo 5 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Botones
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _creandoStatus
                                  ? null
                                  : () {
                                      _nombreController.clear();
                                      _descripcionController.clear();
                                      _formKey.currentState!.reset();
                                      FocusScope.of(context).unfocus();
                                    },
                              icon: const Icon(Icons.clear, size: 18),
                              label: const Text('Limpiar'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: _creandoStatus
                                  ? null
                                  : _crearNuevoStatus,
                              icon: _creandoStatus
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.save_outlined, size: 18),
                              label: Text(
                                _creandoStatus
                                    ? 'Guardando...'
                                    : 'Guardar status',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import '../../widgets/appbar.dart';
import '../../utils/api_service.dart';

class UserScreen extends StatefulWidget {
  final String username;
  final String password;
  final int userId;
  final String token;

  const UserScreen({
    super.key,
    required this.username,
    required this.password,
    required this.userId,
    required this.token,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String _statusSeleccionado = 'Active';
  bool _guardando = false;

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }

  Future<void> _guardarStatus() async {
    if (_statusSeleccionado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(' Selecciona un estado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _guardando = true);
    final result = await ApiService.crearUserStatus(
      nombre: _statusSeleccionado,
      descripcion: 'Estado registrado desde la app',
      token: widget.token,
    );
    setState(() => _guardando = false);
    if (result['statusCode'] == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Nuevo estado registrado: $_statusSeleccionado'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(' Error al registrar el estado'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Perfil de usuario',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 70, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow('Usuario:', widget.username),
                    const SizedBox(height: 15),
                    _buildInfoRow('Email', '${widget.username}@demo.com'),
                    const SizedBox(height: 15),
                    _buildInfoRow(
                      'Contraseña:',
                      '${'*' * widget.password.length} (${widget.password.length} caracteres)',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Estado del usuario',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _statusSeleccionado,
                      items: ['Active', 'Inactive', 'blocked', 'De']
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null)
                          setState(() => _statusSeleccionado = value);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Seleccionar estado',
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _guardando ? null : _guardarStatus,
                        child: _guardando
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Guardar estado'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} */
