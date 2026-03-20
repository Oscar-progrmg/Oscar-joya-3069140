import 'package:flutter/material.dart';
import '../../widgets/appbar.dart';
import '../home/home.dart';
import '../user/form.dart';
import '../../utils/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _registeredUsername;
  String? _registeredPassword;

  @override
  void initState() {
    super.initState;
    _usernameController.text = _registeredUsername ?? '';
    _passwordController.text = _registeredPassword ?? '';
  }

  void _navigateToRegister() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserFormScreen()),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        _registeredUsername = result['username'];
        _registeredPassword = result['password'];
        _usernameController.text = _registeredUsername ?? '';
        _passwordController.text = _registeredPassword ?? '';
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario registrado exitosamente')),
      );
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final resultado = await ApiService.loginUsuario(
        user: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      if (resultado['statusCode'] == 200) {
        final token = resultado['data']['token'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              username: _usernameController.text,
              password: _passwordController.text,
              userId: 0,
              token: token,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(' Usuario o contraseña incorrectos')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Iniciar sesion'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/img/logos/imgAlbarr.jpg', height: 100),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  border: OutlineInputBorder(),
                ), // InputDecoration
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su usuario';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ), // InputDecoration

                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Ingresar'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _navigateToRegister,
                child: const Text('¿No tienes cuenta? Registrate aqui'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
